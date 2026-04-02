Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A062EC0A2
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 04:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775103807; cv=none; b=noJFiFcyQCyuAqG3Uq/drv9LwjtWa7POXj/EWwkAsNpvlb7VjbM0duXYxAVFhEmMlnVBtyrYaiwIXx30lBsEy+FV7pTfEAMA41y+L6qkp9M07A2rlJ27Av92crVmL1I9L1Evn9rdTUlJSXfsl+75PuWUpS91K6sp57/RCuXuLCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775103807; c=relaxed/simple;
	bh=YGUTdn6Y7YBV2CRiihhtKL3gQ9jqeU3vk0NgvIMZ2wc=;
	h=Date:To:From:Subject:Message-Id; b=UM2laKHE/HoSSKykBzEvk2HwF/kx9HWdOicTW1RHVD4Rf7XmJ1juTfeIGhncuCGO0ohySdNWQum+snru1vVxDoLr7rluv6TSsC7ZgTvAfan3U7fJs74n0+kWxgHKI1yfCmTXNbYngVGxFgFFs5cXGta9OHIVECkKbpyKpg3mOn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GbDKZ/gK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GbDKZ/gK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999D7C19423;
	Thu,  2 Apr 2026 04:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775103806;
	bh=YGUTdn6Y7YBV2CRiihhtKL3gQ9jqeU3vk0NgvIMZ2wc=;
	h=Date:To:From:Subject:From;
	b=GbDKZ/gKNgd75rNYa76mWgXIJIU6pCg8buhkY+tAzJHQj81aAwayGSK5nb3N749mw
	 KMO8PCafFocNCpi/XS/IMwueMm6HNwbdD9AMEEX6TDYDBXFixFgnwtd0jUeGmO+uAG
	 X+NmtnphFgY78cg8zvOTilUxvEimW3DzmRZKzcWE=
Date: Wed, 01 Apr 2026 21:23:26 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-introduce-mfill_copy_folio_locked-helper.patch removed from -mm tree
Message-Id: <20260402042326.999D7C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: introduce mfill_copy_folio_locked() helper
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-mfill_copy_folio_locked-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: introduce mfill_copy_folio_locked() helper
Date: Mon, 30 Mar 2026 13:11:02 +0300

Patch series "mm, kvm: allow uffd support in guest_memfd", v3.

These patches enable support for userfaultfd in guest_memfd.

As the ground work I refactored userfaultfd handling of PTE-based memory
types (anonymous and shmem) and converted them to use vm_uffd_ops for
allocating a folio or getting an existing folio from the page cache. 
shmem also implements callbacks that add a folio to the page cache after
the data passed in UFFDIO_COPY was copied and remove the folio from the
page cache if page table update fails.

In order for guest_memfd to notify userspace about page faults, there are
new VM_FAULT_UFFD_MINOR and VM_FAULT_UFFD_MISSING that a ->fault() handler
can return to inform the page fault handler that it needs to call
handle_userfault() to complete the fault.

Nikita helped to plumb these new goodies into guest_memfd and provided
basic tests to verify that guest_memfd works with userfaultfd.  The
handling of UFFDIO_MISSING in guest_memfd requires ability to remove a
folio from page cache, the best way I could find was exporting
filemap_remove_folio() to KVM.

I deliberately left hugetlb out, at least for the most part.  hugetlb
handles acquisition of VMA and more importantly establishing of parent
page table entry differently than PTE-based memory types.  This is a
different abstraction level than what vm_uffd_ops provides and people
objected to exposing such low level APIs as a part of VMA operations.

Also, to enable uffd in guest_memfd refactoring of hugetlb is not needed
and I prefer to delay it until the dust settles after the changes in this
set.


This patch (of 15):

Split copying of data when locks held from mfill_atomic_pte_copy() into a
helper function mfill_copy_folio_locked().

This makes improves code readability and makes complex
mfill_atomic_pte_copy() function easier to comprehend.

No functional change.

Link: https://lkml.kernel.org/r/20260330101116.1117699-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20260330101116.1117699-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   59 ++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-mfill_copy_folio_locked-helper
+++ a/mm/userfaultfd.c
@@ -238,6 +238,40 @@ out:
 	return ret;
 }
 
+static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
+{
+	void *kaddr;
+	int ret;
+
+	kaddr = kmap_local_folio(folio, 0);
+	/*
+	 * The read mmap_lock is held here.  Despite the
+	 * mmap_lock being read recursive a deadlock is still
+	 * possible if a writer has taken a lock.  For example:
+	 *
+	 * process A thread 1 takes read lock on own mmap_lock
+	 * process A thread 2 calls mmap, blocks taking write lock
+	 * process B thread 1 takes page fault, read lock on own mmap lock
+	 * process B thread 2 calls mmap, blocks taking write lock
+	 * process A thread 1 blocks taking read lock on process B
+	 * process B thread 1 blocks taking read lock on process A
+	 *
+	 * Disable page faults to prevent potential deadlock
+	 * and retry the copy outside the mmap_lock.
+	 */
+	pagefault_disable();
+	ret = copy_from_user(kaddr, (const void __user *) src_addr,
+			     PAGE_SIZE);
+	pagefault_enable();
+	kunmap_local(kaddr);
+
+	if (ret)
+		return -EFAULT;
+
+	flush_dcache_folio(folio);
+	return ret;
+}
+
 static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 				 struct vm_area_struct *dst_vma,
 				 unsigned long dst_addr,
@@ -245,7 +279,6 @@ static int mfill_atomic_pte_copy(pmd_t *
 				 uffd_flags_t flags,
 				 struct folio **foliop)
 {
-	void *kaddr;
 	int ret;
 	struct folio *folio;
 
@@ -256,27 +289,7 @@ static int mfill_atomic_pte_copy(pmd_t *
 		if (!folio)
 			goto out;
 
-		kaddr = kmap_local_folio(folio, 0);
-		/*
-		 * The read mmap_lock is held here.  Despite the
-		 * mmap_lock being read recursive a deadlock is still
-		 * possible if a writer has taken a lock.  For example:
-		 *
-		 * process A thread 1 takes read lock on own mmap_lock
-		 * process A thread 2 calls mmap, blocks taking write lock
-		 * process B thread 1 takes page fault, read lock on own mmap lock
-		 * process B thread 2 calls mmap, blocks taking write lock
-		 * process A thread 1 blocks taking read lock on process B
-		 * process B thread 1 blocks taking read lock on process A
-		 *
-		 * Disable page faults to prevent potential deadlock
-		 * and retry the copy outside the mmap_lock.
-		 */
-		pagefault_disable();
-		ret = copy_from_user(kaddr, (const void __user *) src_addr,
-				     PAGE_SIZE);
-		pagefault_enable();
-		kunmap_local(kaddr);
+		ret = mfill_copy_folio_locked(folio, src_addr);
 
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
@@ -285,8 +298,6 @@ static int mfill_atomic_pte_copy(pmd_t *
 			/* don't free the page */
 			goto out;
 		}
-
-		flush_dcache_folio(folio);
 	} else {
 		folio = *foliop;
 		*foliop = NULL;
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_establish_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

