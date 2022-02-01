Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77995C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 20:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiBAU6a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:58:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59360 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242667AbiBAU60 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 15:58:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFC9C6176B
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 20:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01C3C340EB;
        Tue,  1 Feb 2022 20:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643749105;
        bh=uySinXV1IVIh+JM81IdO1rcp+QoS/7A0vzCC4Lz+FXw=;
        h=Date:To:From:Subject:From;
        b=VOrvN6nQI0oy57WzGwshQkwFnD+O/pMzzciiIogvKNsihRLW5/GSYXrLMKWyqG016
         EWuBzdMYOBhKoJNRARHGi9eDRDp+5qQfkvW/3OMBRxbKrTtQGY+BwctK6vzfvJM1aW
         3tlSiB3FRFeNlArOjrc6k0p+ZAhCq23PSPBffLVc=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 12:58:23 -0800
Date:   Tue, 01 Feb 2022 12:58:23 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jgg@nvidia.com,
        jack@suse.cz, david@redhat.com, alex.williamson@redhat.com,
        aarcange@redhat.com, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-get_user_pages_locked.patch added to -mm tree
Message-Id: <20220201205823.D01C3C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove get_user_pages_locked()
has been added to the -mm tree.  Its filename is
     mm-gup-remove-get_user_pages_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-remove-get_user_pages_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-remove-get_user_pages_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: remove get_user_pages_locked()

There is only one caller of get_user_pages_locked().  The purpose of
get_user_pages_locked() is to allow for unlocking the mmap_lock when
reading a page from the disk during a page fault (hidden behind
VM_FAULT_RETRY).  The idea is to reduce contention on the heavily-used
mmap_lock.  (Thanks to Jan Kara for clearly pointing that out, and in fact
I've used some of his wording here.)

However, it is unlikely for lookup_node() to take a page fault.  With that
in mind, change over to calling get_user_pages_fast().  This simplifies
the code, runs a little faster in the expected case, and allows removing
get_user_pages_locked() entirely.

Link: https://lkml.kernel.org/r/20220201101108.306062-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 -
 mm/gup.c           |   59 -------------------------------------------
 mm/mempolicy.c     |   21 ++++++---------
 3 files changed, 9 insertions(+), 73 deletions(-)

--- a/include/linux/mm.h~mm-gup-remove-get_user_pages_locked
+++ a/include/linux/mm.h
@@ -1916,8 +1916,6 @@ long get_user_pages(unsigned long start,
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages,
 		    struct vm_area_struct **vmas);
-long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
--- a/mm/gup.c~mm-gup-remove-get_user_pages_locked
+++ a/mm/gup.c
@@ -2119,65 +2119,6 @@ long get_user_pages(unsigned long start,
 }
 EXPORT_SYMBOL(get_user_pages);
 
-/**
- * get_user_pages_locked() - variant of get_user_pages()
- *
- * @start:      starting user address
- * @nr_pages:   number of pages from start to pin
- * @gup_flags:  flags modifying lookup behaviour
- * @pages:      array that receives pointers to the pages pinned.
- *              Should be at least nr_pages long. Or NULL, if caller
- *              only intends to ensure the pages are faulted in.
- * @locked:     pointer to lock flag indicating whether lock is held and
- *              subsequently whether VM_FAULT_RETRY functionality can be
- *              utilised. Lock must initially be held.
- *
- * It is suitable to replace the form:
- *
- *      mmap_read_lock(mm);
- *      do_something()
- *      get_user_pages(mm, ..., pages, NULL);
- *      mmap_read_unlock(mm);
- *
- *  to:
- *
- *      int locked = 1;
- *      mmap_read_lock(mm);
- *      do_something()
- *      get_user_pages_locked(mm, ..., pages, &locked);
- *      if (locked)
- *          mmap_read_unlock(mm);
- *
- * We can leverage the VM_FAULT_RETRY functionality in the page fault
- * paths better by using either get_user_pages_locked() or
- * get_user_pages_unlocked().
- *
- */
-long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
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
-	/*
-	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
-	 * never directly by the caller, so enforce that:
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
-		return -EINVAL;
-
-	return __get_user_pages_locked(current->mm, start, nr_pages,
-				       pages, NULL, locked,
-				       gup_flags | FOLL_TOUCH);
-}
-EXPORT_SYMBOL(get_user_pages_locked);
-
 /*
  * get_user_pages_unlocked() is suitable to replace the form:
  *
--- a/mm/mempolicy.c~mm-gup-remove-get_user_pages_locked
+++ a/mm/mempolicy.c
@@ -907,17 +907,14 @@ static void get_policy_nodemask(struct m
 static int lookup_node(struct mm_struct *mm, unsigned long addr)
 {
 	struct page *p = NULL;
-	int err;
+	int ret;
 
-	int locked = 1;
-	err = get_user_pages_locked(addr & PAGE_MASK, 1, 0, &p, &locked);
-	if (err > 0) {
-		err = page_to_nid(p);
+	ret = get_user_pages_fast(addr & PAGE_MASK, 1, 0, &p);
+	if (ret > 0) {
+		ret = page_to_nid(p);
 		put_page(p);
 	}
-	if (locked)
-		mmap_read_unlock(mm);
-	return err;
+	return ret;
 }
 
 /* Retrieve NUMA policy */
@@ -968,14 +965,14 @@ static long do_get_mempolicy(int *policy
 	if (flags & MPOL_F_NODE) {
 		if (flags & MPOL_F_ADDR) {
 			/*
-			 * Take a refcount on the mpol, lookup_node()
-			 * will drop the mmap_lock, so after calling
-			 * lookup_node() only "pol" remains valid, "vma"
-			 * is stale.
+			 * Take a refcount on the mpol, because we are about to
+			 * drop the mmap_lock, after which only "pol" remains
+			 * valid, "vma" is stale.
 			 */
 			pol_refcount = pol;
 			vma = NULL;
 			mpol_get(pol);
+			mmap_read_unlock(mm);
 			err = lookup_node(mm, addr);
 			if (err < 0)
 				goto out;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-clean-up-follow_pfn_pte-slightly.patch
mm-gup-remove-unused-pin_user_pages_locked.patch
mm-gup-remove-get_user_pages_locked.patch

