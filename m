Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3726AC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 21:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbiKPVBP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 16:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbiKPVAq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 16:00:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4F631EC1
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 12:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D62961FB7
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 20:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D370AC433D6;
        Wed, 16 Nov 2022 20:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668632325;
        bh=JWWrpDhfh7Oj8hW6C9+8IdUNBYMQMBmyB4bJyk4WQrw=;
        h=Date:To:From:Subject:From;
        b=sacXukDrzjdWPg2zUH3toiteV4Eq4dwLy7MHUxuY6PskyekN1F2NAiCIcH8lqcul6
         Es/Q/w5ycbNO6G49GFlktt8bOUBYcv2HkAvVWTVnPrh0mBjnBuvwgzbNg5V/adSs+o
         0eEFAnT/Vz2DyngHoAQ6FmaE41VYOQblESNDkT4M=
Date:   Wed, 16 Nov 2022 12:58:44 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com,
        apopple@nvidia.com, jgg@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-the-restriction-on-locked-with-foll_longterm.patch added to mm-unstable branch
Message-Id: <20221116205845.D370AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove the restriction on locked with FOLL_LONGTERM
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-the-restriction-on-locked-with-foll_longterm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-the-restriction-on-locked-with-foll_longterm.patch

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
Cc: Alistair Popple <apopple@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  109 +++++++++++++----------------------------------------
 1 file changed, 27 insertions(+), 82 deletions(-)

--- a/mm/gup.c~mm-gup-remove-the-restriction-on-locked-with-foll_longterm
+++ a/mm/gup.c
@@ -1982,14 +1982,19 @@ static long __gup_longterm_locked(struct
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
@@ -2003,8 +2008,13 @@ static long __gup_longterm_locked(struct
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
@@ -2014,6 +2024,10 @@ static long __gup_longterm_locked(struct
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 
+	if (locked && *locked && must_unlock) {
+		mmap_read_unlock(mm);
+		*locked = 0;
+	}
 	return rc ? rc : nr_pinned_pages;
 }
 
@@ -2037,35 +2051,6 @@ static bool is_valid_gup_flags(unsigned
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
@@ -2134,8 +2119,8 @@ long get_user_pages_remote(struct mm_str
 	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
 
-	return __get_user_pages_remote(mm, start, nr_pages, gup_flags,
-				       pages, vmas, locked);
+	return __gup_longterm_locked(mm, start, nr_pages, pages, vmas, locked,
+				     gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 EXPORT_SYMBOL(get_user_pages_remote);
 
@@ -2147,14 +2132,6 @@ long get_user_pages_remote(struct mm_str
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
@@ -2181,7 +2158,7 @@ long get_user_pages(unsigned long start,
 		return -EINVAL;
 
 	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, vmas, gup_flags | FOLL_TOUCH);
+				     pages, vmas, NULL, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages);
 
@@ -2207,18 +2184,9 @@ long get_user_pages_unlocked(unsigned lo
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
@@ -2787,29 +2755,6 @@ static bool gup_fast_permitted(unsigned
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
@@ -2893,8 +2838,8 @@ static int internal_get_user_pages_fast(
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
@@ -3093,9 +3038,9 @@ long pin_user_pages_remote(struct mm_str
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
 
@@ -3129,7 +3074,7 @@ long pin_user_pages(unsigned long start,
 
 	gup_flags |= FOLL_PIN;
 	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, vmas, gup_flags);
+				     pages, vmas, NULL, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
 
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-remove-the-restriction-on-locked-with-foll_longterm.patch

