Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE97C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiLAAGd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiLAAEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017DB9074E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5A5CB81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3474CC43470;
        Thu,  1 Dec 2022 00:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852919;
        bh=fC96z4Kden3tEbro23pwhUfpSy0CBMjafY94VoBm5oE=;
        h=Date:To:From:Subject:From;
        b=y3FapTEpeA7uPAnOlIPBt7PHOYA1hBM/wcIdXrG3CmKxYx2tV9td9Nrqt1KWEN5Gn
         ebeN+GO09yo1JXvr3O6lolLsPLs7jZaAgAtUDHTw3KChcsr3WYsab11wGTkrCg5AFP
         ZVhrAUqkOnH29Y0RY1BGmsjwVT5P4Hwqpi/Um3aU=
Date:   Wed, 30 Nov 2022 16:01:58 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com,
        apopple@nvidia.com, jgg@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-the-restriction-on-locked-with-foll_longterm.patch removed from -mm tree
Message-Id: <20221201000159.3474CC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: remove the restriction on locked with FOLL_LONGTERM
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-the-restriction-on-locked-with-foll_longterm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: remove the restriction on locked with FOLL_LONGTERM
Date: Wed, 16 Nov 2022 16:07:09 -0400

This restriction was created because FOLL_LONGTERM used to scan the vma
list, so it could not tolerate becoming unlocked.  That was fixed in
commit 52650c8b466b ("mm/gup: remove the vma allocation from
gup_longterm_locked()") and the restriction on !vma was removed.

However, the locked restriction remained, even though it isn't necessary
anymore.

Adjust __gup_longterm_locked() so it can handle the mmap_read_lock()
becoming unlocked while it is looping for migration.  Migration does not
require the mmap_read_sem because it is only handling struct pages.  If we
had to unlock then ensure the whole thing returns unlocked.

Remove __get_user_pages_remote() and __gup_longterm_unlocked().  These
cases can now just directly call other functions.

Link: https://lkml.kernel.org/r/0-v1-b9ae39aa8884+14dbb-gup_longterm_locked_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  109 +++++++++++++----------------------------------------
 1 file changed, 27 insertions(+), 82 deletions(-)

--- a/mm/gup.c~mm-gup-remove-the-restriction-on-locked-with-foll_longterm
+++ a/mm/gup.c
@@ -2049,14 +2049,19 @@ static long __gup_longterm_locked(struct
 				  unsigned long nr_pages,
 				  struct page **pages,
 				  struct vm_area_struct **vmas,
+				  int *locked,
 				  unsigned int gup_flags)
 {
+	bool must_unlock = false;
 	unsigned int flags;
 	long rc, nr_pinned_pages;
 
+	if (locked && WARN_ON_ONCE(!*locked))
+		return -EINVAL;
+
 	if (!(gup_flags & FOLL_LONGTERM))
 		return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
-					       NULL, gup_flags);
+					       locked, gup_flags);
 
 	/*
 	 * If we get to this point then FOLL_LONGTERM is set, and FOLL_LONGTERM
@@ -2070,8 +2075,13 @@ static long __gup_longterm_locked(struct
 		return -EINVAL;
 	flags = memalloc_pin_save();
 	do {
+		if (locked && !*locked) {
+			mmap_read_lock(mm);
+			must_unlock = true;
+			*locked = 1;
+		}
 		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
-							  pages, vmas, NULL,
+							  pages, vmas, locked,
 							  gup_flags);
 		if (nr_pinned_pages <= 0) {
 			rc = nr_pinned_pages;
@@ -2081,6 +2091,10 @@ static long __gup_longterm_locked(struct
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 
+	if (locked && *locked && must_unlock) {
+		mmap_read_unlock(mm);
+		*locked = 0;
+	}
 	return rc ? rc : nr_pinned_pages;
 }
 
@@ -2104,35 +2118,6 @@ static bool is_valid_gup_flags(unsigned
 }
 
 #ifdef CONFIG_MMU
-static long __get_user_pages_remote(struct mm_struct *mm,
-				    unsigned long start, unsigned long nr_pages,
-				    unsigned int gup_flags, struct page **pages,
-				    struct vm_area_struct **vmas, int *locked)
-{
-	/*
-	 * Parts of FOLL_LONGTERM behavior are incompatible with
-	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas. However, this only comes up if locked is set, and there are
-	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
-	 * allow what we can.
-	 */
-	if (gup_flags & FOLL_LONGTERM) {
-		if (WARN_ON_ONCE(locked))
-			return -EINVAL;
-		/*
-		 * This will check the vmas (even if our vmas arg is NULL)
-		 * and return -ENOTSUPP if DAX isn't allowed in this case:
-		 */
-		return __gup_longterm_locked(mm, start, nr_pages, pages,
-					     vmas, gup_flags | FOLL_TOUCH |
-					     FOLL_REMOTE);
-	}
-
-	return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
-				       locked,
-				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
-}
-
 /**
  * get_user_pages_remote() - pin user pages in memory
  * @mm:		mm_struct of target mm
@@ -2201,8 +2186,8 @@ long get_user_pages_remote(struct mm_str
 	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
 
-	return __get_user_pages_remote(mm, start, nr_pages, gup_flags,
-				       pages, vmas, locked);
+	return __gup_longterm_locked(mm, start, nr_pages, pages, vmas, locked,
+				     gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 EXPORT_SYMBOL(get_user_pages_remote);
 
@@ -2214,14 +2199,6 @@ long get_user_pages_remote(struct mm_str
 {
 	return 0;
 }
-
-static long __get_user_pages_remote(struct mm_struct *mm,
-				    unsigned long start, unsigned long nr_pages,
-				    unsigned int gup_flags, struct page **pages,
-				    struct vm_area_struct **vmas, int *locked)
-{
-	return 0;
-}
 #endif /* !CONFIG_MMU */
 
 /**
@@ -2248,7 +2225,7 @@ long get_user_pages(unsigned long start,
 		return -EINVAL;
 
 	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, vmas, gup_flags | FOLL_TOUCH);
+				     pages, vmas, NULL, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages);
 
@@ -2274,18 +2251,9 @@ long get_user_pages_unlocked(unsigned lo
 	int locked = 1;
 	long ret;
 
-	/*
-	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
-	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas.  As there are no users of this flag in this call we simply
-	 * disallow this option for now.
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
-		return -EINVAL;
-
 	mmap_read_lock(mm);
-	ret = __get_user_pages_locked(mm, start, nr_pages, pages, NULL,
-				      &locked, gup_flags | FOLL_TOUCH);
+	ret = __gup_longterm_locked(mm, start, nr_pages, pages, NULL, &locked,
+				    gup_flags | FOLL_TOUCH);
 	if (locked)
 		mmap_read_unlock(mm);
 	return ret;
@@ -2879,29 +2847,6 @@ static bool gup_fast_permitted(unsigned
 }
 #endif
 
-static int __gup_longterm_unlocked(unsigned long start, int nr_pages,
-				   unsigned int gup_flags, struct page **pages)
-{
-	int ret;
-
-	/*
-	 * FIXME: FOLL_LONGTERM does not work with
-	 * get_user_pages_unlocked() (see comments in that function)
-	 */
-	if (gup_flags & FOLL_LONGTERM) {
-		mmap_read_lock(current->mm);
-		ret = __gup_longterm_locked(current->mm,
-					    start, nr_pages,
-					    pages, NULL, gup_flags);
-		mmap_read_unlock(current->mm);
-	} else {
-		ret = get_user_pages_unlocked(start, nr_pages,
-					      pages, gup_flags);
-	}
-
-	return ret;
-}
-
 static unsigned long lockless_pages_from_mm(unsigned long start,
 					    unsigned long end,
 					    unsigned int gup_flags,
@@ -2985,8 +2930,8 @@ static int internal_get_user_pages_fast(
 	/* Slow path: try to get the remaining pages with get_user_pages */
 	start += nr_pinned << PAGE_SHIFT;
 	pages += nr_pinned;
-	ret = __gup_longterm_unlocked(start, nr_pages - nr_pinned, gup_flags,
-				      pages);
+	ret = get_user_pages_unlocked(start, nr_pages - nr_pinned, pages,
+				      gup_flags);
 	if (ret < 0) {
 		/*
 		 * The caller has to unpin the pages we already pinned so
@@ -3185,9 +3130,9 @@ long pin_user_pages_remote(struct mm_str
 	if (WARN_ON_ONCE(!pages))
 		return -EINVAL;
 
-	gup_flags |= FOLL_PIN;
-	return __get_user_pages_remote(mm, start, nr_pages, gup_flags,
-				       pages, vmas, locked);
+	return __gup_longterm_locked(mm, start, nr_pages, pages, vmas, locked,
+				     gup_flags | FOLL_PIN | FOLL_TOUCH |
+					     FOLL_REMOTE);
 }
 EXPORT_SYMBOL(pin_user_pages_remote);
 
@@ -3221,7 +3166,7 @@ long pin_user_pages(unsigned long start,
 
 	gup_flags |= FOLL_PIN;
 	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, vmas, gup_flags);
+				     pages, vmas, NULL, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
 
_

Patches currently in -mm which might be from jgg@nvidia.com are


