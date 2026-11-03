Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672241;
	b=ErIxhiWfc1z+Ao4tiUEV1mYTrdWcUDaWk+oRwev5P27TQpMKuaE8MLcHt/dOCVe0bSrB
	 BM6gXtWMYXBCUKe9OA4WJ8OZXYclpU6SNeWbfRHp0+YXQpx3EyZ/KN5j79oC4OJi2ecA8
	 PePJD4zintiXeYjy95actAqNRSe2ZerLj8yeSj0uqG6tInOgsqmcapOSYsoMRxdknVbh0
	 lB9Ek9v+yAvN3lITLiLfosxkoHjS+8lcdQ5GnWXODt12aFFx0H5qTARZF0cCCSJnogFCW
	 Qtn+lQNerZkTobOmJerthJYO0Dizba/1bkMJtCLgxXmbLI97Mwxm/uwXsw3L5zYYr/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672241;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+c3z4vIwouRb2z9inomDkiAWNOgz7WIKqN5Kb/Yjl20=;
	b=csnVHW3Dx9pjq+xEsuNqQ0WisO7REpmhzzKcGLLoGgBFJtZme7XJOuEcuXeOIOOPEn1W
	 eLKyDnJgkgVp0N/ZHkT4fRhJnZC2pnQlh0ZWCJ3NQiNu1MX0A92oKSs+01A2L9ZDIrqNn
	 LPX0sIZgOfG4drXYS7RgFrO5ftNsTKPne/p278SIqg2p9NQAmzm0Ibt5mLsJdGunhSYvd
	 RALteU0hzpZ/z3S+A0icxjUw2llw0+uFxVpyTRf7ktVKEA66vzBHB0DwRpu8Jif3R6sSE
	 KVlkDDSrOeUKrsf0y0BGMlDZjIu2g5NnF5Xk9J0hLfshknIivQJ8JWPhRd1MJFJU6Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=StbF8fZd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AF4606A335
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=StbF8fZd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F451F00A18;
	Tue,  3 Nov 2026 02:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672241;
	bh=+c3z4vIwouRb2z9inomDkiAWNOgz7WIKqN5Kb/Yjl20=;
	h=Date:To:From:Subject;
	b=StbF8fZdkBwQYdaR0TqPrFwNO++vlICVYi9Yy1yfPrE0PoZ/IjqITgQuEENgMaxjV
	 jJSexlciD8iKlWdFoXt7LTUTCE8P4QryfUNNygqLfXCJ51D30yCc1RDyAKZOx+BfTc
	 Z+ouKF0en4fy2XhYRVU3X8/AoM286MqBiAZYHb/U=
Date: Mon, 02 Nov 2026 18:17:20 -0800
To: mm-commits@vger.kernel.org,mason@kernel.org,ljs@kernel.org,
	andrewjballance@gmail.com,aliceryhl@google.com,liam@infradead.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-test-emptying-tree-while-rcu-reading.patch added to mm-hotfixes-unstable branch
Message-Id: <20261103021721.01F451F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: maple_tree: Test emptying tree while RCU reading
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-test-emptying-tree-while-rcu-reading.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-test-emptying-tree-while-rcu-reading.patch

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
Subject: maple_tree: Test emptying tree while RCU reading
Date: Mon, 02 Nov 2026 21:07:23 -0500

Add a test case for the rcu reader being restarted by emptying the tree.
A reverse walk from index 0 must not return the new root entry.

Link: https://lore.kernel.org/20261103020724.2614498-3-liam@infradead.org
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Chris Mason <mason@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
---

 lib/test_maple_tree.c |  165 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-test-emptying-tree-while-rcu-reading
+++ a/lib/test_maple_tree.c
@@ -3740,6 +3740,170 @@ static noinline void __init check_range6
 	rcu_barrier();
 }
 
+/*
+ * A reader that restarts after its leaf died may find a tree without nodes:
+ * emptied, or emptied and then given a single entry at 0.  Each case starts
+ * from a tree with nodes, built by check_seq().  The stores run while the
+ * reader holds rcu_read_lock, so they use GFP_ATOMIC.
+ */
+static noinline void __init check_restart_no_node(struct maple_tree *mt)
+{
+	void *ptr = xa_mk_value(1234);
+	void *entry;
+	MA_STATE(mas, mt, 0, 0);
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_set_non_kernel(99999);
+
+	/* find: the tree is emptied */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* next: the tree is emptied */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find: the tree is emptied, then holds one entry at 0 */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find_rev: the tree is emptied */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, ULONG_MAX);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != xa_mk_value(100));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_none);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* prev: the tree is emptied, then holds one entry at 0 */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, ULONG_MAX);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != xa_mk_value(100));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.status != ma_root);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find_rev: the entry at 0 is below the minimum */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, ULONG_MAX);
+	entry = mas_find_rev(&mas, 1);
+	MT_BUG_ON(mt, entry != xa_mk_value(100));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_find_rev(&mas, 1);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_root);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find_rev: the reader is at 0 when the tree gets one entry at 0 */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_root);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+
+	/* find_range_rev: the reader is at 0 when the tree gets one entry at 0 */
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	check_seq(mt, 100, false);
+	rcu_read_lock();
+	mas_set(&mas, 0);
+	entry = mas_find_range_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != xa_mk_value(0));
+	MT_BUG_ON(mt, mtree_store_range(mt, 0, ULONG_MAX, NULL, GFP_ATOMIC));
+	MT_BUG_ON(mt, mtree_store(mt, 0, ptr, GFP_ATOMIC));
+	entry = mas_find_range_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.status != ma_root);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	rcu_read_unlock();
+	mtree_destroy(mt);
+	rcu_barrier();
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int __init maple_tree_seed(void)
 {
@@ -4031,6 +4195,7 @@ static int __init maple_tree_seed(void)
 
 	check_range64_in_rcu(&tree);
 
+	check_restart_no_node(&tree);
 
 #if defined(BENCH)
 skip:
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-fix-rcu-reader-null-dereference-after-the-tree-is-emptied.patch
maple_tree-test-emptying-tree-while-rcu-reading.patch
maple_tree-update-internal-warning-and-bug_on-code.patch

