Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436061B21B7
	for <mm-commits@vger.kernel.org>; Thu, 14 Nov 2024 23:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731627700; cv=none; b=dyazYQwrp6aV0UPkvjv59JqgqW+6Y9kn/sNAiMHAqYmDn8t1+5st0fXtWz0HlZm0z6y4+1eTSwxMdVFBEMI4TPKHEMusvOir1oll77KA/uBKVB06ko5kmZfBFVQ/xjad9jAC9MZvAPXT+fr/Q+q5jpv7TEhfmrTcgaokFLMZ3Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731627700; c=relaxed/simple;
	bh=makXYllzq37IShbZqSlmrTBJO3CwSEYaYYF0k1lVniY=;
	h=Date:To:From:Subject:Message-Id; b=GC2hCMM6RpQTrPxaM97Eauz7x7Nd4S/88rfJTLPPea44tOFXUl7E7hLu+W2oDUu+p2chMMDq1c8WQAUYx8llFHBjQEGseB7CY4d3Kl3EKxREZLNC2Ywryz8UiozB0RYkR/AgRlpKoyHFrPatSB4nOpELnBzxR/DXWLnJ/1cCIxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zQSPVWZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zQSPVWZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B4CC4CECD;
	Thu, 14 Nov 2024 23:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731627699;
	bh=makXYllzq37IShbZqSlmrTBJO3CwSEYaYYF0k1lVniY=;
	h=Date:To:From:Subject:From;
	b=zQSPVWZcqvatIinzCNMzxPgXyxG8BI1rK0TMPJxFCLaV/gFVS55z7nOd37Q2nHvWn
	 TvZ+i1/YbConCZBamfJlZyQ3MdtKGuBbUGBxEpyg25Afx3JJgV6stQr+ctvCbTrzaO
	 H1y+1NcRbN9K3SrX4F0NVIvDhOWfXN+1FbeX4zOU=
Date: Thu, 14 Nov 2024 15:41:35 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,Liam.Howlett@Oracle.com,jannh@google.com,hdanton@sina.com,corbet@lwn.net,boqun.feng@gmail.com,bagasdotme@gmail.com,aliceryhl@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-vma-locks-documentation-v3.patch added to mm-unstable branch
Message-Id: <20241114234138.E3B4CC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-mm-add-vma-locks-documentation-v3
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-add-vma-locks-documentation-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-vma-locks-documentation-v3.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: docs-mm-add-vma-locks-documentation-v3
Date: Thu, 14 Nov 2024 20:54:01 +0000

Link: https://lkml.kernel.org/r/20241114205402.859737-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com> (for page table locks part)
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |   99 +++++++++++++++------------
 1 file changed, 55 insertions(+), 44 deletions(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-add-vma-locks-documentation-v3
+++ a/Documentation/mm/process_addrs.rst
@@ -53,7 +53,7 @@ Terminology
   you **must** have already acquired an :c:func:`!mmap_write_lock`.
 * **rmap locks** - When trying to access VMAs through the reverse mapping via a
   :c:struct:`!struct address_space` or :c:struct:`!struct anon_vma` object
-  (reachable from a folio via :c:member:`!folio->mapping`) VMAs must be stabilised via
+  (reachable from a folio via :c:member:`!folio->mapping`). VMAs must be stabilised via
   :c:func:`!anon_vma_[try]lock_read` or :c:func:`!anon_vma_[try]lock_write` for
   anonymous memory and :c:func:`!i_mmap_[try]lock_read` or
   :c:func:`!i_mmap_[try]lock_write` for file-backed memory. We refer to these
@@ -101,6 +101,9 @@ in order to obtain a VMA **write** lock.
 obtained without any other lock (:c:func:`!lock_vma_under_rcu` will acquire then
 release an RCU lock to lookup the VMA for you).
 
+This constrains the impact of writers on readers, as a writer can interact with
+one VMA while a reader interacts with another simultaneously.
+
 .. note:: The primary users of VMA read locks are page fault handlers, which
           means that without a VMA write lock, page faults will run concurrent with
           whatever you are doing.
@@ -209,13 +212,17 @@ These are the core fields which describe
                                                            :c:struct:`!struct anon_vma_name`        VMA write.
                                                            object providing a name for anonymous
                                                            mappings, or :c:macro:`!NULL` if none
-                                                           is set or the VMA is file-backed.
+                                                           is set or the VMA is file-backed. The
+							   underlying object is reference counted
+							   and can be shared across multiple VMAs
+							   for scalability.
    :c:member:`!swap_readahead_info`  CONFIG_SWAP           Metadata used by the swap mechanism      mmap read,
                                                            to perform readahead. This field is      swap-specific
                                                            accessed atomically.                     lock.
    :c:member:`!vm_policy`            CONFIG_NUMA           :c:type:`!mempolicy` object which        mmap write,
                                                            describes the NUMA behaviour of the      VMA write.
-                                                           VMA.
+                                                           VMA. The underlying object is reference
+							   counted.
    :c:member:`!numab_state`          CONFIG_NUMA_BALANCING :c:type:`!vma_numab_state` object which  mmap read,
                                                            describes the current state of           numab-specific
                                                            NUMA balancing in relation to this VMA.  lock.
@@ -287,7 +294,7 @@ typically refer to the leaf level as the
 .. note:: In instances where the architecture supports fewer page tables than
 	  five the kernel cleverly 'folds' page table levels, that is stubbing
 	  out functions related to the skipped levels. This allows us to
-	  conceptually act is if there were always five levels, even if the
+	  conceptually act as if there were always five levels, even if the
 	  compiler might, in practice, eliminate any code relating to missing
 	  ones.
 
@@ -298,15 +305,16 @@ There are free key operations typically
    establishes this suffices for traversal (there are also lockless variants
    which eliminate even this requirement, such as :c:func:`!gup_fast`).
 2. **Installing** page table mappings - Whether creating a new mapping or
-   modifying an existing one. This requires that the VMA is kept stable via an
-   mmap or VMA lock (explicitly not rmap locks).
+   modifying an existing one in such a way as to change its identity. This
+   requires that the VMA is kept stable via an mmap or VMA lock (explicitly not
+   rmap locks).
 3. **Zapping/unmapping** page table entries - This is what the kernel calls
    clearing page table mappings at the leaf level only, whilst leaving all page
    tables in place. This is a very common operation in the kernel performed on
    file truncation, the :c:macro:`!MADV_DONTNEED` operation via
    :c:func:`!madvise`, and others. This is performed by a number of functions
-   including :c:func:`!unmap_mapping_range` and :c:func:`!unmap_mapping_pages`
-   among others. The VMA need only be kept stable for this operation.
+   including :c:func:`!unmap_mapping_range` and :c:func:`!unmap_mapping_pages`.
+   The VMA need only be kept stable for this operation.
 4. **Freeing** page tables - When finally the kernel removes page tables from a
    userland process (typically via :c:func:`!free_pgtables`) extreme care must
    be taken to ensure this is done safely, as this logic finally frees all page
@@ -314,6 +322,10 @@ There are free key operations typically
    caller has both zapped the range and prevented any further faults or
    modifications within it).
 
+.. note:: Modifying mappings for reclaim or migration is performed under rmap
+          lock as it, like zapping, does not fundamentally modify the identity
+          of what is being mapped.
+
 **Traversing** and **zapping** ranges can be performed holding any one of the
 locks described in the terminology section above - that is the mmap lock, the
 VMA lock or either of the reverse mapping locks.
@@ -323,9 +335,9 @@ ahead and perform these operations on pa
 operations that perform writes also acquire internal page table locks to
 serialise - see the page table implementation detail section for more details).
 
-When **installing** page table entries, the mmap or VMA lock mut be held to keep
-the VMA stable. We explore why this is in the page table locking details section
-below.
+When **installing** page table entries, the mmap or VMA lock must be held to
+keep the VMA stable. We explore why this is in the page table locking details
+section below.
 
 **Freeing** page tables is an entirely internal memory management operation and
 has special requirements (see the page freeing section below for more details).
@@ -386,50 +398,50 @@ There is also a file-system specific loc
 
 .. code-block::
 
-  ->i_mmap_rwsem                (truncate_pagecache)
-    ->private_lock              (__free_pte->block_dirty_folio)
-      ->swap_lock               (exclusive_swap_page, others)
+  ->i_mmap_rwsem                        (truncate_pagecache)
+    ->private_lock                      (__free_pte->block_dirty_folio)
+      ->swap_lock                       (exclusive_swap_page, others)
         ->i_pages lock
 
   ->i_rwsem
-    ->invalidate_lock           (acquired by fs in truncate path)
-      ->i_mmap_rwsem            (truncate->unmap_mapping_range)
+    ->invalidate_lock                   (acquired by fs in truncate path)
+      ->i_mmap_rwsem                    (truncate->unmap_mapping_range)
 
   ->mmap_lock
     ->i_mmap_rwsem
       ->page_table_lock or pte_lock     (various, mainly in memory.c)
-        ->i_pages lock  (arch-dependent flush_dcache_mmap_lock)
+        ->i_pages lock                  (arch-dependent flush_dcache_mmap_lock)
 
   ->mmap_lock
-    ->invalidate_lock           (filemap_fault)
-      ->lock_page               (filemap_fault, access_process_vm)
+    ->invalidate_lock                   (filemap_fault)
+      ->lock_page                       (filemap_fault, access_process_vm)
 
-  ->i_rwsem                     (generic_perform_write)
-    ->mmap_lock         (fault_in_readable->do_page_fault)
+  ->i_rwsem                             (generic_perform_write)
+    ->mmap_lock                         (fault_in_readable->do_page_fault)
 
   bdi->wb.list_lock
-    sb_lock                     (fs/fs-writeback.c)
-    ->i_pages lock              (__sync_single_inode)
+    sb_lock                             (fs/fs-writeback.c)
+    ->i_pages lock                      (__sync_single_inode)
 
   ->i_mmap_rwsem
-    ->anon_vma.lock             (vma_merge)
+    ->anon_vma.lock                     (vma_merge)
 
   ->anon_vma.lock
     ->page_table_lock or pte_lock       (anon_vma_prepare and various)
 
   ->page_table_lock or pte_lock
-    ->swap_lock         (try_to_unmap_one)
-    ->private_lock              (try_to_unmap_one)
-    ->i_pages lock              (try_to_unmap_one)
-    ->lruvec->lru_lock  (follow_page_mask->mark_page_accessed)
-    ->lruvec->lru_lock  (check_pte_range->folio_isolate_lru)
-    ->private_lock              (folio_remove_rmap_pte->set_page_dirty)
-    ->i_pages lock              (folio_remove_rmap_pte->set_page_dirty)
-    bdi.wb->list_lock           (folio_remove_rmap_pte->set_page_dirty)
-    ->inode->i_lock             (folio_remove_rmap_pte->set_page_dirty)
-    bdi.wb->list_lock           (zap_pte_range->set_page_dirty)
-    ->inode->i_lock             (zap_pte_range->set_page_dirty)
-    ->private_lock              (zap_pte_range->block_dirty_folio)
+    ->swap_lock                         (try_to_unmap_one)
+    ->private_lock                      (try_to_unmap_one)
+    ->i_pages lock                      (try_to_unmap_one)
+    ->lruvec->lru_lock                  (follow_page_mask->mark_page_accessed)
+    ->lruvec->lru_lock                  (check_pte_range->folio_isolate_lru)
+    ->private_lock                      (folio_remove_rmap_pte->set_page_dirty)
+    ->i_pages lock                      (folio_remove_rmap_pte->set_page_dirty)
+    bdi.wb->list_lock                   (folio_remove_rmap_pte->set_page_dirty)
+    ->inode->i_lock                     (folio_remove_rmap_pte->set_page_dirty)
+    bdi.wb->list_lock                   (zap_pte_range->set_page_dirty)
+    ->inode->i_lock                     (zap_pte_range->set_page_dirty)
+    ->private_lock                      (zap_pte_range->block_dirty_folio)
 
 Please check the current state of these comments which may have changed since
 the time of writing of this document.
@@ -592,7 +604,7 @@ or zapping).
 A typical pattern taken when traversing page table entries to install a new
 mapping is to optimistically determine whether the page table entry in the table
 above is empty, if so, only then acquiring the page table lock and checking
-again to see if it was allocated underneath is.
+again to see if it was allocated underneath us.
 
 This allows for a traversal with page table locks only being taken when
 required. An example of this is :c:func:`!__pud_alloc`.
@@ -603,7 +615,7 @@ eliminated the PMD entry as well as the
 
 This is why :c:func:`!__pte_offset_map_lock` locklessly retrieves the PMD entry
 for the PTE, carefully checking it is as expected, before acquiring the
-PTE-specific lock, and then *again* checking that the PMD lock is as expected.
+PTE-specific lock, and then *again* checking that the PMD entry is as expected.
 
 If a THP collapse (or similar) were to occur then the lock on both pages would
 be acquired, so we can ensure this is prevented while the PTE lock is held.
@@ -654,7 +666,7 @@ page tables). Most notable of these is :
 moving higher level page tables.
 
 In these instances, it is required that **all** locks are taken, that is
-the mmap lock, the VMA lock and the relevant rmap lock.
+the mmap lock, the VMA lock and the relevant rmap locks.
 
 You can observe this in the :c:func:`!mremap` implementation in the functions
 :c:func:`!take_rmap_locks` and :c:func:`!drop_rmap_locks` which perform the rmap
@@ -669,11 +681,10 @@ Overview
 VMA read locking is entirely optimistic - if the lock is contended or a competing
 write has started, then we do not obtain a read lock.
 
-A VMA **read** lock is obtained by :c:func:`!lock_vma_under_rcu` function, which
-first calls :c:func:`!rcu_read_lock` to ensure that the VMA is looked up in an
-RCU critical section, then attempts to VMA lock it via
-:c:func:`!vma_start_read`, before releasing the RCU lock via
-:c:func:`!rcu_read_unlock`.
+A VMA **read** lock is obtained by :c:func:`!lock_vma_under_rcu`, which first
+calls :c:func:`!rcu_read_lock` to ensure that the VMA is looked up in an RCU
+critical section, then attempts to VMA lock it via :c:func:`!vma_start_read`,
+before releasing the RCU lock via :c:func:`!rcu_read_unlock`.
 
 VMA read locks hold the read lock on the :c:member:`!vma->vm_lock` semaphore for
 their duration and the caller of :c:func:`!lock_vma_under_rcu` must release it
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
docs-mm-add-vma-locks-documentation-v3.patch
docs-mm-add-vma-locks-documentation-fix.patch

