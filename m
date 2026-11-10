Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293126;
	b=Wz1iZQHo+OP6UD9lD0UCE+rK5ejgzMQiaZroZjbx75tjhFKXshZiMDadPxFmitOIBGi7
	 Acs7qtTh6zl/QFSNDV6+55fYNfsvj/WaRPdtvL7QJjHTWH1ARgePkqFcfg+qkv9aQ33Nv
	 EJQZj3CVOStGyGK0/xHcnevLG59q35sjyFYXOiYNNb6eQUmCHwsrkZh1GPtNve2HCMt+v
	 4EJKGyO6olaAt8kk1e6vl8qYxgAk36t921aOplztZuiq8tbYTttHQozubtjZEtcQC7WCT
	 CgvbSjUkQ8qw6F6QS7/p5z8Y3HU6e4fdjHBcuAyV5T+1h7jKMbqA0f/w5HJ4WC1mz0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293126;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7IRsvSa2I9bYDfi+ENZbUikfq15T4BiMR0cK+ITJNZ4=;
	b=Fg49ZzECtNohKlepxvxgAUUoWfk8JJVgdmji24z32KzQnHDJo9BaJba3C919vcfKEhGH
	 cLmzXX7djhyYjvOqgUcDwdUx4hfQ2wqk0k5ufQ5e7N77HK4/2FVKjevqopGUFABAKFmX8
	 UfYQeFLZSQao9sVxlcd9ANzrZV32Q3++bgaUXduKufvKgoYRfeUZqMY3awW8WaLxIJQ/3
	 vBHDF0gi+sY+QtbRUBvc5FEahx0lSHkt3Y5YcfYfaIZ4tDJreJx5OhohIPvbm1SckioTw
	 v8izso0bxvaq6QhW2Ns4t8s7OwEj+W6X7p5LoJIZKPtrRmrUIbm8PsFSwjkG5Apbcfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uLLBkD3o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FEC606A326
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 06:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uLLBkD3o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594571F008A1;
	Tue, 10 Nov 2026 06:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293125;
	bh=7IRsvSa2I9bYDfi+ENZbUikfq15T4BiMR0cK+ITJNZ4=;
	h=Date:To:From:Subject;
	b=uLLBkD3oAe75y3HPVGhndUrlmZO8V3ewONxRQCkcSNXSR6tp7rQRw6GxB/hjnNxQE
	 zfvMfqa5e4Hdj2hx7oPp3w3OwtF7MKs59GepsRmHEplNyEA4N4mBH8VyG51YCx9gJ6
	 QaJjYIMPVoXJ+MraDUSbYMySPb88jm7e8DK0TTMI=
Date: Mon, 09 Nov 2026 22:45:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,nickolai@csail.mit.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch removed from -mm tree
Message-Id: <20261110064525.594571F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: xarray: clear the new head's parent before freeing the old head
has been removed from the -mm tree.  Its filename was
     xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: xarray: clear the new head's parent before freeing the old head
Date: Tue, 27 Oct 2026 15:20:14 -0400

xas_shrink() passes the old head to xa_node_free(), which queues it with
call_rcu(), before it clears the new head's parent pointer.  A lockless
walker that loads the new head after the grace period has started can
still climb from it into the old head through xa_parent(), as xas_find(),
xas_find_marked(), xas_next() and xas_prev() do when they step past the
end of a node, and read the old head after it is freed.

Clear the parent pointer before freeing the old head, as
radix_tree_shrink() does.

With a delay injected after xa_node_free() in xas_shrink(), KASAN reports
a slab-use-after-free in the walker; with this patch it does not.

Link: https://lore.kernel.org/20261027192014.844878-1-nickolai@csail.mit.edu
Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 lib/xarray.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-clear-the-new-heads-parent-before-freeing-the-old-head
+++ a/lib/xarray.c
@@ -471,11 +471,12 @@ static void xas_shrink(struct xa_state *
 		if (!xa_is_node(entry))
 			RCU_INIT_POINTER(node->slots[0], XA_RETRY_ENTRY);
 		xas_update(xas, node);
+		if (xa_is_node(entry))
+			xa_to_node(entry)->parent = NULL;
 		xa_node_free(node);
 		if (!xa_is_node(entry))
 			break;
 		node = xa_to_node(entry);
-		node->parent = NULL;
 	}
 }
 
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

lib-plist-add-a-plist_test-case-for-plist_requeue-on-the-last-priority-bucket.patch

