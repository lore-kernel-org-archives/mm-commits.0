From: akpm@osdl.org
Subject: + mark-struct-file_operations-const-8.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:32:13 -0800
Message-ID: <200701231932.l0NJWDXJ028999@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50777 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132AbXAWTcS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct file_operations const 8
has been added to the -mm tree.  Its filename is
     mark-struct-file_operations-const-8.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct file_operations const 8
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct file_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/irda/ircomm/ircomm_core.c           |    2 +-
 net/irda/iriap.c                        |    2 +-
 net/irda/irlan/irlan_common.c           |    2 +-
 net/irda/irlap.c                        |    2 +-
 net/irda/irlmp.c                        |    2 +-
 net/irda/irttp.c                        |    2 +-
 net/llc/llc_proc.c                      |    4 ++--
 net/netfilter/nf_conntrack_expect.c     |    2 +-
 net/netfilter/nf_conntrack_standalone.c |    4 ++--
 net/netfilter/nf_log.c                  |    2 +-
 net/netfilter/nf_queue.c                |    2 +-
 net/netfilter/nfnetlink_log.c           |    2 +-
 net/netfilter/nfnetlink_queue.c         |    2 +-
 net/netfilter/x_tables.c                |    2 +-
 net/netfilter/xt_hashlimit.c            |    4 ++--
 net/netlink/af_netlink.c                |    2 +-
 net/netrom/af_netrom.c                  |    2 +-
 net/netrom/nr_route.c                   |    4 ++--
 net/packet/af_packet.c                  |    2 +-
 net/rose/af_rose.c                      |    2 +-
 net/rose/rose_route.c                   |    6 +++---
 net/rxrpc/proc.c                        |    8 ++++----
 net/sched/sch_api.c                     |    2 +-
 net/sctp/proc.c                         |    6 +++---
 net/socket.c                            |    2 +-
 net/sunrpc/cache.c                      |   12 ++++++------
 net/sunrpc/rpc_pipe.c                   |    4 ++--
 net/sunrpc/stats.c                      |    2 +-
 net/unix/af_unix.c                      |    2 +-
 net/wanrouter/wanproc.c                 |    6 +++---
 net/x25/x25_proc.c                      |    4 ++--
 31 files changed, 51 insertions(+), 51 deletions(-)

diff -puN net/irda/ircomm/ircomm_core.c~mark-struct-file_operations-const-8 net/irda/ircomm/ircomm_core.c
--- a/net/irda/ircomm/ircomm_core.c~mark-struct-file_operations-const-8
+++ a/net/irda/ircomm/ircomm_core.c
@@ -55,7 +55,7 @@ static void ircomm_control_indication(st
 extern struct proc_dir_entry *proc_irda;
 static int ircomm_seq_open(struct inode *, struct file *);
 
-static struct file_operations ircomm_proc_fops = {
+static const struct file_operations ircomm_proc_fops = {
 	.owner		= THIS_MODULE,
 	.open           = ircomm_seq_open,
 	.read           = seq_read,
diff -puN net/irda/iriap.c~mark-struct-file_operations-const-8 net/irda/iriap.c
--- a/net/irda/iriap.c~mark-struct-file_operations-const-8
+++ a/net/irda/iriap.c
@@ -1080,7 +1080,7 @@ static int irias_seq_open(struct inode *
 	return seq_open(file, &irias_seq_ops);
 }
 
-struct file_operations irias_seq_fops = {
+const struct file_operations irias_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open           = irias_seq_open,
 	.read           = seq_read,
diff -puN net/irda/irlan/irlan_common.c~mark-struct-file_operations-const-8 net/irda/irlan/irlan_common.c
--- a/net/irda/irlan/irlan_common.c~mark-struct-file_operations-const-8
+++ a/net/irda/irlan/irlan_common.c
@@ -93,7 +93,7 @@ extern struct proc_dir_entry *proc_irda;
 
 static int irlan_seq_open(struct inode *inode, struct file *file);
 
-static struct file_operations irlan_fops = {
+static const struct file_operations irlan_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = irlan_seq_open,
 	.read    = seq_read,
diff -puN net/irda/irlap.c~mark-struct-file_operations-const-8 net/irda/irlap.c
--- a/net/irda/irlap.c~mark-struct-file_operations-const-8
+++ a/net/irda/irlap.c
@@ -1244,7 +1244,7 @@ out_kfree:
 	goto out;
 }
 
-struct file_operations irlap_seq_fops = {
+const struct file_operations irlap_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open           = irlap_seq_open,
 	.read           = seq_read,
diff -puN net/irda/irlmp.c~mark-struct-file_operations-const-8 net/irda/irlmp.c
--- a/net/irda/irlmp.c~mark-struct-file_operations-const-8
+++ a/net/irda/irlmp.c
@@ -2026,7 +2026,7 @@ out_kfree:
 	goto out;
 }
 
-struct file_operations irlmp_seq_fops = {
+const struct file_operations irlmp_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open           = irlmp_seq_open,
 	.read           = seq_read,
diff -puN net/irda/irttp.c~mark-struct-file_operations-const-8 net/irda/irttp.c
--- a/net/irda/irttp.c~mark-struct-file_operations-const-8
+++ a/net/irda/irttp.c
@@ -1895,7 +1895,7 @@ out_kfree:
 	goto out;
 }
 
-struct file_operations irttp_seq_fops = {
+const struct file_operations irttp_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open           = irttp_seq_open,
 	.read           = seq_read,
diff -puN net/llc/llc_proc.c~mark-struct-file_operations-const-8 net/llc/llc_proc.c
--- a/net/llc/llc_proc.c~mark-struct-file_operations-const-8
+++ a/net/llc/llc_proc.c
@@ -208,7 +208,7 @@ static int llc_seq_core_open(struct inod
 	return seq_open(file, &llc_seq_core_ops);
 }
 
-static struct file_operations llc_seq_socket_fops = {
+static const struct file_operations llc_seq_socket_fops = {
 	.owner		= THIS_MODULE,
 	.open		= llc_seq_socket_open,
 	.read		= seq_read,
@@ -216,7 +216,7 @@ static struct file_operations llc_seq_so
 	.release	= seq_release,
 };
 
-static struct file_operations llc_seq_core_fops = {
+static const struct file_operations llc_seq_core_fops = {
 	.owner		= THIS_MODULE,
 	.open		= llc_seq_core_open,
 	.read		= seq_read,
diff -puN net/netfilter/nf_conntrack_expect.c~mark-struct-file_operations-const-8 net/netfilter/nf_conntrack_expect.c
--- a/net/netfilter/nf_conntrack_expect.c~mark-struct-file_operations-const-8
+++ a/net/netfilter/nf_conntrack_expect.c
@@ -435,7 +435,7 @@ static int exp_open(struct inode *inode,
 	return seq_open(file, &exp_seq_ops);
 }
 
-struct file_operations exp_file_ops = {
+const struct file_operations exp_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = exp_open,
 	.read    = seq_read,
diff -puN net/netfilter/nf_conntrack_standalone.c~mark-struct-file_operations-const-8 net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c~mark-struct-file_operations-const-8
+++ a/net/netfilter/nf_conntrack_standalone.c
@@ -229,7 +229,7 @@ out_free:
 	return ret;
 }
 
-static struct file_operations ct_file_ops = {
+static const struct file_operations ct_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = ct_open,
 	.read    = seq_read,
@@ -317,7 +317,7 @@ static int ct_cpu_seq_open(struct inode 
 	return seq_open(file, &ct_cpu_seq_ops);
 }
 
-static struct file_operations ct_cpu_seq_fops = {
+static const struct file_operations ct_cpu_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = ct_cpu_seq_open,
 	.read	 = seq_read,
diff -puN net/netfilter/nf_log.c~mark-struct-file_operations-const-8 net/netfilter/nf_log.c
--- a/net/netfilter/nf_log.c~mark-struct-file_operations-const-8
+++ a/net/netfilter/nf_log.c
@@ -151,7 +151,7 @@ static int nflog_open(struct inode *inod
 	return seq_open(file, &nflog_seq_ops);
 }
 
-static struct file_operations nflog_file_ops = {
+static const struct file_operations nflog_file_ops = {
 	.owner	 = THIS_MODULE,
 	.open	 = nflog_open,
 	.read	 = seq_read,
diff -puN net/netfilter/nf_queue.c~mark-struct-file_operations-const-8 net/netfilter/nf_queue.c
--- a/net/netfilter/nf_queue.c~mark-struct-file_operations-const-8
+++ a/net/netfilter/nf_queue.c
@@ -331,7 +331,7 @@ static int nfqueue_open(struct inode *in
 	return seq_open(file, &nfqueue_seq_ops);
 }
 
-static struct file_operations nfqueue_file_ops = {
+static const struct file_operations nfqueue_file_ops = {
 	.owner	 = THIS_MODULE,
 	.open	 = nfqueue_open,
 	.read	 = seq_read,
diff -puN net/netfilter/nfnetlink_log.c~mark-struct-file_operations-const-8 net/netfilter/nfnetlink_log.c
--- a/net/netfilter/nfnetlink_log.c~mark-struct-file_operations-const-8
+++ a/net/netfilter/nfnetlink_log.c
@@ -1025,7 +1025,7 @@ out_free:
 	return ret;
 }
 
-static struct file_operations nful_file_ops = {
+static const struct file_operations nful_file_ops = {
 	.owner	 = THIS_MODULE,
 	.open	 = nful_open,
 	.read	 = seq_read,
diff -puN net/netfilter/nfnetlink_queue.c~mark-struct-file_operations-const-8 net/netfilter/nfnetlink_queue.c
--- a/net/netfilter/nfnetlink_queue.c~mark-struct-file_operations-const-8
+++ a/net/netfilter/nfnetlink_queue.c
@@ -1077,7 +1077,7 @@ out_free:
 	return ret;
 }
 
-static struct file_operations nfqnl_file_ops = {
+static const struct file_operations nfqnl_file_ops = {
 	.owner	 = THIS_MODULE,
 	.open	 = nfqnl_open,
 	.read	 = seq_read,
diff -puN net/netfilter/x_tables.c~mark-struct-file_operations-const-8 net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~mark-struct-file_operations-const-8
+++ a/net/netfilter/x_tables.c
@@ -772,7 +772,7 @@ static int xt_tgt_open(struct inode *ino
 	return ret;
 }
 
-static struct file_operations xt_file_ops = {
+static const struct file_operations xt_file_ops = {
 	.owner	 = THIS_MODULE,
 	.open	 = xt_tgt_open,
 	.read	 = seq_read,
diff -puN net/netfilter/xt_hashlimit.c~mark-struct-file_operations-const-8 net/netfilter/xt_hashlimit.c
--- a/net/netfilter/xt_hashlimit.c~mark-struct-file_operations-const-8
+++ a/net/netfilter/xt_hashlimit.c
@@ -37,7 +37,7 @@ MODULE_ALIAS("ip6t_hashlimit");
 /* need to declare this at the top */
 static struct proc_dir_entry *hashlimit_procdir4;
 static struct proc_dir_entry *hashlimit_procdir6;
-static struct file_operations dl_file_ops;
+static const struct file_operations dl_file_ops;
 
 /* hash table crap */
 struct dsthash_dst {
@@ -713,7 +713,7 @@ static int dl_proc_open(struct inode *in
 	return ret;
 }
 
-static struct file_operations dl_file_ops = {
+static const struct file_operations dl_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = dl_proc_open,
 	.read    = seq_read,
diff -puN net/netlink/af_netlink.c~mark-struct-file_operations-const-8 net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~mark-struct-file_operations-const-8
+++ a/net/netlink/af_netlink.c
@@ -1713,7 +1713,7 @@ static int netlink_seq_open(struct inode
 	return 0;
 }
 
-static struct file_operations netlink_seq_fops = {
+static const struct file_operations netlink_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open		= netlink_seq_open,
 	.read		= seq_read,
diff -puN net/netrom/af_netrom.c~mark-struct-file_operations-const-8 net/netrom/af_netrom.c
--- a/net/netrom/af_netrom.c~mark-struct-file_operations-const-8
+++ a/net/netrom/af_netrom.c
@@ -1335,7 +1335,7 @@ static int nr_info_open(struct inode *in
 	return seq_open(file, &nr_info_seqops);
 }
  
-static struct file_operations nr_info_fops = {
+static const struct file_operations nr_info_fops = {
 	.owner = THIS_MODULE,
 	.open = nr_info_open,
 	.read = seq_read,
diff -puN net/netrom/nr_route.c~mark-struct-file_operations-const-8 net/netrom/nr_route.c
--- a/net/netrom/nr_route.c~mark-struct-file_operations-const-8
+++ a/net/netrom/nr_route.c
@@ -933,7 +933,7 @@ static int nr_node_info_open(struct inod
 	return seq_open(file, &nr_node_seqops);
 }
 
-struct file_operations nr_nodes_fops = {
+const struct file_operations nr_nodes_fops = {
 	.owner = THIS_MODULE,
 	.open = nr_node_info_open,
 	.read = seq_read,
@@ -1017,7 +1017,7 @@ static int nr_neigh_info_open(struct ino
 	return seq_open(file, &nr_neigh_seqops);
 }
 
-struct file_operations nr_neigh_fops = {
+const struct file_operations nr_neigh_fops = {
 	.owner = THIS_MODULE,
 	.open = nr_neigh_info_open,
 	.read = seq_read,
diff -puN net/packet/af_packet.c~mark-struct-file_operations-const-8 net/packet/af_packet.c
--- a/net/packet/af_packet.c~mark-struct-file_operations-const-8
+++ a/net/packet/af_packet.c
@@ -1898,7 +1898,7 @@ static int packet_seq_open(struct inode 
 	return seq_open(file, &packet_seq_ops);
 }
 
-static struct file_operations packet_seq_fops = {
+static const struct file_operations packet_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open		= packet_seq_open,
 	.read		= seq_read,
diff -puN net/rose/af_rose.c~mark-struct-file_operations-const-8 net/rose/af_rose.c
--- a/net/rose/af_rose.c~mark-struct-file_operations-const-8
+++ a/net/rose/af_rose.c
@@ -1440,7 +1440,7 @@ static int rose_info_open(struct inode *
 	return seq_open(file, &rose_info_seqops);
 }
 
-static struct file_operations rose_info_fops = {
+static const struct file_operations rose_info_fops = {
 	.owner = THIS_MODULE,
 	.open = rose_info_open,
 	.read = seq_read,
diff -puN net/rose/rose_route.c~mark-struct-file_operations-const-8 net/rose/rose_route.c
--- a/net/rose/rose_route.c~mark-struct-file_operations-const-8
+++ a/net/rose/rose_route.c
@@ -1128,7 +1128,7 @@ static int rose_nodes_open(struct inode 
 	return seq_open(file, &rose_node_seqops);
 }
 
-struct file_operations rose_nodes_fops = {
+const struct file_operations rose_nodes_fops = {
 	.owner = THIS_MODULE,
 	.open = rose_nodes_open,
 	.read = seq_read,
@@ -1210,7 +1210,7 @@ static int rose_neigh_open(struct inode 
 	return seq_open(file, &rose_neigh_seqops);
 }
 
-struct file_operations rose_neigh_fops = {
+const struct file_operations rose_neigh_fops = {
 	.owner = THIS_MODULE,
 	.open = rose_neigh_open,
 	.read = seq_read,
@@ -1294,7 +1294,7 @@ static int rose_route_open(struct inode 
 	return seq_open(file, &rose_route_seqops);
 }
 
-struct file_operations rose_routes_fops = {
+const struct file_operations rose_routes_fops = {
 	.owner = THIS_MODULE,
 	.open = rose_route_open,
 	.read = seq_read,
diff -puN net/rxrpc/proc.c~mark-struct-file_operations-const-8 net/rxrpc/proc.c
--- a/net/rxrpc/proc.c~mark-struct-file_operations-const-8
+++ a/net/rxrpc/proc.c
@@ -37,7 +37,7 @@ static struct seq_operations rxrpc_proc_
 	.show	= rxrpc_proc_transports_show,
 };
 
-static struct file_operations rxrpc_proc_transports_fops = {
+static const struct file_operations rxrpc_proc_transports_fops = {
 	.open		= rxrpc_proc_transports_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -57,7 +57,7 @@ static struct seq_operations rxrpc_proc_
 	.show	= rxrpc_proc_peers_show,
 };
 
-static struct file_operations rxrpc_proc_peers_fops = {
+static const struct file_operations rxrpc_proc_peers_fops = {
 	.open		= rxrpc_proc_peers_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -77,7 +77,7 @@ static struct seq_operations rxrpc_proc_
 	.show	= rxrpc_proc_conns_show,
 };
 
-static struct file_operations rxrpc_proc_conns_fops = {
+static const struct file_operations rxrpc_proc_conns_fops = {
 	.open		= rxrpc_proc_conns_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -97,7 +97,7 @@ static struct seq_operations rxrpc_proc_
 	.show	= rxrpc_proc_calls_show,
 };
 
-static struct file_operations rxrpc_proc_calls_fops = {
+static const struct file_operations rxrpc_proc_calls_fops = {
 	.open		= rxrpc_proc_calls_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN net/sched/sch_api.c~mark-struct-file_operations-const-8 net/sched/sch_api.c
--- a/net/sched/sch_api.c~mark-struct-file_operations-const-8
+++ a/net/sched/sch_api.c
@@ -1193,7 +1193,7 @@ static int psched_open(struct inode *ino
 	return single_open(file, psched_show, PDE(inode)->data);
 }
 
-static struct file_operations psched_fops = {
+static const struct file_operations psched_fops = {
 	.owner = THIS_MODULE,
 	.open = psched_open,
 	.read  = seq_read,
diff -puN net/sctp/proc.c~mark-struct-file_operations-const-8 net/sctp/proc.c
--- a/net/sctp/proc.c~mark-struct-file_operations-const-8
+++ a/net/sctp/proc.c
@@ -114,7 +114,7 @@ static int sctp_snmp_seq_open(struct ino
 	return single_open(file, sctp_snmp_seq_show, NULL);
 }
 
-static struct file_operations sctp_snmp_seq_fops = {
+static const struct file_operations sctp_snmp_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = sctp_snmp_seq_open,
 	.read	 = seq_read,
@@ -264,7 +264,7 @@ static int sctp_eps_seq_open(struct inod
 	return seq_open(file, &sctp_eps_ops);
 }
 
-static struct file_operations sctp_eps_seq_fops = {
+static const struct file_operations sctp_eps_seq_fops = {
 	.open	 = sctp_eps_seq_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
@@ -374,7 +374,7 @@ static int sctp_assocs_seq_open(struct i
 	return seq_open(file, &sctp_assoc_ops);
 }
 
-static struct file_operations sctp_assocs_seq_fops = {
+static const struct file_operations sctp_assocs_seq_fops = {
 	.open	 = sctp_assocs_seq_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
diff -puN net/socket.c~mark-struct-file_operations-const-8 net/socket.c
--- a/net/socket.c~mark-struct-file_operations-const-8
+++ a/net/socket.c
@@ -117,7 +117,7 @@ static ssize_t sock_sendpage(struct file
  *	in the operation structures but are done directly via the socketcall() multiplexor.
  */
 
-static struct file_operations socket_file_ops = {
+static const struct file_operations socket_file_ops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.aio_read =	sock_aio_read,
diff -puN net/sunrpc/cache.c~mark-struct-file_operations-const-8 net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~mark-struct-file_operations-const-8
+++ a/net/sunrpc/cache.c
@@ -282,9 +282,9 @@ static DEFINE_SPINLOCK(cache_list_lock);
 static struct cache_detail *current_detail;
 static int current_index;
 
-static struct file_operations cache_file_operations;
-static struct file_operations content_file_operations;
-static struct file_operations cache_flush_operations;
+static const struct file_operations cache_file_operations;
+static const struct file_operations content_file_operations;
+static const struct file_operations cache_flush_operations;
 
 static void do_cache_clean(struct work_struct *work);
 static DECLARE_DELAYED_WORK(cache_cleaner, do_cache_clean);
@@ -887,7 +887,7 @@ cache_release(struct inode *inode, struc
 
 
 
-static struct file_operations cache_file_operations = {
+static const struct file_operations cache_file_operations = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= cache_read,
@@ -1245,7 +1245,7 @@ static int content_release(struct inode 
 	return seq_release(inode, file);
 }
 
-static struct file_operations content_file_operations = {
+static const struct file_operations content_file_operations = {
 	.open		= content_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -1297,7 +1297,7 @@ static ssize_t write_flush(struct file *
 	return count;
 }
 
-static struct file_operations cache_flush_operations = {
+static const struct file_operations cache_flush_operations = {
 	.open		= nonseekable_open,
 	.read		= read_flush,
 	.write		= write_flush,
diff -puN net/sunrpc/rpc_pipe.c~mark-struct-file_operations-const-8 net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~mark-struct-file_operations-const-8
+++ a/net/sunrpc/rpc_pipe.c
@@ -309,7 +309,7 @@ rpc_pipe_ioctl(struct inode *ino, struct
 	}
 }
 
-static struct file_operations rpc_pipe_fops = {
+static const struct file_operations rpc_pipe_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= rpc_pipe_read,
@@ -366,7 +366,7 @@ rpc_info_release(struct inode *inode, st
 	return single_release(inode, file);
 }
 
-static struct file_operations rpc_info_operations = {
+static const struct file_operations rpc_info_operations = {
 	.owner		= THIS_MODULE,
 	.open		= rpc_info_open,
 	.read		= seq_read,
diff -puN net/sunrpc/stats.c~mark-struct-file_operations-const-8 net/sunrpc/stats.c
--- a/net/sunrpc/stats.c~mark-struct-file_operations-const-8
+++ a/net/sunrpc/stats.c
@@ -65,7 +65,7 @@ static int rpc_proc_open(struct inode *i
 	return single_open(file, rpc_proc_show, PDE(inode)->data);
 }
 
-static struct file_operations rpc_proc_fops = {
+static const struct file_operations rpc_proc_fops = {
 	.owner = THIS_MODULE,
 	.open = rpc_proc_open,
 	.read  = seq_read,
diff -puN net/unix/af_unix.c~mark-struct-file_operations-const-8 net/unix/af_unix.c
--- a/net/unix/af_unix.c~mark-struct-file_operations-const-8
+++ a/net/unix/af_unix.c
@@ -2040,7 +2040,7 @@ out_kfree:
 	goto out;
 }
 
-static struct file_operations unix_seq_fops = {
+static const struct file_operations unix_seq_fops = {
 	.owner		= THIS_MODULE,
 	.open		= unix_seq_open,
 	.read		= seq_read,
diff -puN net/wanrouter/wanproc.c~mark-struct-file_operations-const-8 net/wanrouter/wanproc.c
--- a/net/wanrouter/wanproc.c~mark-struct-file_operations-const-8
+++ a/net/wanrouter/wanproc.c
@@ -188,7 +188,7 @@ static int status_open(struct inode *ino
 	return seq_open(file, &status_op);
 }
 
-static struct file_operations config_fops = {
+static const struct file_operations config_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = config_open,
 	.read	 = seq_read,
@@ -196,7 +196,7 @@ static struct file_operations config_fop
 	.release = seq_release,
 };
 
-static struct file_operations status_fops = {
+static const struct file_operations status_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = status_open,
 	.read	 = seq_read,
@@ -271,7 +271,7 @@ static int wandev_open(struct inode *ino
 	return single_open(file, wandev_show, PDE(inode)->data);
 }
 
-static struct file_operations wandev_fops = {
+static const struct file_operations wandev_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = wandev_open,
 	.read	 = seq_read,
diff -puN net/x25/x25_proc.c~mark-struct-file_operations-const-8 net/x25/x25_proc.c
--- a/net/x25/x25_proc.c~mark-struct-file_operations-const-8
+++ a/net/x25/x25_proc.c
@@ -189,7 +189,7 @@ static int x25_seq_route_open(struct ino
 	return seq_open(file, &x25_seq_route_ops);
 }
 
-static struct file_operations x25_seq_socket_fops = {
+static const struct file_operations x25_seq_socket_fops = {
 	.owner		= THIS_MODULE,
 	.open		= x25_seq_socket_open,
 	.read		= seq_read,
@@ -197,7 +197,7 @@ static struct file_operations x25_seq_so
 	.release	= seq_release,
 };
 
-static struct file_operations x25_seq_route_fops = {
+static const struct file_operations x25_seq_route_fops = {
 	.owner		= THIS_MODULE,
 	.open		= x25_seq_route_open,
 	.read		= seq_read,
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
