Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147561FB8
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vP9xq2JV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D41C433C9;
	Mon, 11 Dec 2023 00:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256037;
	bh=8U+8gb1tmUhocXkAAxQX/jR2ODxv373IUyV4tirx+cQ=;
	h=Date:To:From:Subject:From;
	b=vP9xq2JVWMaeAGn736NgEtDYM8GaBpClsnYX6OF+WoLjJhtmnRHMJJXYnN8QNUqqu
	 amtEkpXhQqlx9utmDtyuq8bY8E3wlS2qRoQkgBWc6UVWw1Saoh9oDFyhmMaPa21d7l
	 0M71DUZCzXchyqUUb/Tufw5yqLP33ZXjf3wKwuvM=
Date: Sun, 10 Dec 2023 16:53:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,peterz@infradead.org,npiggin@gmail.com,mst@redhat.com,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,Liam.Howlett@oracle.com,corbet@lwn.net,brauner@kernel.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree.patch removed from -mm tree
Message-Id: <20231211005357.D2D41C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: preserve the tree attributes when destroying maple tree
has been removed from the -mm tree.  Its filename was
     maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: preserve the tree attributes when destroying maple tree
Date: Fri, 27 Oct 2023 11:38:44 +0800

When destroying maple tree, preserve its attributes and then turn it into
an empty tree.  This allows it to be reused without needing to be
reinitialized.

Link: https://lkml.kernel.org/r/20231027033845.90608-10-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree
+++ a/lib/maple_tree.c
@@ -6763,7 +6763,7 @@ void __mt_destroy(struct maple_tree *mt)
 	if (xa_is_node(root))
 		mte_destroy_walk(root, mt);
 
-	mt->ma_flags = 0;
+	mt->ma_flags = mt_attr(mt);
 }
 EXPORT_SYMBOL_GPL(__mt_destroy);
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch
maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum.patch
maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch
maple_tree-delete-one-of-the-two-identical-checks.patch
maple_tree-simplify-mas_leaf_set_meta.patch

