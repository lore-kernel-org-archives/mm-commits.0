Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1286DECAAA3
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 01:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbiHZBZb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 21:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiHZBZU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 21:25:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1D91F2C1
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 18:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84470B8273D
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 01:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42766C433D6;
        Fri, 26 Aug 2022 01:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661477116;
        bh=MbZZAtlGRxqni/wgSc+UrBobAQGJUDCE0pDBGczL4X0=;
        h=Date:To:From:Subject:From;
        b=l9HPT3rSSSgK4qTU6WeNNy5wHXNB1qyEUUsD2kQGgXqzf7BWKF/fJuizl7zcfoyLc
         mOmeQKnmsHlT+eEf2Z589PMu6hzkXTaotlMmsuA99uYVjGPil8I0OF5HySXLz33wVI
         AXZEeFqjC9o5Eopp+tQ4iQ76UZPKAUfQWDwoNMD8=
Date:   Thu, 25 Aug 2022 18:25:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        mgorman@suse.de, jhubbard@nvidia.com, jgg@nvidia.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch added to mm-unstable branch
Message-Id: <20220826012516.42766C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: replace FOLL_NUMA by gup_can_follow_protnone()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -2937,7 +2937,6 @@ struct page *follow_page(struct vm_area_
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
@@ -526,7 +526,7 @@ retry:
 		migration_entry_wait(mm, pmd, address);
 		goto retry;
 	}
-	if ((flags & FOLL_NUMA) && pte_protnone(pte))
+	if (pte_protnone(pte) && !gup_can_follow_protnone(flags))
 		goto no_page;
 	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
 		pte_unmap_unlock(ptep, ptl);
@@ -672,7 +672,7 @@ retry:
 	if (likely(!pmd_trans_huge(pmdval)))
 		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
 
-	if ((flags & FOLL_NUMA) && pmd_protnone(pmdval))
+	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(flags))
 		return no_page_table(vma, flags);
 
 retry_locked:
@@ -1129,14 +1129,6 @@ static long __get_user_pages(struct mm_s
 
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
@@ -1421,7 +1421,7 @@ struct page *follow_trans_huge_pmd(struc
 		return ERR_PTR(-EFAULT);
 
 	/* Full NUMA hinting faults to serialise migration in fault paths */
-	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
+	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(flags))
 		goto out;
 
 	page = pmd_page(*pmd);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch
mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch
mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch

