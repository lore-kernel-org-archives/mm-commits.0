From: akpm@linux-foundation.org
Subject: + net-possible-cleanups.patch added to -mm tree
Date: Fri, 06 Apr 2007 15:45:15 -0700
Message-ID: <200704062245.l36MjFZI021160@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36483 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933279AbXDFWs3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 18:48:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     net/: possible cleanups
has been added to the -mm tree.  Its filename is
     net-possible-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net/: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

- make the following needlessly global variables static:
  - core/rtnetlink.c: struct rtnl_msg_handlers[]
  - netfilter/nf_conntrack_proto.c: struct nf_ct_protos[]
- make the following needlessly global functions static:
  - core/rtnetlink.c: rtnl_dump_all()
  - netlink/af_netlink.c: netlink_queue_skip()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/netfilter/nf_conntrack_l4proto.h |    1 -
 include/net/netlink.h                        |    2 --
 include/net/rtnetlink.h                      |    1 -
 net/core/rtnetlink.c                         |    6 ++----
 net/netfilter/nf_conntrack_proto.c           |    2 +-
 net/netlink/af_netlink.c                     |    4 ++--
 6 files changed, 5 insertions(+), 11 deletions(-)

diff -puN include/net/netfilter/nf_conntrack_l4proto.h~net-possible-cleanups include/net/netfilter/nf_conntrack_l4proto.h
--- a/include/net/netfilter/nf_conntrack_l4proto.h~net-possible-cleanups
+++ a/include/net/netfilter/nf_conntrack_l4proto.h
@@ -97,7 +97,6 @@ extern struct nf_conntrack_l4proto nf_co
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
 #define MAX_NF_CT_PROTO 256
-extern struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX];
 
 extern struct nf_conntrack_l4proto *
 __nf_ct_l4proto_find(u_int16_t l3proto, u_int8_t l4proto);
diff -puN include/net/netlink.h~net-possible-cleanups include/net/netlink.h
--- a/include/net/netlink.h~net-possible-cleanups
+++ a/include/net/netlink.h
@@ -217,8 +217,6 @@ struct nl_info {
 extern void		netlink_run_queue(struct sock *sk, unsigned int *qlen,
 					  int (*cb)(struct sk_buff *,
 						    struct nlmsghdr *));
-extern void		netlink_queue_skip(struct nlmsghdr *nlh,
-					   struct sk_buff *skb);
 extern int		nlmsg_notify(struct sock *sk, struct sk_buff *skb,
 				     u32 pid, unsigned int group, int report,
 				     gfp_t flags);
diff -puN include/net/rtnetlink.h~net-possible-cleanups include/net/rtnetlink.h
--- a/include/net/rtnetlink.h~net-possible-cleanups
+++ a/include/net/rtnetlink.h
@@ -13,7 +13,6 @@ extern void	rtnl_register(int protocol, 
 			      rtnl_doit_func, rtnl_dumpit_func);
 extern int	rtnl_unregister(int protocol, int msgtype);
 extern void	rtnl_unregister_all(int protocol);
-extern int	rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb);
 
 static inline int rtnl_msg_family(struct nlmsghdr *nlh)
 {
diff -puN net/core/rtnetlink.c~net-possible-cleanups net/core/rtnetlink.c
--- a/net/core/rtnetlink.c~net-possible-cleanups
+++ a/net/core/rtnetlink.c
@@ -101,7 +101,7 @@ int rtattr_parse(struct rtattr *tb[], in
 	return 0;
 }
 
-struct rtnl_link *rtnl_msg_handlers[NPROTO];
+static struct rtnl_link *rtnl_msg_handlers[NPROTO];
 
 static inline int rtm_msgindex(int msgtype)
 {
@@ -798,7 +798,7 @@ errout:
 	return err;
 }
 
-int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
+static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	int idx;
 	int s_idx = cb->family;
@@ -822,8 +822,6 @@ int rtnl_dump_all(struct sk_buff *skb, s
 	return skb->len;
 }
 
-EXPORT_SYMBOL_GPL(rtnl_dump_all);
-
 void rtmsg_ifinfo(int type, struct net_device *dev, unsigned change)
 {
 	struct sk_buff *skb;
diff -puN net/netfilter/nf_conntrack_proto.c~net-possible-cleanups net/netfilter/nf_conntrack_proto.c
--- a/net/netfilter/nf_conntrack_proto.c~net-possible-cleanups
+++ a/net/netfilter/nf_conntrack_proto.c
@@ -28,7 +28,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX] __read_mostly;
+static struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX] __read_mostly;
 struct nf_conntrack_l3proto *nf_ct_l3protos[AF_MAX] __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_l3protos);
 
diff -puN net/netlink/af_netlink.c~net-possible-cleanups net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~net-possible-cleanups
+++ a/net/netlink/af_netlink.c
@@ -118,6 +118,7 @@ static DECLARE_WAIT_QUEUE_HEAD(nl_table_
 
 static int netlink_dump(struct sock *sk);
 static void netlink_destroy_callback(struct netlink_callback *cb);
+static void netlink_queue_skip(struct nlmsghdr *nlh, struct sk_buff *skb);
 
 static DEFINE_RWLOCK(nl_table_lock);
 static atomic_t nl_table_users = ATOMIC_INIT(0);
@@ -1556,7 +1557,7 @@ void netlink_run_queue(struct sock *sk, 
  * Pulls the given netlink message off the socket buffer so the next
  * call to netlink_queue_run() will not reconsider the message.
  */
-void netlink_queue_skip(struct nlmsghdr *nlh, struct sk_buff *skb)
+static void netlink_queue_skip(struct nlmsghdr *nlh, struct sk_buff *skb)
 {
 	int msglen = NLMSG_ALIGN(nlh->nlmsg_len);
 
@@ -1839,7 +1840,6 @@ core_initcall(netlink_proto_init);
 
 EXPORT_SYMBOL(netlink_ack);
 EXPORT_SYMBOL(netlink_run_queue);
-EXPORT_SYMBOL(netlink_queue_skip);
 EXPORT_SYMBOL(netlink_broadcast);
 EXPORT_SYMBOL(netlink_dump_start);
 EXPORT_SYMBOL(netlink_kernel_create);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
net-possible-cleanups.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
