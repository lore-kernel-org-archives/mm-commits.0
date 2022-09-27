Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD03C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiI0Czx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiI0CzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC113F1F1
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A869AB81982
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62335C433D6;
        Tue, 27 Sep 2022 02:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247013;
        bh=oNVe+E9K/eOE7cAaWXAnGHnoa5Z+wCcaux/qbFw6++E=;
        h=Date:To:From:Subject:From;
        b=lJJiZjj0GFzylO94t3SM9bwS4cUnpssdAYJsza5IiDzDy+VzhGAKpG/uqsEyitTGu
         oirp4qEQdpWOw0S1BqCSzyS4x9AaBYIMl4oLK8KGZUU33vDOnjUAkZMQXJifYvmvYu
         JcJlutl9xVtivks9g+jslW+dTu15g0KXdy5IPA6g=
Date:   Mon, 26 Sep 2022 19:50:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        mgorman@suse.de, jhubbard@nvidia.com, jgg@nvidia.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch removed from -mm tree
Message-Id: <20220927025013.62335C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: replace FOLL_NUMA by gup_can_follow_protnone()
has been removed from the -mm tree.  Its filename was
     mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: replace FOLL_NUMA by gup_can_follow_protnone()
Date: Thu, 25 Aug 2022 18:46:57 +0200

Patch series "mm: minor cleanups around NUMA hinting".

Working on some GUP cleanups (e.g., getting rid of some FOLL_ flags) and
preparing for other GUP changes (getting rid of FOLL_FORCE|FOLL_WRITE for
for taking a R/O longterm pin), this is something I can easily send out
independently.

Get rid of FOLL_NUMA, allow FOLL_FORCE access to PROT_NONE mapped pages in
GUP-fast, and fixup some documentation around NUMA hinting.


This patch (of 3):

No need for a special flag that is not even properly documented to be
internal-only.

Let's just factor this check out and get rid of this flag.  The separate
function has the nice benefit that we can centralize comments.

Link: https://lkml.kernel.org/r/20220825164659.89824-2-david@redhat.com
Link: https://lkml.kernel.org/r/20220825164659.89824-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 +++++++++++++++-
 mm/gup.c           |   12 ++----------
 mm/huge_memory.c   |    2 +-
 3 files changed, 18 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-gup-replace-foll_numa-by-gup_can_follow_protnone
+++ a/include/linux/mm.h
@@ -2933,7 +2933,6 @@ struct page *follow_page(struct vm_area_
 				 * and return without waiting upon it */
 #define FOLL_NOFAULT	0x80	/* do not fault in pages */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
-#define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
@@ -3054,6 +3053,21 @@ static inline bool gup_must_unshare(unsi
 	return !PageAnonExclusive(page);
 }
 
+/*
+ * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
+ * a (NUMA hinting) fault is required.
+ */
+static inline bool gup_can_follow_protnone(unsigned int flags)
+{
+	/*
+	 * FOLL_FORCE has to be able to make progress even if the VMA is
+	 * inaccessible. Further, FOLL_FORCE access usually does not represent
+	 * application behaviour and we should avoid triggering NUMA hinting
+	 * faults.
+	 */
+	return flags & FOLL_FORCE;
+}
+
 typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
--- a/mm/gup.c~mm-gup-replace-foll_numa-by-gup_can_follow_protnone
+++ a/mm/gup.c
@@ -573,7 +573,7 @@ retry:
 		migration_entry_wait(mm, pmd, address);
 		goto retry;
 	}
-	if ((flags & FOLL_NUMA) && pte_protnone(pte))
+	if (pte_protnone(pte) && !gup_can_follow_protnone(flags))
 		goto no_page;
 
 	page = vm_normal_page(vma, address, pte);
@@ -726,7 +726,7 @@ retry:
 	if (likely(!pmd_trans_huge(pmdval)))
 		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
 
-	if ((flags & FOLL_NUMA) && pmd_protnone(pmdval))
+	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(flags))
 		return no_page_table(vma, flags);
 
 retry_locked:
@@ -1172,14 +1172,6 @@ static long __get_user_pages(struct mm_s
 
 	VM_BUG_ON(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
 
-	/*
-	 * If FOLL_FORCE is set then do not force a full fault as the hinting
-	 * fault information is unrelated to the reference behaviour of a task
-	 * using the address space
-	 */
-	if (!(gup_flags & FOLL_FORCE))
-		gup_flags |= FOLL_NUMA;
-
 	do {
 		struct page *page;
 		unsigned int foll_flags = gup_flags;
--- a/mm/huge_memory.c~mm-gup-replace-foll_numa-by-gup_can_follow_protnone
+++ a/mm/huge_memory.c
@@ -1447,7 +1447,7 @@ struct page *follow_trans_huge_pmd(struc
 		return ERR_PTR(-EFAULT);
 
 	/* Full NUMA hinting faults to serialise migration in fault paths */
-	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
+	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(flags))
 		return NULL;
 
 	if (!pmd_write(*pmd) && gup_must_unshare(flags, page))
_

Patches currently in -mm which might be from david@redhat.com are


