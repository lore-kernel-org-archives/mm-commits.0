Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D572C43334
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 23:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355419AbiFUXfz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 19:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355424AbiFUXfl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 19:35:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766D263C3
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 16:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9EC461725
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 23:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1701C3411C;
        Tue, 21 Jun 2022 23:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655854535;
        bh=KwWwGkX2VFQ3oJ2KTwZIKYhImwrMhAqpV5Sau6gBorg=;
        h=Date:To:From:Subject:From;
        b=MPJ44WeSZUMEZHoawYrLNrLIxv2DGOBHdUe5Fy0BZ/iCNwYn0VeDx9mrCBRs1faIC
         7FCEXY9nMyH8OGEhGUe16/eK5QVewQW3XQc+49y1ZqZ+GAXAnn51U8GITkgaoiAKPy
         iFKu8yuuEOFiwj2Q099UB28udC1vDVjQ0OFMWJCU=
Date:   Tue, 21 Jun 2022 16:35:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tkjos@android.com,
        surenb@google.com, minchan@kernel.org, maco@android.com,
        joel@joelfernandes.org, hridya@google.com,
        gregkh@linuxfoundation.org, brauner@kernel.org,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + android-binder-stop-saving-a-pointer-to-the-vma.patch added to mm-unstable branch
Message-Id: <20220621233533.C1701C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Mon, 20 Jun 2022 21:09:09 -0400
has been added to the -mm mm-unstable branch.  Its filename is
     android-binder-stop-saving-a-pointer-to-the-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/android-binder-stop-saving-a-pointer-to-the-vma.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Date: Mon, 20 Jun 2022 21:09:09 -0400
Subject: android: binder: stop saving a pointer to the VMA

Do not record a pointer to a VMA outside of the mmap_lock for later use. 
This is unsafe and there are a number of failure paths *after* the
recorded VMA pointer may be freed during setup.  There is no callback to
the driver to clear the saved pointer from generic mm code.  Furthermore,
the VMA pointer may become stale if any number of VMA operations end up
freeing the VMA so saving it was fragile to being with.

Instead, change the binder_alloc struct to record the start address of the
VMA and use vma_lookup() to get the vma when needed.  Add lockdep
mmap_lock checks on updates to the vma pointer to ensure the lock is held
and depend on that lock for synchronization of readers and writers - which
was already the case anyways, so the smp_wmb()/smp_rmb() was not
necessary.

Link: https://lkml.kernel.org/r/20220621140212.vpkio64idahetbyf@revolver
Fixes: da1b9564e85b ("android: binder: fix the race mmap and alloc_new_buf_locked")
Reported-by: syzbot+58b51ac2b04e388ab7b0@syzkaller.appspotmail.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Martijn Coenen <maco@android.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder_alloc.c |   30 ++++++++++++++----------------
 drivers/android/binder_alloc.h |    2 +-
 2 files changed, 15 insertions(+), 17 deletions(-)

--- a/drivers/android/binder_alloc.c~android-binder-stop-saving-a-pointer-to-the-vma
+++ a/drivers/android/binder_alloc.c
@@ -213,7 +213,7 @@ static int binder_update_page_range(stru
 
 	if (mm) {
 		mmap_read_lock(mm);
-		vma = alloc->vma;
+		vma = vma_lookup(mm, alloc->vma_addr);
 	}
 
 	if (!vma && need_mm) {
@@ -313,16 +313,15 @@ err_no_vma:
 static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
 		struct vm_area_struct *vma)
 {
-	if (vma)
+	unsigned long vm_start = 0;
+
+	if (vma) {
+		vm_start = vma->vm_start;
 		alloc->vma_vm_mm = vma->vm_mm;
-	/*
-	 * If we see alloc->vma is not NULL, buffer data structures set up
-	 * completely. Look at smp_rmb side binder_alloc_get_vma.
-	 * We also want to guarantee new alloc->vma_vm_mm is always visible
-	 * if alloc->vma is set.
-	 */
-	smp_wmb();
-	alloc->vma = vma;
+	}
+
+	mmap_assert_write_locked(alloc->vma_vm_mm);
+	alloc->vma_addr = vm_start;
 }
 
 static inline struct vm_area_struct *binder_alloc_get_vma(
@@ -330,11 +329,9 @@ static inline struct vm_area_struct *bin
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (alloc->vma) {
-		/* Look at description in binder_alloc_set_vma */
-		smp_rmb();
-		vma = alloc->vma;
-	}
+	if (alloc->vma_addr)
+		vma = vma_lookup(alloc->vma_vm_mm, alloc->vma_addr);
+
 	return vma;
 }
 
@@ -817,7 +814,8 @@ void binder_alloc_deferred_release(struc
 
 	buffers = 0;
 	mutex_lock(&alloc->mutex);
-	BUG_ON(alloc->vma);
+	BUG_ON(alloc->vma_addr &&
+	       vma_lookup(alloc->vma_vm_mm, alloc->vma_addr));
 
 	while ((n = rb_first(&alloc->allocated_buffers))) {
 		buffer = rb_entry(n, struct binder_buffer, rb_node);
--- a/drivers/android/binder_alloc.h~android-binder-stop-saving-a-pointer-to-the-vma
+++ a/drivers/android/binder_alloc.h
@@ -100,7 +100,7 @@ struct binder_lru_page {
  */
 struct binder_alloc {
 	struct mutex mutex;
-	struct vm_area_struct *vma;
+	unsigned long vma_addr;
 	struct mm_struct *vma_vm_mm;
 	void __user *buffer;
 	struct list_head buffers;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

android-binder-stop-saving-a-pointer-to-the-vma.patch
maple-tree-add-new-data-structure-fix-6.patch
nommu-remove-uses-of-vma-linked-list-fix.patch
nommu-remove-uses-of-vma-linked-list-fix-fix.patch

