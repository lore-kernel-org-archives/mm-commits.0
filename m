Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C11C43603
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE38206C3
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhA0Csj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404060AbhAZTjL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 14:39:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AD05207BC;
        Tue, 26 Jan 2021 19:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611689910;
        bh=On7eHpPUe4F1q7DgicJzCsKUjfv0ai/fYqmmIkK9lno=;
        h=Date:From:To:Subject:From;
        b=uNSiHpDxAlcrPnx/iBSE6qfzTQZCZEA24dquyn+QwaYyUYgbE7plHregGfhTOHaFo
         s9fQKUxN1C6JZLXz4iG2CwpDniuXu3f+zggUvzigiZNkemYtdFKtHFeKFICDwQ4K0M
         iclweJs8AM0mQSi1u0EUlY1qcd5YGGTSUHUsE114=
Date:   Tue, 26 Jan 2021 11:38:30 -0800
From:   akpm@linux-foundation.org
To:     joao.m.martins@oracle.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [to-be-updated]
 mm-hugetlb-grab-head-page-refcount-once-per-group-of-subpages.patch removed
 from -mm tree
Message-ID: <20210126193830.59BRTueIc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: grab head page refcount once per group of subpages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-grab-head-page-refcount-once-per-group-of-subpages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb: grab head page refcount once per group of subpages

Patch series "mm/hugetlb: follow_hugetlb_page() improvements".

While looking at ZONE_DEVICE struct page reuse particularly the last
patch[0], I found two possible improvements for follow_hugetlb_page()
which is solely used for get_user_pages()/pin_user_pages().

The first patch batches page refcount updates while the second tidies
up storing the subpages/vmas. Both together bring the cost of slow
variant of gup() cost from ~86k usecs to ~4.4k usecs.

libhugetlbfs tests seem to pass as well gup_test benchmarks
with hugetlbfs vmas.


This patch (of 2):

follow_hugetlb_page() once it locks the pmd/pud, it checks all the
subpages in a huge page and grabs a reference for each one, depending on
how many pages we can store or the size of va range.  Similar to gup-fast,
have follow_hugetlb_page() grab the head page refcount only after counting
all its subpages that are part of the just faulted huge page.

Consequently we reduce the number of atomics necessary to pin
said huge page, which improves non-fast gup() considerably:

 - 16G with 1G huge page size
 gup_test -f /mnt/huge/file -m 16384 -r 10 -L -S -n 512 -w

 PIN_LONGTERM_BENCHMARK: ~87.6k us -> ~11k us

Link: https://lkml.kernel.org/r/20210125205744.10203-1-joao.m.martins@oracle.com
Link: https://lkml.kernel.org/r/20210125205744.10203-2-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/gup.c           |    5 ++---
 mm/hugetlb.c       |   43 ++++++++++++++++++++++++-------------------
 3 files changed, 29 insertions(+), 22 deletions(-)

--- a/include/linux/mm.h~mm-hugetlb-grab-head-page-refcount-once-per-group-of-subpages
+++ a/include/linux/mm.h
@@ -1181,6 +1181,9 @@ static inline void get_page(struct page
 }
 
 bool __must_check try_grab_page(struct page *page, unsigned int flags);
+__maybe_unused struct page *try_grab_compound_head(struct page *page, int refs,
+						   unsigned int flags);
+
 
 static inline __must_check bool try_get_page(struct page *page)
 {
--- a/mm/gup.c~mm-hugetlb-grab-head-page-refcount-once-per-group-of-subpages
+++ a/mm/gup.c
@@ -78,9 +78,8 @@ static inline struct page *try_get_compo
  * considered failure, and furthermore, a likely bug in the caller, so a warning
  * is also emitted.
  */
-static __maybe_unused struct page *try_grab_compound_head(struct page *page,
-							  int refs,
-							  unsigned int flags)
+__maybe_unused struct page *try_grab_compound_head(struct page *page,
+						   int refs, unsigned int flags)
 {
 	if (flags & FOLL_GET)
 		return try_get_compound_head(page, refs);
--- a/mm/hugetlb.c~mm-hugetlb-grab-head-page-refcount-once-per-group-of-subpages
+++ a/mm/hugetlb.c
@@ -4798,7 +4798,7 @@ long follow_hugetlb_page(struct mm_struc
 	unsigned long vaddr = *position;
 	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
-	int err = -EFAULT;
+	int err = -EFAULT, refs;
 
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
@@ -4918,26 +4918,11 @@ long follow_hugetlb_page(struct mm_struc
 			continue;
 		}
 
+		refs = 0;
+
 same_page:
-		if (pages) {
+		if (pages)
 			pages[i] = mem_map_offset(page, pfn_offset);
-			/*
-			 * try_grab_page() should always succeed here, because:
-			 * a) we hold the ptl lock, and b) we've just checked
-			 * that the huge page is present in the page tables. If
-			 * the huge page is present, then the tail pages must
-			 * also be present. The ptl prevents the head page and
-			 * tail pages from being rearranged in any way. So this
-			 * page must be available at this point, unless the page
-			 * refcount overflowed:
-			 */
-			if (WARN_ON_ONCE(!try_grab_page(pages[i], flags))) {
-				spin_unlock(ptl);
-				remainder = 0;
-				err = -ENOMEM;
-				break;
-			}
-		}
 
 		if (vmas)
 			vmas[i] = vma;
@@ -4946,6 +4931,7 @@ same_page:
 		++pfn_offset;
 		--remainder;
 		++i;
+		refs++;
 		if (vaddr < vma->vm_end && remainder &&
 				pfn_offset < pages_per_huge_page(h)) {
 			/*
@@ -4953,6 +4939,25 @@ same_page:
 			 * of this compound page.
 			 */
 			goto same_page;
+		} else if (pages) {
+			/*
+			 * try_grab_compound_head() should always succeed here,
+			 * because: a) we hold the ptl lock, and b) we've just
+			 * checked that the huge page is present in the page
+			 * tables. If the huge page is present, then the tail
+			 * pages must also be present. The ptl prevents the
+			 * head page and tail pages from being rearranged in
+			 * any way. So this page must be available at this
+			 * point, unless the page refcount overflowed:
+			 */
+			if (WARN_ON_ONCE(!try_grab_compound_head(pages[i-1],
+								 refs,
+								 flags))) {
+				spin_unlock(ptl);
+				remainder = 0;
+				err = -ENOMEM;
+				break;
+			}
 		}
 		spin_unlock(ptl);
 	}
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-hugetlb-refactor-subpage-recording.patch

