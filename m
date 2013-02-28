From: akpm@linux-foundation.org
Subject: [folded-merged] hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:49:47 -0800
Message-ID: <20130228004947.EB5B831C1CE@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:61613 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3B1Atu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:49:50 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so139774vea.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:49:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, sasha.levin@oracle.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch

This patch was dropped because it was folded into hlist-drop-the-node-parameter-from-iterators.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix

fix warnings

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c             |    5 ++---
 net/batman-adv/originator.c |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/cgroup.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix kernel/cgroup.c
--- a/kernel/cgroup.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix
+++ a/kernel/cgroup.c
@@ -1610,7 +1610,6 @@ static struct dentry *cgroup_mount(struc
 		struct cgroupfs_root *existing_root;
 		const struct cred *cred;
 		int i;
-		struct hlist_node *node;
 		struct css_set *cg;
 
 		BUG_ON(sb->s_root != NULL);
@@ -4492,7 +4491,7 @@ int __init_or_module cgroup_load_subsys(
 {
 	struct cgroup_subsys_state *css;
 	int i, ret;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	struct css_set *cg;
 	unsigned long key;
 
@@ -4570,7 +4569,7 @@ int __init_or_module cgroup_load_subsys(
 		cg->subsys[ss->subsys_id] = css;
 		/* recompute hash and restore entry */
 		key = css_set_hash(cg->subsys);
-		hash_add(css_set_table, node, key);
+		hash_add(css_set_table, &cg->hlist, key);
 	}
 	write_unlock(&css_set_lock);
 
diff -puN net/batman-adv/originator.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix net/batman-adv/originator.c
--- a/net/batman-adv/originator.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix
+++ a/net/batman-adv/originator.c
@@ -408,7 +408,6 @@ int batadv_orig_seq_print_text(struct se
 	struct net_device *net_dev = (struct net_device *)seq->private;
 	struct batadv_priv *bat_priv = netdev_priv(net_dev);
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	struct batadv_hard_iface *primary_if;
 	struct batadv_orig_node *orig_node;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc.patch
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

