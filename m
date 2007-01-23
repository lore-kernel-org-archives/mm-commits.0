From: akpm@osdl.org
Subject: + mark-struct-file_operations-const-1.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:31:57 -0800
Message-ID: <200701231931.l0NJVv0U028973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122AbXAWTcA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct file_operations const 1
has been added to the -mm tree.  Its filename is
     mark-struct-file_operations-const-1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct file_operations const 1
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct file_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/atalk.h                       |    2 +-
 include/linux/cpuset.h                      |    2 +-
 include/linux/random.h                      |    2 +-
 include/linux/security.h                    |    2 +-
 include/net/ax25.h                          |    4 ++--
 include/net/netfilter/nf_conntrack_expect.h |    2 +-
 include/net/netrom.h                        |    4 ++--
 include/net/rose.h                          |    6 +++---
 include/sound/pcm.h                         |    2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/atalk.h~mark-struct-file_operations-const-1 include/linux/atalk.h
--- a/include/linux/atalk.h~mark-struct-file_operations-const-1
+++ a/include/linux/atalk.h
@@ -182,7 +182,7 @@ extern rwlock_t atalk_interfaces_lock;
 
 extern struct atalk_route atrtr_default;
 
-extern struct file_operations atalk_seq_arp_fops;
+extern const struct file_operations atalk_seq_arp_fops;
 
 extern int sysctl_aarp_expiry_time;
 extern int sysctl_aarp_tick_time;
diff -puN include/linux/cpuset.h~mark-struct-file_operations-const-1 include/linux/cpuset.h
--- a/include/linux/cpuset.h~mark-struct-file_operations-const-1
+++ a/include/linux/cpuset.h
@@ -55,7 +55,7 @@ extern int cpuset_excl_nodes_overlap(con
 extern int cpuset_memory_pressure_enabled;
 extern void __cpuset_memory_pressure_bump(void);
 
-extern struct file_operations proc_cpuset_operations;
+extern const struct file_operations proc_cpuset_operations;
 extern char *cpuset_task_status_allowed(struct task_struct *task, char *buffer);
 
 extern void cpuset_lock(void);
diff -puN include/linux/random.h~mark-struct-file_operations-const-1 include/linux/random.h
--- a/include/linux/random.h~mark-struct-file_operations-const-1
+++ a/include/linux/random.h
@@ -63,7 +63,7 @@ extern u64 secure_dccp_sequence_number(_
 				       __be16 sport, __be16 dport);
 
 #ifndef MODULE
-extern struct file_operations random_fops, urandom_fops;
+extern const struct file_operations random_fops, urandom_fops;
 #endif
 
 unsigned int get_random_int(void);
diff -puN include/linux/security.h~mark-struct-file_operations-const-1 include/linux/security.h
--- a/include/linux/security.h~mark-struct-file_operations-const-1
+++ a/include/linux/security.h
@@ -2134,7 +2134,7 @@ extern int mod_reg_security	(const char 
 extern int mod_unreg_security	(const char *name, struct security_operations *ops);
 extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
 					     struct dentry *parent, void *data,
-					     struct file_operations *fops);
+					     const struct file_operations *fops);
 extern struct dentry *securityfs_create_dir(const char *name, struct dentry *parent);
 extern void securityfs_remove(struct dentry *dentry);
 
diff -puN include/net/ax25.h~mark-struct-file_operations-const-1 include/net/ax25.h
--- a/include/net/ax25.h~mark-struct-file_operations-const-1
+++ a/include/net/ax25.h
@@ -377,7 +377,7 @@ extern int  ax25_check_iframes_acked(ax2
 /* ax25_route.c */
 extern void ax25_rt_device_down(struct net_device *);
 extern int  ax25_rt_ioctl(unsigned int, void __user *);
-extern struct file_operations ax25_route_fops;
+extern const struct file_operations ax25_route_fops;
 extern ax25_route *ax25_get_route(ax25_address *addr, struct net_device *dev);
 extern int  ax25_rt_autobind(ax25_cb *, ax25_address *);
 extern struct sk_buff *ax25_rt_build_path(struct sk_buff *, ax25_address *, ax25_address *, ax25_digi *);
@@ -430,7 +430,7 @@ extern unsigned long ax25_display_timer(
 extern int  ax25_uid_policy;
 extern ax25_uid_assoc *ax25_findbyuid(uid_t);
 extern int __must_check ax25_uid_ioctl(int, struct sockaddr_ax25 *);
-extern struct file_operations ax25_uid_fops;
+extern const struct file_operations ax25_uid_fops;
 extern void ax25_uid_free(void);
 
 /* sysctl_net_ax25.c */
diff -puN include/net/netfilter/nf_conntrack_expect.h~mark-struct-file_operations-const-1 include/net/netfilter/nf_conntrack_expect.h
--- a/include/net/netfilter/nf_conntrack_expect.h~mark-struct-file_operations-const-1
+++ a/include/net/netfilter/nf_conntrack_expect.h
@@ -8,7 +8,7 @@
 
 extern struct list_head nf_conntrack_expect_list;
 extern struct kmem_cache *nf_conntrack_expect_cachep;
-extern struct file_operations exp_file_ops;
+extern const struct file_operations exp_file_ops;
 
 struct nf_conntrack_expect
 {
diff -puN include/net/netrom.h~mark-struct-file_operations-const-1 include/net/netrom.h
--- a/include/net/netrom.h~mark-struct-file_operations-const-1
+++ a/include/net/netrom.h
@@ -215,8 +215,8 @@ extern struct net_device *nr_dev_get(ax2
 extern int  nr_rt_ioctl(unsigned int, void __user *);
 extern void nr_link_failed(ax25_cb *, int);
 extern int  nr_route_frame(struct sk_buff *, ax25_cb *);
-extern struct file_operations nr_nodes_fops;
-extern struct file_operations nr_neigh_fops;
+extern const struct file_operations nr_nodes_fops;
+extern const struct file_operations nr_neigh_fops;
 extern void nr_rt_free(void);
 
 /* nr_subr.c */
diff -puN include/net/rose.h~mark-struct-file_operations-const-1 include/net/rose.h
--- a/include/net/rose.h~mark-struct-file_operations-const-1
+++ a/include/net/rose.h
@@ -189,9 +189,9 @@ extern void rose_enquiry_response(struct
 
 /* rose_route.c */
 extern struct rose_neigh rose_loopback_neigh;
-extern struct file_operations rose_neigh_fops;
-extern struct file_operations rose_nodes_fops;
-extern struct file_operations rose_routes_fops;
+extern const struct file_operations rose_neigh_fops;
+extern const struct file_operations rose_nodes_fops;
+extern const struct file_operations rose_routes_fops;
 
 extern void rose_add_loopback_neigh(void);
 extern int __must_check rose_add_loopback_node(rose_address *);
diff -puN include/sound/pcm.h~mark-struct-file_operations-const-1 include/sound/pcm.h
--- a/include/sound/pcm.h~mark-struct-file_operations-const-1
+++ a/include/sound/pcm.h
@@ -447,7 +447,7 @@ struct snd_pcm_notify {
  *  Registering
  */
 
-extern struct file_operations snd_pcm_f_ops[2];
+extern const struct file_operations snd_pcm_f_ops[2];
 
 int snd_pcm_new(struct snd_card *card, char *id, int device,
 		int playback_count, int capture_count,
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
