From: akpm@linux-foundation.org
Subject: - netdev-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:25 -0700
Message-ID: <200804300547.m3U5lPKd029703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760491AbYD3GMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, jgarzik@pobox.com, mm-commits@vger.kernel.org


The patch titled
     netdev: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     netdev-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_main.c |    9 +--
 drivers/net/ibmveth.c           |    9 +--
 drivers/net/irda/vlsi_ir.c      |    5 -
 drivers/net/pppoe.c             |    4 -
 drivers/net/pppol2tp.c          |    4 -
 drivers/net/wireless/airo.c     |   84 +++++++++++-------------------
 6 files changed, 43 insertions(+), 72 deletions(-)

diff -puN drivers/net/bonding/bond_main.c~netdev-use-non-racy-method-for-proc-entries-creation drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~netdev-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/net/bonding/bond_main.c
@@ -3282,17 +3282,14 @@ static int bond_create_proc_entry(struct
 	struct net_device *bond_dev = bond->dev;
 
 	if (bond_proc_dir) {
-		bond->proc_entry = create_proc_entry(bond_dev->name,
-						     S_IRUGO,
-						     bond_proc_dir);
+		bond->proc_entry = proc_create_data(bond_dev->name,
+						    S_IRUGO, bond_proc_dir,
+						    &bond_info_fops, bond);
 		if (bond->proc_entry == NULL) {
 			printk(KERN_WARNING DRV_NAME
 			       ": Warning: Cannot create /proc/net/%s/%s\n",
 			       DRV_NAME, bond_dev->name);
 		} else {
-			bond->proc_entry->data = bond;
-			bond->proc_entry->proc_fops = &bond_info_fops;
-			bond->proc_entry->owner = THIS_MODULE;
 			memcpy(bond->proc_file_name, bond_dev->name, IFNAMSIZ);
 		}
 	}
diff -puN drivers/net/ibmveth.c~netdev-use-non-racy-method-for-proc-entries-creation drivers/net/ibmveth.c
--- a/drivers/net/ibmveth.c~netdev-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/net/ibmveth.c
@@ -1302,13 +1302,10 @@ static void ibmveth_proc_register_adapte
 	if (ibmveth_proc_dir) {
 		char u_addr[10];
 		sprintf(u_addr, "%x", adapter->vdev->unit_address);
-		entry = create_proc_entry(u_addr, S_IFREG, ibmveth_proc_dir);
-		if (!entry) {
+		entry = proc_create_data(u_addr, S_IFREG, ibmveth_proc_dir,
+					 &ibmveth_proc_fops, adapter);
+		if (!entry)
 			ibmveth_error_printk("Cannot create adapter proc entry");
-		} else {
-			entry->data = (void *) adapter;
-			entry->proc_fops = &ibmveth_proc_fops;
-		}
 	}
 	return;
 }
diff -puN drivers/net/irda/vlsi_ir.c~netdev-use-non-racy-method-for-proc-entries-creation drivers/net/irda/vlsi_ir.c
--- a/drivers/net/irda/vlsi_ir.c~netdev-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/net/irda/vlsi_ir.c
@@ -1674,13 +1674,12 @@ vlsi_irda_probe(struct pci_dev *pdev, co
 	if (vlsi_proc_root != NULL) {
 		struct proc_dir_entry *ent;
 
-		ent = create_proc_entry(ndev->name, S_IFREG|S_IRUGO, vlsi_proc_root);
+		ent = proc_create_data(ndev->name, S_IFREG|S_IRUGO,
+				       vlsi_proc_root, VLSI_PROC_FOPS, ndev);
 		if (!ent) {
 			IRDA_WARNING("%s: failed to create proc entry\n",
 				     __FUNCTION__);
 		} else {
-			ent->data = ndev;
-			ent->proc_fops = VLSI_PROC_FOPS;
 			ent->size = 0;
 		}
 		idev->proc_entry = ent;
diff -puN drivers/net/pppoe.c~netdev-use-non-racy-method-for-proc-entries-creation drivers/net/pppoe.c
--- a/drivers/net/pppoe.c~netdev-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/net/pppoe.c
@@ -1052,11 +1052,9 @@ static int __init pppoe_proc_init(void)
 {
 	struct proc_dir_entry *p;
 
-	p = create_proc_entry("pppoe", S_IRUGO, init_net.proc_net);
+	p = proc_net_fops_create(&init_net, "pppoe", S_IRUGO, &pppoe_seq_fops);
 	if (!p)
 		return -ENOMEM;
-
-	p->proc_fops = &pppoe_seq_fops;
 	return 0;
 }
 #else /* CONFIG_PROC_FS */
diff -puN drivers/net/pppol2tp.c~netdev-use-non-racy-method-for-proc-entries-creation drivers/net/pppol2tp.c
--- a/drivers/net/pppol2tp.c~netdev-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/net/pppol2tp.c
@@ -2469,12 +2469,12 @@ static int __init pppol2tp_init(void)
 		goto out_unregister_pppol2tp_proto;
 
 #ifdef CONFIG_PROC_FS
-	pppol2tp_proc = create_proc_entry("pppol2tp", 0, init_net.proc_net);
+	pppol2tp_proc = proc_net_fops_create(&init_net, "pppol2tp", 0,
+					     &pppol2tp_proc_fops);
 	if (!pppol2tp_proc) {
 		err = -ENOMEM;
 		goto out_unregister_pppox_proto;
 	}
-	pppol2tp_proc->proc_fops = &pppol2tp_proc_fops;
 #endif /* CONFIG_PROC_FS */
 	printk(KERN_INFO "PPPoL2TP kernel driver, %s\n",
 	       PPPOL2TP_DRV_VERSION);
diff -puN drivers/net/wireless/airo.c~netdev-use-non-racy-method-for-proc-entries-creation drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~netdev-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/net/wireless/airo.c
@@ -4347,24 +4347,28 @@ static int proc_config_open( struct inod
 static int proc_wepkey_open( struct inode *inode, struct file *file );
 
 static const struct file_operations proc_statsdelta_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_statsdelta_open,
 	.release	= proc_close
 };
 
 static const struct file_operations proc_stats_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_stats_open,
 	.release	= proc_close
 };
 
 static const struct file_operations proc_status_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_status_open,
 	.release	= proc_close
 };
 
 static const struct file_operations proc_SSID_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_SSID_open,
@@ -4372,6 +4376,7 @@ static const struct file_operations proc
 };
 
 static const struct file_operations proc_BSSList_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_BSSList_open,
@@ -4379,6 +4384,7 @@ static const struct file_operations proc
 };
 
 static const struct file_operations proc_APList_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_APList_open,
@@ -4386,6 +4392,7 @@ static const struct file_operations proc
 };
 
 static const struct file_operations proc_config_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_config_open,
@@ -4393,6 +4400,7 @@ static const struct file_operations proc
 };
 
 static const struct file_operations proc_wepkey_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_wepkey_open,
@@ -4411,10 +4419,6 @@ struct proc_data {
 	void (*on_close) (struct inode *, struct file *);
 };
 
-#ifndef SETPROC_OPS
-#define SETPROC_OPS(entry, ops) (entry)->proc_fops = &(ops)
-#endif
-
 static int setup_proc_entry( struct net_device *dev,
 			     struct airo_info *apriv ) {
 	struct proc_dir_entry *entry;
@@ -4430,100 +4434,76 @@ static int setup_proc_entry( struct net_
 	apriv->proc_entry->owner = THIS_MODULE;
 
 	/* Setup the StatsDelta */
-	entry = create_proc_entry("StatsDelta",
-				  S_IFREG | (S_IRUGO&proc_perm),
-				  apriv->proc_entry);
+	entry = proc_create_data("StatsDelta",
+				 S_IFREG | (S_IRUGO&proc_perm),
+				 apriv->proc_entry, &proc_statsdelta_ops, dev);
 	if (!entry)
 		goto fail_stats_delta;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_statsdelta_ops);
 
 	/* Setup the Stats */
-	entry = create_proc_entry("Stats",
-				  S_IFREG | (S_IRUGO&proc_perm),
-				  apriv->proc_entry);
+	entry = proc_create_data("Stats",
+				 S_IFREG | (S_IRUGO&proc_perm),
+				 apriv->proc_entry, &proc_stats_ops, dev);
 	if (!entry)
 		goto fail_stats;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_stats_ops);
 
 	/* Setup the Status */
-	entry = create_proc_entry("Status",
-				  S_IFREG | (S_IRUGO&proc_perm),
-				  apriv->proc_entry);
+	entry = proc_create_data("Status",
+				 S_IFREG | (S_IRUGO&proc_perm),
+				 apriv->proc_entry, &proc_status_ops, dev);
 	if (!entry)
 		goto fail_status;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_status_ops);
 
 	/* Setup the Config */
-	entry = create_proc_entry("Config",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("Config",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_config_ops, dev);
 	if (!entry)
 		goto fail_config;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_config_ops);
 
 	/* Setup the SSID */
-	entry = create_proc_entry("SSID",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("SSID",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_SSID_ops, dev);
 	if (!entry)
 		goto fail_ssid;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_SSID_ops);
 
 	/* Setup the APList */
-	entry = create_proc_entry("APList",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("APList",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_APList_ops, dev);
 	if (!entry)
 		goto fail_aplist;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_APList_ops);
 
 	/* Setup the BSSList */
-	entry = create_proc_entry("BSSList",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("BSSList",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_BSSList_ops, dev);
 	if (!entry)
 		goto fail_bsslist;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_BSSList_ops);
 
 	/* Setup the WepKey */
-	entry = create_proc_entry("WepKey",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("WepKey",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_wepkey_ops, dev);
 	if (!entry)
 		goto fail_wepkey;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_wepkey_ops);
 
 	return 0;
 
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch
net-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch
atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch
vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch
cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch
netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

