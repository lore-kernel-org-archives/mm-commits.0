Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEF4315F
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 22:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768860979; cv=none; b=f0ZUDNQlHmrgUehRl7SHgTIR3ztUWl5HVTPetPGNt0nYsfkDIafJqV7M/e1O+zVicdNH0vdlp30eJFHx/O8ghFmMWWXL+c/hhJho2mK811zkrEEuV3YIuYpXgV0h3IvvDG634JjjbysMsB5l3/SYWRiGcaQY8qat7S8ms00+S0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768860979; c=relaxed/simple;
	bh=PZD89ILHj+mhK/kMm5jCFe44UMvKF/liTb89/8pAqaY=;
	h=Date:To:From:Subject:Message-Id; b=MsNHnW4QSlCppLuT8D4b8hhd2ILpTmAkQ1WeYGAt/8BUJ06k1YHmtkc8PUb11Ov8WnXKJiVrx20vuBAI+YnU0VucROe4Am9xMA4LyLvQoFQKusAq1RrQVnipDf+qDfYsPgIMGps8/10uE9UknVqNOQPnDqlQdROA89U7MsVdqB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=soZ42ZwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="soZ42ZwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633CAC116C6;
	Mon, 19 Jan 2026 22:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768860978;
	bh=PZD89ILHj+mhK/kMm5jCFe44UMvKF/liTb89/8pAqaY=;
	h=Date:To:From:Subject:From;
	b=soZ42ZwINPrFj2IKQLqAVtglCitShJY/tM3q64VIawQ1dx215dSteO+ucJENxTSBX
	 r1jRSilBrLZ82JkbJP2QDNHaJfsaQ4BWlvjB9g/xq6yLbfW+cTs0gD7hBPUyHc1kcw
	 Xrj2DzYaWhPDq4tYq9hbDz9hHkVM5j1+pq8Xv0wA=
Date: Mon, 19 Jan 2026 14:16:17 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-use-lockdep-where-we-can-reduce-duplication.patch added to mm-new branch
Message-Id: <20260119221618.633CAC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: use lockdep where we can, reduce duplication
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-use-lockdep-where-we-can-reduce-duplication.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-use-lockdep-where-we-can-reduce-duplication.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
mm-vma-use-lockdep-where-we-can-reduce-duplication.patch
mm-add-vma_assert_stabilised.patch

