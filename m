Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F641C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjBJA5k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjBJA4L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:56:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAAA70944
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20334B82396
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE63FC433D2;
        Fri, 10 Feb 2023 00:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990478;
        bh=UNeiaC7RLbmHvf/R5kYNz2B0eHTUe++LjTnKHIRgTkA=;
        h=Date:To:From:Subject:From;
        b=TkeeZo9uJovry0/C4mUsCOyobcqyheA/nIcV/zgxTcXTLBW5Pbg7cnVdkVdk3JYrL
         PiIpinNsqYliL1AcezlfH0eVWTr2z3cn8UHyXPTNauhsQPucY7gMPfFsXLXYVQz8ZE
         k7O0SlqSn/jDs+WhyogXhcYQiJbhNRGEeZMqY99s=
Date:   Thu, 09 Feb 2023 16:54:38 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-add-foll_unlockable.patch removed from -mm tree
Message-Id: <20230210005438.BE63FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: add FOLL_UNLOCKABLE
has been removed from the -mm tree.  Its filename was
     mm-gup-add-foll_unlockable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/mm_types.h |    1 +
 mm/gup.c                 |   36 +++++++++++++++++++++++-------------
 2 files changed, 24 insertions(+), 13 deletions(-)

--- a/include/linux/mm_types.h~mm-gup-add-foll_unlockable
+++ a/include/linux/mm_types.h
@@ -1104,5 +1104,6 @@ typedef unsigned int __bitwise zap_flags
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


