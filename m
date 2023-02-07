Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC825C61DA4
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjBGB3t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjBGB3q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98882ED66
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F7DB816C6
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC54AC433EF;
        Tue,  7 Feb 2023 01:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733382;
        bh=OKRPH1W/BDVuBBJe9CNLN13aD3ok2EbhIWPEX0DNXyw=;
        h=Date:To:From:Subject:From;
        b=E6gNMmEuimhgVPZe3lHg+8DxrYvLV7do4r9bSvCDu++EmxTTA2S3AnmKKolJ7Tz1W
         rgybgTtIu2YAw3V1d4TNIPGxai3hUOMTDwF9q49a5c8YpbVAMyNimfsi/Y3NvBxr20
         2juo2ZEbtR9aSXkZFiazR/clNgu7QoJnlj1H/Hwo=
Date:   Mon, 06 Feb 2023 17:29:41 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-add-foll_unlockable.patch added to mm-unstable branch
Message-Id: <20230207012941.EC54AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: add FOLL_UNLOCKABLE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-add-foll_unlockable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-add-foll_unlockable.patch

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
Subject: mm/gup: add FOLL_UNLOCKABLE
Date: Tue, 24 Jan 2023 16:34:29 -0400

Setting FOLL_UNLOCKABLE allows GUP to lock/unlock the mmap lock on its
own.  It is a more explicit replacement for locked != NULL.  This clears
the way for passing in locked = 1, without intending that the lock can be
unlocked.

Set the flag in all cases where it is used, eg locked is present in the
external interface or locked is used internally with locked = 0.

Link: https://lkml.kernel.org/r/8-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm_types.h~mm-gup-add-foll_unlockable
+++ a/include/linux/mm_types.h
@@ -1109,5 +1109,6 @@ typedef unsigned int __bitwise zap_flags
 #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
 #define FOLL_PCI_P2PDMA	0x100000 /* allow returning PCI P2PDMA pages */
 #define FOLL_INTERRUPTIBLE  0x200000 /* allow interrupts from generic signals */
+#define FOLL_UNLOCKABLE	0x400000 /* allow unlocking the mmap lock (internal only) */
 
 #endif /* _LINUX_MM_TYPES_H */
--- a/mm/gup.c~mm-gup-add-foll_unlockable
+++ a/mm/gup.c
@@ -896,7 +896,7 @@ static int faultin_page(struct vm_area_s
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (*flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
-	if (locked) {
+	if (*flags & FOLL_UNLOCKABLE) {
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 		/*
 		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
@@ -1382,9 +1382,11 @@ static __always_inline long __get_user_p
 	for (;;) {
 		ret = __get_user_pages(mm, start, nr_pages, flags, pages,
 				       vmas, locked);
-		if (!locked)
+		if (!(flags & FOLL_UNLOCKABLE)) {
 			/* VM_FAULT_RETRY couldn't trigger, bypass */
-			return ret;
+			pages_done = ret;
+			break;
+		}
 
 		/* VM_FAULT_RETRY or VM_FAULT_COMPLETED cannot return errors */
 		if (!*locked) {
@@ -1532,6 +1534,9 @@ long populate_vma_page_range(struct vm_a
 	if (vma_is_accessible(vma))
 		gup_flags |= FOLL_FORCE;
 
+	if (locked)
+		gup_flags |= FOLL_UNLOCKABLE;
+
 	/*
 	 * We made sure addr is within a VMA, so the following will
 	 * not result in a stack expansion that recurses back here.
@@ -1583,7 +1588,7 @@ long faultin_vma_page_range(struct vm_ar
 	 *		  a poisoned page.
 	 * !FOLL_FORCE: Require proper access permissions.
 	 */
-	gup_flags = FOLL_TOUCH | FOLL_HWPOISON;
+	gup_flags = FOLL_TOUCH | FOLL_HWPOISON | FOLL_UNLOCKABLE;
 	if (write)
 		gup_flags |= FOLL_WRITE;
 
@@ -2107,12 +2112,20 @@ static bool is_valid_gup_args(struct pag
 	 * interfaces:
 	 * - FOLL_PIN/FOLL_TRIED/FOLL_FAST_ONLY are internal only
 	 * - FOLL_REMOTE is internal only and used on follow_page()
+	 * - FOLL_UNLOCKABLE is internal only and used if locked is !NULL
 	 */
-	if (WARN_ON_ONCE(gup_flags & (FOLL_PIN | FOLL_TRIED |
+	if (WARN_ON_ONCE(gup_flags & (FOLL_PIN | FOLL_TRIED | FOLL_UNLOCKABLE |
 				      FOLL_REMOTE | FOLL_FAST_ONLY)))
 		return false;
 
 	gup_flags |= to_set;
+	if (locked) {
+		/* At the external interface locked must be set */
+		if (WARN_ON_ONCE(*locked != 1))
+			return false;
+
+		gup_flags |= FOLL_UNLOCKABLE;
+	}
 
 	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
 	if (WARN_ON_ONCE((gup_flags & (FOLL_PIN | FOLL_GET)) ==
@@ -2127,10 +2140,6 @@ static bool is_valid_gup_args(struct pag
 	if (WARN_ON_ONCE((gup_flags & (FOLL_GET | FOLL_PIN)) && !pages))
 		return false;
 
-	/* At the external interface locked must be set */
-	if (WARN_ON_ONCE(locked && *locked != 1))
-		return false;
-
 	/* We want to allow the pgmap to be hot-unplugged at all times */
 	if (WARN_ON_ONCE((gup_flags & FOLL_LONGTERM) &&
 			 (gup_flags & FOLL_PCI_P2PDMA)))
@@ -2140,7 +2149,7 @@ static bool is_valid_gup_args(struct pag
 	 * Can't use VMAs with locked, as locked allows GUP to unlock
 	 * which invalidates the vmas array
 	 */
-	if (WARN_ON_ONCE(vmas && locked))
+	if (WARN_ON_ONCE(vmas && (gup_flags & FOLL_UNLOCKABLE)))
 		return false;
 
 	*gup_flags_p = gup_flags;
@@ -2280,7 +2289,8 @@ long get_user_pages_unlocked(unsigned lo
 {
 	int locked = 0;
 
-	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags, FOLL_TOUCH))
+	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags,
+			       FOLL_TOUCH | FOLL_UNLOCKABLE))
 		return -EINVAL;
 
 	return __get_user_pages_locked(current->mm, start, nr_pages, pages,
@@ -2968,7 +2978,7 @@ static int internal_get_user_pages_fast(
 	pages += nr_pinned;
 	ret = __gup_longterm_locked(current->mm, start, nr_pages - nr_pinned,
 				    pages, NULL, &locked,
-				    gup_flags | FOLL_TOUCH);
+				    gup_flags | FOLL_TOUCH | FOLL_UNLOCKABLE);
 	if (ret < 0) {
 		/*
 		 * The caller has to unpin the pages we already pinned so
@@ -3195,7 +3205,7 @@ long pin_user_pages_unlocked(unsigned lo
 	int locked = 0;
 
 	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags,
-			       FOLL_PIN | FOLL_TOUCH))
+			       FOLL_PIN | FOLL_TOUCH | FOLL_UNLOCKABLE))
 		return 0;
 
 	return __gup_longterm_locked(current->mm, start, nr_pages, pages, NULL,
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

