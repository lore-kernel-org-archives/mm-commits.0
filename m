Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D068366047
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898365; cv=none; b=jCK3oeJC84gF4LYdh36HtyeffLOXVSW4lGlUlE+YmbX5+VG+XxVufgQly8RNb0ijZNaVWWPCygY/nNsb2cbpB6hdi8/CCVp3IwPjlf4icjMYgWMwEen+XlpVioBv/XMOKajLEV9OXOL2/lKxU8ZfcIk0meEoEg1dxPCu99Tbsx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898365; c=relaxed/simple;
	bh=VU3412dQLR78AQCLEbqxJ8eNs3VlLJaexH8+x6mx2e4=;
	h=Date:To:From:Subject:Message-Id; b=GPC/pe4adbd7v63o6IBo/VJeK1W6ttBV9reC4QrU8iurPgRhMcNe+Nt/iDvNIWnwd/Ir3fwGkW1HIyiP3on4MBfXfRK4UPY0nTAHcYu4JIY3D3SCl8Y6Oi2kskv3SwzQL0fPwICSHQYAPL2+6uPkHaKcBMANoE0JKDbay8/Lq60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OW67if13; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OW67if13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66DCC4CEF1;
	Sat, 31 Jan 2026 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898364;
	bh=VU3412dQLR78AQCLEbqxJ8eNs3VlLJaexH8+x6mx2e4=;
	h=Date:To:From:Subject:From;
	b=OW67if132jzrHN6AAbCUfdb7cvu23dVqh1q+G8t49HG/0T1EPmZIi52ILBTDgRvKe
	 smm7fdoNjGg/8BEV9GZJQvktgMqIkEpX3TKLQI9Xm53UqUAIGj5npsX8OWmZf+O+fd
	 ch/3Z4REbhgsvug/bv6W+dngNpnaqyTsefTYDxj8=
Date: Sat, 31 Jan 2026 14:26:04 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-de-duplicate-__vma_enter_locked-error-path.patch removed from -mm tree
Message-Id: <20260131222604.D66DCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: de-duplicate __vma_enter_locked() error path
has been removed from the -mm tree.  Its filename was
     mm-vma-de-duplicate-__vma_enter_locked-error-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: de-duplicate __vma_enter_locked() error path
Date: Fri, 23 Jan 2026 20:12:15 +0000

We're doing precisely the same thing that __vma_exit_locked() does, so
de-duplicate this code and keep the refcount primitive in one place.

No functional change intended.

Link: https://lkml.kernel.org/r/c9759b593f6a158e984fa87abe2c3cbd368ef825.1769198904.git.lorenzo.stoakes@oracle.com
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

 mm/mmap_lock.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/mm/mmap_lock.c~mm-vma-de-duplicate-__vma_enter_locked-error-path
+++ a/mm/mmap_lock.c
@@ -45,6 +45,14 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
 
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
+
+static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
+{
+	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					  &vma->vm_refcnt);
+	__vma_lockdep_release_exclusive(vma);
+}
+
 /*
  * __vma_enter_locked() returns 0 immediately if the vma is not
  * attached, otherwise it waits for any current readers to finish and
@@ -77,7 +85,10 @@ static inline int __vma_enter_locked(str
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
+		bool detached;
+
+		__vma_exit_locked(vma, &detached);
+		if (detached) {
 			/*
 			 * The wait failed, but the last reader went away
 			 * as well.  Tell the caller the VMA is detached.
@@ -85,7 +96,6 @@ static inline int __vma_enter_locked(str
 			WARN_ON_ONCE(!detaching);
 			err = 0;
 		}
-		__vma_lockdep_release_exclusive(vma);
 		return err;
 	}
 	__vma_lockdep_stat_mark_acquired(vma);
@@ -93,13 +103,6 @@ static inline int __vma_enter_locked(str
 	return 1;
 }
 
-static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
-{
-	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					  &vma->vm_refcnt);
-	__vma_lockdep_release_exclusive(vma);
-}
-
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 		int state)
 {
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

