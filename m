Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0638A9C8
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898363; cv=none; b=ZW7mPaug4aAunnYOHaew2fCKWTa346AHR7pb5BnmLFHcRYo725ds+MRXv8xtNzOq2lDQFdtkK+SKMTJDZL6f5bGJyU4kAIRL36MtVzzmXE3lfuDp+fYSs/2hdDYDsg8HAXMZ2yuz+52qVRZfyQ+Is3R69f5RUEoig7546XzXCr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898363; c=relaxed/simple;
	bh=NkpH11Jr4eXWVAYL0bwCQIbWCWD+4Jts8IExOBFwbHk=;
	h=Date:To:From:Subject:Message-Id; b=LHQpQsT9KxqwmRkYYXIUUrdtqRBf0Qi0yPkePgq6V9heO+WR3VxHcjpjUQnE140ykA7u4ZZaVFKaJCP2EUDBdL0UgEUExgvzvwsmWJPfphTzPzneNDmi/4niQf1t47G3V2Jp16UfCdUVcFRaxEakV38cr7+8oMC1PGPhqO5wSf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oAyYkcZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oAyYkcZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD3DC19425;
	Sat, 31 Jan 2026 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898363;
	bh=NkpH11Jr4eXWVAYL0bwCQIbWCWD+4Jts8IExOBFwbHk=;
	h=Date:To:From:Subject:From;
	b=oAyYkcZhAloiNTtk9RIWG+zbe00m4QWasAtCkc61uGdq9/CUBO5WmF4om3EwMv9xK
	 aMg6hI9f5OKlpQXzr989t0MLAgn490g8e3CkEztsyfSgw3X/N4NUHC3QP56AekkM+k
	 u9esmmYRpYtzyEkLnf1NrA5ZsdP9Sx9GXGqvKFs4=
Date: Sat, 31 Jan 2026 14:26:02 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-adduse-vma-lockdep-acquire-release-defines.patch removed from -mm tree
Message-Id: <20260131222603.5AD3DC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: add+use vma lockdep acquire/release defines
has been removed from the -mm tree.  Its filename was
     mm-vma-adduse-vma-lockdep-acquire-release-defines.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: add+use vma lockdep acquire/release defines
Date: Fri, 23 Jan 2026 20:12:14 +0000

The code is littered with inscrutable and duplicative lockdep
incantations, replace these with defines which explain what is going on
and add commentary to explain what we're doing.

If lockdep is disabled these become no-ops.  We must use defines so
_RET_IP_ remains meaningful.

These are self-documenting and aid readability of the code.

Additionally, instead of using the confusing rwsem_*() form for something
that is emphatically not an rwsem, we instead explicitly use
lock_[acquired, release]_shared/exclusive() lockdep invocations since we
are doing something rather custom here and these make more sense to use.

No functional change intended.

Link: https://lkml.kernel.org/r/fdae72441949ecf3b4a0ed3510da803e881bb153.1769198904.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   37 +++++++++++++++++++++++++++++++++---
 mm/mmap_lock.c            |   10 ++++-----
 2 files changed, 39 insertions(+), 8 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-adduse-vma-lockdep-acquire-release-defines
+++ a/include/linux/mmap_lock.h
@@ -78,6 +78,37 @@ static inline void mmap_assert_write_loc
 
 #ifdef CONFIG_PER_VMA_LOCK
 
+/*
+ * VMA locks do not behave like most ordinary locks found in the kernel, so we
+ * cannot quite have full lockdep tracking in the way we would ideally prefer.
+ *
+ * Read locks act as shared locks which exclude an exclusive lock being
+ * taken. We therefore mark these accordingly on read lock acquire/release.
+ *
+ * Write locks are acquired exclusively per-VMA, but released in a shared
+ * fashion, that is upon vma_end_write_all(), we update the mmap's seqcount such
+ * that write lock is released.
+ *
+ * We therefore cannot track write locks per-VMA, nor do we try. Mitigating this
+ * is the fact that, of course, we do lockdep-track the mmap lock rwsem which
+ * must be held when taking a VMA write lock.
+ *
+ * We do, however, want to indicate that during either acquisition of a VMA
+ * write lock or detachment of a VMA that we require the lock held be exclusive,
+ * so we utilise lockdep to do so.
+ */
+#define __vma_lockdep_acquire_read(vma) \
+	lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
+#define __vma_lockdep_release_read(vma) \
+	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+#define __vma_lockdep_acquire_exclusive(vma) \
+	lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_)
+#define __vma_lockdep_release_exclusive(vma) \
+	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+/* Only meaningful if CONFIG_LOCK_STAT is defined. */
+#define __vma_lockdep_stat_mark_acquired(vma) \
+	lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
+
 static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
 	seqcount_init(&mm->mm_lock_seq);
@@ -176,9 +207,9 @@ static inline void vma_refcount_put(stru
 	struct mm_struct *mm = vma->vm_mm;
 	int newcnt;
 
-	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
-
+	__vma_lockdep_release_read(vma);
 	newcnt = __vma_refcount_put_return(vma);
+
 	/*
 	 * __vma_enter_locked() may be sleeping waiting for readers to drop
 	 * their reference count, so wake it up if we were the last reader
@@ -207,7 +238,7 @@ static inline bool vma_start_read_locked
 							      VM_REFCNT_LIMIT)))
 		return false;
 
-	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+	__vma_lockdep_acquire_read(vma);
 	return true;
 }
 
--- a/mm/mmap_lock.c~mm-vma-adduse-vma-lockdep-acquire-release-defines
+++ a/mm/mmap_lock.c
@@ -72,7 +72,7 @@ static inline int __vma_enter_locked(str
 	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;
 
-	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
+	__vma_lockdep_acquire_exclusive(vma);
 	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
@@ -85,10 +85,10 @@ static inline int __vma_enter_locked(str
 			WARN_ON_ONCE(!detaching);
 			err = 0;
 		}
-		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
+		__vma_lockdep_release_exclusive(vma);
 		return err;
 	}
-	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
+	__vma_lockdep_stat_mark_acquired(vma);
 
 	return 1;
 }
@@ -97,7 +97,7 @@ static inline void __vma_exit_locked(str
 {
 	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
 					  &vma->vm_refcnt);
-	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
+	__vma_lockdep_release_exclusive(vma);
 }
 
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
@@ -204,7 +204,7 @@ static inline struct vm_area_struct *vma
 		goto err;
 	}
 
-	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+	__vma_lockdep_acquire_read(vma);
 
 	if (unlikely(vma->vm_mm != mm))
 		goto err_unstable;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

