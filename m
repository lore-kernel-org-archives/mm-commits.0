Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C903C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbiG3BIQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiG3BIP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB47B3B979
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7034BB829CB
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155C2C433B5;
        Sat, 30 Jul 2022 01:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143291;
        bh=0PQi031OeDXPni26e6t2I2SZqIDkuYymuD4tiyMPcS4=;
        h=Date:To:From:Subject:From;
        b=U4rTq18SUtYZl1J9Zt+Y5/C4WDsgiPtMbAEpPgYLtxYp1zsc6+Qv/Ip9cRbKumyCe
         0ugyoSijV0zccNJdenJCvepsG6tskikT/5cNo9bHZYOaaoQkPR4PpMyUM3VAHTj/Sp
         bf0QM2nudfC2ZgeMIE2dafvhaKLCVx43vj7iqwG8=
Date:   Fri, 29 Jul 2022 18:08:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tkjos@android.com,
        surenb@google.com, minchan@kernel.org, maco@android.com,
        joel@joelfernandes.org, hridya@google.com,
        gregkh@linuxfoundation.org, brauner@kernel.org,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] android-binder-stop-saving-a-pointer-to-the-vma.patch removed from -mm tree
Message-Id: <20220730010811.155C2C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Date: Mon, 20 Jun 2022 21:09:09 -0400
has been removed from the -mm tree.  Its filename was
     android-binder-stop-saving-a-pointer-to-the-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: fix drivers/android/binder_alloc_selftest.c]
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

 drivers/android/binder_alloc.c          |   30 ++++++++++------------
 drivers/android/binder_alloc.h          |    2 -
 drivers/android/binder_alloc_selftest.c |    2 -
 3 files changed, 16 insertions(+), 18 deletions(-)

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
--- a/drivers/android/binder_alloc_selftest.c~android-binder-stop-saving-a-pointer-to-the-vma
+++ a/drivers/android/binder_alloc_selftest.c
@@ -287,7 +287,7 @@ void binder_selftest_alloc(struct binder
 	if (!binder_selftest_run)
 		return;
 	mutex_lock(&binder_selftest_lock);
-	if (!binder_selftest_run || !alloc->vma)
+	if (!binder_selftest_run || !alloc->vma_addr)
 		goto done;
 	pr_info("STARTED\n");
 	binder_selftest_alloc_offset(alloc, end_offset, 0);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


