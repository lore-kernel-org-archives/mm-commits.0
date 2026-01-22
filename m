Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FA3389DE0
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 15:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769096151; cv=none; b=fEeB63x7bPGjhZkkCJPChYzUEvUIyeHGwoRmLe7wzCht9ZYCLk8FToiPY3nKM4seyk8XU2pMRNXGR/Z6GWIPo7bEKLFQwHWWvB94cI6TixpXa66mf0aY/jmJdHmwSnZXH/t3zNQcX9tYUM0PkG3+zVVZYPp80kH+uO0CfkwQuu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769096151; c=relaxed/simple;
	bh=E/rtuOpW6gN8qkFKw+0+eKY5RuOrTQ6ZmC+E3KiS+LY=;
	h=Date:To:From:Subject:Message-Id; b=BoaINQKZT5cL8U+ZMMai0bnhcdAskU/QUf2Neqe5kZD4jyRQK9ke1+IhNK5wuT/NmWeYYFpbylJwMlhD5C+FUn+tolGM6dYnwmVWkblOj8WqsQhc4wRBLxv6AjyBRp3C65KCzMoH2r9E6PZCdjSQ29R2YaWAOrkIhutVvL42gRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SBYPXPeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SBYPXPeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A609C116C6;
	Thu, 22 Jan 2026 15:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769096151;
	bh=E/rtuOpW6gN8qkFKw+0+eKY5RuOrTQ6ZmC+E3KiS+LY=;
	h=Date:To:From:Subject:From;
	b=SBYPXPeJP4t6Zo8kf7yftNFdejKp33nbLPLjvoIFSNUL43Qxg0yuHa7neCllNd4/l
	 i46FXWFyZXyi2gnEL9w6wWlNQuJiuZZuD5vEz/hOPTuB/FL+0Yqf4EZyKmvomNbm0S
	 7B1hcwWEuoCmZAac7qKxLAWYyIAHbnM9LZ+1BBo8=
Date: Thu, 22 Jan 2026 07:35:50 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-use-lockdep-where-we-can-reduce-duplication.patch removed from -mm tree
Message-Id: <20260122153551.0A609C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: use lockdep where we can, reduce duplication
has been removed from the -mm tree.  Its filename was
     mm-vma-use-lockdep-where-we-can-reduce-duplication.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: use lockdep where we can, reduce duplication
Date: Mon, 19 Jan 2026 20:59:39 +0000

We introduce vma_is_read_locked(), which must deal with the case in which
VMA write lock sets refcnt to VMA_LOCK_OFFSET or VMA_LOCK_OFFSET + 1. 
Luckily is_vma_writer_only() already exists which we can use to check
this.

We then try to make vma_assert_locked() use lockdep as far as we can.

Unfortunately the VMA lock implementation does not even try to track VMA
write locks using lockdep, so we cannot track the lock this way.

This is less egregious than it might seem as VMA write locks are
predicated on mmap write locks, which we do lockdep assert.

vma_assert_write_locked() already asserts the mmap write lock is taken so
we get that checked implicitly.

However for read locks we do indeed use lockdup, via rwsem_acquire_read()
called in vma_start_read() and rwsem_release_read() called in
vma_refcount_put() called in turn by vma_end_read().

Therefore we perform a lockdep assertion if the VMA is known to be
read-locked.

If it is write-locked, we assert the mmap lock instead, with a lockdep
check if lockdep is enabled.

If lockdep is not enabled, we just check that locks are in place.

Link: https://lkml.kernel.org/r/bd410fd91d22eef37f9b617327cafce33b267b09.1768855783.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-use-lockdep-where-we-can-reduce-duplication
+++ a/include/linux/mmap_lock.h
@@ -236,6 +236,13 @@ int vma_start_write_killable(struct vm_a
 	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
 }
 
+static inline bool vma_is_read_locked(const struct vm_area_struct *vma)
+{
+	const unsigned int refcnt = refcount_read(&vma->vm_refcnt);
+
+	return refcnt > 1 && !is_vma_writer_only(refcnt);
+}
+
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 	unsigned int mm_lock_seq;
@@ -243,12 +250,31 @@ static inline void vma_assert_write_lock
 	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
+/**
+ * vma_assert_locked() - Assert that @vma is either read or write locked and
+ * that we have ownership of that lock (if lockdep is enabled).
+ * @vma: The VMA we assert.
+ *
+ * If lockdep is enabled, we ensure ownership of the VMA lock. Otherwise we
+ * assert that we are VMA write-locked, which implicitly asserts that we hold
+ * the mmap write lock.
+ */
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
-	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
-		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
+	/*
+	 * VMA locks currently only utilise lockdep for read locks, as
+	 * vma_end_write_all() releases an unknown number of VMA write locks and
+	 * we don't currently walk the maple tree to identify which locks are
+	 * released even under CONFIG_LOCKDEP.
+	 *
+	 * However, VMA write locks are predicated on an mmap write lock, which
+	 * we DO track under lockdep, and which vma_assert_write_locked()
+	 * asserts.
+	 */
+	if (vma_is_read_locked(vma))
+		lockdep_assert(lock_is_held(&vma->vmlock_dep_map));
+	else
+		vma_assert_write_locked(vma);
 }
 
 static inline bool vma_is_attached(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
selftests-mm-remove-virtual_address_range-test.patch
mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch
mm-vma-rename-is_vma_write_only-separate-out-shared-refcount-put.patch
mm-vma-adduse-vma-lockdep-acquire-release-defines.patch
mm-vma-de-duplicate-__vma_enter_locked-error-path.patch
mm-vma-clean-up-__vma_enter-exit_locked.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch
mm-vma-improve-and-document-__is_vma_write_locked.patch
mm-vma-update-vma_assert_locked-to-use-lockdep.patch
mm-vma-add-and-use-vma_assert_stabilised.patch
mm-add-vma_assert_stabilised.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

