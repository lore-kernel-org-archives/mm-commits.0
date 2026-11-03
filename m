Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672239;
	b=1WrIaJ44C+GPhyKkYUpTOTHP5bor3nD7ZPj2aJkL60pXhCYhYz9uEMdJk5zaeTuPYy/R
	 kgNqFyDE3v6dLUNUeg+y5ni6TaRDPWYEYsQoVNDq5Wb449Z2DDJKhqBl1ALhYtjbodctP
	 qh0GtxWde4oycR8NZ/J4EXiAzB629zWJXxlqTAqnOVzSy/HNdZ6pUmeW4KzzRSVyWvp+z
	 zg68ztn1W1WSapS55xPKfK/A4xaoEcKJuu5qZKpHHatQp0oijsh6SSKBzIpay3EjmBoeN
	 yUu+989Ifa2Ve7b+hCjIL3xbEV+M8tpiP8UUR3Dty+zgbP7WOr65aW+1QeoQ0Z7k0gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672239;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hWYM3SuLTrNZdQ9LQU3h1JDCEXg2qdJ0fduVuCQkRDg=;
	b=xiyJDPcSlWFO/vo7vX2Vh96015mN9kgWMFHKUhsR+JiIPfh727gmgXGfUiWRaqtwRuI8
	 k9qCeE4TUUeRvfq7QK+hzEShkIsbk/rinmnC6p4m4hV+Xvx0Ks0BTl3YptYiafRajxvBd
	 4+hYx154+aNJ8T+1VQSLPK+MNstqALLnYZho3v2h+NWUk8Q2/Gx/9LRrXxSrpm5Tm6OJD
	 +3Y+ytGYa0Wl5vmb52QoOXEovQpcgx/W1PbzaQm6EyGop+DS3G3Q8Xx1AFu0qN3Z1U9ig
	 1EDm/Vlb/SOua4zbnVRnxxivGUC6/oXSwoG7wunXz0adTipDjb37JvgvuCuHmddFVKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CHTJXSiy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356CE606A324;
	Tue,  3 Nov 2026 02:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CHTJXSiy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E6A1F000C1;
	Tue,  3 Nov 2026 02:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672239;
	bh=hWYM3SuLTrNZdQ9LQU3h1JDCEXg2qdJ0fduVuCQkRDg=;
	h=Date:To:From:Subject;
	b=CHTJXSiySAJZyOfgaN9lG7BZ2bqYawzz3SgqnuKZ27Fhvg2JGR+d2XtMoxJjYmyQs
	 81BEQC1Kaid2/nYvEtiWbLgm7t8XHtlefWN6MpALkO/SMJRwOrxcGUkhkdMAvVuobj
	 7dFRU5bdgcSLxyQohZnWqR5bbH87KDn+bZL5yw4A=
Date: Mon, 02 Nov 2026 18:17:18 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mason@kernel.org,
	ljs@kernel.org,andrewjballance@gmail.com,aliceryhl@google.com,
	liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied.patch added to mm-hotfixes-unstable branch
Message-Id: <20261103021718.F3E6A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: maple_tree: Fix rcu reader NULL dereference after the tree is emptied
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Liam R. Howlett (Google)" <liam@infradead.org>
Subject: maple_tree: Fix rcu reader NULL dereference after the tree is emptied
Date: Mon, 02 Nov 2026 21:07:22 -0500

Patch series "maple_tree fixes for 7.3", v2.

Two bugs found by an LLM review, and one problem Lorenzo Stoakes
reported off list.

An RCU reader that restarts after its node dies can dereference NULL if
the tree was emptied, or holds a single entry in the root pointer.
Patch 1 fixes it and patch 2 adds a test.

With CONFIG_DEBUG_MAPLE_TREE, MT_WARN_ON() and the other WARN macros
print the tree and call dump_stack() rather than WARN(), so syzbot never
sees them.  Patch 3 makes them WARN once per call site, after the dump,
and makes the BUG macros BUG() after theirs.  The userspace tests make
WARN() fatal to keep failing as they did on dump_stack().


This patch (of 3):

RCU readers may hit a NULL dereference if the tree is emptied while the
walker is restarted from a dead node.  Avoid the NULL dereference by
checking for an emptied/pointer tree (0->ptr, 1-ULONG_MAX -> NULL) and
set the maple state limits correctly.

A reader of /proc/<pid>/maps racing with an munmap() of the whole
address space can hit this.  The first implementation has the same
problem in both directions.

Initial fix was generated by LLM and sent by Chris Mason in private.

Link: https://lore.kernel.org/20261103020724.2614498-1-liam@infradead.org
Link: https://lore.kernel.org/20261103020724.2614498-2-liam@infradead.org
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: <stable@vger.kernel.org>
---

 lib/maple_tree.c |  112 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 85 insertions(+), 27 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied
+++ a/lib/maple_tree.c
@@ -3891,14 +3891,56 @@ retry:
 		goto retry;
 }
 
-static __always_inline bool mas_rewalk_if_dead(struct ma_state *mas,
-		struct maple_node *node, const unsigned long index)
+/*
+ * mas_next_no_node() - Finish a next walk that restarted into a tree without
+ * nodes.
+ * @mas: The inactive maple state (ma_none or ma_root)
+ *
+ * The arrival here is either because there is a root value or nothing.  Either
+ * way, the next entry is nothing.  So set the limits and overwrite the status.
+ *
+ * Return: NULL
+ */
+static inline void *mas_next_no_node(struct ma_state *mas)
 {
-	if (unlikely(ma_dead_node(node))) {
-		mas_rewalk(mas, index);
-		return true;
+	if (mas_is_ptr(mas))
+		mas->index = 1;
+	else
+		mas->index = 0;
+
+	mas->last = ULONG_MAX;
+	mas->status = ma_none;
+	return NULL;
+}
+
+/*
+ * mas_prev_no_node() - Finish a prev walk that restarted into a tree without
+ * nodes.
+ * @mas: The inactive maple state (ma_none or ma_root)
+ * @index: The start of the range the walk left
+ * @min: The lowest index to return
+ *
+ * The arrival here is either because there is a root value or nothing.  With
+ * nothing, leave the limits mas_walk() sets for an empty tree.  A root value
+ * sits at 0: stop on it as mas_prev_setup() does, unless the walk was at 0.
+ *
+ * Return: The root entry if @index and @min allow it, NULL otherwise.  A node
+ * if the root changed again since the walk; the caller restarts.
+ */
+static inline void *mas_prev_no_node(struct ma_state *mas, unsigned long index,
+		unsigned long min)
+{
+	mas->index = 0;
+	if (mas_is_none(mas)) {
+		mas->last = ULONG_MAX;
+		return NULL;
 	}
-	return false;
+
+	mas->last = 0;
+	if (!index || min)
+		return NULL;
+
+	return mas_root(mas);
 }
 
 /*
@@ -4006,14 +4048,14 @@ retry:
 	node = mas_mn(mas);
 	type = mte_node_type(mas->node);
 	pivots = ma_pivots(node, type);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (mas->min <= min) {
 		pivot = mas_safe_min(mas, pivots, mas->offset);
 
-		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-			goto retry;
+		if (unlikely(ma_dead_node(node)))
+			goto dead;
 
 		if (pivot <= min)
 			goto underflow;
@@ -4028,10 +4070,8 @@ again:
 		if (mas->index <= min)
 			goto underflow;
 
-		if (mas_prev_node(mas, min)) {
-			mas_rewalk(mas, save_point);
-			goto retry;
-		}
+		if (mas_prev_node(mas, min))
+			goto dead;
 
 		if (WARN_ON_ONCE(mas_is_underflow(mas)))
 			return NULL;
@@ -4045,8 +4085,8 @@ again:
 
 	slots = ma_slots(node, type);
 	entry = mas_slot(mas, slots, mas->offset);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (likely(entry))
 		return entry;
@@ -4063,6 +4103,17 @@ again:
 underflow:
 	mas->status = ma_underflow;
 	return NULL;
+
+dead:
+	mas_rewalk(mas, save_point);
+	if (likely(mas_is_active(mas)))
+		goto retry;
+
+	entry = mas_prev_no_node(mas, save_point, min);
+	if (unlikely(xa_is_node(entry))) /* The root changed again */
+		goto dead;
+
+	return entry;
 }
 
 /*
@@ -4176,8 +4227,8 @@ retry:
 	node = mas_mn(mas);
 	type = mte_node_type(mas->node);
 	pivots = ma_pivots(node, type);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (mas->max >= max) {
 		if (likely(mas->offset < mas->end))
@@ -4185,8 +4236,8 @@ retry:
 		else
 			pivot = mas->max;
 
-		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-			goto retry;
+		if (unlikely(ma_dead_node(node)))
+			goto dead;
 
 		if (pivot >= max) { /* Was at the limit, next will extend beyond */
 			mas->status = ma_overflow;
@@ -4208,10 +4259,8 @@ again:
 			return NULL;
 		}
 
-		if (mas_next_node(mas, node, max)) {
-			mas_rewalk(mas, save_point);
-			goto retry;
-		}
+		if (mas_next_node(mas, node, max))
+			goto dead;
 
 		if (WARN_ON_ONCE(mas_is_overflow(mas)))
 			return NULL;
@@ -4226,8 +4275,8 @@ again:
 
 	slots = ma_slots(node, type);
 	entry = mt_slot(mas->tree, slots, mas->offset);
-	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
-		goto retry;
+	if (unlikely(ma_dead_node(node)))
+		goto dead;
 
 	if (entry)
 		return entry;
@@ -4244,6 +4293,13 @@ again:
 	}
 
 	return entry;
+
+dead:
+	mas_rewalk(mas, save_point);
+	if (likely(mas_is_active(mas)))
+		goto retry;
+
+	return mas_next_no_node(mas);
 }
 
 /*
@@ -5450,7 +5506,9 @@ void *mas_find(struct ma_state *mas, uns
 	/* Retries on dead nodes handled by mas_next_slot */
 	entry = mas_next_slot(mas, max, false);
 	/* Ignore overflow */
-	mas->status = ma_active;
+	if (mas_is_overflow(mas))
+		mas->status = ma_active;
+
 	return entry;
 }
 EXPORT_SYMBOL_GPL(mas_find);
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied.patch
maple_tree-test-emptying-tree-while-rcu-reading.patch
maple_tree-update-internal-warning-and-bug_on-code.patch

