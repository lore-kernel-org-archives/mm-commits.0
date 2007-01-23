From: akpm@osdl.org
Subject: + mark-struct-file_operations-const-7.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:32:11 -0800
Message-ID: <200701231932.l0NJWBlu028995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120AbXAWTcR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct file_operations const 7
has been added to the -mm tree.  Its filename is
     mark-struct-file_operations-const-7.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct file_operations const 7
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct file_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 ipc/mqueue.c                                          |    4 +--
 ipc/shm.c                                             |    4 +--
 ipc/util.c                                            |    4 +--
 kernel/cpuset.c                                       |    2 -
 net/802/tr.c                                          |    2 -
 net/8021q/vlanproc.c                                  |    4 +--
 net/appletalk/aarp.c                                  |    2 -
 net/appletalk/atalk_proc.c                            |    6 ++---
 net/atm/br2684.c                                      |    2 -
 net/atm/clip.c                                        |    2 -
 net/atm/lec.c                                         |    2 -
 net/atm/mpoa_proc.c                                   |    2 -
 net/atm/proc.c                                        |   12 +++++-----
 net/ax25/af_ax25.c                                    |    2 -
 net/ax25/ax25_route.c                                 |    2 -
 net/ax25/ax25_uid.c                                   |    2 -
 net/core/dev.c                                        |    4 +--
 net/core/dev_mcast.c                                  |    2 -
 net/core/neighbour.c                                  |    4 +--
 net/core/pktgen.c                                     |    6 ++---
 net/core/sock.c                                       |    2 -
 net/core/wireless.c                                   |    2 -
 net/dccp/probe.c                                      |    2 -
 net/decnet/af_decnet.c                                |    2 -
 net/decnet/dn_dev.c                                   |    2 -
 net/decnet/dn_neigh.c                                 |    2 -
 net/decnet/dn_route.c                                 |    2 -
 net/ipv4/arp.c                                        |    2 -
 net/ipv4/fib_hash.c                                   |    2 -
 net/ipv4/fib_trie.c                                   |    6 ++---
 net/ipv4/igmp.c                                       |    4 +--
 net/ipv4/ipconfig.c                                   |    2 -
 net/ipv4/ipmr.c                                       |    4 +--
 net/ipv4/ipvs/ip_vs_app.c                             |    2 -
 net/ipv4/ipvs/ip_vs_conn.c                            |    2 -
 net/ipv4/ipvs/ip_vs_ctl.c                             |    4 +--
 net/ipv4/netfilter/ip_conntrack_standalone.c          |    6 ++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c                    |    4 +--
 net/ipv4/netfilter/ipt_recent.c                       |    4 +--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |    6 ++---
 net/ipv4/proc.c                                       |    6 ++---
 net/ipv4/raw.c                                        |    2 -
 net/ipv4/route.c                                      |    4 +--
 net/ipv4/tcp_probe.c                                  |    2 -
 net/ipv6/addrconf.c                                   |    2 -
 net/ipv6/anycast.c                                    |    2 -
 net/ipv6/ip6_flowlabel.c                              |    2 -
 net/ipv6/mcast.c                                      |    4 +--
 net/ipv6/proc.c                                       |    4 +--
 net/ipv6/raw.c                                        |    2 -
 net/ipv6/route.c                                      |    2 -
 net/ipx/ipx_proc.c                                    |    6 ++---
 net/irda/discovery.c                                  |    2 -
 53 files changed, 86 insertions(+), 86 deletions(-)

diff -puN ipc/mqueue.c~mark-struct-file_operations-const-7 ipc/mqueue.c
--- a/ipc/mqueue.c~mark-struct-file_operations-const-7
+++ a/ipc/mqueue.c
@@ -85,7 +85,7 @@ struct mqueue_inode_info {
 };
 
 static struct inode_operations mqueue_dir_inode_operations;
-static struct file_operations mqueue_file_operations;
+static const struct file_operations mqueue_file_operations;
 static struct super_operations mqueue_super_ops;
 static void remove_notification(struct mqueue_inode_info *info);
 
@@ -1166,7 +1166,7 @@ static struct inode_operations mqueue_di
 	.unlink = mqueue_unlink,
 };
 
-static struct file_operations mqueue_file_operations = {
+static const struct file_operations mqueue_file_operations = {
 	.flush = mqueue_flush_file,
 	.poll = mqueue_poll_file,
 	.read = mqueue_read_file,
diff -puN ipc/shm.c~mark-struct-file_operations-const-7 ipc/shm.c
--- a/ipc/shm.c~mark-struct-file_operations-const-7
+++ a/ipc/shm.c
@@ -42,7 +42,7 @@
 
 #include "util.h"
 
-static struct file_operations shm_file_operations;
+static const struct file_operations shm_file_operations;
 static struct vm_operations_struct shm_vm_ops;
 
 static struct ipc_ids init_shm_ids;
@@ -249,7 +249,7 @@ static int shm_release(struct inode *ino
 	return 0;
 }
 
-static struct file_operations shm_file_operations = {
+static const struct file_operations shm_file_operations = {
 	.mmap		= shm_mmap,
 	.release	= shm_release,
 #ifndef CONFIG_MMU
diff -puN ipc/util.c~mark-struct-file_operations-const-7 ipc/util.c
--- a/ipc/util.c~mark-struct-file_operations-const-7
+++ a/ipc/util.c
@@ -205,7 +205,7 @@ void __ipc_init ipc_init_ids(struct ipc_
 }
 
 #ifdef CONFIG_PROC_FS
-static struct file_operations sysvipc_proc_fops;
+static const struct file_operations sysvipc_proc_fops;
 /**
  *	ipc_init_proc_interface	-  Create a proc interface for sysipc types using a seq_file interface.
  *	@path: Path in procfs
@@ -847,7 +847,7 @@ static int sysvipc_proc_open(struct inod
 	return ret;
 }
 
-static struct file_operations sysvipc_proc_fops = {
+static const struct file_operations sysvipc_proc_fops = {
 	.open    = sysvipc_proc_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
diff -puN kernel/cpuset.c~mark-struct-file_operations-const-7 kernel/cpuset.c
--- a/kernel/cpuset.c~mark-struct-file_operations-const-7
+++ a/kernel/cpuset.c
@@ -2576,7 +2576,7 @@ static int cpuset_open(struct inode *ino
 	return single_open(file, proc_cpuset_show, pid);
 }
 
-struct file_operations proc_cpuset_operations = {
+const struct file_operations proc_cpuset_operations = {
 	.open		= cpuset_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN net/802/tr.c~mark-struct-file_operations-const-7 net/802/tr.c
--- a/net/802/tr.c~mark-struct-file_operations-const-7
+++ a/net/802/tr.c
@@ -576,7 +576,7 @@ static int rif_seq_open(struct inode *in
 	return seq_open(file, &rif_seq_ops);
 }
 
-static struct file_operations rif_seq_fops = {
+static const struct file_operations rif_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = rif_seq_open,
 	.read    = seq_read,
diff -puN net/8021q/vlanproc.c~mark-struct-file_operations-const-7 net/8021q/vlanproc.c
--- a/net/8021q/vlanproc.c~mark-struct-file_operations-const-7
+++ a/net/8021q/vlanproc.c
@@ -81,7 +81,7 @@ static int vlan_seq_open(struct inode *i
 	return seq_open(file, &vlan_seq_ops);
 }
 
-static struct file_operations vlan_fops = {
+static const struct file_operations vlan_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = vlan_seq_open,
 	.read    = seq_read,
@@ -98,7 +98,7 @@ static int vlandev_seq_open(struct inode
 	return single_open(file, vlandev_seq_show, PDE(inode)->data);
 }
 
-static struct file_operations vlandev_fops = {
+static const struct file_operations vlandev_fops = {
 	.owner = THIS_MODULE,
 	.open    = vlandev_seq_open,
 	.read    = seq_read,
diff -puN net/appletalk/aarp.c~mark-struct-file_operations-const-7 net/appletalk/aarp.c
--- a/net/appletalk/aarp.c~mark-struct-file_operations-const-7
+++ a/net/appletalk/aarp.c
@@ -1048,7 +1048,7 @@ out_kfree:
 	goto out;
 }
 
-struct file_operations atalk_seq_arp_fops = {
+const struct file_operations atalk_seq_arp_fops = {
 	.owner		= THIS_MODULE,
 	.open           = aarp_seq_open,
 	.read           = seq_read,
diff -puN net/appletalk/atalk_proc.c~mark-struct-file_operations-const-7 net/appletalk/atalk_proc.c
--- a/net/appletalk/atalk_proc.c~mark-struct-file_operations-const-7
+++ a/net/appletalk/atalk_proc.c
@@ -240,7 +240,7 @@ static int atalk_seq_socket_open(struct 
 	return seq_open(file, &atalk_seq_socket_ops);
 }
 
-static struct file_operations atalk_seq_interface_fops = {
+static const struct file_operations atalk_seq_interface_fops = {
 	.owner		= THIS_MODULE,
 	.open		= atalk_seq_interface_open,
 	.read		= seq_read,
@@ -248,7 +248,7 @@ static struct file_operations atalk_seq_
 	.release	= seq_release,
 };
 
-static struct file_operations atalk_seq_route_fops = {
+static const struct file_operations atalk_seq_route_fops = {
 	.owner		= THIS_MODULE,
 	.open		= atalk_seq_route_open,
 	.read		= seq_read,
@@ -256,7 +256,7 @@ static struct file_operations atalk_seq_
 	.release	= seq_release,
 };
 
-static struct file_operations atalk_seq_socket_fops = {
+static const struct file_operations atalk_seq_socket_fops = {
 	.owner		= THIS_MODULE,
 	.open		= atalk_seq_socket_open,
 	.read		= seq_read,
diff -puN net/atm/br2684.c~mark-struct-file_operations-const-7 net/atm/br2684.c
--- a/net/atm/br2684.c~mark-struct-file_operations-const-7
+++ a/net/atm/br2684.c
@@ -784,7 +784,7 @@ static int br2684_proc_open(struct inode
 	return seq_open(file, &br2684_seq_ops);
 }
 
-static struct file_operations br2684_proc_ops = {
+static const struct file_operations br2684_proc_ops = {
 	.owner   = THIS_MODULE,
 	.open    = br2684_proc_open,
 	.read    = seq_read,
diff -puN net/atm/clip.c~mark-struct-file_operations-const-7 net/atm/clip.c
--- a/net/atm/clip.c~mark-struct-file_operations-const-7
+++ a/net/atm/clip.c
@@ -971,7 +971,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations arp_seq_fops = {
+static const struct file_operations arp_seq_fops = {
 	.open		= arp_seq_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN net/atm/lec.c~mark-struct-file_operations-const-7 net/atm/lec.c
--- a/net/atm/lec.c~mark-struct-file_operations-const-7
+++ a/net/atm/lec.c
@@ -1212,7 +1212,7 @@ static int lec_seq_release(struct inode 
 	return seq_release_private(inode, file);
 }
 
-static struct file_operations lec_seq_fops = {
+static const struct file_operations lec_seq_fops = {
 	.owner = THIS_MODULE,
 	.open = lec_seq_open,
 	.read = seq_read,
diff -puN net/atm/mpoa_proc.c~mark-struct-file_operations-const-7 net/atm/mpoa_proc.c
--- a/net/atm/mpoa_proc.c~mark-struct-file_operations-const-7
+++ a/net/atm/mpoa_proc.c
@@ -39,7 +39,7 @@ static int parse_qos(const char *buff);
 /*
  *   Define allowed FILE OPERATIONS
  */
-static struct file_operations mpc_file_operations = {
+static const struct file_operations mpc_file_operations = {
 	.owner =	THIS_MODULE,
 	.open =		proc_mpc_open,
 	.read =		seq_read,
diff -puN net/atm/proc.c~mark-struct-file_operations-const-7 net/atm/proc.c
--- a/net/atm/proc.c~mark-struct-file_operations-const-7
+++ a/net/atm/proc.c
@@ -33,7 +33,7 @@
 static ssize_t proc_dev_atm_read(struct file *file,char __user *buf,size_t count,
     loff_t *pos);
 
-static struct file_operations proc_atm_dev_ops = {
+static const struct file_operations proc_atm_dev_ops = {
 	.owner =	THIS_MODULE,
 	.read =		proc_dev_atm_read,
 };
@@ -272,7 +272,7 @@ static int atm_dev_seq_open(struct inode
 	return seq_open(file, &atm_dev_seq_ops);
 }
  
-static struct file_operations devices_seq_fops = {
+static const struct file_operations devices_seq_fops = {
 	.open		= atm_dev_seq_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -307,7 +307,7 @@ static int pvc_seq_open(struct inode *in
 	return __vcc_seq_open(inode, file, PF_ATMPVC, &pvc_seq_ops);
 }
 
-static struct file_operations pvc_seq_fops = {
+static const struct file_operations pvc_seq_fops = {
 	.open		= pvc_seq_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -341,7 +341,7 @@ static int vcc_seq_open(struct inode *in
  	return __vcc_seq_open(inode, file, 0, &vcc_seq_ops);
 }
  
-static struct file_operations vcc_seq_fops = {
+static const struct file_operations vcc_seq_fops = {
 	.open		= vcc_seq_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -376,7 +376,7 @@ static int svc_seq_open(struct inode *in
 	return __vcc_seq_open(inode, file, PF_ATMSVC, &svc_seq_ops);
 }
 
-static struct file_operations svc_seq_fops = {
+static const struct file_operations svc_seq_fops = {
 	.open		= svc_seq_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -457,7 +457,7 @@ void atm_proc_dev_deregister(struct atm_
 
 static struct atm_proc_entry {
 	char *name;
-	struct file_operations *proc_fops;
+	const struct file_operations *proc_fops;
 	struct proc_dir_entry *dirent;
 } atm_proc_ents[] = {
 	{ .name = "devices",	.proc_fops = &devices_seq_fops },
diff -puN net/ax25/af_ax25.c~mark-struct-file_operations-const-7 net/ax25/af_ax25.c
--- a/net/ax25/af_ax25.c~mark-struct-file_operations-const-7
+++ a/net/ax25/af_ax25.c
@@ -1938,7 +1938,7 @@ static int ax25_info_open(struct inode *
 	return seq_open(file, &ax25_info_seqops);
 }
 
-static struct file_operations ax25_info_fops = {
+static const struct file_operations ax25_info_fops = {
 	.owner = THIS_MODULE,
 	.open = ax25_info_open,
 	.read = seq_read,
diff -puN net/ax25/ax25_route.c~mark-struct-file_operations-const-7 net/ax25/ax25_route.c
--- a/net/ax25/ax25_route.c~mark-struct-file_operations-const-7
+++ a/net/ax25/ax25_route.c
@@ -332,7 +332,7 @@ static int ax25_rt_info_open(struct inod
 	return seq_open(file, &ax25_rt_seqops);
 }
 
-struct file_operations ax25_route_fops = {
+const struct file_operations ax25_route_fops = {
 	.owner = THIS_MODULE,
 	.open = ax25_rt_info_open,
 	.read = seq_read,
diff -puN net/ax25/ax25_uid.c~mark-struct-file_operations-const-7 net/ax25/ax25_uid.c
--- a/net/ax25/ax25_uid.c~mark-struct-file_operations-const-7
+++ a/net/ax25/ax25_uid.c
@@ -197,7 +197,7 @@ static int ax25_uid_info_open(struct ino
 	return seq_open(file, &ax25_uid_seqops);
 }
 
-struct file_operations ax25_uid_fops = {
+const struct file_operations ax25_uid_fops = {
 	.owner = THIS_MODULE,
 	.open = ax25_uid_info_open,
 	.read = seq_read,
diff -puN net/core/dev.c~mark-struct-file_operations-const-7 net/core/dev.c
--- a/net/core/dev.c~mark-struct-file_operations-const-7
+++ a/net/core/dev.c
@@ -2200,7 +2200,7 @@ static int dev_seq_open(struct inode *in
 	return seq_open(file, &dev_seq_ops);
 }
 
-static struct file_operations dev_seq_fops = {
+static const struct file_operations dev_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = dev_seq_open,
 	.read    = seq_read,
@@ -2220,7 +2220,7 @@ static int softnet_seq_open(struct inode
 	return seq_open(file, &softnet_seq_ops);
 }
 
-static struct file_operations softnet_seq_fops = {
+static const struct file_operations softnet_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = softnet_seq_open,
 	.read    = seq_read,
diff -puN net/core/dev_mcast.c~mark-struct-file_operations-const-7 net/core/dev_mcast.c
--- a/net/core/dev_mcast.c~mark-struct-file_operations-const-7
+++ a/net/core/dev_mcast.c
@@ -276,7 +276,7 @@ static int dev_mc_seq_open(struct inode 
 	return seq_open(file, &dev_mc_seq_ops);
 }
 
-static struct file_operations dev_mc_seq_fops = {
+static const struct file_operations dev_mc_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = dev_mc_seq_open,
 	.read    = seq_read,
diff -puN net/core/neighbour.c~mark-struct-file_operations-const-7 net/core/neighbour.c
--- a/net/core/neighbour.c~mark-struct-file_operations-const-7
+++ a/net/core/neighbour.c
@@ -62,7 +62,7 @@ void neigh_changeaddr(struct neigh_table
 
 static struct neigh_table *neigh_tables;
 #ifdef CONFIG_PROC_FS
-static struct file_operations neigh_stat_seq_fops;
+static const struct file_operations neigh_stat_seq_fops;
 #endif
 
 /*
@@ -2399,7 +2399,7 @@ static int neigh_stat_seq_open(struct in
 	return ret;
 };
 
-static struct file_operations neigh_stat_seq_fops = {
+static const struct file_operations neigh_stat_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open 	 = neigh_stat_seq_open,
 	.read	 = seq_read,
diff -puN net/core/pktgen.c~mark-struct-file_operations-const-7 net/core/pktgen.c
--- a/net/core/pktgen.c~mark-struct-file_operations-const-7
+++ a/net/core/pktgen.c
@@ -579,7 +579,7 @@ static int pgctrl_open(struct inode *ino
 	return single_open(file, pgctrl_show, PDE(inode)->data);
 }
 
-static struct file_operations pktgen_fops = {
+static const struct file_operations pktgen_fops = {
 	.owner   = THIS_MODULE,
 	.open    = pgctrl_open,
 	.read    = seq_read,
@@ -1672,7 +1672,7 @@ static int pktgen_if_open(struct inode *
 	return single_open(file, pktgen_if_show, PDE(inode)->data);
 }
 
-static struct file_operations pktgen_if_fops = {
+static const struct file_operations pktgen_if_fops = {
 	.owner   = THIS_MODULE,
 	.open    = pktgen_if_open,
 	.read    = seq_read,
@@ -1815,7 +1815,7 @@ static int pktgen_thread_open(struct ino
 	return single_open(file, pktgen_thread_show, PDE(inode)->data);
 }
 
-static struct file_operations pktgen_thread_fops = {
+static const struct file_operations pktgen_thread_fops = {
 	.owner   = THIS_MODULE,
 	.open    = pktgen_thread_open,
 	.read    = seq_read,
diff -puN net/core/sock.c~mark-struct-file_operations-const-7 net/core/sock.c
--- a/net/core/sock.c~mark-struct-file_operations-const-7
+++ a/net/core/sock.c
@@ -1911,7 +1911,7 @@ static int proto_seq_open(struct inode *
 	return seq_open(file, &proto_seq_ops);
 }
 
-static struct file_operations proto_seq_fops = {
+static const struct file_operations proto_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open		= proto_seq_open,
 	.read		= seq_read,
diff -puN net/core/wireless.c~mark-struct-file_operations-const-7 net/core/wireless.c
--- a/net/core/wireless.c~mark-struct-file_operations-const-7
+++ a/net/core/wireless.c
@@ -674,7 +674,7 @@ static int wireless_seq_open(struct inod
 	return seq_open(file, &wireless_seq_ops);
 }
 
-static struct file_operations wireless_seq_fops = {
+static const struct file_operations wireless_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = wireless_seq_open,
 	.read    = seq_read,
diff -puN net/dccp/probe.c~mark-struct-file_operations-const-7 net/dccp/probe.c
--- a/net/dccp/probe.c~mark-struct-file_operations-const-7
+++ a/net/dccp/probe.c
@@ -149,7 +149,7 @@ out_free:
 	return error ? error : cnt;
 }
 
-static struct file_operations dccpprobe_fops = {
+static const struct file_operations dccpprobe_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = dccpprobe_open,
 	.read    = dccpprobe_read,
diff -puN net/decnet/af_decnet.c~mark-struct-file_operations-const-7 net/decnet/af_decnet.c
--- a/net/decnet/af_decnet.c~mark-struct-file_operations-const-7
+++ a/net/decnet/af_decnet.c
@@ -2331,7 +2331,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations dn_socket_seq_fops = {
+static const struct file_operations dn_socket_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open		= dn_socket_seq_open,
 	.read		= seq_read,
diff -puN net/decnet/dn_dev.c~mark-struct-file_operations-const-7 net/decnet/dn_dev.c
--- a/net/decnet/dn_dev.c~mark-struct-file_operations-const-7
+++ a/net/decnet/dn_dev.c
@@ -1431,7 +1431,7 @@ static int dn_dev_seq_open(struct inode 
 	return seq_open(file, &dn_dev_seq_ops);
 }
 
-static struct file_operations dn_dev_seq_fops = {
+static const struct file_operations dn_dev_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = dn_dev_seq_open,
 	.read	 = seq_read,
diff -puN net/decnet/dn_neigh.c~mark-struct-file_operations-const-7 net/decnet/dn_neigh.c
--- a/net/decnet/dn_neigh.c~mark-struct-file_operations-const-7
+++ a/net/decnet/dn_neigh.c
@@ -598,7 +598,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations dn_neigh_seq_fops = {
+static const struct file_operations dn_neigh_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open		= dn_neigh_seq_open,
 	.read		= seq_read,
diff -puN net/decnet/dn_route.c~mark-struct-file_operations-const-7 net/decnet/dn_route.c
--- a/net/decnet/dn_route.c~mark-struct-file_operations-const-7
+++ a/net/decnet/dn_route.c
@@ -1751,7 +1751,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations dn_rt_cache_seq_fops = {
+static const struct file_operations dn_rt_cache_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = dn_rt_cache_seq_open,
 	.read	 = seq_read,
diff -puN net/ipv4/arp.c~mark-struct-file_operations-const-7 net/ipv4/arp.c
--- a/net/ipv4/arp.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/arp.c
@@ -1389,7 +1389,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations arp_seq_fops = {
+static const struct file_operations arp_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open           = arp_seq_open,
 	.read           = seq_read,
diff -puN net/ipv4/fib_hash.c~mark-struct-file_operations-const-7 net/ipv4/fib_hash.c
--- a/net/ipv4/fib_hash.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/fib_hash.c
@@ -1056,7 +1056,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations fib_seq_fops = {
+static const struct file_operations fib_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open           = fib_seq_open,
 	.read           = seq_read,
diff -puN net/ipv4/fib_trie.c~mark-struct-file_operations-const-7 net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/fib_trie.c
@@ -2161,7 +2161,7 @@ static int fib_triestat_seq_open(struct 
 	return single_open(file, fib_triestat_seq_show, NULL);
 }
 
-static struct file_operations fib_triestat_fops = {
+static const struct file_operations fib_triestat_fops = {
 	.owner	= THIS_MODULE,
 	.open	= fib_triestat_seq_open,
 	.read	= seq_read,
@@ -2351,7 +2351,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations fib_trie_fops = {
+static const struct file_operations fib_trie_fops = {
 	.owner  = THIS_MODULE,
 	.open   = fib_trie_seq_open,
 	.read   = seq_read,
@@ -2472,7 +2472,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations fib_route_fops = {
+static const struct file_operations fib_route_fops = {
 	.owner  = THIS_MODULE,
 	.open   = fib_route_seq_open,
 	.read   = seq_read,
diff -puN net/ipv4/igmp.c~mark-struct-file_operations-const-7 net/ipv4/igmp.c
--- a/net/ipv4/igmp.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/igmp.c
@@ -2401,7 +2401,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations igmp_mc_seq_fops = {
+static const struct file_operations igmp_mc_seq_fops = {
 	.owner		=	THIS_MODULE,
 	.open		=	igmp_mc_seq_open,
 	.read		=	seq_read,
@@ -2575,7 +2575,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations igmp_mcf_seq_fops = {
+static const struct file_operations igmp_mcf_seq_fops = {
 	.owner		=	THIS_MODULE,
 	.open		=	igmp_mcf_seq_open,
 	.read		=	seq_read,
diff -puN net/ipv4/ipconfig.c~mark-struct-file_operations-const-7 net/ipv4/ipconfig.c
--- a/net/ipv4/ipconfig.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/ipconfig.c
@@ -1200,7 +1200,7 @@ static int pnp_seq_open(struct inode *in
 	return single_open(file, pnp_seq_show, NULL);
 }
 
-static struct file_operations pnp_seq_fops = {
+static const struct file_operations pnp_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open		= pnp_seq_open,
 	.read		= seq_read,
diff -puN net/ipv4/ipmr.c~mark-struct-file_operations-const-7 net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/ipmr.c
@@ -1711,7 +1711,7 @@ out_kfree:
 
 }
 
-static struct file_operations ipmr_vif_fops = {
+static const struct file_operations ipmr_vif_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = ipmr_vif_open,
 	.read    = seq_read,
@@ -1873,7 +1873,7 @@ out_kfree:
 
 }
 
-static struct file_operations ipmr_mfc_fops = {
+static const struct file_operations ipmr_mfc_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = ipmr_mfc_open,
 	.read    = seq_read,
diff -puN net/ipv4/ipvs/ip_vs_app.c~mark-struct-file_operations-const-7 net/ipv4/ipvs/ip_vs_app.c
--- a/net/ipv4/ipvs/ip_vs_app.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/ipvs/ip_vs_app.c
@@ -561,7 +561,7 @@ static int ip_vs_app_open(struct inode *
 	return seq_open(file, &ip_vs_app_seq_ops);
 }
 
-static struct file_operations ip_vs_app_fops = {
+static const struct file_operations ip_vs_app_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = ip_vs_app_open,
 	.read	 = seq_read,
diff -puN net/ipv4/ipvs/ip_vs_conn.c~mark-struct-file_operations-const-7 net/ipv4/ipvs/ip_vs_conn.c
--- a/net/ipv4/ipvs/ip_vs_conn.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/ipvs/ip_vs_conn.c
@@ -757,7 +757,7 @@ static int ip_vs_conn_open(struct inode 
 	return seq_open(file, &ip_vs_conn_seq_ops);
 }
 
-static struct file_operations ip_vs_conn_fops = {
+static const struct file_operations ip_vs_conn_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = ip_vs_conn_open,
 	.read    = seq_read,
diff -puN net/ipv4/ipvs/ip_vs_ctl.c~mark-struct-file_operations-const-7 net/ipv4/ipvs/ip_vs_ctl.c
--- a/net/ipv4/ipvs/ip_vs_ctl.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/ipvs/ip_vs_ctl.c
@@ -1812,7 +1812,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations ip_vs_info_fops = {
+static const struct file_operations ip_vs_info_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = ip_vs_info_open,
 	.read    = seq_read,
@@ -1859,7 +1859,7 @@ static int ip_vs_stats_seq_open(struct i
 	return single_open(file, ip_vs_stats_show, NULL);
 }
 
-static struct file_operations ip_vs_stats_fops = {
+static const struct file_operations ip_vs_stats_fops = {
 	.owner = THIS_MODULE,
 	.open = ip_vs_stats_seq_open,
 	.read = seq_read,
diff -puN net/ipv4/netfilter/ip_conntrack_standalone.c~mark-struct-file_operations-const-7 net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -222,7 +222,7 @@ out_free:
 	return ret;
 }
 
-static struct file_operations ct_file_ops = {
+static const struct file_operations ct_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = ct_open,
 	.read    = seq_read,
@@ -298,7 +298,7 @@ static int exp_open(struct inode *inode,
 	return seq_open(file, &exp_seq_ops);
 }
   
-static struct file_operations exp_file_ops = {
+static const struct file_operations exp_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = exp_open,
 	.read    = seq_read,
@@ -386,7 +386,7 @@ static int ct_cpu_seq_open(struct inode 
 	return seq_open(file, &ct_cpu_seq_ops);
 }
 
-static struct file_operations ct_cpu_seq_fops = {
+static const struct file_operations ct_cpu_seq_fops = {
 	.owner   = THIS_MODULE,
 	.open    = ct_cpu_seq_open,
 	.read    = seq_read,
diff -puN net/ipv4/netfilter/ipt_CLUSTERIP.c~mark-struct-file_operations-const-7 net/ipv4/netfilter/ipt_CLUSTERIP.c
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -69,7 +69,7 @@ static LIST_HEAD(clusterip_configs);
 static DEFINE_RWLOCK(clusterip_lock);
 
 #ifdef CONFIG_PROC_FS
-static struct file_operations clusterip_proc_fops;
+static const struct file_operations clusterip_proc_fops;
 static struct proc_dir_entry *clusterip_procdir;
 #endif
 
@@ -712,7 +712,7 @@ static ssize_t clusterip_proc_write(stru
 	return size;
 }
 
-static struct file_operations clusterip_proc_fops = {
+static const struct file_operations clusterip_proc_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = clusterip_proc_open,
 	.read	 = seq_read,
diff -puN net/ipv4/netfilter/ipt_recent.c~mark-struct-file_operations-const-7 net/ipv4/netfilter/ipt_recent.c
--- a/net/ipv4/netfilter/ipt_recent.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/netfilter/ipt_recent.c
@@ -78,7 +78,7 @@ static DEFINE_MUTEX(recent_mutex);
 
 #ifdef CONFIG_PROC_FS
 static struct proc_dir_entry	*proc_dir;
-static struct file_operations	recent_fops;
+static const struct file_operations	recent_fops;
 #endif
 
 static u_int32_t hash_rnd;
@@ -453,7 +453,7 @@ static ssize_t recent_proc_write(struct 
 	return size;
 }
 
-static struct file_operations recent_fops = {
+static const struct file_operations recent_fops = {
 	.open		= recent_seq_open,
 	.read		= seq_read,
 	.write		= recent_proc_write,
diff -puN net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c~mark-struct-file_operations-const-7 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -197,7 +197,7 @@ out_free:
 	return ret;
 }
 
-static struct file_operations ct_file_ops = {
+static const struct file_operations ct_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = ct_open,
 	.read    = seq_read,
@@ -278,7 +278,7 @@ static int exp_open(struct inode *inode,
 	return seq_open(file, &exp_seq_ops);
 }
 
-static struct file_operations ip_exp_file_ops = {
+static const struct file_operations ip_exp_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = exp_open,
 	.read    = seq_read,
@@ -366,7 +366,7 @@ static int ct_cpu_seq_open(struct inode 
 	return seq_open(file, &ct_cpu_seq_ops);
 }
 
-static struct file_operations ct_cpu_seq_fops = {
+static const struct file_operations ct_cpu_seq_fops = {
 	.owner   = THIS_MODULE,
 	.open    = ct_cpu_seq_open,
 	.read    = seq_read,
diff -puN net/ipv4/proc.c~mark-struct-file_operations-const-7 net/ipv4/proc.c
--- a/net/ipv4/proc.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/proc.c
@@ -79,7 +79,7 @@ static int sockstat_seq_open(struct inod
 	return single_open(file, sockstat_seq_show, NULL);
 }
 
-static struct file_operations sockstat_seq_fops = {
+static const struct file_operations sockstat_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = sockstat_seq_open,
 	.read	 = seq_read,
@@ -326,7 +326,7 @@ static int snmp_seq_open(struct inode *i
 	return single_open(file, snmp_seq_show, NULL);
 }
 
-static struct file_operations snmp_seq_fops = {
+static const struct file_operations snmp_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = snmp_seq_open,
 	.read	 = seq_read,
@@ -360,7 +360,7 @@ static int netstat_seq_open(struct inode
 	return single_open(file, netstat_seq_show, NULL);
 }
 
-static struct file_operations netstat_seq_fops = {
+static const struct file_operations netstat_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = netstat_seq_open,
 	.read	 = seq_read,
diff -puN net/ipv4/raw.c~mark-struct-file_operations-const-7 net/ipv4/raw.c
--- a/net/ipv4/raw.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/raw.c
@@ -916,7 +916,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations raw_seq_fops = {
+static const struct file_operations raw_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = raw_seq_open,
 	.read	 = seq_read,
diff -puN net/ipv4/route.c~mark-struct-file_operations-const-7 net/ipv4/route.c
--- a/net/ipv4/route.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/route.c
@@ -392,7 +392,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations rt_cache_seq_fops = {
+static const struct file_operations rt_cache_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = rt_cache_seq_open,
 	.read	 = seq_read,
@@ -483,7 +483,7 @@ static int rt_cpu_seq_open(struct inode 
 	return seq_open(file, &rt_cpu_seq_ops);
 }
 
-static struct file_operations rt_cpu_seq_fops = {
+static const struct file_operations rt_cpu_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = rt_cpu_seq_open,
 	.read	 = seq_read,
diff -puN net/ipv4/tcp_probe.c~mark-struct-file_operations-const-7 net/ipv4/tcp_probe.c
--- a/net/ipv4/tcp_probe.c~mark-struct-file_operations-const-7
+++ a/net/ipv4/tcp_probe.c
@@ -143,7 +143,7 @@ out_free:
 	return error ? error : cnt;
 }
 
-static struct file_operations tcpprobe_fops = {
+static const struct file_operations tcpprobe_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = tcpprobe_open,
 	.read    = tcpprobe_read,
diff -puN net/ipv6/addrconf.c~mark-struct-file_operations-const-7 net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~mark-struct-file_operations-const-7
+++ a/net/ipv6/addrconf.c
@@ -2775,7 +2775,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations if6_fops = {
+static const struct file_operations if6_fops = {
 	.owner		= THIS_MODULE,
 	.open		= if6_seq_open,
 	.read		= seq_read,
diff -puN net/ipv6/anycast.c~mark-struct-file_operations-const-7 net/ipv6/anycast.c
--- a/net/ipv6/anycast.c~mark-struct-file_operations-const-7
+++ a/net/ipv6/anycast.c
@@ -564,7 +564,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations ac6_seq_fops = {
+static const struct file_operations ac6_seq_fops = {
 	.owner		=	THIS_MODULE,
 	.open		=	ac6_seq_open,
 	.read		=	seq_read,
diff -puN net/ipv6/ip6_flowlabel.c~mark-struct-file_operations-const-7 net/ipv6/ip6_flowlabel.c
--- a/net/ipv6/ip6_flowlabel.c~mark-struct-file_operations-const-7
+++ a/net/ipv6/ip6_flowlabel.c
@@ -677,7 +677,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations ip6fl_seq_fops = {
+static const struct file_operations ip6fl_seq_fops = {
 	.owner		=	THIS_MODULE,
 	.open		=	ip6fl_seq_open,
 	.read		=	seq_read,
diff -puN net/ipv6/mcast.c~mark-struct-file_operations-const-7 net/ipv6/mcast.c
--- a/net/ipv6/mcast.c~mark-struct-file_operations-const-7
+++ a/net/ipv6/mcast.c
@@ -2449,7 +2449,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations igmp6_mc_seq_fops = {
+static const struct file_operations igmp6_mc_seq_fops = {
 	.owner		=	THIS_MODULE,
 	.open		=	igmp6_mc_seq_open,
 	.read		=	seq_read,
@@ -2623,7 +2623,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations igmp6_mcf_seq_fops = {
+static const struct file_operations igmp6_mcf_seq_fops = {
 	.owner		=	THIS_MODULE,
 	.open		=	igmp6_mcf_seq_open,
 	.read		=	seq_read,
diff -puN net/ipv6/proc.c~mark-struct-file_operations-const-7 net/ipv6/proc.c
--- a/net/ipv6/proc.c~mark-struct-file_operations-const-7
+++ a/net/ipv6/proc.c
@@ -186,7 +186,7 @@ static int sockstat6_seq_open(struct ino
 	return single_open(file, sockstat6_seq_show, NULL);
 }
 
-static struct file_operations sockstat6_seq_fops = {
+static const struct file_operations sockstat6_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = sockstat6_seq_open,
 	.read	 = seq_read,
@@ -199,7 +199,7 @@ static int snmp6_seq_open(struct inode *
 	return single_open(file, snmp6_seq_show, PDE(inode)->data);
 }
 
-static struct file_operations snmp6_seq_fops = {
+static const struct file_operations snmp6_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = snmp6_seq_open,
 	.read	 = seq_read,
diff -puN net/ipv6/raw.c~mark-struct-file_operations-const-7 net/ipv6/raw.c
--- a/net/ipv6/raw.c~mark-struct-file_operations-const-7
+++ a/net/ipv6/raw.c
@@ -1263,7 +1263,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations raw6_seq_fops = {
+static const struct file_operations raw6_seq_fops = {
 	.owner =	THIS_MODULE,
 	.open =		raw6_seq_open,
 	.read =		seq_read,
diff -puN net/ipv6/route.c~mark-struct-file_operations-const-7 net/ipv6/route.c
--- a/net/ipv6/route.c~mark-struct-file_operations-const-7
+++ a/net/ipv6/route.c
@@ -2331,7 +2331,7 @@ static int rt6_stats_seq_open(struct ino
 	return single_open(file, rt6_stats_seq_show, NULL);
 }
 
-static struct file_operations rt6_stats_seq_fops = {
+static const struct file_operations rt6_stats_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = rt6_stats_seq_open,
 	.read	 = seq_read,
diff -puN net/ipx/ipx_proc.c~mark-struct-file_operations-const-7 net/ipx/ipx_proc.c
--- a/net/ipx/ipx_proc.c~mark-struct-file_operations-const-7
+++ a/net/ipx/ipx_proc.c
@@ -322,7 +322,7 @@ static int ipx_seq_socket_open(struct in
 	return seq_open(file, &ipx_seq_socket_ops);
 }
 
-static struct file_operations ipx_seq_interface_fops = {
+static const struct file_operations ipx_seq_interface_fops = {
 	.owner		= THIS_MODULE,
 	.open           = ipx_seq_interface_open,
 	.read           = seq_read,
@@ -330,7 +330,7 @@ static struct file_operations ipx_seq_in
 	.release        = seq_release,
 };
 
-static struct file_operations ipx_seq_route_fops = {
+static const struct file_operations ipx_seq_route_fops = {
 	.owner		= THIS_MODULE,
 	.open           = ipx_seq_route_open,
 	.read           = seq_read,
@@ -338,7 +338,7 @@ static struct file_operations ipx_seq_ro
 	.release        = seq_release,
 };
 
-static struct file_operations ipx_seq_socket_fops = {
+static const struct file_operations ipx_seq_socket_fops = {
 	.owner		= THIS_MODULE,
 	.open           = ipx_seq_socket_open,
 	.read           = seq_read,
diff -puN net/irda/discovery.c~mark-struct-file_operations-const-7 net/irda/discovery.c
--- a/net/irda/discovery.c~mark-struct-file_operations-const-7
+++ a/net/irda/discovery.c
@@ -409,7 +409,7 @@ static int discovery_seq_open(struct ino
 	return seq_open(file, &discovery_seq_ops);
 }
 
-struct file_operations discovery_seq_fops = {
+const struct file_operations discovery_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open           = discovery_seq_open,
 	.read           = seq_read,
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
