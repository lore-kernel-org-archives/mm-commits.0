Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828042;
	b=BW0rImqaaCWyM87QW9UxNwiODrEtLtffGLySI1+oSQyFQBSRBpk7dxlYsg+7HsQlkbHF
	 WErxBeyVkhofBBo0pJdWBSvx494zO3NTcT41kMDapND7QgnXUN2H4mwK3fh9M+wRq8VZi
	 GUEwAQsgzz/DxHzWu/UcvWmou+FEm3oWOmH6xKiSDmJUbX4ULp9LpXmnQT+FGZ901oWFP
	 9+PWfzCp7paflIbrogD1OnvOaBs99RnM5WGok9vm4rve6U2A+r1PMTAefcVF+h28WEmiN
	 xNshdz2uZ4UR/mc12eTUT2wAY/mOycnh0hTst+vCAI2NrkD6TxVpL7P6L8QOeTLh71g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828042;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mn1BEchkJGdoCaKOLA4w6fiYmN3/C8fFfsm6HF47veY=;
	b=TMVjf2SWikeWmiMx61lhRBIa55fcOl1rCG85SfQYNJWnsHtvz+0NKPeQ7ku4nLEafcZm
	 pKsTeR1+oewuSs3MwXKm3PVN+ZVJ8dUkoib1Ojbmu2SLwRt24+CBYg/nH6/PvQa/3TPXU
	 ILoEMXZFFHg2w/TuXcc3mfkyUHAV1rAuale/ewY0k9B0Py+dzrPhV2ueqj0bOkoRCzauc
	 z0q8NHes08PjvyqzxYsynvfGE/HbeZeuCRM/c6J/cwMPEBGMFvxG/FzpMpPKMcCSZ8hQu
	 V3ZZkzoqamwBJ7tyqL0UJ8MbvsYCC59Dt35vPYenOFXytXyqotmGkwefopzSsHmtDZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OVFiBFFX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E993606A321;
	Sat, 24 Oct 2026 07:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OVFiBFFX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBD01F01825;
	Sat, 24 Oct 2026 07:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828041;
	bh=mn1BEchkJGdoCaKOLA4w6fiYmN3/C8fFfsm6HF47veY=;
	h=Date:To:From:Subject;
	b=OVFiBFFXB1G9qKWFcPlmVZsAGF9WBrOcWQdSAQRXcN2FulBMGWdGp2EkdjeVHQEur
	 YNtMMvi4R8PdZfWiKBwm2A7m8xlh9T1Qb+m6puKu0A2eih9N7I6I2FRW1aenUAKipP
	 53k/GoVSUmlyGEDk31f3YzDnWo6t/kFgS7lgxkvo=
Date: Sat, 24 Oct 2026 00:47:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch removed from -mm tree
Message-Id: <20261024074721.BEBD01F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2/cluster: remove zero-address nodes from IP tree on teardown
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2/cluster: remove zero-address nodes from IP tree on teardown
Date: Tue, 20 Oct 2026 21:12:50 +0800

o2nm_node_ipv4_address_store() accepts 0.0.0.0. It sets
O2NM_NODE_ATTR_ADDRESS and links nd_ip_node into cl_node_ip_tree under
cl_nodes_lock, but o2nm_node_group_drop_item() uses nd_ipv4_address as a
membership test. A zero address therefore leaves the rbtree node linked
when config_item_put() releases and frees struct o2nm_node. A later
address store or IP lookup can then walk the stale node and dereference
freed memory.

During teardown, drop_item takes cl_nodes_lock, skips rb_erase()
for the zero key, and then calls config_item_put(). A later
o2nm_node_ipv4_address_store() duplicate check or o2nm_get_node_by_ip()
lookup takes the same lock and walks the stale cl_node_ip_tree entry. Use
O2NM_NODE_ATTR_ADDRESS for teardown so every published nd_ip_node is
erased before configfs can release the node, without rejecting 0.0.0.0
or changing lookup semantics.

Link: https://lore.kernel.org/pm-ocfs2-node-ip-rbtree-zero-address-uaf-v5-e7f64be16b7c3b0988d1@gmail.com
Fixes: 0c83ed8eeb28 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/cluster/nodemanager.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -627,8 +627,11 @@ static void o2nm_node_group_drop_item(st
 
 	write_lock(&cluster->cl_nodes_lock);
 
-	/* XXX sloppy */
-	if (node->nd_ipv4_address)
+	/*
+	 * 0.0.0.0 is a valid configured address, so nd_ipv4_address does
+	 * not tell us whether nd_ip_node was published in the IP tree.
+	 */
+	if (test_bit(O2NM_NODE_ATTR_ADDRESS, &node->nd_set_attributes))
 		rb_erase(&node->nd_ip_node, &cluster->cl_node_ip_tree);
 
 	/* nd_num might be 0 if the node number hasn't been set.. */
_

Patches currently in -mm which might be from zzzccc427@gmail.com are


