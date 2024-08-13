Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830AC1AAE03
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 21:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723585853; cv=none; b=WX3FKjHcpFdW0hc1a8pgeRL0Lm82T48WliUyLAqLOxWfGaxseniaKbYSQLAXpr4NGE8oG+tC54t2hkzOQUaS9JZ6pR2h5OgZioAp8fnhm6vWooZvXknfdfhke4uhlwexNj9py+l0pg6yQS3yXB0CmuO/zK2RJSYVYpI8EAamoJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723585853; c=relaxed/simple;
	bh=mTkR8iWaOVY1b2LkxFSEj+7H9ssJsTwKEa9DquPq0Lw=;
	h=Date:To:From:Subject:Message-Id; b=tgq5fA+5EKOzJ5X0VIdSztxrUCKZzF4XpwqlNhrKzJ5ijQuBJHcMPtgsx//78vKBipX8UwRZUcOlMdnHcjLjvWXbVlVA44xS2RpAL2qgTMaTkmZTxS506nmp4D66naY6hgV3+1qm8XnUrQGRJ345hQp+NVWVhhLFFVWWFCX1PO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b6hSWtFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b6hSWtFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DBCC32782;
	Tue, 13 Aug 2024 21:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723585852;
	bh=mTkR8iWaOVY1b2LkxFSEj+7H9ssJsTwKEa9DquPq0Lw=;
	h=Date:To:From:Subject:From;
	b=b6hSWtFsJ5CLJrBIYMzCeY/L/QLb5YiVfJvfuAv93cfhRdVrSLh2D8A9M2nvTZzEP
	 z4ZzWLZZq4+UdRhaM1oh5+Ewpj71LoW03IKETka5v6R8YfGrcC8WG29pyW8LaKtVHr
	 LmOpIBf7dzSoC3w0TwzhgvR/l0SbGldk4XAesyjs=
Date: Tue, 13 Aug 2024 14:50:52 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,dtcccc@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-save-freeing-stack-trace-at-calling-time-instead-of-freeing-time.patch added to mm-unstable branch
Message-Id: <20240813215052.C4DBCC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfence: save freeing stack trace at calling time instead of freeing time
has been added to the -mm mm-unstable branch.  Its filename is
     kfence-save-freeing-stack-trace-at-calling-time-instead-of-freeing-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-save-freeing-stack-trace-at-calling-time-instead-of-freeing-time.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: kfence: save freeing stack trace at calling time instead of freeing time
Date: Mon, 12 Aug 2024 17:55:17 +0800

For kmem_cache with SLAB_TYPESAFE_BY_RCU, the freeing trace stack at
calling kmem_cache_free() is more useful. While the following stack is
meaningless and provides no help:
  freed by task 46 on cpu 0 at 656.840729s:
   rcu_do_batch+0x1ab/0x540
   nocb_cb_wait+0x8f/0x260
   rcu_nocb_cb_kthread+0x25/0x80
   kthread+0xd2/0x100
   ret_from_fork+0x34/0x50
   ret_from_fork_asm+0x1a/0x30

Link: https://lkml.kernel.org/r/20240812095517.2357-1-dtcccc@linux.alibaba.com
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c   |   39 +++++++++++++++++++++++++++++----------
 mm/kfence/kfence.h |    1 +
 mm/kfence/report.c |    7 ++++---
 3 files changed, 34 insertions(+), 13 deletions(-)

--- a/mm/kfence/core.c~kfence-save-freeing-stack-trace-at-calling-time-instead-of-freeing-time
+++ a/mm/kfence/core.c
@@ -273,6 +273,13 @@ static inline unsigned long metadata_to_
 	return pageaddr;
 }
 
+static inline bool kfence_obj_allocated(const struct kfence_metadata *meta)
+{
+	enum kfence_object_state state = READ_ONCE(meta->state);
+
+	return state == KFENCE_OBJECT_ALLOCATED || state == KFENCE_OBJECT_RCU_FREEING;
+}
+
 /*
  * Update the object's metadata state, including updating the alloc/free stacks
  * depending on the state transition.
@@ -282,10 +289,14 @@ metadata_update_state(struct kfence_meta
 		      unsigned long *stack_entries, size_t num_stack_entries)
 {
 	struct kfence_track *track =
-		next == KFENCE_OBJECT_FREED ? &meta->free_track : &meta->alloc_track;
+		next == KFENCE_OBJECT_ALLOCATED ? &meta->alloc_track : &meta->free_track;
 
 	lockdep_assert_held(&meta->lock);
 
+	/* Stack has been saved when calling rcu, skip. */
+	if (READ_ONCE(meta->state) == KFENCE_OBJECT_RCU_FREEING)
+		goto out;
+
 	if (stack_entries) {
 		memcpy(track->stack_entries, stack_entries,
 		       num_stack_entries * sizeof(stack_entries[0]));
@@ -301,6 +312,7 @@ metadata_update_state(struct kfence_meta
 	track->cpu = raw_smp_processor_id();
 	track->ts_nsec = local_clock(); /* Same source as printk timestamps. */
 
+out:
 	/*
 	 * Pairs with READ_ONCE() in
 	 *	kfence_shutdown_cache(),
@@ -506,7 +518,7 @@ static void kfence_guarded_free(void *ad
 
 	raw_spin_lock_irqsave(&meta->lock, flags);
 
-	if (meta->state != KFENCE_OBJECT_ALLOCATED || meta->addr != (unsigned long)addr) {
+	if (!kfence_obj_allocated(meta) || meta->addr != (unsigned long)addr) {
 		/* Invalid or double-free, bail out. */
 		atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
 		kfence_report_error((unsigned long)addr, false, NULL, meta,
@@ -784,7 +796,7 @@ static void kfence_check_all_canary(void
 	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
 		struct kfence_metadata *meta = &kfence_metadata[i];
 
-		if (meta->state == KFENCE_OBJECT_ALLOCATED)
+		if (kfence_obj_allocated(meta))
 			check_canary(meta);
 	}
 }
@@ -1010,12 +1022,11 @@ void kfence_shutdown_cache(struct kmem_c
 		 * the lock will not help, as different critical section
 		 * serialization will have the same outcome.
 		 */
-		if (READ_ONCE(meta->cache) != s ||
-		    READ_ONCE(meta->state) != KFENCE_OBJECT_ALLOCATED)
+		if (READ_ONCE(meta->cache) != s || !kfence_obj_allocated(meta))
 			continue;
 
 		raw_spin_lock_irqsave(&meta->lock, flags);
-		in_use = meta->cache == s && meta->state == KFENCE_OBJECT_ALLOCATED;
+		in_use = meta->cache == s && kfence_obj_allocated(meta);
 		raw_spin_unlock_irqrestore(&meta->lock, flags);
 
 		if (in_use) {
@@ -1160,11 +1171,19 @@ void __kfence_free(void *addr)
 	 * the object, as the object page may be recycled for other-typed
 	 * objects once it has been freed. meta->cache may be NULL if the cache
 	 * was destroyed.
+	 * Save the stack trace here so that reports show where the user freed
+	 * the object.
 	 */
-	if (unlikely(meta->cache && (meta->cache->flags & SLAB_TYPESAFE_BY_RCU)))
+	if (unlikely(meta->cache && (meta->cache->flags & SLAB_TYPESAFE_BY_RCU))) {
+		unsigned long flags;
+
+		raw_spin_lock_irqsave(&meta->lock, flags);
+		metadata_update_state(meta, KFENCE_OBJECT_RCU_FREEING, NULL, 0);
+		raw_spin_unlock_irqrestore(&meta->lock, flags);
 		call_rcu(&meta->rcu_head, rcu_guarded_free);
-	else
+	} else {
 		kfence_guarded_free(addr, meta, false);
+	}
 }
 
 bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs *regs)
@@ -1188,14 +1207,14 @@ bool kfence_handle_page_fault(unsigned l
 		int distance = 0;
 
 		meta = addr_to_metadata(addr - PAGE_SIZE);
-		if (meta && READ_ONCE(meta->state) == KFENCE_OBJECT_ALLOCATED) {
+		if (meta && kfence_obj_allocated(meta)) {
 			to_report = meta;
 			/* Data race ok; distance calculation approximate. */
 			distance = addr - data_race(meta->addr + meta->size);
 		}
 
 		meta = addr_to_metadata(addr + PAGE_SIZE);
-		if (meta && READ_ONCE(meta->state) == KFENCE_OBJECT_ALLOCATED) {
+		if (meta && kfence_obj_allocated(meta)) {
 			/* Data race ok; distance calculation approximate. */
 			if (!to_report || distance > data_race(meta->addr) - addr)
 				to_report = meta;
--- a/mm/kfence/kfence.h~kfence-save-freeing-stack-trace-at-calling-time-instead-of-freeing-time
+++ a/mm/kfence/kfence.h
@@ -38,6 +38,7 @@
 enum kfence_object_state {
 	KFENCE_OBJECT_UNUSED,		/* Object is unused. */
 	KFENCE_OBJECT_ALLOCATED,	/* Object is currently allocated. */
+	KFENCE_OBJECT_RCU_FREEING,	/* Object was allocated, and then being freed by rcu. */
 	KFENCE_OBJECT_FREED,		/* Object was allocated, and then freed. */
 };
 
--- a/mm/kfence/report.c~kfence-save-freeing-stack-trace-at-calling-time-instead-of-freeing-time
+++ a/mm/kfence/report.c
@@ -114,7 +114,8 @@ static void kfence_print_stack(struct se
 
 	/* Timestamp matches printk timestamp format. */
 	seq_con_printf(seq, "%s by task %d on cpu %d at %lu.%06lus (%lu.%06lus ago):\n",
-		       show_alloc ? "allocated" : "freed", track->pid,
+		       show_alloc ? "allocated" : meta->state == KFENCE_OBJECT_RCU_FREEING ?
+		       "rcu freeing" : "freed", track->pid,
 		       track->cpu, (unsigned long)ts_sec, rem_nsec / 1000,
 		       (unsigned long)interval_nsec, rem_interval_nsec / 1000);
 
@@ -149,7 +150,7 @@ void kfence_print_object(struct seq_file
 
 	kfence_print_stack(seq, meta, true);
 
-	if (meta->state == KFENCE_OBJECT_FREED) {
+	if (meta->state == KFENCE_OBJECT_FREED || meta->state == KFENCE_OBJECT_RCU_FREEING) {
 		seq_con_printf(seq, "\n");
 		kfence_print_stack(seq, meta, false);
 	}
@@ -318,7 +319,7 @@ bool __kfence_obj_info(struct kmem_obj_i
 	kpp->kp_slab_cache = meta->cache;
 	kpp->kp_objp = (void *)meta->addr;
 	kfence_to_kp_stack(&meta->alloc_track, kpp->kp_stack);
-	if (meta->state == KFENCE_OBJECT_FREED)
+	if (meta->state == KFENCE_OBJECT_FREED || meta->state == KFENCE_OBJECT_RCU_FREEING)
 		kfence_to_kp_stack(&meta->free_track, kpp->kp_free_stack);
 	/* get_stack_skipnr() ensures the first entry is outside allocator. */
 	kpp->kp_ret = kpp->kp_stack[0];
_

Patches currently in -mm which might be from dtcccc@linux.alibaba.com are

kfence-save-freeing-stack-trace-at-calling-time-instead-of-freeing-time.patch

