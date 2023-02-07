Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C803C61DA4
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjBGBaH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjBGB35 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7A734C37
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9BE7B8167B
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D19C4339C;
        Tue,  7 Feb 2023 01:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733389;
        bh=D3PfdsjCA4NZb+bL27bpYxFdCnFv7TCR7sBth7Dwudg=;
        h=Date:To:From:Subject:From;
        b=CduFmsz46qKKOIs38kvrTJxuPIObwj/TxAt7HkYSuTVygm2vfHxkpL1bmvq4PFlCP
         ZbVTYdR6Ymt78s9whZkyFfAn/OZn5faG2k2Z16LStZF+UMzEWZ5nTzjLouITXC1xe2
         SEz5WvyOzEVQIC0LBxWQbX24EpiUEYDhfOy0Mp7s=
Date:   Mon, 06 Feb 2023 17:29:48 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-move-gup_must_unshare-to-mm-internalh.patch added to mm-unstable branch
Message-Id: <20230207012949.50D19C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: move gup_must_unshare() to mm/internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-move-gup_must_unshare-to-mm-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-move-gup_must_unshare-to-mm-internalh.patch

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
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: move gup_must_unshare() to mm/internal.h
Date: Tue, 24 Jan 2023 16:34:33 -0400

This function is only used in gup.c and closely related.  It touches
FOLL_PIN so it must be moved before the next patch.

Link: https://lkml.kernel.org/r/12-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-gup-move-gup_must_unshare-to-mm-internalh
+++ a/include/linux/mm.h
@@ -3206,71 +3206,6 @@ static inline int vm_fault_to_errno(vm_f
 }
 
 /*
- * Indicates for which pages that are write-protected in the page table,
- * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
- * GUP pin will remain consistent with the pages mapped into the page tables
- * of the MM.
- *
- * Temporary unmapping of PageAnonExclusive() pages or clearing of
- * PageAnonExclusive() has to protect against concurrent GUP:
- * * Ordinary GUP: Using the PT lock
- * * GUP-fast and fork(): mm->write_protect_seq
- * * GUP-fast and KSM or temporary unmapping (swap, migration): see
- *    page_try_share_anon_rmap()
- *
- * Must be called with the (sub)page that's actually referenced via the
- * page table entry, which might not necessarily be the head page for a
- * PTE-mapped THP.
- *
- * If the vma is NULL, we're coming from the GUP-fast path and might have
- * to fallback to the slow path just to lookup the vma.
- */
-static inline bool gup_must_unshare(struct vm_area_struct *vma,
-				    unsigned int flags, struct page *page)
-{
-	/*
-	 * FOLL_WRITE is implicitly handled correctly as the page table entry
-	 * has to be writable -- and if it references (part of) an anonymous
-	 * folio, that part is required to be marked exclusive.
-	 */
-	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
-		return false;
-	/*
-	 * Note: PageAnon(page) is stable until the page is actually getting
-	 * freed.
-	 */
-	if (!PageAnon(page)) {
-		/*
-		 * We only care about R/O long-term pining: R/O short-term
-		 * pinning does not have the semantics to observe successive
-		 * changes through the process page tables.
-		 */
-		if (!(flags & FOLL_LONGTERM))
-			return false;
-
-		/* We really need the vma ... */
-		if (!vma)
-			return true;
-
-		/*
-		 * ... because we only care about writable private ("COW")
-		 * mappings where we have to break COW early.
-		 */
-		return is_cow_mapping(vma->vm_flags);
-	}
-
-	/* Paired with a memory barrier in page_try_share_anon_rmap(). */
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
-		smp_rmb();
-
-	/*
-	 * Note that PageKsm() pages cannot be exclusive, and consequently,
-	 * cannot get pinned.
-	 */
-	return !PageAnonExclusive(page);
-}
-
-/*
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
  * a (NUMA hinting) fault is required.
  */
--- a/mm/internal.h~mm-gup-move-gup_must_unshare-to-mm-internalh
+++ a/mm/internal.h
@@ -858,6 +858,71 @@ int migrate_device_coherent_page(struct
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags);
 int __must_check try_grab_page(struct page *page, unsigned int flags);
 
+/*
+ * Indicates for which pages that are write-protected in the page table,
+ * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
+ * GUP pin will remain consistent with the pages mapped into the page tables
+ * of the MM.
+ *
+ * Temporary unmapping of PageAnonExclusive() pages or clearing of
+ * PageAnonExclusive() has to protect against concurrent GUP:
+ * * Ordinary GUP: Using the PT lock
+ * * GUP-fast and fork(): mm->write_protect_seq
+ * * GUP-fast and KSM or temporary unmapping (swap, migration): see
+ *    page_try_share_anon_rmap()
+ *
+ * Must be called with the (sub)page that's actually referenced via the
+ * page table entry, which might not necessarily be the head page for a
+ * PTE-mapped THP.
+ *
+ * If the vma is NULL, we're coming from the GUP-fast path and might have
+ * to fallback to the slow path just to lookup the vma.
+ */
+static inline bool gup_must_unshare(struct vm_area_struct *vma,
+				    unsigned int flags, struct page *page)
+{
+	/*
+	 * FOLL_WRITE is implicitly handled correctly as the page table entry
+	 * has to be writable -- and if it references (part of) an anonymous
+	 * folio, that part is required to be marked exclusive.
+	 */
+	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
+		return false;
+	/*
+	 * Note: PageAnon(page) is stable until the page is actually getting
+	 * freed.
+	 */
+	if (!PageAnon(page)) {
+		/*
+		 * We only care about R/O long-term pining: R/O short-term
+		 * pinning does not have the semantics to observe successive
+		 * changes through the process page tables.
+		 */
+		if (!(flags & FOLL_LONGTERM))
+			return false;
+
+		/* We really need the vma ... */
+		if (!vma)
+			return true;
+
+		/*
+		 * ... because we only care about writable private ("COW")
+		 * mappings where we have to break COW early.
+		 */
+		return is_cow_mapping(vma->vm_flags);
+	}
+
+	/* Paired with a memory barrier in page_try_share_anon_rmap(). */
+	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+		smp_rmb();
+
+	/*
+	 * Note that PageKsm() pages cannot be exclusive, and consequently,
+	 * cannot get pinned.
+	 */
+	return !PageAnonExclusive(page);
+}
+
 extern bool mirrored_kernelcore;
 
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-have-internal-functions-get-the-mmap_read_lock.patch
mm-gup-remove-obsolete-foll_longterm-comment.patch
mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch
mm-gup-move-try_grab_page-to-mm-internalh.patch
mm-gup-simplify-the-external-interface-functions-and-consolidate-invariants.patch
mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch
mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch
mm-gup-add-foll_unlockable.patch
mm-gup-make-locked-never-null-in-the-internal-gup-functions.patch
mm-gup-remove-pin_user_pages_fast_only.patch
mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch
mm-gup-move-gup_must_unshare-to-mm-internalh.patch
mm-gup-move-private-gup-foll_-flags-to-internalh.patch

