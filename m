Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E763265CAD
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860808; cv=none; b=ccZnuRc2TRc8k0Ic0yEWhBgAsQW+jHXsi/AF8rER51enSqfDS59yl3dpVv2RgvJwvNWCQaJhJd0mwue0ESmf1jN3dXcZ+J1oh3QKJ70QNgISvp1enuRraJ/3VqiCUO4Wqe4QlDlXZu2+f2clVfJZNoz8h2a4IzunqcWkBsQybr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860808; c=relaxed/simple;
	bh=1BabqAMc8gK/fNSjLOZ6lzgCWua6tVkDk9j+GA5DF3Y=;
	h=Date:To:From:Subject:Message-Id; b=TBcwcguWzTYypZ9lfDfpf+I6IJlGgMCDKeqTs08KlV5jRUYvc7Rv8Y1NjIZAxdHZW2qFkvRl30gUVuXeCdOZnSuVF3+gSGYyVOTjLL/xt0lea/nlzqGzmWLBD36hhVWmKJVGeazHL5ZdQ3XWJMqy6WqrpVmCLuV8OwdzESnaOZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1vSxGjml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1vSxGjml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70511F000E9;
	Tue, 30 Jun 2026 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860807;
	bh=cBSTfGxOoJs3oWXYNIPSFSfBkbj0h9XsamQeU1Q8mH4=;
	h=Date:To:From:Subject;
	b=1vSxGjmlrMAQw8TjnHZgBxjiMk5lHt1roud7qUVpJFGDSj1CCazKnnGlQFeNqfguL
	 ZlE8PH+u0xxED7PAEP2LKt39W4EoZBJYMFpYSOV8xF8cefeg8sLKkGpCPZrrh2CyFl
	 GyrsqBLMClWH1eXi4tgHCQr5+H9NzkAksmb/zf0k=
Date: Tue, 30 Jun 2026 16:06:46 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch added to mm-new branch
Message-Id: <20260630230646.E70511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add rcu locking check when LOCKDEP is enabled
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: maple_tree: add rcu locking check when LOCKDEP is enabled
Date: Tue, 30 Jun 2026 15:08:25 -0400

Patch series "maple_tree: lock checking and clean ups", v2.

The goals of this series are:
1. Lock issue detection
  A number of syzbot reports are incorrectly pointing to the mm exit as
  a source of the locking error.  The first three patches attempt to
  help users detect errors in their locking - but they still have to use
  LOCKDEP.  I guess it's still down to hope and prayers.

2. Documentation fixes
  The documentation was lacking clarity, there are updates to try and
  help the users, especially around the erase() cases.

3. Two benign issues
  The cyclic allocator may have a race, although no in-kernel user can
  hit it.
  The erase functions may cause allocation issues if used with the
  incorrect locking type, but none are present in-tree.

Beyond these goals there are some test fixes, some general speed-up
patches targeting extra work and cycles, and dropping dead code.


This patch (of 19):

When CONFIG_LOCKDEP and CONFIG_RCU_STRICT_GRACE_PERIOD is enabled, check
for rcu locking issues by recording the grace period in the maple state
and checking the rcu window is still valid whenever the maple state is
reused with a state that is not MA_START or MA_PAUSED.

Link: https://lore.kernel.org/20260630190843.3563858-1-liam@infradead.org
Link: https://lore.kernel.org/20260630190843.3563858-2-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
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

 include/linux/maple_tree.h |    3 ++
 lib/maple_tree.c           |   50 ++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

--- a/include/linux/maple_tree.h~maple_tree-add-rcu-locking-check-when-lockdep-is-enabled
+++ a/include/linux/maple_tree.h
@@ -485,6 +485,9 @@ struct ma_state {
 	unsigned char mas_flags;
 	unsigned char end;		/* The end of the node */
 	enum store_type store_type;	/* The type of store needed for this operation */
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	unsigned long rcu_gp;
+#endif
 };
 
 struct ma_wr_state {
--- a/lib/maple_tree.c~maple_tree-add-rcu-locking-check-when-lockdep-is-enabled
+++ a/lib/maple_tree.c
@@ -1153,6 +1153,42 @@ static inline void mas_free(struct ma_st
 	ma_free_rcu(mte_to_node(used));
 }
 
+void mas_lock_check(struct ma_state *mas)
+{
+
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (!mas_is_active(mas))
+		return;
+
+	if (!mt_locked(mas->tree)) {
+		if (mt_in_rcu(mas->tree))
+			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
+	}
+#endif
+
+}
+
+void mas_init_lock_check(struct ma_state *mas)
+{
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (!mt_locked(mas->tree)) {
+		if (mt_in_rcu(mas->tree))
+			mas->rcu_gp = get_state_synchronize_rcu();
+	}
+#endif
+
+}
+
+static void mas_may_init_lock_check(struct ma_state *mas)
+{
+#if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD)
+	if (mas_is_start(mas) || mas_is_paused(mas))
+		mas_init_lock_check(mas);
+	else
+		mas_lock_check(mas);
+#endif
+}
+
 /*
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
@@ -1171,6 +1207,7 @@ static inline struct maple_enode *mas_st
 	if (likely(mas_is_start(mas))) {
 		struct maple_enode *root;
 
+		mas_init_lock_check(mas);
 		mas->min = 0;
 		mas->max = ULONG_MAX;
 
@@ -4360,6 +4397,7 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
+	mas_may_init_lock_check(mas);
 	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 retry:
@@ -4997,6 +5035,7 @@ static void mas_may_activate(struct ma_s
 		mas->status = ma_start;
 	} else {
 		mas->status = ma_active;
+		mas_lock_check(mas);
 	}
 }
 
@@ -5074,6 +5113,7 @@ void *mas_next(struct ma_state *mas, uns
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5097,6 +5137,7 @@ void *mas_next_range(struct ma_state *ma
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5205,6 +5246,7 @@ void *mas_prev(struct ma_state *mas, uns
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5228,6 +5270,7 @@ void *mas_prev_range(struct ma_state *ma
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5274,6 +5317,7 @@ EXPORT_SYMBOL_GPL(mt_prev);
  */
 void mas_pause(struct ma_state *mas)
 {
+	mas_lock_check(mas);
 	mas->status = ma_pause;
 	mas->node = NULL;
 }
@@ -5382,6 +5426,7 @@ void *mas_find(struct ma_state *mas, uns
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5409,6 +5454,7 @@ void *mas_find_range(struct ma_state *ma
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5521,6 +5567,7 @@ void *mas_find_rev(struct ma_state *mas,
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5547,6 +5594,7 @@ void *mas_find_range_rev(struct ma_state
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5623,7 +5671,7 @@ bool mas_nomem(struct ma_state *mas, gfp
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
-	mas->status = ma_start;
+	mas_reset(mas);
 	return true;
 }
 
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
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

