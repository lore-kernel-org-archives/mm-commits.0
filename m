Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1381737F8C9
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896576; cv=none; b=iIL4iQ8NE9fbllZRibfxkSrl2kWve0yt7Q6gBGYYbfvdVgJdMHYG/3JXFJrSCWtXKlJInpmz5huXAx/M9qpLFzGaWFkUBEjFNp33QXPf54VdIQkQPA3mGryNwQOUkw+JzLKRZkbbxWxDNusshy+6+xzFtUkWqqvciN5rj5YelQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896576; c=relaxed/simple;
	bh=EmvzZlRb65DyoIsR1+CEyzq6KJlTT9uQjvSCP/BlZZs=;
	h=Date:To:From:Subject:Message-Id; b=gt3sfTH/i32thiOYPkfB1nikLEJtAxSzA9qiXdXTJ0+pAbm5PhsFg/LWvq7cFT77O7oA/bDjlIZNUltOtUc0lU/QKV7pOMqXVkoIVa91kPS/3J+8hn4io8tu2sPaY0kF7DCnUYRgfcpMwCAxBMlmNIMIE1ZLP2CADStfZSjTxBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djR6+VmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djR6+VmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C5CC4CEF1;
	Sat, 31 Jan 2026 21:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896575;
	bh=EmvzZlRb65DyoIsR1+CEyzq6KJlTT9uQjvSCP/BlZZs=;
	h=Date:To:From:Subject:From;
	b=djR6+VmLG1JYN3W/lQgdHj/N8mpFaCnbg5GvVNnkcD/LCXw3b0l8voEhOt4P/k3Lv
	 ZaaKUEG09zP24HWg56gEJZUeAwxP59kROM4d5GnkvCnqx4/n6YqpYuUCZWl2lY8kYP
	 6ffeFwGiSUYAZox4NY0fEwDVmk/ahaKlCB3B4ryU=
Date: Sat, 31 Jan 2026 13:56:15 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-improve-and-document-__is_vma_write_locked-fix.patch removed from -mm tree
Message-Id: <20260131215615.A4C5CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vma-improve-and-document-__is_vma_write_locked-fix
has been removed from the -mm tree.  Its filename was
     mm-vma-improve-and-document-__is_vma_write_locked-fix.patch

This patch was dropped because it was folded into mm-vma-improve-and-document-__is_vma_write_locked.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-vma-improve-and-document-__is_vma_write_locked-fix
Date: Mon, 26 Jan 2026 16:23:16 +0000

minor tweaks, per Vlastimil

Link: https://lkml.kernel.org/r/3fa89c13-232d-4eee-86cc-96caa75c2c67@lucifer.local
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

 include/linux/mmap_lock.h |    9 +++------
 mm/mmap_lock.c            |    6 +++---
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-improve-and-document-__is_vma_write_locked-fix
+++ a/include/linux/mmap_lock.h
@@ -272,8 +272,6 @@ static inline unsigned int __vma_raw_mm_
  * write lock is held.
  *
  * Returns true if write-locked, otherwise false.
- *
- * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.
  */
 static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
 {
@@ -284,8 +282,7 @@ static inline bool __is_vma_write_locked
 	return vma->vm_lock_seq == __vma_raw_mm_seqnum(vma);
 }
 
-int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
-		int state);
+int __vma_start_write(struct vm_area_struct *vma, int state);
 
 /*
  * Begin writing to a VMA.
@@ -297,7 +294,7 @@ static inline void vma_start_write(struc
 	if (__is_vma_write_locked(vma))
 		return;
 
-	__vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_UNINTERRUPTIBLE);
+	__vma_start_write(vma, TASK_UNINTERRUPTIBLE);
 }
 
 /**
@@ -319,7 +316,7 @@ int vma_start_write_killable(struct vm_a
 	if (__is_vma_write_locked(vma))
 		return 0;
 
-	return __vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_KILLABLE);
+	return __vma_start_write(vma, TASK_KILLABLE);
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
--- a/mm/mmap_lock.c~mm-vma-improve-and-document-__is_vma_write_locked-fix
+++ a/mm/mmap_lock.c
@@ -136,14 +136,14 @@ static int __vma_start_exclude_readers(s
 	return 0;
 }
 
-int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
-		int state)
+int __vma_start_write(struct vm_area_struct *vma, int state)
 {
-	int err;
+	const unsigned int mm_lock_seq = __vma_raw_mm_seqnum(vma);
 	struct vma_exclude_readers_state ves = {
 		.vma = vma,
 		.state = state,
 	};
+	int err;
 
 	err = __vma_start_exclude_readers(&ves);
 	if (err) {
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
mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
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

