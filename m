From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent-v2.patch removed from -mm tree
Date: Wed, 15 Nov 2017 16:49:24 -0800
Message-ID: <5a0ce094.tHiIosUyBmjgjUM0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753402AbdKPAt0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:49:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent-v2.patch

This patch was dropped because it was folded into ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent.patch

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent-v2

Link: http://lkml.kernel.org/r/59EEAA69.9080703@huawei.com
Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/nodemanager.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/ocfs2/cluster/nodemanager.c~ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent-v2 fs/ocfs2/cluster/nodemanager.c
--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent-v2
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -39,6 +39,7 @@ char *o2nm_fence_method_desc[O2NM_FENCE_
 		"reset",	/* O2NM_FENCE_RESET */
 		"panic",	/* O2NM_FENCE_PANIC */
 };
+
 static inline void o2nm_lock_subsystem(void);
 static inline void o2nm_unlock_subsystem(void);
 
@@ -218,6 +219,7 @@ static ssize_t o2nm_node_num_store(struc
 	if (!test_bit(O2NM_NODE_ATTR_ADDRESS, &node->nd_set_attributes) ||
 	    !test_bit(O2NM_NODE_ATTR_PORT, &node->nd_set_attributes))
 		return -EINVAL; /* XXX */
+
 	o2nm_lock_subsystem();
 	cluster = to_o2nm_cluster_from_node(node);
 	if (!cluster) {
@@ -238,6 +240,7 @@ static ssize_t o2nm_node_num_store(struc
 	}
 	write_unlock(&cluster->cl_nodes_lock);
 	o2nm_unlock_subsystem();
+
 	if (ret)
 		return ret;
 
@@ -297,12 +300,14 @@ static ssize_t o2nm_node_ipv4_address_st
 			return -ERANGE;
 		be32_add_cpu(&ipv4_addr, octets[i] << (i * 8));
 	}
+
 	o2nm_lock_subsystem();
 	cluster = to_o2nm_cluster_from_node(node);
 	if (!cluster) {
 		o2nm_unlock_subsystem();
 		return -EINVAL;
 	}
+
 	ret = 0;
 	write_lock(&cluster->cl_nodes_lock);
 	if (o2nm_node_ip_tree_lookup(cluster, ipv4_addr, &p, &parent))
@@ -316,6 +321,7 @@ static ssize_t o2nm_node_ipv4_address_st
 	}
 	write_unlock(&cluster->cl_nodes_lock);
 	o2nm_unlock_subsystem();
+
 	if (ret)
 		return ret;
 
@@ -357,6 +363,7 @@ static ssize_t o2nm_node_local_store(str
 		ret = -EINVAL;
 		goto out;
 	}
+
 	/* the only failure case is trying to set a new local node
 	 * when a different one is already set */
 	if (tmp && tmp == cluster->cl_has_local &&
@@ -364,6 +371,7 @@ static ssize_t o2nm_node_local_store(str
 		ret = -EBUSY;
 		goto out;
 	}
+
 	/* bring up the rx thread if we're setting the new local node. */
 	if (tmp && !cluster->cl_has_local) {
 		ret = o2net_start_listening(node);
@@ -382,6 +390,7 @@ static ssize_t o2nm_node_local_store(str
 		cluster->cl_has_local = tmp;
 		cluster->cl_local_node = node->nd_num;
 	}
+
 	ret = count;
 
 out:
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr.patch
ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block.patch
ocfs2-subsystemsu_mutex-is-required-while-accessing-the-item-ci_parent.patch

