Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F6CFBF0
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755323810; cv=none; b=g9HwBiRy7ek40HKrQ38J27jU3kHhkPoJnAtjeliiE7/XjgMinaoTbn74RXHCSplZf1FnBdOvhxyXnCIsuDgABKLkvsGmJBGDyUOMSW1T7jqbSRAxphu6HeqlZKgW4Zu5yypUsKhiz8ZwUX7YyCqS8bmVFRaD/AdE+3OELYd7HYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755323810; c=relaxed/simple;
	bh=1dUmAbacK926gwQJ+hWQXPCC88ANSM5YUbyO34vJzYg=;
	h=Date:To:From:Subject:Message-Id; b=KdrioELZ9wjWX4AnLwYRVMZAuAtgZGBZPSWbrMeyRIW4B56iUITZ9PN0/SujzBbm7yudi07oubTgeY4tjHyKBiWQmHKzZoo0lHYq/BP7lIEEE5U6lxWgV4lmdIdx+SkRqz0jXiQM/VxCbGoXPjQZXAZvf3M89XmAMiwpcx4iL9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uF5Cx7rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uF5Cx7rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DAAC4CEEF;
	Sat, 16 Aug 2025 05:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755323809;
	bh=1dUmAbacK926gwQJ+hWQXPCC88ANSM5YUbyO34vJzYg=;
	h=Date:To:From:Subject:From;
	b=uF5Cx7rfE801o1OX5yBT0UXMbQ5JvhqqSD5/A31SJnpB9rN2VADGdP4qASmgEktGx
	 xRT+0MmnS3HmsMzk9kU/vyrlqUO4qaoZ5xE1y4pcMZFUqzMBzBhcHe9HyKJA5U4IlA
	 jgAb/3OuO1Xb3k9q2sa0frUGosgiOrqV2QG1lPwE=
Date: Fri, 15 Aug 2025 22:56:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,liam.howlett@oracle.com,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] maple_tree-use-kfree_rcu-in-ma_free_rcu.patch removed from -mm tree
Message-Id: <20250816055649.B2DAAC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use kfree_rcu in ma_free_rcu
has been removed from the -mm tree.  Its filename was
     maple_tree-use-kfree_rcu-in-ma_free_rcu.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: maple_tree: use kfree_rcu in ma_free_rcu
Date: Fri, 18 Jul 2025 18:21:36 +0100

kfree_rcu is an optimized version of call_rcu + kfree.  It used to not be
possible to call it on non-kmalloc objects, but this restriction was
lifted ever since SLOB was dropped from the kernel, and since commit
6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from
kmem_cache_destroy()").

Thus, replace call_rcu + mt_free_rcu with kfree_rcu.

Link: https://lkml.kernel.org/r/20250718172138.103116-1-pfalcato@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-kfree_rcu-in-ma_free_rcu
+++ a/lib/maple_tree.c
@@ -191,13 +191,6 @@ static inline void mt_free_bulk(size_t s
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
 }
 
-static void mt_free_rcu(struct rcu_head *head)
-{
-	struct maple_node *node = container_of(head, struct maple_node, rcu);
-
-	kmem_cache_free(maple_node_cache, node);
-}
-
 /*
  * ma_free_rcu() - Use rcu callback to free a maple node
  * @node: The node to free
@@ -208,7 +201,7 @@ static void mt_free_rcu(struct rcu_head
 static void ma_free_rcu(struct maple_node *node)
 {
 	WARN_ON(node->parent != ma_parent_ptr(node));
-	call_rcu(&node->rcu, mt_free_rcu);
+	kfree_rcu(node, rcu);
 }
 
 static void mt_set_height(struct maple_tree *mt, unsigned char height)
@@ -5281,7 +5274,7 @@ static void mt_free_walk(struct rcu_head
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_rcu(&node->rcu);
+	mt_free_one(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5365,7 +5358,7 @@ next:
 
 free_leaf:
 	if (free)
-		mt_free_rcu(&node->rcu);
+		mt_free_one(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }
_

Patches currently in -mm which might be from pfalcato@suse.de are

testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch

