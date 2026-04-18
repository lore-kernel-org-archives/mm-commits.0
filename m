Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78EF2475E3
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498998; cv=none; b=RNwglkuBZKuB7imem6mQYMZYRBPwpkM4JOv3HZVqogy1k3kWQ5ZbTf/hkqPFXq0B2EwNduHaJWKLKoJdi7q29oBPzxvEpuaWy5cpWyLPg58O7tIpS6Z25JuGJ71GNMAROzLe9UuswWGo4r8Ng10wx52HXLFRDAmaXi4V96Gs318=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498998; c=relaxed/simple;
	bh=pTQgOi27OvrIzSes4TQKd9NWLhSmiPP60E5E96q88D8=;
	h=Date:To:From:Subject:Message-Id; b=HpF9qQJk1IRD7GF7nmkYAPepjwv9ReF1z5yG8LdTW8vQGNrKJjJUNqERRMyaes56F0FK9p6r/1073/myvgnVfmHSX2uzpld3cmDaJE0e0XN2o+ZWZLDGAKu7L0MJgzYzwg/7Zx4RHTaWOu1v4ULiywIeVGpN//V7t0jV+ojbR2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OWA+hM5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OWA+hM5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998D9C19424;
	Sat, 18 Apr 2026 07:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498997;
	bh=pTQgOi27OvrIzSes4TQKd9NWLhSmiPP60E5E96q88D8=;
	h=Date:To:From:Subject:From;
	b=OWA+hM5Z4HV9xaovzKPmx4+IGwmfFXLlvAOmV20QPF65zIHpkP9QuGkkBgYsL4URq
	 tv4Skc6fNMPbGinvROuhkTi4hFxp3MTwAh1+J+Tp/2z8OPCJ6UkuLg/ONZcUAGtFf4
	 XgmRKOzUuI0Gthz31OjZz6xbC06uDuYuxpFtS0kg=
Date: Sat, 18 Apr 2026 00:56:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,devnexen@gmail.com,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-introduce-mfill_copy_folio_locked-helper.patch removed from -mm tree
Message-Id: <20260418075636.998D9C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: introduce mfill_copy_folio_locked() helper
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-mfill_copy_folio_locked-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: introduce mfill_copy_folio_locked() helper
Date: Thu, 2 Apr 2026 07:11:42 +0300

Patch series "mm, kvm: allow uffd support in guest_memfd", v4.

These patches enable support for userfaultfd in guest_memfd.

As the groundwork I refactored userfaultfd handling of PTE-based memory
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


This patch (of 4):

Split copying of data when locks held from mfill_atomic_pte_copy() into a
helper function mfill_copy_folio_locked().

This makes improves code readability and makes complex
mfill_atomic_pte_copy() function easier to comprehend.

No functional change.

Link: https://lore.kernel.org/20260402041156.1377214-1-rppt@kernel.org
Link: https://lore.kernel.org/20260402041156.1377214-2-rppt@kernel.org
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
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: David Carlier <devnexen@gmail.com>
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


