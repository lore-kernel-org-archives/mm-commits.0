Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F917C2C9
	for <mm-commits@vger.kernel.org>; Fri, 18 Jul 2025 21:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752873343; cv=none; b=PNsz9CGo5KaV7vGr0MFE1QbKvSRefACZ+mMu3dSeh8Uh11AiNkkx1ZxkfacJVA/H2TMlTKxhg3lgHYOeeONNdJvhtX8cM23lcYg0jLhdPDGDFLNdDrMMiyY/2A5+II250BXDnPTltSJgr3pU1/HNHClfEPQZ8a3Ga9nWGh2W770=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752873343; c=relaxed/simple;
	bh=NbteYGTUr8p4crj7zXJzi7/jhKZfMmpsq+U3RAZSWtE=;
	h=Date:To:From:Subject:Message-Id; b=ZjDyuUoB7kT7jpsxerKgdsl6VbcOrO6Oo8D7wH0oucnc3/gREcP2aQTxbvPLENtvB10LOhnFhAnlrOYmRzfiKmt4HjpQnqHrqv59IYrPQp3l1gqPtGWSTeuESrAFcCC81Cguqp8T/ylFLJTL1rjZnqrazQwgB+9Ym64lAA69QMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hrG2oegp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hrG2oegp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE27C4CEEB;
	Fri, 18 Jul 2025 21:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752873342;
	bh=NbteYGTUr8p4crj7zXJzi7/jhKZfMmpsq+U3RAZSWtE=;
	h=Date:To:From:Subject:From;
	b=hrG2oegphxMeCnLG6R9tFzIptR2Yu6TU7OAStboM4k3sFIHPjmRhOUQRwiUTMoEGQ
	 iA1Iczt7sSMIU77HCewZICMj9lgFZz1TYmz1/Ch1ELHTc6BM+UieIImBz6EvlcptkY
	 UnB4tPpxn8ZhNJ7EjWqHhowis0olg7Q1X8RRO7kc=
Date: Fri, 18 Jul 2025 14:15:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,liam.howlett@oracle.com,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-kfree_rcu-in-ma_free_rcu.patch added to mm-new branch
Message-Id: <20250718211542.ABE27C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use kfree_rcu in ma_free_rcu
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-use-kfree_rcu-in-ma_free_rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-kfree_rcu-in-ma_free_rcu.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

maple_tree-use-kfree_rcu-in-ma_free_rcu.patch
testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch

