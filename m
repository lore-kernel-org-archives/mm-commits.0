Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C638B9A9
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898372; cv=none; b=Dk90A6Ot6ntq0xqPtt7TgSBKMELFM/caN0Z8GIhJAV8YfW/gt3NtAteQzZA/f87grUQXT99KuaqSYLUKVtx0AtKc2qm6VDezzd485alRW6gBfOsLyUk3cje7v5+5YaqL6pkD//tt5BjVLB6wyU3rAKLDukVKtMIwCWNOVAeymPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898372; c=relaxed/simple;
	bh=LYnVaxji0q5MIP8iYB/inJUF3lhsWJlMoA7RGM4zegg=;
	h=Date:To:From:Subject:Message-Id; b=cAzgl3izRDf0MmHvqZi44qt/zTDFadY8siqqxTl9IGsYmz2rD/RC0UI1hMTw/1YxpzSUE6gu7dU77flUYdrmpWb07ubUGCCp1oBjfQm4QsUKl6fy+NAd+IC0IHQ1SkJnKIpqNMUmLAifrRvr8mbQE9+SCN6C+zbuRHMGUqf8gwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SBpgCT6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SBpgCT6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2007C4CEF1;
	Sat, 31 Jan 2026 22:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898371;
	bh=LYnVaxji0q5MIP8iYB/inJUF3lhsWJlMoA7RGM4zegg=;
	h=Date:To:From:Subject:From;
	b=SBpgCT6tpkK4Jpj6IQ9nlQilyPxljvpxB0IjtZMYHJX8mureu7dyq6OFCuCM+cyg0
	 FROXNrQXFxTvW+hb9Cnod7baOs6X22MUAfXnoWP1d+qGs54nWIpokgkAr1kkUJXwBD
	 4kVeb5J9xAgRhrBCH8BRRX2J+YU/ywZNK+jS8SSk=
Date: Sat, 31 Jan 2026 14:26:11 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-improve-and-document-__is_vma_write_locked.patch removed from -mm tree
Message-Id: <20260131222611.C2007C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: improve and document __is_vma_write_locked()
has been removed from the -mm tree.  Its filename was
     mm-vma-improve-and-document-__is_vma_write_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: improve and document __is_vma_write_locked()
Date: Fri, 23 Jan 2026 20:12:18 +0000

We don't actually need to return an output parameter providing mm sequence
number, rather we can separate that out into another function -
__vma_raw_mm_seqnum() - and have any callers which need to obtain that
invoke that instead.

The access to the raw sequence number requires that we hold the exclusive
mmap lock such that we know we can't race vma_end_write_all(), so move the
assert to __vma_raw_mm_seqnum() to make this requirement clear.

Also while we're here, convert all of the VM_BUG_ON_VMA()'s to
VM_WARN_ON_ONCE_VMA()'s in line with the convention that we do not invoke
oopses when we can avoid it.

[lorenzo.stoakes@oracle.com: minor tweaks, per Vlastimil]
  Link: https://lkml.kernel.org/r/3fa89c13-232d-4eee-86cc-96caa75c2c67@lucifer.local
Link: https://lkml.kernel.org/r/ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   45 +++++++++++++++++++-----------------
 mm/mmap_lock.c            |    6 ++--
 2 files changed, 27 insertions(+), 24 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-improve-and-document-__is_vma_write_locked
+++ a/include/linux/mmap_lock.h
@@ -258,21 +258,31 @@ static inline void vma_end_read(struct v
 	vma_refcount_put(vma);
 }
 
-/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
+static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
 {
+	const struct mm_struct *mm = vma->vm_mm;
+
+	/* We must hold an exclusive write lock for this access to be valid. */
 	mmap_assert_write_locked(vma->vm_mm);
+	return mm->mm_lock_seq.sequence;
+}
 
+/*
+ * Determine whether a VMA is write-locked. Must be invoked ONLY if the mmap
+ * write lock is held.
+ *
+ * Returns true if write-locked, otherwise false.
+ */
+static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
+{
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
 	 * mm->mm_lock_seq can't be concurrently modified.
 	 */
-	*mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
-	return (vma->vm_lock_seq == *mm_lock_seq);
+	return vma->vm_lock_seq == __vma_raw_mm_seqnum(vma);
 }
 
-int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
-		int state);
+int __vma_start_write(struct vm_area_struct *vma, int state);
 
 /*
  * Begin writing to a VMA.
@@ -281,12 +291,10 @@ int __vma_start_write(struct vm_area_str
  */
 static inline void vma_start_write(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
-	if (__is_vma_write_locked(vma, &mm_lock_seq))
+	if (__is_vma_write_locked(vma))
 		return;
 
-	__vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
+	__vma_start_write(vma, TASK_UNINTERRUPTIBLE);
 }
 
 /**
@@ -305,30 +313,25 @@ static inline void vma_start_write(struc
 static inline __must_check
 int vma_start_write_killable(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
-	if (__is_vma_write_locked(vma, &mm_lock_seq))
+	if (__is_vma_write_locked(vma))
 		return 0;
-	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
+
+	return __vma_start_write(vma, TASK_KILLABLE);
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
-	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
+	VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
 }
 
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
 	/*
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
-		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
+	VM_WARN_ON_ONCE_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
+			    !__is_vma_write_locked(vma), vma);
 }
 
 static inline bool vma_is_attached(struct vm_area_struct *vma)
--- a/mm/mmap_lock.c~mm-vma-improve-and-document-__is_vma_write_locked
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

