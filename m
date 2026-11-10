Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293147;
	b=qw7EJcm8UlwxKu53RnT7wUpfmXNYPX2pJxjsR+vB2c7xNC5lVQJedvdHpvP8ie3VBkku
	 xR/yvRb8wr0Q2IZOu8VaF9i3BkXv6vjAUyx7FEeeLwQv0a371RqqjZCWLjuZHqqabTqZK
	 WA5PtRlXnwtz47+AYRUKww4guWcRESmD0URM/O9ylcggiGVfewUW/oQubcWznDt7yrSo9
	 8W9MLZOrCbHlHxZjAJU399mtb2u6O8qSxB9cwyZtWzgW1HcxMIrYUwACWQn5lO66ycNOx
	 a2N+eLKlUZ04nh6JJFiZD5BlkRhPfN9GXRw9rOGnOuhhZqo60dZk4WYvpq3tzSgZBcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293147;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3SwKzQh3h2EaVYAQHE3Yp1saaij+CRlMWbeUsdvKuxM=;
	b=A8+av7iJkGwC6yKoIV/8Obg993eksXGRwV26zf16L/KOjmmRWQ7P2lw14BhpLOiXuhId
	 3yDzGSc7zqULL5ixYjb7OAnz+sehOe182Ne3farkYqDiYfHLLGU1VsZeQgxYmqZRcS958
	 3Bieg8DhzKu28zFEqFOIVoFWY1YfKHSyBqemVJ4Pv1fxReyHRmt/t2UMaex/mp64OgzFo
	 b8w5aKZ+/qvosqk6vFWJunwDnIjuVQ5PaRbOWm+FvrX9U6DvnA5c7Zw2+gtM0ECl7mdrw
	 eRuRXUP7Y3gFfkONYQzZc2PdmuDw/OQmPLIVf9dMjRtPOGetrWMnhR/1yii2VYD4tog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vaEMzSfR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16D7606A640
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 06:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vaEMzSfR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3971F0089F;
	Tue, 10 Nov 2026 06:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293146;
	bh=3SwKzQh3h2EaVYAQHE3Yp1saaij+CRlMWbeUsdvKuxM=;
	h=Date:To:From:Subject;
	b=vaEMzSfR+iC837Q1B/nL0JeJikZDThq700tW1hJr1AayAipV3hk/wNejd/wNYqmsz
	 ITAlKWwcNpmYza6MqZCQXY/XWhEjpLiqE1cZtLFtMqWeOHzcdZMTq8hWFGRDfs4MMV
	 SVaZIS+dwIj+aeMjspMM4s+SJsqBy5d07TsYt6Jw=
Date: Mon, 09 Nov 2026 22:45:46 -0800
To: mm-commits@vger.kernel.org,mason@kernel.org,ljs@kernel.org,
	andrewjballance@gmail.com,aliceryhl@google.com,liam@infradead.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-test-emptying-tree-while-rcu-reading.patch removed from -mm tree
Message-Id: <20261110064546.8A3971F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: maple_tree: test emptying tree while RCU reading
has been removed from the -mm tree.  Its filename was
     maple_tree-test-emptying-tree-while-rcu-reading.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Google)" <liam@infradead.org>
Subject: maple_tree: test emptying tree while RCU reading
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

maple_tree-update-internal-warning-and-bug_on-code.patch

