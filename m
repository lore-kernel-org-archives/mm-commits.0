Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD14438A9C2
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898376; cv=none; b=SXiBunlIvNld/9efbRRuroNM5JitrDv+1MmffhBT+c5EpdPPXwIggG5Y/N/xNYtQ16Iv0c+uZHV0qDqwae1KO40Vwgf6gCcxEq8fAfKsWPylcLAZCf4uRkmref0P3TyJwNU7pupVysg/Ut1/3q0iGp2wGt5EhWH0OJ/pCyiIj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898376; c=relaxed/simple;
	bh=K3xZDJHZkLbqL2xrA6bnO7s42jY7ovmILQsJD4VCqb0=;
	h=Date:To:From:Subject:Message-Id; b=uMcafAkb3gBZGHDA0/DiEPkYYbP2SBPR4RO/CC4Qd2MXA8tuqhXoyV/mW31jBRztHNqomlxE2/55kAr5kzOeq0bY9PM9fZCOxahbm5HDkp+9ZiaWIr1DyhYw37GZaDjkLRISMU1nliI9CAFZ9+H9ioTZM7Jc3rLtyXBiY4yjxUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=firhw1su; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="firhw1su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A03EC4CEF1;
	Sat, 31 Jan 2026 22:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898376;
	bh=K3xZDJHZkLbqL2xrA6bnO7s42jY7ovmILQsJD4VCqb0=;
	h=Date:To:From:Subject:From;
	b=firhw1sui6rtseVO295qbaHElUEE7URchEkU8Y+Z6maaoW4S8jxL9iJY0yzUo+NUq
	 RnTNl2cYKTsUiep1GxgvW4ZhfEZxmT/MXq+xEWAmm7TOt+c1ukd970thGhhssow0+3
	 DyVms60pleQ63ytffT6xIa/UNz4YRXh/UfidgmUU=
Date: Sat, 31 Jan 2026 14:26:16 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-update-vma_assert_locked-to-use-lockdep.patch removed from -mm tree
Message-Id: <20260131222616.8A03EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: update vma_assert_locked() to use lockdep
has been removed from the -mm tree.  Its filename was
     mm-vma-update-vma_assert_locked-to-use-lockdep.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: update vma_assert_locked() to use lockdep
Date: Fri, 23 Jan 2026 20:12:19 +0000

We can use lockdep to avoid unnecessary work here, otherwise update the
code to logically evaluate all pertinent cases and share code with
vma_assert_write_locked().

Make it clear here that we treat the VMA being detached at this point as a
bug, this was only implicit before.

Additionally, abstract references to vma->vmlock_dep_map by introducing a
macro helper __vma_lockdep_map() which accesses this field if lockdep is
enabled.

Since lock_is_held() is specified as an extern function if lockdep is
disabled, we can simply have __vma_lockdep_map() defined as NULL in this
case, and then use IS_ENABLED(CONFIG_LOCKDEP) to avoid ugly ifdeffery.

[lorenzo.stoakes@oracle.com: add helper macro __vma_lockdep_map(), per Vlastimil]
  Link: https://lkml.kernel.org/r/7c4b722e-604b-4b20-8e33-03d2f8d55407@lucifer.local
Link: https://lkml.kernel.org/r/538762f079cc4fa76ff8bf30a8a9525a09961451.1769198904.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   56 ++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 8 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-update-vma_assert_locked-to-use-lockdep
+++ a/include/linux/mmap_lock.h
@@ -78,6 +78,12 @@ static inline void mmap_assert_write_loc
 
 #ifdef CONFIG_PER_VMA_LOCK
 
+#ifdef CONFIG_LOCKDEP
+#define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
+#else
+#define __vma_lockdep_map(vma) NULL
+#endif
+
 /*
  * VMA locks do not behave like most ordinary locks found in the kernel, so we
  * cannot quite have full lockdep tracking in the way we would ideally prefer.
@@ -98,16 +104,16 @@ static inline void mmap_assert_write_loc
  * so we utilise lockdep to do so.
  */
 #define __vma_lockdep_acquire_read(vma) \
-	lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
+	lock_acquire_shared(__vma_lockdep_map(vma), 0, 1, NULL, _RET_IP_)
 #define __vma_lockdep_release_read(vma) \
-	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+	lock_release(__vma_lockdep_map(vma), _RET_IP_)
 #define __vma_lockdep_acquire_exclusive(vma) \
-	lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_)
+	lock_acquire_exclusive(__vma_lockdep_map(vma), 0, 0, NULL, _RET_IP_)
 #define __vma_lockdep_release_exclusive(vma) \
-	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+	lock_release(__vma_lockdep_map(vma), _RET_IP_)
 /* Only meaningful if CONFIG_LOCK_STAT is defined. */
 #define __vma_lockdep_stat_mark_acquired(vma) \
-	lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
+	lock_acquired(__vma_lockdep_map(vma), _RET_IP_)
 
 static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
@@ -146,7 +152,7 @@ static inline void vma_lock_init(struct
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	static struct lock_class_key lockdep_key;
 
-	lockdep_init_map(&vma->vmlock_dep_map, "vm_lock", &lockdep_key, 0);
+	lockdep_init_map(__vma_lockdep_map(vma), "vm_lock", &lockdep_key, 0);
 #endif
 	if (reset_refcnt)
 		refcount_set(&vma->vm_refcnt, 0);
@@ -319,19 +325,53 @@ int vma_start_write_killable(struct vm_a
 	return __vma_start_write(vma, TASK_KILLABLE);
 }
 
+/**
+ * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
+ * @vma: The VMA to assert.
+ */
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 	VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
 }
 
+/**
+ * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
+ * lock and is not detached.
+ * @vma: The VMA to assert.
+ */
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
+	unsigned int refcnt;
+
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		if (!lock_is_held(__vma_lockdep_map(vma)))
+			vma_assert_write_locked(vma);
+		return;
+	}
+
 	/*
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	VM_WARN_ON_ONCE_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
-			    !__is_vma_write_locked(vma), vma);
+	refcnt = refcount_read(&vma->vm_refcnt);
+
+	/*
+	 * In this case we're either read-locked, write-locked with temporary
+	 * readers, or in the midst of excluding readers, all of which means
+	 * we're locked.
+	 */
+	if (refcnt > 1)
+		return;
+
+	/* It is a bug for the VMA to be detached here. */
+	VM_WARN_ON_ONCE_VMA(!refcnt, vma);
+
+	/*
+	 * OK, the VMA has a reference count of 1 which means it is either
+	 * unlocked and attached or write-locked, so assert that it is
+	 * write-locked.
+	 */
+	vma_assert_write_locked(vma);
 }
 
 static inline bool vma_is_attached(struct vm_area_struct *vma)
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

