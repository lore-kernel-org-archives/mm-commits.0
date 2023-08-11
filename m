Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E253C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbjHKXNQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjHKXND (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BFE468E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C73FE6464E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC67C433C7;
        Fri, 11 Aug 2023 23:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794956;
        bh=XFv+mDteOLjp0vo4o+fHbBabq1PL7oUTKyAoXUOxtcc=;
        h=Date:To:From:Subject:From;
        b=NokWRZ1ljXTCrIqytTM9j8OCbAtvEnQY5nkrXps//ahhEd4pJDjUFT8qkXfLUKVFw
         n6HuT2rLVebyPajZxpGTWfo1/fwJSbKmlb1+qOfwjgAgqSPz2jycLuOMiAczqCGTbh
         7XnCJdG8IPWMNnTyTKxI1hfzwG2j3yIA89PR/56A=
Date:   Fri, 11 Aug 2023 16:02:35 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, jannh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-dont-drop-vma-locks-in-mm_drop_all_locks.patch removed from -mm tree
Message-Id: <20230811230236.2DC67C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: don't drop VMA locks in mm_drop_all_locks()
has been removed from the -mm tree.  Its filename was
     mm-dont-drop-vma-locks-in-mm_drop_all_locks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm: don't drop VMA locks in mm_drop_all_locks()
Date: Thu, 20 Jul 2023 21:34:36 +0200

Despite its name, mm_drop_all_locks() does not drop _all_ locks; the mmap
lock is held write-locked by the caller, and the caller is responsible for
dropping the mmap lock at a later point (which will also release the VMA
locks).

Calling vma_end_write_all() here is dangerous because the caller might
have write-locked a VMA with the expectation that it will stay
write-locked until the mmap_lock is released, as usual.

This _almost_ becomes a problem in the following scenario:

An anonymous VMA A and an SGX VMA B are mapped adjacent to each other. 
Userspace calls munmap() on a range starting at the start address of A and
ending in the middle of B.

Hypothetical call graph with additional notes in brackets:

do_vmi_align_munmap
  [begin first for_each_vma_range loop]
  vma_start_write [on VMA A]
  vma_mark_detached [on VMA A]
  __split_vma [on VMA B]
    sgx_vma_open [== new->vm_ops->open]
      sgx_encl_mm_add
        __mmu_notifier_register [luckily THIS CAN'T ACTUALLY HAPPEN]
          mm_take_all_locks
          mm_drop_all_locks
            vma_end_write_all [drops VMA lock taken on VMA A before]
  vma_start_write [on VMA B]
  vma_mark_detached [on VMA B]
  [end first for_each_vma_range loop]
  vma_iter_clear_gfp [removes VMAs from maple tree]
  mmap_write_downgrade
  unmap_region
  mmap_read_unlock

In this hypothetical scenario, while do_vmi_align_munmap() thinks it still
holds a VMA write lock on VMA A, the VMA write lock has actually been
invalidated inside __split_vma().

The call from sgx_encl_mm_add() to __mmu_notifier_register() can't
actually happen here, as far as I understand, because we are duplicating
an existing SGX VMA, but sgx_encl_mm_add() only calls
__mmu_notifier_register() for the first SGX VMA created in a given
process.  So this could only happen in fork(), not on munmap().  But in my
view it is just pure luck that this can't happen.

Also, we wouldn't actually have any bad consequences from this in
do_vmi_align_munmap(), because by the time the bug drops the lock on VMA
A, we've already marked VMA A as detached, which makes it completely
ineligible for any VMA-locked page faults.  But again, that's just pure
luck.

So remove the vma_end_write_all(), so that VMA write locks are only ever
released on mmap_write_unlock() or mmap_write_downgrade().

Also add comments to document the locking rules established by this patch.

Link: https://lkml.kernel.org/r/20230720193436.454247-1-jannh@google.com
Fixes: eeff9a5d47f8 ("mm/mmap: prevent pagefault handler from racing with mmu_notifier registration")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h        |    5 +++++
 include/linux/mmap_lock.h |    8 ++++++++
 mm/mmap.c                 |    7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

--- a/include/linux/mmap_lock.h~mm-dont-drop-vma-locks-in-mm_drop_all_locks
+++ a/include/linux/mmap_lock.h
@@ -73,6 +73,14 @@ static inline void mmap_assert_write_loc
 }
 
 #ifdef CONFIG_PER_VMA_LOCK
+/*
+ * Drop all currently-held per-VMA locks.
+ * This is called from the mmap_lock implementation directly before releasing
+ * a write-locked mmap_lock (or downgrading it to read-locked).
+ * This should normally NOT be called manually from other places.
+ * If you want to call this manually anyway, keep in mind that this will release
+ * *all* VMA write locks, including ones from further up the stack.
+ */
 static inline void vma_end_write_all(struct mm_struct *mm)
 {
 	mmap_assert_write_locked(mm);
--- a/include/linux/mm.h~mm-dont-drop-vma-locks-in-mm_drop_all_locks
+++ a/include/linux/mm.h
@@ -691,6 +691,11 @@ static bool __is_vma_write_locked(struct
 	return (vma->vm_lock_seq == *mm_lock_seq);
 }
 
+/*
+ * Begin writing to a VMA.
+ * Exclude concurrent readers under the per-VMA lock until the currently
+ * write-locked mmap_lock is dropped or downgraded.
+ */
 static inline void vma_start_write(struct vm_area_struct *vma)
 {
 	int mm_lock_seq;
--- a/mm/mmap.c~mm-dont-drop-vma-locks-in-mm_drop_all_locks
+++ a/mm/mmap.c
@@ -3642,6 +3642,12 @@ int mm_take_all_locks(struct mm_struct *
 
 	mutex_lock(&mm_all_locks_mutex);
 
+	/*
+	 * vma_start_write() does not have a complement in mm_drop_all_locks()
+	 * because vma_start_write() is always asymmetrical; it marks a VMA as
+	 * being written to until mmap_write_unlock() or mmap_write_downgrade()
+	 * is reached.
+	 */
 	mas_for_each(&mas, vma, ULONG_MAX) {
 		if (signal_pending(current))
 			goto out_unlock;
@@ -3738,7 +3744,6 @@ void mm_drop_all_locks(struct mm_struct
 		if (vma->vm_file && vma->vm_file->f_mapping)
 			vm_unlock_mapping(vma->vm_file->f_mapping);
 	}
-	vma_end_write_all(mm);
 
 	mutex_unlock(&mm_all_locks_mutex);
 }
_

Patches currently in -mm which might be from jannh@google.com are


