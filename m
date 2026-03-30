Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1717819D891
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899234; cv=none; b=qQz+gQVsCohvwy6oD9YEbdcZjSzj3WAa+EWiMQcxAb75qMqUxwVK5Yila9a+46KXrs0EAg1UfB/0hS38Bw4gV1Z115xO+/gQ/stMXsXLNAivuDi+povFIpxwHSnBl8/lf8vCusXzPZ5sM9OfwoadWoCXg4hKdmYr28C32x0psgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899234; c=relaxed/simple;
	bh=YlSGkVnismYeW593dnT4qX3iIYauXEsISfjtuLTkJmU=;
	h=Date:To:From:Subject:Message-Id; b=AJKQrqtoeZ9OOe+YGGOp+xXaYX/HE5ztTlMLvOE+PzWQC5g1kP8zeQP4yKlSxN6GT3lMne87d040VIGZsxLytGf5XDWKf9vw8T10Socs6Ef5bJFhTva/R2+4bMfBB0aqd5oY2D8EpvBVsO9aOjeKCtSy1/7BijLCKReLqibKUN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z72BMcwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z72BMcwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCAAC4CEF7;
	Mon, 30 Mar 2026 19:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774899233;
	bh=YlSGkVnismYeW593dnT4qX3iIYauXEsISfjtuLTkJmU=;
	h=Date:To:From:Subject:From;
	b=z72BMcwgdfWIbBi2CHv2Cq/XggStLgas+l3++hN4YN3Go/GG248RxQU5wxv2bGjrG
	 tpqZ3ZRlISHakpYsjeIWaXgukovLkcvEUeiD+1T0tEsmEBQQ6+XSO6/8KFzDIisIci
	 1QJKa9MROjiG1E/hwauyKxB2Ar5SGGm4GzAm6dQg=
Date: Mon, 30 Mar 2026 12:33:52 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] userfaultfd-introduce-mfill_copy_folio_locked-helper.patch removed from -mm tree
Message-Id: <20260330193353.8DCAAC4CEF7@smtp.kernel.org>
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
Date: Fri, 6 Mar 2026 19:18:01 +0200

Patch series "mm, kvm: allow uffd support in guest_memfd", v2.

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

Link: https://lkml.kernel.org/r/20260306171815.3160826-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20260306171815.3160826-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
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
userfaultfd-introduce-mfill_get_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

