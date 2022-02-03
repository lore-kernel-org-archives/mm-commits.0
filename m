Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B286C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  3 Feb 2022 22:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355770AbiBCWWC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 17:22:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54108 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBCWWC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 17:22:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A4ACB835E5
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 22:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EA3C340E8;
        Thu,  3 Feb 2022 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643926920;
        bh=LVnxMtl1sp1upBIgJ4tloyf+tGWffy5hhE5iYHugjrE=;
        h=Date:To:From:Subject:From;
        b=lOvJ32Vpt/LK4CsDep5hK6rJHWHswE1PXCzHMs7CHb4jGbKVFddIl0C+B0S/wc9o6
         EeM6nTDS3rW9ws/iTfxfkzgCjqV9OApsM1/DPXWEuutFmak1W1oC56u5LrBx4hjxjK
         4uNgexPVvuZ5wT3hH4eJR84EwJx4inZyR0MRnKzQ=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 14:21:58 -0800
Date:   Thu, 03 Feb 2022 14:21:58 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jgg@nvidia.com,
        jack@suse.cz, hch@lst.de, david@redhat.com,
        alex.williamson@redhat.com, aarcange@redhat.com,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-gup-remove-unused-pin_user_pages_locked.patch removed from -mm tree
Message-Id: <20220203222158.B5EA3C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove unused pin_user_pages_locked()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-unused-pin_user_pages_locked.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: remove unused pin_user_pages_locked()

This routine was used for a short while, but then the calling code was
refactored and the only caller was removed.

Link: https://lkml.kernel.org/r/20220201101108.306062-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/gup.c           |   29 -----------------------------
 2 files changed, 31 deletions(-)

--- a/include/linux/mm.h~mm-gup-remove-unused-pin_user_pages_locked
+++ a/include/linux/mm.h
@@ -1918,8 +1918,6 @@ long pin_user_pages(unsigned long start,
 		    struct vm_area_struct **vmas);
 long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
-long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
--- a/mm/gup.c~mm-gup-remove-unused-pin_user_pages_locked
+++ a/mm/gup.c
@@ -3120,32 +3120,3 @@ long pin_user_pages_unlocked(unsigned lo
 	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
-
-/*
- * pin_user_pages_locked() is the FOLL_PIN variant of get_user_pages_locked().
- * Behavior is the same, except that this one sets FOLL_PIN and rejects
- * FOLL_GET.
- */
-long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
-			   unsigned int gup_flags, struct page **pages,
-			   int *locked)
-{
-	/*
-	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
-	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas.  As there are no users of this flag in this call we simply
-	 * disallow this option for now.
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
-		return -EINVAL;
-
-	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
-	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
-		return -EINVAL;
-
-	gup_flags |= FOLL_PIN;
-	return __get_user_pages_locked(current->mm, start, nr_pages,
-				       pages, NULL, locked,
-				       gup_flags | FOLL_TOUCH);
-}
-EXPORT_SYMBOL(pin_user_pages_locked);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-remove-get_user_pages_locked.patch

