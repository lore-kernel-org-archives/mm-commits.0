Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335E374E7A
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622963; cv=none; b=Rl/hXE2OXqCgn0AejBZ6fYIN5fhxJyDcPhAPfrMqqWAy63S4b9NDKusuhjRkEYn1sGgdmbl0ig1Wj2XBqp2Q84UITtn+jmSBwsBnRdaFOcaeoX3j93ni1zTqiGeqIM1pRP918YMXYXtX+1tOe8wTyhnNjgR9Cy2uVKq9NJxI+Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622963; c=relaxed/simple;
	bh=8UIhre5ktQc29lXLL2Vi3kRxgU2fpHKoJTuEGc//n4U=;
	h=Date:To:From:Subject:Message-Id; b=P2FDsed37QxaxQS5lK3mb4tSmotOC1LTG4IMW3jmUXCaNrtKnbueehYBCR+64oKjZsgFuLkZN3Df717U20UsYPXB2+v6lDp1KN9wIejIb4AMclRjC1GOvxSsqlmCDxgaG388wHFgvWxP0hd3CEtntLbFoJ33t2XHYsoT0/k4IDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BEiyT02I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BEiyT02I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F23C1F00A3A;
	Tue, 25 Aug 2026 01:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622961;
	bh=G+Lr8t2Ai6CvEy4RXx8GBfJEdFLiN2IkM1Y9I2k4KhQ=;
	h=Date:To:From:Subject;
	b=BEiyT02IBbZv83XFISKiINDEDQQAWkIWYqRXcjIB/J8b+qF9ywdm67DDLXLHamu5o
	 /iFDh3wvgdlqCoqTwcqzzigrkgNErDIgnVOYkcyGvU1N6KJJf4EI8Na8tMiCvMa/CE
	 /a1kkwnSIJe+bOAdeVNvTCscuyNd8LeTo42qLTxE=
Date: Mon, 24 Aug 2026 18:56:01 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch removed from -mm tree
Message-Id: <20260825015601.7F23C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add rcu locking check when LOCKDEP is enabled
has been removed from the -mm tree.  Its filename was
     maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: add rcu locking check when LOCKDEP is enabled
Date: Fri, 21 Aug 2026 15:26:09 -0400

Patch series "maple_tree: lock checking and clean ups", v3.

In this series:
1. Try to detect lock issues
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

4. The erase gfp uses
  mas_erase() and mtree_erase() do not take a gfp argument.  To improve
  reliability of the erase, the first attempt to allocate will be
  GFP_NOWAIT, followed by a retry (if necessary of GFP_KERNEL |
  GFP_NOFAIL.  This will ensure the data is gone.  I've updated the
  documentation to make it more clear as well.  mas_store() is not
  addressed in the same way, but may need to be updated at a later date,
  but that may require changing callers so it is out of scope here.

Beyond these goals there are some test fixes, some general speed-up
patches targeting extra work and cycles, and dropping dead code.


This patch (of 19):

When CONFIG_LOCKDEP and CONFIG_RCU_STRICT_GRACE_PERIOD is enabled, check
for rcu locking issues by recording the grace period in the maple state
and checking the rcu window is still valid whenever the maple state is
reused with a state that is not MA_START or MA_PAUSED.

Link: https://lore.kernel.org/20260821192627.4085470-1-liam@infradead.org
Link: https://lore.kernel.org/20260821192627.4085470-2-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
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
@@ -484,6 +484,9 @@ struct ma_state {
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
@@ -1148,6 +1148,42 @@ static inline void mas_free(struct ma_st
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
@@ -1166,6 +1202,7 @@ static inline struct maple_enode *mas_st
 	if (likely(mas_is_start(mas))) {
 		struct maple_enode *root;
 
+		mas_init_lock_check(mas);
 		mas->min = 0;
 		mas->max = ULONG_MAX;
 
@@ -4355,6 +4392,7 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
+	mas_may_init_lock_check(mas);
 	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 retry:
@@ -4992,6 +5030,7 @@ static void mas_may_activate(struct ma_s
 		mas->status = ma_start;
 	} else {
 		mas->status = ma_active;
+		mas_lock_check(mas);
 	}
 }
 
@@ -5069,6 +5108,7 @@ void *mas_next(struct ma_state *mas, uns
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5092,6 +5132,7 @@ void *mas_next_range(struct ma_state *ma
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_next_setup(mas, max, &entry))
 		return entry;
 
@@ -5200,6 +5241,7 @@ void *mas_prev(struct ma_state *mas, uns
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5223,6 +5265,7 @@ void *mas_prev_range(struct ma_state *ma
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_prev_setup(mas, min, &entry))
 		return entry;
 
@@ -5269,6 +5312,7 @@ EXPORT_SYMBOL_GPL(mt_prev);
  */
 void mas_pause(struct ma_state *mas)
 {
+	mas_lock_check(mas);
 	mas->status = ma_pause;
 	mas->node = NULL;
 }
@@ -5377,6 +5421,7 @@ void *mas_find(struct ma_state *mas, uns
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5404,6 +5449,7 @@ void *mas_find_range(struct ma_state *ma
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_setup(mas, max, &entry))
 		return entry;
 
@@ -5516,6 +5562,7 @@ void *mas_find_rev(struct ma_state *mas,
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5542,6 +5589,7 @@ void *mas_find_range_rev(struct ma_state
 {
 	void *entry = NULL;
 
+	mas_may_init_lock_check(mas);
 	if (mas_find_rev_setup(mas, min, &entry))
 		return entry;
 
@@ -5618,7 +5666,7 @@ bool mas_nomem(struct ma_state *mas, gfp
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
-	mas->status = ma_start;
+	mas_reset(mas);
 	return true;
 }
 
_

Patches currently in -mm which might be from liam@infradead.org are


