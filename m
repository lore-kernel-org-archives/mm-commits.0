Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344AAC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjBJA5R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjBJAz0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219956F8D2
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADD2E61BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF77C433D2;
        Fri, 10 Feb 2023 00:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990468;
        bh=MqR+ykdOm+mw438P9ZpZRvbiULiUeV3bAv+/MwGyYHU=;
        h=Date:To:From:Subject:From;
        b=b2cLry5KJxyXYvsW3PVOuwMLSW5ODCeYpVcU8Xf0693WFx3oKlcBvBJmgAMP5eqT+
         oQ1t5n4FWZgtz4Mn9iqD6dWW4QdGdNDx7fpZJ9YwdXb2MI5QCZ6OG+2aaru/AGzgGK
         0EbrZqUO9L6nClTRtGuqJQthS0whcINch5b5L3SI=
Date:   Thu, 09 Feb 2023 16:54:27 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-have-internal-functions-get-the-mmap_read_lock.patch removed from -mm tree
Message-Id: <20230210005428.0EF77C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: have internal functions get the mmap_read_lock()
has been removed from the -mm tree.  Its filename was
     mm-gup-have-internal-functions-get-the-mmap_read_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: have internal functions get the mmap_read_lock()
Date: Tue, 24 Jan 2023 16:34:22 -0400

Patch series "Simplify the external interface for GUP", v2.

It is quite a maze of EXPORTED symbols leading up to the three actual
worker functions of GUP. Simplify this by reorganizing some of the code so
the EXPORTED symbols directly call the correct internal function with
validated and consistent arguments.

Consolidate all the assertions into one place at the top of the call
chains.

Remove some dead code.

Move more things into the mm/internal.h header


This patch (of 13):

__get_user_pages_locked() and __gup_longterm_locked() both require the
mmap lock to be held.  They have a slightly unusual locked parameter that
is used to allow these functions to unlock and relock the mmap lock and
convey that fact to the caller.

Several places wrap these functions with a simple mmap_read_lock() just so
they can follow the optimized locked protocol.

Consolidate this internally to the functions.  Allow internal callers to
set locked = 0 to cause the functions to acquire and release the lock on
their own.

Reorganize __gup_longterm_locked() to use the autolocking in
__get_user_pages_locked().

Replace all the places obtaining the mmap_read_lock() just to call
__get_user_pages_locked() with the new mechanism.  Replace all the
internal callers of get_user_pages_unlocked() with direct calls to
__gup_longterm_locked() using the new mechanism.

A following patch will add assertions ensuring the external interface
continues to always pass in locked = 1.

Link: https://lkml.kernel.org/r/0-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Link: https://lkml.kernel.org/r/1-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  113 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 65 insertions(+), 48 deletions(-)

--- a/mm/gup.c~mm-gup-have-internal-functions-get-the-mmap_read_lock
+++ a/mm/gup.c
@@ -1331,8 +1331,17 @@ static bool gup_signal_pending(unsigned
 }
 
 /*
- * Please note that this function, unlike __get_user_pages will not
- * return 0 for nr_pages > 0 without FOLL_NOWAIT
+ * Locking: (*locked == 1) means that the mmap_lock has already been acquired by
+ * the caller. This function may drop the mmap_lock. If it does so, then it will
+ * set (*locked = 0).
+ *
+ * (*locked == 0) means that the caller expects this function to acquire and
+ * drop the mmap_lock. Therefore, the value of *locked will still be zero when
+ * the function returns, even though it may have changed temporarily during
+ * function execution.
+ *
+ * Please note that this function, unlike __get_user_pages(), will not return 0
+ * for nr_pages > 0, unless FOLL_NOWAIT is used.
  */
 static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 						unsigned long start,
@@ -1343,13 +1352,22 @@ static __always_inline long __get_user_p
 						unsigned int flags)
 {
 	long ret, pages_done;
-	bool lock_dropped;
+	bool must_unlock = false;
 
 	if (locked) {
 		/* if VM_FAULT_RETRY can be returned, vmas become invalid */
 		BUG_ON(vmas);
-		/* check caller initialized locked */
-		BUG_ON(*locked != 1);
+	}
+
+	/*
+	 * The internal caller expects GUP to manage the lock internally and the
+	 * lock must be released when this returns.
+	 */
+	if (locked && !*locked) {
+		if (mmap_read_lock_killable(mm))
+			return -EAGAIN;
+		must_unlock = true;
+		*locked = 1;
 	}
 
 	if (flags & FOLL_PIN)
@@ -1368,7 +1386,6 @@ static __always_inline long __get_user_p
 		flags |= FOLL_GET;
 
 	pages_done = 0;
-	lock_dropped = false;
 	for (;;) {
 		ret = __get_user_pages(mm, start, nr_pages, flags, pages,
 				       vmas, locked);
@@ -1404,7 +1421,9 @@ static __always_inline long __get_user_p
 		if (likely(pages))
 			pages += ret;
 		start += ret << PAGE_SHIFT;
-		lock_dropped = true;
+
+		/* The lock was temporarily dropped, so we must unlock later */
+		must_unlock = true;
 
 retry:
 		/*
@@ -1451,10 +1470,11 @@ retry:
 			pages++;
 		start += PAGE_SIZE;
 	}
-	if (lock_dropped && *locked) {
+	if (must_unlock && *locked) {
 		/*
-		 * We must let the caller know we temporarily dropped the lock
-		 * and so the critical section protected by it was lost.
+		 * We either temporarily dropped the lock, or the caller
+		 * requested that we both acquire and drop the lock. Either way,
+		 * we must now unlock, and notify the caller of that state.
 		 */
 		mmap_read_unlock(mm);
 		*locked = 0;
@@ -1659,9 +1679,24 @@ static long __get_user_pages_locked(stru
 		unsigned int foll_flags)
 {
 	struct vm_area_struct *vma;
+	bool must_unlock = false;
 	unsigned long vm_flags;
 	long i;
 
+	if (!nr_pages)
+		return 0;
+
+	/*
+	 * The internal caller expects GUP to manage the lock internally and the
+	 * lock must be released when this returns.
+	 */
+	if (locked && !*locked) {
+		if (mmap_read_lock_killable(mm))
+			return -EAGAIN;
+		must_unlock = true;
+		*locked = 1;
+	}
+
 	/* calculate required read or write permissions.
 	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
@@ -1673,12 +1708,12 @@ static long __get_user_pages_locked(stru
 	for (i = 0; i < nr_pages; i++) {
 		vma = find_vma(mm, start);
 		if (!vma)
-			goto finish_or_fault;
+			break;
 
 		/* protect what we can, including chardevs */
 		if ((vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
 		    !(vm_flags & vma->vm_flags))
-			goto finish_or_fault;
+			break;
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
@@ -1690,9 +1725,11 @@ static long __get_user_pages_locked(stru
 		start = (start + PAGE_SIZE) & PAGE_MASK;
 	}
 
-	return i;
+	if (must_unlock && *locked) {
+		mmap_read_unlock(mm);
+		*locked = 0;
+	}
 
-finish_or_fault:
 	return i ? : -EFAULT;
 }
 #endif /* !CONFIG_MMU */
@@ -1861,17 +1898,13 @@ EXPORT_SYMBOL(fault_in_readable);
 #ifdef CONFIG_ELF_CORE
 struct page *get_dump_page(unsigned long addr)
 {
-	struct mm_struct *mm = current->mm;
 	struct page *page;
-	int locked = 1;
+	int locked = 0;
 	int ret;
 
-	if (mmap_read_lock_killable(mm))
-		return NULL;
-	ret = __get_user_pages_locked(mm, addr, 1, &page, NULL, &locked,
+	ret = __get_user_pages_locked(current->mm, addr, 1, &page, NULL,
+				      &locked,
 				      FOLL_FORCE | FOLL_DUMP | FOLL_GET);
-	if (locked)
-		mmap_read_unlock(mm);
 	return (ret == 1) ? page : NULL;
 }
 #endif /* CONFIG_ELF_CORE */
@@ -2047,13 +2080,9 @@ static long __gup_longterm_locked(struct
 				  int *locked,
 				  unsigned int gup_flags)
 {
-	bool must_unlock = false;
 	unsigned int flags;
 	long rc, nr_pinned_pages;
 
-	if (locked && WARN_ON_ONCE(!*locked))
-		return -EINVAL;
-
 	if (!(gup_flags & FOLL_LONGTERM))
 		return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
 					       locked, gup_flags);
@@ -2070,11 +2099,6 @@ static long __gup_longterm_locked(struct
 		return -EINVAL;
 	flags = memalloc_pin_save();
 	do {
-		if (locked && !*locked) {
-			mmap_read_lock(mm);
-			must_unlock = true;
-			*locked = 1;
-		}
 		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
 							  pages, vmas, locked,
 							  gup_flags);
@@ -2085,11 +2109,6 @@ static long __gup_longterm_locked(struct
 		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages);
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
-
-	if (locked && *locked && must_unlock) {
-		mmap_read_unlock(mm);
-		*locked = 0;
-	}
 	return rc ? rc : nr_pinned_pages;
 }
 
@@ -2242,16 +2261,10 @@ EXPORT_SYMBOL(get_user_pages);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 			     struct page **pages, unsigned int gup_flags)
 {
-	struct mm_struct *mm = current->mm;
-	int locked = 1;
-	long ret;
+	int locked = 0;
 
-	mmap_read_lock(mm);
-	ret = __gup_longterm_locked(mm, start, nr_pages, pages, NULL, &locked,
-				    gup_flags | FOLL_TOUCH);
-	if (locked)
-		mmap_read_unlock(mm);
-	return ret;
+	return __gup_longterm_locked(current->mm, start, nr_pages, pages, NULL,
+				     &locked, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
@@ -2904,6 +2917,7 @@ static int internal_get_user_pages_fast(
 {
 	unsigned long len, end;
 	unsigned long nr_pinned;
+	int locked = 0;
 	int ret;
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
@@ -2932,8 +2946,9 @@ static int internal_get_user_pages_fast(
 	/* Slow path: try to get the remaining pages with get_user_pages */
 	start += nr_pinned << PAGE_SHIFT;
 	pages += nr_pinned;
-	ret = get_user_pages_unlocked(start, nr_pages - nr_pinned, pages,
-				      gup_flags);
+	ret = __gup_longterm_locked(current->mm, start, nr_pages - nr_pinned,
+				    pages, NULL, &locked,
+				    gup_flags | FOLL_TOUCH);
 	if (ret < 0) {
 		/*
 		 * The caller has to unpin the pages we already pinned so
@@ -3183,11 +3198,13 @@ long pin_user_pages_unlocked(unsigned lo
 	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
 	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
 		return -EINVAL;
+	int locked = 0;
 
 	if (WARN_ON_ONCE(!pages))
 		return -EINVAL;
 
-	gup_flags |= FOLL_PIN;
-	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
+	gup_flags |= FOLL_PIN | FOLL_TOUCH;
+	return __gup_longterm_locked(current->mm, start, nr_pages, pages, NULL,
+				     &locked, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
_

Patches currently in -mm which might be from jgg@nvidia.com are


