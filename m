Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E83FEE49B4
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbjHXXVt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbjHXXVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909B2A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296A164AEE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76253C433C8;
        Thu, 24 Aug 2023 23:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919268;
        bh=F4dhQOuCeeoOV0D/V/WxOgY6z4UWx7+Xxt2r+lG3MK4=;
        h=Date:To:From:Subject:From;
        b=KHqjAd+hAd11M6pf/nydQnQMDNJZZtM1ckRi4y8Am1mYLEqZN4UaL6xcpTl8Fa8O5
         hQg1WpKYpE87sxU0anNpUu0eFUPBvQhtZPx3U7RnF0AqHkEsvQTYj1vC+F9sz6QWq+
         zP4HZ279aWvKFLh/bL1oqX4DtaqJVci25TFhljlo=
Date:   Thu, 24 Aug 2023 16:21:07 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, punit.agrawal@bytedance.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hughd@google.com,
        hdanton@sina.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, apopple@nvidia.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-swap-page-faults-under-per-vma-lock.patch removed from -mm tree
Message-Id: <20230824232108.76253C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle swap page faults under per-VMA lock
has been removed from the -mm tree.  Its filename was
     mm-handle-swap-page-faults-under-per-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: handle swap page faults under per-VMA lock
Date: Fri, 30 Jun 2023 14:19:56 -0700

When page fault is handled under per-VMA lock protection, all swap page
faults are retried with mmap_lock because folio_lock_or_retry has to drop
and reacquire mmap_lock if folio could not be immediately locked.  Follow
the same pattern as mmap_lock to drop per-VMA lock when waiting for folio
and retrying once folio is available.

With this obstacle removed, enable do_swap_page to operate under per-VMA
lock protection.  Drivers implementing ops->migrate_to_ram might still
rely on mmap_lock, therefore we have to fall back to mmap_lock in that
particular case.

Note that the only time do_swap_page calls synchronous swap_readpage is
when SWP_SYNCHRONOUS_IO is set, which is only set for
QUEUE_FLAG_SYNCHRONOUS devices: brd, zram and nvdimms (both btt and pmem).
Therefore we don't sleep in this path, and there's no need to drop the
mmap or per-VMA lock.

Link: https://lkml.kernel.org/r/20230630211957.1341547-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +++++++++++++
 mm/filemap.c       |   17 ++++++++---------
 mm/memory.c        |   16 ++++++++++------
 3 files changed, 31 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-handle-swap-page-faults-under-per-vma-lock
+++ a/include/linux/mm.h
@@ -729,6 +729,14 @@ static inline void vma_mark_detached(str
 	vma->detached = detached;
 }
 
+static inline void release_fault_lock(struct vm_fault *vmf)
+{
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
+		vma_end_read(vmf->vma);
+	else
+		mmap_read_unlock(vmf->vma->vm_mm);
+}
+
 struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 					  unsigned long address);
 
@@ -749,6 +757,11 @@ static inline struct vm_area_struct *loc
 	return NULL;
 }
 
+static inline void release_fault_lock(struct vm_fault *vmf)
+{
+	mmap_read_unlock(vmf->vma->vm_mm);
+}
+
 #endif /* CONFIG_PER_VMA_LOCK */
 
 extern const struct vm_operations_struct vma_dummy_vm_ops;
--- a/mm/filemap.c~mm-handle-swap-page-faults-under-per-vma-lock
+++ a/mm/filemap.c
@@ -1671,27 +1671,26 @@ static int __folio_lock_async(struct fol
  * Return values:
  * 0 - folio is locked.
  * non-zero - folio is not locked.
- *     mmap_lock has been released (mmap_read_unlock(), unless flags had both
- *     FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_RETRY_NOWAIT set, in
- *     which case mmap_lock is still held.
+ *     mmap_lock or per-VMA lock has been released (mmap_read_unlock() or
+ *     vma_end_read()), unless flags had both FAULT_FLAG_ALLOW_RETRY and
+ *     FAULT_FLAG_RETRY_NOWAIT set, in which case the lock is still held.
  *
  * If neither ALLOW_RETRY nor KILLABLE are set, will always return 0
- * with the folio locked and the mmap_lock unperturbed.
+ * with the folio locked and the mmap_lock/per-VMA lock is left unperturbed.
  */
 vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf)
 {
-	struct mm_struct *mm = vmf->vma->vm_mm;
 	unsigned int flags = vmf->flags;
 
 	if (fault_flag_allow_retry_first(flags)) {
 		/*
-		 * CAUTION! In this case, mmap_lock is not released
-		 * even though return VM_FAULT_RETRY.
+		 * CAUTION! In this case, mmap_lock/per-VMA lock is not
+		 * released even though returning VM_FAULT_RETRY.
 		 */
 		if (flags & FAULT_FLAG_RETRY_NOWAIT)
 			return VM_FAULT_RETRY;
 
-		mmap_read_unlock(mm);
+		release_fault_lock(vmf);
 		if (flags & FAULT_FLAG_KILLABLE)
 			folio_wait_locked_killable(folio);
 		else
@@ -1703,7 +1702,7 @@ vm_fault_t __folio_lock_or_retry(struct
 
 		ret = __folio_lock_killable(folio);
 		if (ret) {
-			mmap_read_unlock(mm);
+			release_fault_lock(vmf);
 			return VM_FAULT_RETRY;
 		}
 	} else {
--- a/mm/memory.c~mm-handle-swap-page-faults-under-per-vma-lock
+++ a/mm/memory.c
@@ -3746,12 +3746,6 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (!pte_unmap_same(vmf))
 		goto out;
 
-	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		ret = VM_FAULT_RETRY;
-		vma_end_read(vma);
-		goto out;
-	}
-
 	entry = pte_to_swp_entry(vmf->orig_pte);
 	if (unlikely(non_swap_entry(entry))) {
 		if (is_migration_entry(entry)) {
@@ -3761,6 +3755,16 @@ vm_fault_t do_swap_page(struct vm_fault
 			vmf->page = pfn_swap_entry_to_page(entry);
 			ret = remove_device_exclusive_entry(vmf);
 		} else if (is_device_private_entry(entry)) {
+			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+				/*
+				 * migrate_to_ram is not yet ready to operate
+				 * under VMA lock.
+				 */
+				vma_end_read(vma);
+				ret = VM_FAULT_RETRY;
+				goto out;
+			}
+
 			vmf->page = pfn_swap_entry_to_page(entry);
 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					vmf->address, &vmf->ptl);
_

Patches currently in -mm which might be from surenb@google.com are


