Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EC139021C
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352218; cv=none; b=I/x4ZvpWWpSOQ9qFzimKb7HVX5lK4ha72ZjzJ5t3oXfYtskn67eUlC5F83VPdIoCcRkr0z33wkHWhT4vx5S84Q776UksA2zz0rbbExTzdeApweI5WBbjnr8Qo6LUOJykrrTQKVMKeTJFeDSoZxRAdKMGCKwfwkNVoVoM1eyXqGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352218; c=relaxed/simple;
	bh=SvEtBl/7hFaVUdCLJycePSe91Ew3d56wCLo/qT0RU4U=;
	h=Date:To:From:Subject:Message-Id; b=D9MXXAGkc04yKEA7b0YSrcDEyzg6En+//o/NETei4GvkCALfG/Z5q9CnlzbCQdG8K2+t50f9y8JQBpM99GCmZGUzPMuKP+/HeTJE7x2J99yoO05klquM2e42Aq2MYBoD7SPupUGbYloi9XYIWJI+ZGkeu7qojAbPdh6yq1J8lz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u5sO/Ew1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u5sO/Ew1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04F21F000E9;
	Fri, 21 Aug 2026 22:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352216;
	bh=nNWjj834MNDNzBdpDTLZG5afToIKqg8I1Dlrv3i3bWg=;
	h=Date:To:From:Subject;
	b=u5sO/Ew1vglER34dT/CSlXRvi3Jc1mkrUyCZMNl4WfR8OVumjD+7Tv8BO9Rf7kOR6
	 A6+y9CQDAKkVAH2hnh2rIXL+2Sbu9f8fOjD7wc0qxydOMxkHbeCrYD+OvVt9X7TvbB
	 ZH6O5sbOAukl2w2ikSRRUY6HU0Tr29bkM9gGOJrM=
Date: Fri, 21 Aug 2026 15:43:36 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch added to mm-unstable branch
Message-Id: <20260821224336.C04F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add write lock checking with lockdep sequence numbers
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: add write lock checking with lockdep sequence numbers
Date: Fri, 21 Aug 2026 15:26:11 -0400

Use the lockdep sequence numbers to ensure the write lock is not dropped
between write operations.  The lockdep sequence is recorded on any walk
that starts from the top of the tree and re-checked prior to any operation
using an active node.

When lockdep detects an issue, it sets debug_locks to 0 disabling further
reports.  __lock_sequnece() will return u32 ~0 when debug_locks is zero,
and the real sequnece count cannot return such a high value as it is less
than 32bits.

By always updating the sequence number, regardless of lock state and by
ignoring ~0 value in the sequence number will avoid ever printing a
WARN_ON when lockdep sets debug_locks to 0.

Link: https://lore.kernel.org/20260821192627.4085470-4-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Breno Leitao <leitao@debian.org>
Tested-by: Breno Leitao <leitao@debian.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    7 ++-
 lib/maple_tree.c           |   64 ++++++++++++++++++++++++++++-------
 2 files changed, 57 insertions(+), 14 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers
+++ a/include/linux/maple_tree.h
@@ -484,9 +484,12 @@ struct ma_state {
 	unsigned char mas_flags;
 	unsigned char end;		/* The end of the node */
 	enum store_type store_type;	/* The type of store needed for this operation */
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+#ifdef CONFIG_LOCKDEP
+	u32 ld_seq;
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 	unsigned long rcu_gp;
-#endif
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+#endif /* CONFIG_LOCKDEP */
 };
 
 struct ma_wr_state {
--- a/lib/maple_tree.c~maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers
+++ a/lib/maple_tree.c
@@ -1148,40 +1148,77 @@ static inline void mas_free(struct ma_st
 	ma_free_rcu(mte_to_node(used));
 }
 
-void mas_lock_check(struct ma_state *mas)
+
+#ifdef CONFIG_LOCKDEP
+static struct lockdep_map *mas_lockdep_map(struct ma_state *mas)
 {
+	struct maple_tree *mt = mas->tree;
+
+	if (mt_external_lock(mt))
+		return mt->ma_external_lock;
+
+	return &(mt->ma_lock).dep_map;
+}
+
+#endif
+
+static void mas_lock_check(struct ma_state *mas)
+{
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map *map;
+	u32 seq;
 
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
 	if (!mas_is_active(mas))
 		return;
 
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 	if (!mt_locked(mas->tree)) {
 		if (mt_in_rcu(mas->tree))
 			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
 	}
-#endif
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+
+	map = mas_lockdep_map(mas);
+	if (!map)
+		return;
+
+	seq = lock_sequence(map);
+	if (seq != UINT_MAX && mas->ld_seq != UINT_MAX)
+		WARN_ON_ONCE(mas->ld_seq != seq);
+#endif /* CONFIG_LOCKDEP */
 
 }
 
-void mas_init_lock_check(struct ma_state *mas)
+static void mas_init_lock_check(struct ma_state *mas)
 {
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map *map;
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 	if (!mt_locked(mas->tree)) {
 		if (mt_in_rcu(mas->tree))
 			mas->rcu_gp = get_state_synchronize_rcu();
+		return;
 	}
-#endif
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+
+	map = mas_lockdep_map(mas);
+	if (map) /* Update regardless of lock state */
+		mas->ld_seq = lock_sequence(map);
+#endif /* CONFIG_LOCKDEP */
 
 }
 
 static void mas_may_init_lock_check(struct ma_state *mas)
 {
-#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
-	if (mas_is_start(mas) || mas_is_paused(mas))
+#ifdef CONFIG_LOCKDEP
+#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
+	if (mas_is_start(mas) || mas_is_paused(mas)) {
 		mas_init_lock_check(mas);
-	else
-		mas_lock_check(mas);
-#endif
+		return;
+	}
+#endif /* CONFIG_RCU_STRICT_GRACE_PERIOD */
+	mas_lock_check(mas);
+#endif /* CONFIG_LOCKDEP */
 }
 
 /*
@@ -4864,6 +4901,7 @@ void *mas_store(struct ma_state *mas, vo
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_may_init_lock_check(mas);
 	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
@@ -4922,6 +4960,7 @@ int mas_store_gfp(struct ma_state *mas,
 	MA_WR_STATE(wr_mas, mas, entry);
 	int ret = 0;
 
+	mas_may_init_lock_check(mas);
 retry:
 	mas_wr_preallocate(&wr_mas, entry);
 	if (unlikely(mas_nomem(mas, gfp))) {
@@ -4952,6 +4991,7 @@ void mas_store_prealloc(struct ma_state
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_lock_check(mas);
 	if (mas->store_type == wr_store_root) {
 		mas_wr_prealloc_setup(&wr_mas);
 		goto store;
@@ -4984,6 +5024,7 @@ int mas_preallocate(struct ma_state *mas
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
+	mas_may_init_lock_check(mas);
 	mas_wr_prealloc_setup(&wr_mas);
 	mas->store_type = mas_wr_store_type(&wr_mas);
 	mas_prealloc_calc(&wr_mas, entry);
@@ -5469,7 +5510,6 @@ EXPORT_SYMBOL_GPL(mas_find_range);
 static bool mas_find_rev_setup(struct ma_state *mas, unsigned long min,
 		void **entry)
 {
-
 	switch (mas->status) {
 	case ma_active:
 		goto active;
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

