Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83B7376479
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896604; cv=none; b=Ejf0lkDTF9RcXkAGUK7oWetcPidWNKO9UUxNtebFYoLh6bY3XAj/b1e6AP8xM2wos0vo7kM/cRsByweqGh+O8jxnqSkHXvZ0wJF/t1GSTUFVKhs6UGezlQ4uIyhYaKsU8QXA0Ca1srhFrZEHIVhWcQiALQ0dFK632u9yv1Rcdqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896604; c=relaxed/simple;
	bh=vdUv5saq3xKFQEl1yBxMVQXUO0QbJ5L4meWQ0A3HCNQ=;
	h=Date:To:From:Subject:Message-Id; b=oBqI209YIO7EJ6KuOSEu9GpTlhdnKOOOChfv2M5CTWrodAuK5apkADZkJgdKQT53bjv+ShvPYsm8m2FcHQJbUaG378keLyd97IMmfB5x+J85jNlEjnoMAOnzDTwdUvK/tteQOlSVGiEXhJgaEI3rboYM/5YR1LE1oYe2At4lqGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zuipXKf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zuipXKf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528D5C116D0;
	Sat, 31 Jan 2026 21:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896604;
	bh=vdUv5saq3xKFQEl1yBxMVQXUO0QbJ5L4meWQ0A3HCNQ=;
	h=Date:To:From:Subject:From;
	b=zuipXKf/2/GIfhel54sQiodP1DNgVcL015VQQSRZTaWkPoKgcsZsq4AMfmy4msUt1
	 NAQAQGjC7cOUKKXK6f5nXLE1WKwiyGPTNGJ9fu4kuXCUlHaACV6v+nA6sQtHUPsYDH
	 hopP3pLcQm3qXTh8xnFQxR9F+IX4IvQA3QV2oEFo=
Date: Sat, 31 Jan 2026 13:56:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch removed from -mm tree
Message-Id: <20260131215644.528D5C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vma-update-vma_assert_locked-to-use-lockdep-fix
has been removed from the -mm tree.  Its filename was
     mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch

This patch was dropped because it was folded into mm-vma-update-vma_assert_locked-to-use-lockdep.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-vma-update-vma_assert_locked-to-use-lockdep-fix
Date: Mon, 26 Jan 2026 16:40:34 +0000

add helper macro __vma_lockdep_map(), per Vlastimil

Link: https://lkml.kernel.org/r/7c4b722e-604b-4b20-8e33-03d2f8d55407@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-update-vma_assert_locked-to-use-lockdep-fix
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
@@ -337,14 +343,11 @@ static inline void vma_assert_locked(str
 {
 	unsigned int refcnt;
 
-	/*
-	 * If read-locked or currently excluding readers, then the VMA is
-	 * locked.
-	 */
-#ifdef CONFIG_LOCKDEP
-	if (lock_is_held(&vma->vmlock_dep_map))
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		if (!lock_is_held(__vma_lockdep_map(vma)))
+			vma_assert_write_locked(vma);
 		return;
-#endif
+	}
 
 	/*
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

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

