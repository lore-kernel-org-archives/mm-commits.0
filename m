From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 04 Nov 2013 11:20:36 -0800
Message-ID: <5277f384.H964ywxfENZZGKyq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3KDTUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 14:20:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 11:20:36 -0800


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/emulex/benet/be.h |    3 -
 drivers/net/netconsole.c               |    4 --
 net/bridge/br_private.h                |   41 -----------------------
 3 files changed, 48 deletions(-)

diff -puN drivers/net/ethernet/emulex/benet/be.h~linux-next-git-rejects drivers/net/ethernet/emulex/benet/be.h
--- a/drivers/net/ethernet/emulex/benet/be.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/emulex/benet/be.h
@@ -741,7 +741,6 @@ static inline int fw_major_num(const cha
 	return fw_major;
 }
 
-<<<<<<< HEAD
 extern void be_cq_notify(struct be_adapter *adapter, u16 qid, bool arm,
 		u16 num_popped);
 extern void be_link_status_update(struct be_adapter *adapter, u8 link_status);
@@ -750,7 +749,6 @@ extern int be_load_fw(struct be_adapter
 extern bool be_is_wol_supported(struct be_adapter *adapter);
 extern bool be_pause_supported(struct be_adapter *adapter);
 extern u32 be_get_fw_log_level(struct be_adapter *adapter);
-=======
 #ifdef CONFIG_NET_RX_BUSY_POLL
 static inline bool be_lock_napi(struct be_eq_obj *eqo)
 {
@@ -859,7 +857,6 @@ int be_load_fw(struct be_adapter *adapte
 bool be_is_wol_supported(struct be_adapter *adapter);
 bool be_pause_supported(struct be_adapter *adapter);
 u32 be_get_fw_log_level(struct be_adapter *adapter);
->>>>>>> linux-next/akpm-base
 int be_update_queues(struct be_adapter *adapter);
 int be_poll(struct napi_struct *napi, int budget);
 
diff -puN drivers/net/netconsole.c~linux-next-git-rejects drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~linux-next-git-rejects
+++ a/drivers/net/netconsole.c
@@ -338,11 +338,7 @@ static ssize_t store_enabled(struct netc
 		if (err)
 			return err;
 
-<<<<<<< HEAD
-		printk(KERN_INFO "netconsole: network logging started\n");
-=======
 		pr_info("network logging started\n");
->>>>>>> linux-next/akpm-base
 	} else {	/* 0 */
 		/* We need to disable the netconsole before cleaning it up
 		 * otherwise we might end up in write_msg() with
diff -puN net/bridge/br_private.h~linux-next-git-rejects net/bridge/br_private.h
--- a/net/bridge/br_private.h~linux-next-git-rejects
+++ a/net/bridge/br_private.h
@@ -434,46 +434,6 @@ int br_ioctl_deviceless_stub(struct net
 /* br_multicast.c */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 extern unsigned int br_mdb_rehash_seq;
-<<<<<<< HEAD
-extern int br_multicast_rcv(struct net_bridge *br,
-			    struct net_bridge_port *port,
-			    struct sk_buff *skb,
-			    u16 vid);
-extern struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
-					       struct sk_buff *skb, u16 vid);
-extern void br_multicast_add_port(struct net_bridge_port *port);
-extern void br_multicast_del_port(struct net_bridge_port *port);
-extern void br_multicast_enable_port(struct net_bridge_port *port);
-extern void br_multicast_disable_port(struct net_bridge_port *port);
-extern void br_multicast_init(struct net_bridge *br);
-extern void br_multicast_open(struct net_bridge *br);
-extern void br_multicast_stop(struct net_bridge *br);
-extern void br_multicast_deliver(struct net_bridge_mdb_entry *mdst,
-				 struct sk_buff *skb);
-extern void br_multicast_forward(struct net_bridge_mdb_entry *mdst,
-				 struct sk_buff *skb, struct sk_buff *skb2);
-extern int br_multicast_set_router(struct net_bridge *br, unsigned long val);
-extern int br_multicast_set_port_router(struct net_bridge_port *p,
-					unsigned long val);
-extern int br_multicast_toggle(struct net_bridge *br, unsigned long val);
-extern int br_multicast_set_querier(struct net_bridge *br, unsigned long val);
-extern int br_multicast_set_hash_max(struct net_bridge *br, unsigned long val);
-extern struct net_bridge_mdb_entry *br_mdb_ip_get(
-				struct net_bridge_mdb_htable *mdb,
-				struct br_ip *dst);
-extern struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
-				struct net_bridge_port *port, struct br_ip *group);
-extern void br_multicast_free_pg(struct rcu_head *head);
-extern struct net_bridge_port_group *br_multicast_new_port_group(
-				struct net_bridge_port *port,
-				struct br_ip *group,
-				struct net_bridge_port_group __rcu *next,
-				unsigned char state);
-extern void br_mdb_init(void);
-extern void br_mdb_uninit(void);
-extern void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
-			  struct br_ip *group, int type);
-=======
 int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 		     struct sk_buff *skb, u16 vid);
 struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
@@ -508,7 +468,6 @@ void br_mdb_init(void);
 void br_mdb_uninit(void);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
 		   struct br_ip *group, int type);
->>>>>>> linux-next/akpm-base
 
 #define mlock_dereference(X, br) \
 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
kfifo-api-type-safety-checkpatch-fixes.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

