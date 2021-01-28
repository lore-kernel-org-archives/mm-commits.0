Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C5CC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 20:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A845564DD6
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 20:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhA1Ug7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhA1Ug6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Jan 2021 15:36:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A986564DA1;
        Thu, 28 Jan 2021 20:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611866177;
        bh=hjHkMZZjAfpUyXOGldeh+kxA6o6uAEqih/AIrwXmORk=;
        h=Date:From:To:Subject:From;
        b=Xlebid2RW18f6fTkfG0IVDmc2wo2pqfczxLqnGwQanDdvCrzzneLKs+7YcUPGUJo2
         B5VvIhCnapVTIKFuQHEkzvjGdRvGjl+Ld2r0Ni17BVWIRl/rKVgFXhVzxQP1jY9E/1
         8mzDx060OEX+w3kXc6v18E8jKXZ6mm3Ew3sBVpyw=
Date:   Thu, 28 Jan 2021 12:36:17 -0800
From:   akpm@linux-foundation.org
To:     joao.m.martins@oracle.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-hugetlb-grab-head-page-refcount-once-for-group-of-subpages.patch added
 to -mm tree
Message-ID: <20210128203617.6InQL9zCN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: grab head page refcount once for group of subpages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-grab-head-page-refcount-once-for-group-of-subpages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-grab-head-page-refcount-once-for-group-of-subpages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-grab-head-page-refcount-once-for-group-of-subpages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb: grab head page refcount once for group of subpages

Patch series "mm/hugetlb: follow_hugetlb_page() improvements", v2.

While looking at ZONE_DEVICE struct page reuse particularly the last
patch[0], I found two possible improvements for follow_hugetlb_page()
which is solely used for get_user_pages()/pin_user_pages().

The first patch batches page refcount updates while the second tidies up
storing the subpages/vmas.  Both together bring the cost of slow variant
of gup() cost from ~87.6k usecs to ~5.8k usecs.

libhugetlbfs tests seem to pass as well gup_test benchmarks with hugetlbfs
vmas.


This patch (of 2):

follow_hugetlb_page() once it locks the pmd/pud, checks all its N subpages
in a huge page and grabs a reference for each one.  Similar to gup-fast,
have follow_hugetlb_page() grab the head page refcount only after counting
all its subpages that are part of the just faulted huge page.

Consequently we reduce the number of atomics necessary to pin said huge
page, which improves non-fast gup() considerably:

  - 16G with 1G huge page size
  gup_test -f /mnt/huge/file -m 16384 -r 10 -L -S -n 512 -w

PIN_LONGTERM_BENCHMARK: ~87.6k us -> ~12.8k us

Link: https://lkml.kernel.org/r/20210128182632.24562-1-joao.m.martins@oracle.com
Link: https://lkml.kernel.org/r/20210128182632.24562-2-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/gup.c           |    5 ++---
 mm/hugetlb.c       |   43 ++++++++++++++++++++++++-------------------
 3 files changed, 29 insertions(+), 22 deletions(-)

--- a/include/linux/mm.h~mm-hugetlb-grab-head-page-refcount-once-for-group-of-subpages
+++ a/include/linux/mm.h
@@ -1181,6 +1181,9 @@ static inline void get_page(struct page
 }
 
 bool __must_check try_grab_page(struct page *page, unsigned int flags);
+__maybe_unused struct page *try_grab_compound_head(struct page *page, int refs,
+						   unsigned int flags);
+
 
 static inline __must_check bool try_get_page(struct page *page)
 {
--- a/mm/gup.c~mm-hugetlb-grab-head-page-refcount-once-for-group-of-subpages
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
--- a/mm/hugetlb.c~mm-hugetlb-grab-head-page-refcount-once-for-group-of-subpages
+++ a/mm/hugetlb.c
@@ -4810,7 +4810,7 @@ long follow_hugetlb_page(struct mm_struc
 	unsigned long vaddr = *position;
 	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
-	int err = -EFAULT;
+	int err = -EFAULT, refs;
 
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
@@ -4930,26 +4930,11 @@ long follow_hugetlb_page(struct mm_struc
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
@@ -4958,6 +4943,7 @@ same_page:
 		++pfn_offset;
 		--remainder;
 		++i;
+		++refs;
 		if (vaddr < vma->vm_end && remainder &&
 				pfn_offset < pages_per_huge_page(h)) {
 			/*
@@ -4965,6 +4951,25 @@ same_page:
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

mm-hugetlb-grab-head-page-refcount-once-for-group-of-subpages.patch
mm-hugetlb-refactor-subpage-recording.patch

