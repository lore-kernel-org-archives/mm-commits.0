Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903043396F1
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675103; cv=none; b=UWINMyXv6a4X1jdHT0oS6TwZeioin9LheTGOcwg8CuTl43Y0X9cCm00Nm9t05Aq8pUDMKGN4VplM3NO97SJr7ipUrHc7YPPbU0UomEubkDgklW89+FDZu8In9QiMP0zsZeSAb43PUNhIp1rI5V6ihywrwwHgF4XKgjFaF7nb+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675103; c=relaxed/simple;
	bh=1eUPxG/TwseJK4ehqVTaq5AcW0zcrTfTLXjbVoPaCOk=;
	h=Date:To:From:Subject:Message-Id; b=rNTvOdyDKTdGaW/zzz+UVCQT/O5WskVgKmL2nwXr/69ioTc5geeVZx7uWti+tXg/QY+vQ/MnGHGHGkgTirnhtqgD0BsxdET+xXqCY3GetwTbLIDOUFwhTA3UTOItE4esYJE850v0qfTsNaAEo2KioNEzSGbd2acmyXhXIviNqCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JMab3lzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JMab3lzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EA2C4CEF1;
	Thu, 20 Nov 2025 21:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675103;
	bh=1eUPxG/TwseJK4ehqVTaq5AcW0zcrTfTLXjbVoPaCOk=;
	h=Date:To:From:Subject:From;
	b=JMab3lzLL/+RNQPxU7S+flu4jMrJk/8T4rXArjkHomvav++cYg1rQzIvPyR+Uoaxf
	 3iFlM3wNZtJNC7ChZVMNqdjcXsJl6Jtkr3cxwXztsY680+/BNjjQAAA+0l0RdCc37N
	 jjjA3esB46ui+S9HiF0EFkdIk/mcga0t85eYL28s=
Date: Thu, 20 Nov 2025 13:45:02 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,chriscli@google.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-vma_start_write_killable.patch removed from -mm tree
Message-Id: <20251120214503.57EA2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add vma_start_write_killable()
has been removed from the -mm tree.  Its filename was
     mm-add-vma_start_write_killable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add vma_start_write_killable()
Date: Mon, 10 Nov 2025 20:32:01 +0000

Patch series "vma_start_write_killable"", v2.

When we added the VMA lock, we made a major oversight in not adding a
killable variant.  That can run us into trouble where a thread takes the
VMA lock for read (eg handling a page fault) and then goes out to lunch
for an hour (eg doing reclaim).  Another thread tries to modify the VMA,
taking the mmap_lock for write, then attempts to lock the VMA for write. 
That blocks on the first thread, and ensures that every other page fault
now tries to take the mmap_lock for read.  Because everything's in an
uninterruptible sleep, we can't kill the task, which makes me angry.

This patchset just adds vma_start_write_killable() and converts one caller
to use it.  Most users are somewhat tricky to convert, so expect follow-up
individual patches per call-site which need careful analysis to make sure
we've done proper cleanup.


This patch (of 2):

The vma can be held read-locked for a substantial period of time, eg if
memory allocation needs to go into reclaim.  It's useful to be able to
send fatal signals to threads which are waiting for the write lock.

Link: https://lkml.kernel.org/r/20251110203204.1454057-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20251110203204.1454057-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chris Li <chriscli@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |    9 ++++++-
 include/linux/mmap_lock.h          |   30 ++++++++++++++++++++++-
 mm/mmap_lock.c                     |   34 +++++++++++++++++++--------
 tools/testing/vma/vma_internal.h   |    8 ++++++
 4 files changed, 69 insertions(+), 12 deletions(-)

--- a/Documentation/mm/process_addrs.rst~mm-add-vma_start_write_killable
+++ a/Documentation/mm/process_addrs.rst
@@ -48,7 +48,8 @@ Terminology
 * **VMA locks** - The VMA lock is at VMA granularity (of course) which behaves
   as a read/write semaphore in practice. A VMA read lock is obtained via
   :c:func:`!lock_vma_under_rcu` (and unlocked via :c:func:`!vma_end_read`) and a
-  write lock via :c:func:`!vma_start_write` (all VMA write locks are unlocked
+  write lock via vma_start_write() or vma_start_write_killable()
+  (all VMA write locks are unlocked
   automatically when the mmap write lock is released). To take a VMA write lock
   you **must** have already acquired an :c:func:`!mmap_write_lock`.
 * **rmap locks** - When trying to access VMAs through the reverse mapping via a
@@ -907,3 +908,9 @@ Stack expansion
 Stack expansion throws up additional complexities in that we cannot permit there
 to be racing page faults, as a result we invoke :c:func:`!vma_start_write` to
 prevent this in :c:func:`!expand_downwards` or :c:func:`!expand_upwards`.
+
+------------------------
+Functions and structures
+------------------------
+
+.. kernel-doc:: include/linux/mmap_lock.h
--- a/include/linux/mmap_lock.h~mm-add-vma_start_write_killable
+++ a/include/linux/mmap_lock.h
@@ -195,7 +195,8 @@ static inline bool __is_vma_write_locked
 	return (vma->vm_lock_seq == *mm_lock_seq);
 }
 
-void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq);
+int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
+		int state);
 
 /*
  * Begin writing to a VMA.
@@ -209,7 +210,30 @@ static inline void vma_start_write(struc
 	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
 
-	__vma_start_write(vma, mm_lock_seq);
+	__vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
+}
+
+/**
+ * vma_start_write_killable - Begin writing to a VMA.
+ * @vma: The VMA we are going to modify.
+ *
+ * Exclude concurrent readers under the per-VMA lock until the currently
+ * write-locked mmap_lock is dropped or downgraded.
+ *
+ * Context: May sleep while waiting for readers to drop the vma read lock.
+ * Caller must already hold the mmap_lock for write.
+ *
+ * Return: 0 for a successful acquisition.  -EINTR if a fatal signal was
+ * received.
+ */
+static inline __must_check
+int vma_start_write_killable(struct vm_area_struct *vma)
+{
+	unsigned int mm_lock_seq;
+
+	if (__is_vma_write_locked(vma, &mm_lock_seq))
+		return 0;
+	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
@@ -283,6 +307,8 @@ static inline bool mmap_lock_speculate_r
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
+static inline __must_check
+int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
 static inline void vma_assert_attached(struct vm_area_struct *vma) {}
--- a/mm/mmap_lock.c~mm-add-vma_start_write_killable
+++ a/mm/mmap_lock.c
@@ -45,8 +45,15 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
 
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
-static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching)
+/*
+ * Return value: 0 if vma detached,
+ * 1 if vma attached with no readers,
+ * -EINTR if signal received,
+ */
+static inline int __vma_enter_locked(struct vm_area_struct *vma,
+		bool detaching, int state)
 {
+	int err;
 	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
 
 	/* Additional refcnt if the vma is attached. */
@@ -58,15 +65,19 @@ static inline bool __vma_enter_locked(st
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
 	 */
 	if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
-		return false;
+		return 0;
 
 	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
-	rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
+	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
-		   TASK_UNINTERRUPTIBLE);
+		   state);
+	if (err) {
+		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
+		return err;
+	}
 	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
 
-	return true;
+	return 1;
 }
 
 static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
@@ -75,16 +86,19 @@ static inline void __vma_exit_locked(str
 	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
 }
 
-void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
+int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
+		int state)
 {
-	bool locked;
+	int locked;
 
 	/*
 	 * __vma_enter_locked() returns false immediately if the vma is not
 	 * attached, otherwise it waits until refcnt is indicating that vma
 	 * is attached with no readers.
 	 */
-	locked = __vma_enter_locked(vma, false);
+	locked = __vma_enter_locked(vma, false, state);
+	if (locked < 0)
+		return locked;
 
 	/*
 	 * We should use WRITE_ONCE() here because we can have concurrent reads
@@ -100,6 +114,8 @@ void __vma_start_write(struct vm_area_st
 		__vma_exit_locked(vma, &detached);
 		WARN_ON_ONCE(detached); /* vma should remain attached */
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__vma_start_write);
 
@@ -118,7 +134,7 @@ void vma_mark_detached(struct vm_area_st
 	 */
 	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
 		/* Wait until vma is detached with no readers. */
-		if (__vma_enter_locked(vma, true)) {
+		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
 			bool detached;
 
 			__vma_exit_locked(vma, &detached);
--- a/tools/testing/vma/vma_internal.h~mm-add-vma_start_write_killable
+++ a/tools/testing/vma/vma_internal.h
@@ -952,6 +952,14 @@ static inline void vma_start_write(struc
 	vma->vm_lock_seq++;
 }
 
+static inline __must_check
+int vma_start_write_killable(struct vm_area_struct *vma)
+{
+	/* Used to indicate to tests that a write operation has begun. */
+	vma->vm_lock_seq++;
+	return 0;
+}
+
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-tweak-__vma_enter_locked.patch

