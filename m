Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9013B32ABE1
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898366; cv=none; b=EqRafQ7FbT/R8APV9GHRxtGoYLkAclAhvw9w7K+lW0eAW4iCA3LqLGgcnWAriYYkgSlvBoyYS+g2YMposSfVGEIcHx4B7OUvMM7fF3ycvuVGmmF5963RtOYkNxcETx9OhmZgKXM499ikys/sQc3RINQrOxTxigtvfPCsb8n7Y9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898366; c=relaxed/simple;
	bh=HGNc2iTESN+4bLusbB09485lg0xWMi0SeBkereD4g0o=;
	h=Date:To:From:Subject:Message-Id; b=ragcY1JULIdZiGyVZi2NxCc7XS4hdgARY50OfxtAZsFjrH6ZF4MaUpPXKNqG9qhGFixTSb+tCpz5Nu/oju2B+bL3bqNlT0BBSbkvwIR33XjiySaE9VaogxS/iCnstwum1cLv1I0HihzUUJlb4Y663PNdU9vKmi+qft07y5fX+uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kbqwigN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kbqwigN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68762C19425;
	Sat, 31 Jan 2026 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898366;
	bh=HGNc2iTESN+4bLusbB09485lg0xWMi0SeBkereD4g0o=;
	h=Date:To:From:Subject:From;
	b=kbqwigN+cF69OZYL23wxw7VUUUN1zLBUkX+SkLeDBv0hqXkM4jRGoyTWeMd7I3XOE
	 Z/fYY5+VjOn6Xf/0acEPIbTOCs2DE2GVazq9D1Pz0m+v322NlFyReQxV6mwK7kh66G
	 cFR/PLztEacezKLE5cTdu6APyiRtPGlQWk1VEbm4=
Date: Sat, 31 Jan 2026 14:26:05 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-clean-up-__vma_enter-exit_locked.patch removed from -mm tree
Message-Id: <20260131222606.68762C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: clean up __vma_enter/exit_locked()
has been removed from the -mm tree.  Its filename was
     mm-vma-clean-up-__vma_enter-exit_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: clean up __vma_enter/exit_locked()
Date: Fri, 23 Jan 2026 20:12:16 +0000

These functions are very confusing indeed.  'Entering' a lock could be
interpreted as acquiring it, but this is not what these functions are
interacting with.

Equally they don't indicate at all what kind of lock we are 'entering' or
'exiting'.  Finally they are misleading as we invoke these functions when
we already hold a write lock to detach a VMA.

These functions are explicitly simply 'entering' and 'exiting' a state in
which we hold the EXCLUSIVE lock in order that we can either mark the VMA
as being write-locked, or mark the VMA detached.

Rename the functions accordingly, and also update
__vma_end_exclude_readers() to return detached state with a __must_check
directive, as it is simply clumsy to pass an output pointer here to
detached state and inconsistent vs.  __vma_start_exclude_readers().

Finally, remove the unnecessary 'inline' directives.

No functional change intended.

Link: https://lkml.kernel.org/r/33273be9389712347d69987c408ca7436f0c1b22.1769198904.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    4 +-
 mm/mmap_lock.c            |   58 ++++++++++++++++++++++++------------
 2 files changed, 42 insertions(+), 20 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-clean-up-__vma_enter-exit_locked
+++ a/include/linux/mmap_lock.h
@@ -211,8 +211,8 @@ static inline void vma_refcount_put(stru
 	newcnt = __vma_refcount_put_return(vma);
 
 	/*
-	 * __vma_enter_locked() may be sleeping waiting for readers to drop
-	 * their reference count, so wake it up if we were the last reader
+	 * __vma_start_exclude_readers() may be sleeping waiting for readers to
+	 * drop their reference count, so wake it up if we were the last reader
 	 * blocking it from being acquired.
 	 *
 	 * We may be raced by other readers temporarily incrementing the
--- a/mm/mmap_lock.c~mm-vma-clean-up-__vma_enter-exit_locked
+++ a/mm/mmap_lock.c
@@ -46,19 +46,44 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 
-static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
+/*
+ * Now that all readers have been evicted, mark the VMA as being out of the
+ * 'exclude readers' state.
+ *
+ * Returns true if the VMA is now detached, otherwise false.
+ */
+static bool __must_check __vma_end_exclude_readers(struct vm_area_struct *vma)
 {
-	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					  &vma->vm_refcnt);
+	bool detached;
+
+	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					 &vma->vm_refcnt);
 	__vma_lockdep_release_exclusive(vma);
+	return detached;
 }
 
 /*
- * __vma_enter_locked() returns 0 immediately if the vma is not
- * attached, otherwise it waits for any current readers to finish and
- * returns 1.  Returns -EINTR if a signal is received while waiting.
+ * Mark the VMA as being in a state of excluding readers, check to see if any
+ * VMA read locks are indeed held, and if so wait for them to be released.
+ *
+ * Note that this function pairs with vma_refcount_put() which will wake up this
+ * thread when it detects that the last reader has released its lock.
+ *
+ * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
+ * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
+ * is permitted to kill it.
+ *
+ * The function will return 0 immediately if the VMA is detached, or wait for
+ * readers and return 1 once they have all exited, leaving the VMA exclusively
+ * locked.
+ *
+ * If the function returns 1, the caller is required to invoke
+ * __vma_end_exclude_readers() once the exclusive state is no longer required.
+ *
+ * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
+ * may also return -EINTR to indicate a fatal signal was received while waiting.
  */
-static inline int __vma_enter_locked(struct vm_area_struct *vma,
+static int __vma_start_exclude_readers(struct vm_area_struct *vma,
 		bool detaching, int state)
 {
 	int err;
@@ -85,13 +110,10 @@ static inline int __vma_enter_locked(str
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		bool detached;
-
-		__vma_exit_locked(vma, &detached);
-		if (detached) {
+		if (__vma_end_exclude_readers(vma)) {
 			/*
 			 * The wait failed, but the last reader went away
-			 * as well.  Tell the caller the VMA is detached.
+			 * as well. Tell the caller the VMA is detached.
 			 */
 			WARN_ON_ONCE(!detaching);
 			err = 0;
@@ -108,7 +130,7 @@ int __vma_start_write(struct vm_area_str
 {
 	int locked;
 
-	locked = __vma_enter_locked(vma, false, state);
+	locked = __vma_start_exclude_readers(vma, false, state);
 	if (locked < 0)
 		return locked;
 
@@ -121,10 +143,10 @@ int __vma_start_write(struct vm_area_str
 	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
 
 	if (locked) {
-		bool detached;
+		bool detached = __vma_end_exclude_readers(vma);
 
-		__vma_exit_locked(vma, &detached);
-		WARN_ON_ONCE(detached); /* vma should remain attached */
+		/* The VMA should remain attached. */
+		WARN_ON_ONCE(detached);
 	}
 
 	return 0;
@@ -148,14 +170,14 @@ void vma_mark_detached(struct vm_area_st
 	 */
 	if (unlikely(__vma_refcount_put_return(vma))) {
 		/* Wait until vma is detached with no readers. */
-		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
+		if (__vma_start_exclude_readers(vma, true, TASK_UNINTERRUPTIBLE)) {
 			bool detached;
 
 			/*
 			 * Once this is complete, no readers can increment the
 			 * reference count, and the VMA is marked detached.
 			 */
-			__vma_exit_locked(vma, &detached);
+			detached = __vma_end_exclude_readers(vma);
 			WARN_ON_ONCE(!detached);
 		}
 	}
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

