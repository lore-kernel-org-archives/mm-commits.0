Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CE7C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED21A64F26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhBXUIV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235285AbhBXUHz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98CEA64EC3;
        Wed, 24 Feb 2021 20:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197236;
        bh=oCoZ5ZuMn2MQBNBxn3RHBg0iGZjgl+ZqjzMn4M8xWWw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DHIIHjJaZK15cSmn8qiJYsUH6SP3zhBP5cUdOfxGDrifnT7ctF+dp3X7BCawH3AkN
         XgxtqbzWbtLcWnCK0G/NKxrluG1SSg5Si/y/JzSrTgT3NfqkGaQ2FGSP2bmo/q3ZET
         WmIC73gokbhd7gZa1Lxh68MUxNYt+Df1tbGnTWhA=
Date:   Wed, 24 Feb 2021 12:07:16 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joao.m.martins@oracle.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 120/173] mm/hugetlb: refactor subpage recording
Message-ID: <20210224200716.FuqvixbD6%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb: refactor subpage recording

For a given hugepage backing a VA, there's a rather ineficient loop which
is solely responsible for storing subpages in GUP @pages/@vmas array.  For
each subpage we check whether it's within range or size of @pages and keep
increment @pfn_offset and a couple other variables per subpage iteration.

Simplify this logic and minimize the cost of each iteration to just store
the output page/vma.  Instead of incrementing number of @refs iteratively,
we do it through pre-calculation of @refs and only with a tight loop for
storing pinned subpages/vmas.

Additionally, retain existing behaviour with using mem_map_offset() when
recording the subpages for configurations that don't have a contiguous
mem_map.

pinning consequently improves bringing us close to
{pin,get}_user_pages_fast:

  - 16G with 1G huge page size
  gup_test -f /mnt/huge/file -m 16384 -r 30 -L -S -n 512 -w

PIN_LONGTERM_BENCHMARK: ~12.8k us -> ~5.8k us
PIN_FAST_BENCHMARK: ~3.7k us

Link: https://lkml.kernel.org/r/20210128182632.24562-3-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-refactor-subpage-recording
+++ a/mm/hugetlb.c
@@ -4787,6 +4787,20 @@ out_release_nounlock:
 	goto out;
 }
 
+static void record_subpages_vmas(struct page *page, struct vm_area_struct *vma,
+				 int refs, struct page **pages,
+				 struct vm_area_struct **vmas)
+{
+	int nr;
+
+	for (nr = 0; nr < refs; nr++) {
+		if (likely(pages))
+			pages[nr] = mem_map_offset(page, nr);
+		if (vmas)
+			vmas[nr] = vma;
+	}
+}
+
 long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			 struct page **pages, struct vm_area_struct **vmas,
 			 unsigned long *position, unsigned long *nr_pages,
@@ -4916,28 +4930,16 @@ long follow_hugetlb_page(struct mm_struc
 			continue;
 		}
 
-		refs = 0;
+		refs = min3(pages_per_huge_page(h) - pfn_offset,
+			    (vma->vm_end - vaddr) >> PAGE_SHIFT, remainder);
 
-same_page:
-		if (pages)
-			pages[i] = mem_map_offset(page, pfn_offset);
+		if (pages || vmas)
+			record_subpages_vmas(mem_map_offset(page, pfn_offset),
+					     vma, refs,
+					     likely(pages) ? pages + i : NULL,
+					     vmas ? vmas + i : NULL);
 
-		if (vmas)
-			vmas[i] = vma;
-
-		vaddr += PAGE_SIZE;
-		++pfn_offset;
-		--remainder;
-		++i;
-		++refs;
-		if (vaddr < vma->vm_end && remainder &&
-				pfn_offset < pages_per_huge_page(h)) {
-			/*
-			 * We use pfn_offset to avoid touching the pageframes
-			 * of this compound page.
-			 */
-			goto same_page;
-		} else if (pages) {
+		if (pages) {
 			/*
 			 * try_grab_compound_head() should always succeed here,
 			 * because: a) we hold the ptl lock, and b) we've just
@@ -4948,7 +4950,7 @@ same_page:
 			 * any way. So this page must be available at this
 			 * point, unless the page refcount overflowed:
 			 */
-			if (WARN_ON_ONCE(!try_grab_compound_head(pages[i-1],
+			if (WARN_ON_ONCE(!try_grab_compound_head(pages[i],
 								 refs,
 								 flags))) {
 				spin_unlock(ptl);
@@ -4957,6 +4959,11 @@ same_page:
 				break;
 			}
 		}
+
+		vaddr += (refs << PAGE_SHIFT);
+		remainder -= refs;
+		i += refs;
+
 		spin_unlock(ptl);
 	}
 	*nr_pages = remainder;
_
