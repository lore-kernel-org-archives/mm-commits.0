Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652CCC43381
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397C6206CC
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhA0Csj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404074AbhAZTjO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 14:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FDB207C8;
        Tue, 26 Jan 2021 19:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611689913;
        bh=KRUlM3ZA1gToOXxg/JkYCvWhOK5sJ47IvcVLIihDSIE=;
        h=Date:From:To:Subject:From;
        b=zcwiF5Lbd67L85o6/R+JnVjuAv67BwMG9JWU5RoyFcJlTHIpwmW5HNV7UknFiNN0L
         wbx8l9ARbEf64i/v+BPuQ+KsvmCQ8c4c2iaS8v8q33UqfXqO3/ivZIjeaer+Vz6jpg
         jjGSkNaGxyts7xLFAxouVHt3N+x8q8UhDMa5r1Uo=
Date:   Tue, 26 Jan 2021 11:38:33 -0800
From:   akpm@linux-foundation.org
To:     joao.m.martins@oracle.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [to-be-updated]
 mm-hugetlb-refactor-subpage-recording.patch removed from -mm tree
Message-ID: <20210126193833.jQmHRI0Y3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: refactor subpage recording
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-refactor-subpage-recording.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb: refactor subpage recording

For a given hugepage backing a VA, there's a rather ineficient
loop which is solely responsible for storing subpages in the passed
pages/vmas array. For each subpage we check whether it's within
range or size of @pages and keep incrementing @pfn_offset and a couple
other variables per subpage iteration.

Simplify this logic and minimize ops per iteration to just
store the output page/vma. Instead of incrementing number of @refs
iteratively, we do it through a precalculation of @refs and having
only a tight loop for storing pinned subpages/vmas.

pinning consequently improves considerably, bringing us close to
{pin,get}_user_pages_fast:

 - 16G with 1G huge page size
 gup_test -f /mnt/huge/file -m 16384 -r 10 -L -S -n 512 -w

 PIN_LONGTERM_BENCHMARK: ~11k us -> ~4400 us
 PIN_FAST_BENCHMARK: ~3700 us

Link: https://lkml.kernel.org/r/20210125205744.10203-3-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-refactor-subpage-recording
+++ a/mm/hugetlb.c
@@ -4789,6 +4789,20 @@ out_release_nounlock:
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
+			pages[nr] = page++;
+		if (vmas)
+			vmas[nr] = vma;
+	}
+}
+
 long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			 struct page **pages, struct vm_area_struct **vmas,
 			 unsigned long *position, unsigned long *nr_pages,
@@ -4918,28 +4932,16 @@ long follow_hugetlb_page(struct mm_struc
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
-		refs++;
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
@@ -4950,7 +4952,7 @@ same_page:
 			 * any way. So this page must be available at this
 			 * point, unless the page refcount overflowed:
 			 */
-			if (WARN_ON_ONCE(!try_grab_compound_head(pages[i-1],
+			if (WARN_ON_ONCE(!try_grab_compound_head(pages[i],
 								 refs,
 								 flags))) {
 				spin_unlock(ptl);
@@ -4959,6 +4961,11 @@ same_page:
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

Patches currently in -mm which might be from joao.m.martins@oracle.com are


