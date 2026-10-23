Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792772494;
	b=QvCt68U/3yzKWCQFfRUMICKTiP9jJy2UBrH0F1mf63Wvcy96cpnCoc6fz/D8QCxyxhRd
	 MlakFwhGM8crQEKtuasHIGAJXXbZkuEkFZlBEYSyVIWrTiekpmrzBQ+13AtJsqIT6jI7y
	 KL4Kb9ar4GS3j6hcffEVMfjiLOU/2m5UAKVGa5s32DdhxlpR8mNYPvgAlroUT98j6tzt7
	 0AjvxPHRpxoAZSHwXwkoQlQ5lLBK7ONkeGXLx9u9nE9ATsR+8zLHBzqIg2wMR/ntIc2O/
	 dVeeU5XTQ+U8su0XkdHPEX5i0Ee/B3VB1/yfW4VlhcBDfW33hnkiLdwOcI6u1pGJiUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792772494;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gf/7iou61FmGymvRsPLyDqQnM2BemOpHHtmTu2Du/nM=;
	b=ggmT/ztV/N+t7+FWnQVon90zR1CGTOQUty5mxR15Ck1274HlX9XXqqtU8+Y0zL1pKJKC
	 aBECoZM1rakfo/AvGzxV1fdk+tAf5v0sidiT+KLs9DmEoCWU/5sV0wnINbdORTBliGgEQ
	 LrKergG2rBbAnzrqZlJdg35RfXWYRUGMjSVEe62gMH+H8/x4wCG5iVtxd3KqgizQqWtcO
	 rM0qEbqR7GTg4Ip2rn9LE3ZYTJAoKQkodRceUNbndAPXkDrt/XlmHzRBorf/gVoL+hr9w
	 zLq4dpclyr83FGDrxmalE7O8S/InpTw4cSUoZAP6u7Kw/uDvToAPKoCkbeVBJulS2uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Yp6miC9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D72F606A31E;
	Fri, 23 Oct 2026 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Yp6miC9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028C01F01825;
	Fri, 23 Oct 2026 16:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792772493;
	bh=gf/7iou61FmGymvRsPLyDqQnM2BemOpHHtmTu2Du/nM=;
	h=Date:To:From:Subject;
	b=Yp6miC9m4FJ5BYQFPP12hM6kjaH3O72cI7yCZjC9yQbEiLlQ75NIfzhg+TpJuH/mH
	 uMxDL9rROmKJCdfIh8um0fLc52tmOTmrqkiy+OoYFLGzHZv+1z3JWNqHP1CkKwj5lh
	 XPufAw+hfxaw7uxTz6kwhwBKQs4z40MrT+42MTpw=
Date: Fri, 23 Oct 2026 09:21:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch added to mm-nonmm-unstable branch
Message-Id: <20261023162133.028C01F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2/cluster: remove zero-address nodes from IP tree on teardown
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ocfs2-drain-quorum-work-before-removing-the-cluster.patch
ocfs2-dlm-drain-join-handlers-before-releasing-module-text.patch
ocfs2-snapshot-dentry-names-in-file-and-setattr-traces.patch
ocfs2-snapshot-the-dentry-name-while-tracing-file-release.patch
ocfs2-cluster-remove-zero-address-nodes-from-ip-tree-on-teardown.patch

