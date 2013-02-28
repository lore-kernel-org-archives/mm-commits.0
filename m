From: akpm@linux-foundation.org
Subject: [merged] hlist-drop-the-node-parameter-from-iterators.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:18:16 -0800
Message-ID: <20130228201817.1FE0031C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:47026 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3B1UST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:18:19 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so246796yhr.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:18:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, fengguang.wu@intel.com, gleb@redhat.com, mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, peter.senna@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist: drop the node parameter from iterators
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: hlist: drop the node parameter from iterators

I'm not sure why, but the hlist for each entry iterators were conceived

        list_for_each_entry(pos, head, member)

The hlist ones were greedy and wanted an extra parameter:

        hlist_for_each_entry(tpos, pos, head, member)

Why did they need an extra pos parameter? I'm not quite sure. Not only
they don't really need it, it also prevents the iterator from looking
exactly like the list iterator, which is unfortunate.

Besides the semantic patch, there was some manual work required:

 - Fix up the actual hlist iterators in linux/list.h
 - Fix up the declaration of other iterators based on the hlist ones.
 - A very small amount of places were using the 'node' parameter, this
 was modified to use 'obj->member' instead.
 - Coccinelle didn't handle the hlist_for_each_entry_safe iterator
 properly, so those had to be fixed up manually.

The semantic patch which is mostly the work of Peter Senna Tschudin is here:

@@
iterator name hlist_for_each_entry, hlist_for_each_entry_continue, hlist_for_each_entry_from, hlist_for_each_entry_rcu, hlist_for_each_entry_rcu_bh, hlist_for_each_entry_continue_rcu_bh, for_each_busy_worker, ax25_uid_for_each, ax25_for_each, inet_bind_bucket_for_each, sctp_for_each_hentry, sk_for_each, sk_for_each_rcu, sk_for_each_from, sk_for_each_safe, sk_for_each_bound, hlist_for_each_entry_safe, hlist_for_each_entry_continue_rcu, nr_neigh_for_each, nr_neigh_for_each_safe, nr_node_for_each, nr_node_for_each_safe, for_each_gfn_indirect_valid_sp, for_each_gfn_sp, for_each_host;

type T;
expression a,c,d,e;
identifier b;
statement S;
@@

-T b;
    <+... when != b
(
hlist_for_each_entry(a,
- b,
c, d) S
|
hlist_for_each_entry_continue(a,
- b,
c) S
|
hlist_for_each_entry_from(a,
- b,
c) S
|
hlist_for_each_entry_rcu(a,
- b,
c, d) S
|
hlist_for_each_entry_rcu_bh(a,
- b,
c, d) S
|
hlist_for_each_entry_continue_rcu_bh(a,
- b,
c) S
|
for_each_busy_worker(a, c,
- b,
d) S
|
ax25_uid_for_each(a,
- b,
c) S
|
ax25_for_each(a,
- b,
c) S
|
inet_bind_bucket_for_each(a,
- b,
c) S
|
sctp_for_each_hentry(a,
- b,
c) S
|
sk_for_each(a,
- b,
c) S
|
sk_for_each_rcu(a,
- b,
c) S
|
sk_for_each_from
-(a, b)
+(a)
S
+ sk_for_each_from(a) S
|
sk_for_each_safe(a,
- b,
c, d) S
|
sk_for_each_bound(a,
- b,
c) S
|
hlist_for_each_entry_safe(a,
- b,
c, d, e) S
|
hlist_for_each_entry_continue_rcu(a,
- b,
c) S
|
nr_neigh_for_each(a,
- b,
c) S
|
nr_neigh_for_each_safe(a,
- b,
c, d) S
|
nr_node_for_each(a,
- b,
c) S
|
nr_node_for_each_safe(a,
- b,
c, d) S
|
- for_each_gfn_sp(a, c, d, b) S
+ for_each_gfn_sp(a, c, d) S
|
- for_each_gfn_indirect_valid_sp(a, c, d, b) S
+ for_each_gfn_indirect_valid_sp(a, c, d) S
|
for_each_host(a,
- b,
c) S
|
for_each_host_safe(a,
- b,
c, d) S
|
for_each_mesh_entry(a,
- b,
c, d) S
)
    ...+>

[akpm@linux-foundation.org: drop bogus change from net/ipv4/raw.c]
[akpm@linux-foundation.org: drop bogus hunk from net/ipv6/raw.c]
[akpm@linux-foundation.org: checkpatch fixes]
[akpm@linux-foundation.org: fix warnings]
[akpm@linux-foudnation.org: redo intrusive kvm changes]
Tested-by: Peter Senna Tschudin <peter.senna@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/kprobes.c                           |    6 
 arch/ia64/kernel/kprobes.c                          |    8 
 arch/mips/kernel/kprobes.c                          |    6 
 arch/powerpc/kernel/kprobes.c                       |    6 
 arch/powerpc/kvm/book3s_mmu_hpte.c                  |   18 --
 arch/s390/kernel/kprobes.c                          |    8 
 arch/s390/pci/pci_msi.c                             |    3 
 arch/sh/kernel/kprobes.c                            |    6 
 arch/sparc/kernel/kprobes.c                         |    6 
 arch/sparc/kernel/ldc.c                             |    3 
 arch/x86/kernel/kprobes/core.c                      |    8 
 arch/x86/kvm/mmu.c                                  |   26 +--
 block/blk-cgroup.c                                  |    6 
 block/blk-ioc.c                                     |    3 
 block/bsg.c                                         |    3 
 block/cfq-iosched.c                                 |    3 
 block/elevator.c                                    |    4 
 crypto/algapi.c                                     |    6 
 drivers/atm/atmtcp.c                                |    6 
 drivers/atm/eni.c                                   |    3 
 drivers/atm/he.c                                    |    3 
 drivers/atm/solos-pci.c                             |    3 
 drivers/clk/clk.c                                   |   59 ++-----
 drivers/gpu/drm/drm_hashtab.c                       |   19 --
 drivers/infiniband/core/cma.c                       |    3 
 drivers/infiniband/core/fmr_pool.c                  |    3 
 drivers/isdn/mISDN/socket.c                         |    3 
 drivers/isdn/mISDN/stack.c                          |    3 
 drivers/md/dm-bio-prison.c                          |    3 
 drivers/md/dm-bufio.c                               |    3 
 drivers/md/dm-snap.c                                |    3 
 drivers/md/persistent-data/dm-transaction-manager.c |    7 
 drivers/md/raid5.c                                  |    3 
 drivers/misc/sgi-gru/grutlbpurge.c                  |    3 
 drivers/misc/vmw_vmci/vmci_doorbell.c               |    7 
 drivers/misc/vmw_vmci/vmci_resource.c               |    6 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c    |   18 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       |    8 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c      |   17 --
 drivers/net/ethernet/mellanox/mlx4/en_rx.c          |    4 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c      |   10 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c      |   10 -
 drivers/net/ethernet/sun/sunvnet.c                  |    3 
 drivers/net/macvlan.c                               |    6 
 drivers/net/tun.c                                   |   15 -
 drivers/net/vxlan.c                                 |   12 -
 drivers/net/wireless/zd1201.c                       |    7 
 drivers/pci/pci.c                                   |   12 -
 drivers/staging/android/binder.c                    |   19 --
 drivers/target/tcm_fc/tfc_sess.c                    |   12 -
 fs/affs/amigaffs.c                                  |    3 
 fs/aio.c                                            |    3 
 fs/cifs/inode.c                                     |    3 
 fs/dcache.c                                         |    9 -
 fs/dlm/lowcomms.c                                   |   11 -
 fs/ecryptfs/messaging.c                             |    6 
 fs/exportfs/expfs.c                                 |    3 
 fs/fat/inode.c                                      |    3 
 fs/fat/nfs.c                                        |    3 
 fs/fscache/cookie.c                                 |   11 -
 fs/inode.c                                          |   19 --
 fs/lockd/host.c                                     |   29 +--
 fs/lockd/svcsubs.c                                  |    7 
 fs/nfs/pnfs_dev.c                                   |    9 -
 fs/nfsd/nfscache.c                                  |    3 
 fs/notify/fsnotify.c                                |    3 
 fs/notify/inode_mark.c                              |   19 --
 fs/notify/vfsmount_mark.c                           |   19 --
 fs/ocfs2/dcache.c                                   |    3 
 fs/ocfs2/dlm/dlmrecovery.c                          |    6 
 fs/super.c                                          |    6 
 fs/sysfs/bin.c                                      |    3 
 fs/xfs/xfs_log_recover.c                            |    3 
 include/linux/hashtable.h                           |   40 ++--
 include/linux/if_team.h                             |    6 
 include/linux/list.h                                |   49 ++---
 include/linux/pid.h                                 |    3 
 include/linux/rculist.h                             |   56 +++---
 include/net/ax25.h                                  |    8 
 include/net/inet_hashtables.h                       |    4 
 include/net/inet_timewait_sock.h                    |    8 
 include/net/netrom.h                                |   16 -
 include/net/sch_generic.h                           |    3 
 include/net/sctp/sctp.h                             |    4 
 include/net/sock.h                                  |   21 +-
 kernel/cgroup.c                                     |   12 -
 kernel/events/core.c                                |    6 
 kernel/kprobes.c                                    |   35 +---
 kernel/pid.c                                        |    3 
 kernel/sched/core.c                                 |    6 
 kernel/smpboot.c                                    |    2 
 kernel/trace/ftrace.c                               |   24 +-
 kernel/trace/trace_output.c                         |    3 
 kernel/tracepoint.c                                 |    6 
 kernel/user-return-notifier.c                       |    4 
 kernel/user.c                                       |    3 
 kernel/workqueue.c                                  |   13 -
 lib/debugobjects.c                                  |   21 +-
 lib/lru_cache.c                                     |    3 
 mm/huge_memory.c                                    |    3 
 mm/kmemleak.c                                       |    9 -
 mm/ksm.c                                            |   15 -
 mm/mmu_notifier.c                                   |   18 --
 net/9p/error.c                                      |    4 
 net/9p/trans_virtio.c                               |    2 
 net/appletalk/ddp.c                                 |    9 -
 net/atm/common.c                                    |    7 
 net/atm/lec.c                                       |   66 +++-----
 net/atm/signaling.c                                 |    3 
 net/ax25/af_ax25.c                                  |   15 -
 net/ax25/ax25_ds_subr.c                             |    6 
 net/ax25/ax25_ds_timer.c                            |    3 
 net/ax25/ax25_iface.c                               |    3 
 net/ax25/ax25_uid.c                                 |   11 -
 net/batman-adv/bat_iv_ogm.c                         |   12 -
 net/batman-adv/bridge_loop_avoidance.c              |   39 +---
 net/batman-adv/distributed-arp-table.c              |   15 -
 net/batman-adv/gateway_client.c                     |   13 -
 net/batman-adv/main.c                               |    6 
 net/batman-adv/originator.c                         |   31 +--
 net/batman-adv/originator.h                         |    3 
 net/batman-adv/routing.c                            |    6 
 net/batman-adv/send.c                               |    6 
 net/batman-adv/translation-table.c                  |   82 ++++------
 net/batman-adv/vis.c                                |   38 +---
 net/bluetooth/hci_sock.c                            |   15 -
 net/bluetooth/rfcomm/sock.c                         |   13 -
 net/bluetooth/sco.c                                 |   14 -
 net/bridge/br_fdb.c                                 |   23 +-
 net/bridge/br_mdb.c                                 |    6 
 net/bridge/br_multicast.c                           |   25 +--
 net/can/af_can.c                                    |   18 --
 net/can/gw.c                                        |   15 -
 net/can/proc.c                                      |    3 
 net/core/dev.c                                      |   12 -
 net/core/flow.c                                     |   11 -
 net/core/net-procfs.c                               |    3 
 net/core/rtnetlink.c                                |    3 
 net/decnet/af_decnet.c                              |    9 -
 net/decnet/dn_table.c                               |   13 -
 net/ieee802154/dgram.c                              |    3 
 net/ieee802154/raw.c                                |    3 
 net/ipv4/devinet.c                                  |   10 -
 net/ipv4/fib_frontend.c                             |   15 -
 net/ipv4/fib_semantics.c                            |   23 +-
 net/ipv4/fib_trie.c                                 |   33 +---
 net/ipv4/inet_connection_sock.c                     |   10 -
 net/ipv4/inet_fragment.c                            |   10 -
 net/ipv4/inet_hashtables.c                          |    8 
 net/ipv4/inet_timewait_sock.c                       |    7 
 net/ipv4/raw.c                                      |    8 
 net/ipv4/tcp_ipv4.c                                 |    7 
 net/ipv6/addrconf.c                                 |   32 +--
 net/ipv6/addrlabel.c                                |   18 --
 net/ipv6/inet6_connection_sock.c                    |    5 
 net/ipv6/ip6_fib.c                                  |   12 -
 net/ipv6/raw.c                                      |    3 
 net/ipv6/xfrm6_tunnel.c                             |   10 -
 net/ipx/af_ipx.c                                    |   16 -
 net/ipx/ipx_proc.c                                  |    5 
 net/iucv/af_iucv.c                                  |   21 --
 net/key/af_key.c                                    |    3 
 net/l2tp/l2tp_core.c                                |   12 -
 net/l2tp/l2tp_ip.c                                  |    3 
 net/l2tp/l2tp_ip6.c                                 |    3 
 net/llc/llc_sap.c                                   |    3 
 net/mac80211/mesh_pathtbl.c                         |   45 ++---
 net/netfilter/ipvs/ip_vs_conn.c                     |   26 +--
 net/netfilter/nf_conntrack_expect.c                 |   17 --
 net/netfilter/nf_conntrack_helper.c                 |   13 -
 net/netfilter/nf_conntrack_netlink.c                |    9 -
 net/netfilter/nf_conntrack_sip.c                    |    8 
 net/netfilter/nf_nat_core.c                         |    3 
 net/netfilter/nfnetlink_cthelper.c                  |   17 --
 net/netfilter/nfnetlink_log.c                       |    7 
 net/netfilter/nfnetlink_queue_core.c                |   10 -
 net/netfilter/xt_RATEEST.c                          |    3 
 net/netfilter/xt_connlimit.c                        |    8 
 net/netfilter/xt_hashlimit.c                        |   16 -
 net/netlink/af_netlink.c                            |   30 +--
 net/netrom/af_netrom.c                              |   12 -
 net/netrom/nr_route.c                               |   30 +--
 net/nfc/llcp/llcp.c                                 |   16 -
 net/openvswitch/datapath.c                          |   10 -
 net/openvswitch/flow.c                              |   13 -
 net/openvswitch/vport.c                             |    3 
 net/packet/af_packet.c                              |    3 
 net/packet/diag.c                                   |    3 
 net/phonet/pep.c                                    |    3 
 net/phonet/socket.c                                 |    9 -
 net/rds/bind.c                                      |    3 
 net/rds/connection.c                                |    9 -
 net/rose/af_rose.c                                  |   14 -
 net/sched/sch_api.c                                 |    4 
 net/sched/sch_cbq.c                                 |   18 --
 net/sched/sch_drr.c                                 |   10 -
 net/sched/sch_hfsc.c                                |   15 -
 net/sched/sch_htb.c                                 |   12 -
 net/sched/sch_qfq.c                                 |   16 -
 net/sctp/endpointola.c                              |    3 
 net/sctp/input.c                                    |    6 
 net/sctp/proc.c                                     |    9 -
 net/sctp/socket.c                                   |    9 -
 net/sunrpc/auth.c                                   |    5 
 net/sunrpc/cache.c                                  |    4 
 net/sunrpc/svcauth.c                                |    3 
 net/tipc/name_table.c                               |    8 
 net/tipc/node.c                                     |    3 
 net/unix/af_unix.c                                  |    6 
 net/unix/diag.c                                     |    7 
 net/x25/af_x25.c                                    |   12 -
 net/xfrm/xfrm_policy.c                              |   47 ++---
 net/xfrm/xfrm_state.c                               |   42 +----
 security/integrity/ima/ima_queue.c                  |    3 
 security/selinux/avc.c                              |   19 --
 tools/perf/util/evlist.c                            |    3 
 virt/kvm/eventfd.c                                  |    3 
 virt/kvm/irq_comm.c                                 |   18 --
 218 files changed, 987 insertions(+), 1494 deletions(-)

diff -puN arch/arm/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators arch/arm/kernel/kprobes.c
--- a/arch/arm/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/arm/kernel/kprobes.c
@@ -395,7 +395,7 @@ static __used __kprobes void *trampoline
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 
@@ -415,7 +415,7 @@ static __used __kprobes void *trampoline
 	 *       real return address, and all the rest will point to
 	 *       kretprobe_trampoline
 	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -442,7 +442,7 @@ static __used __kprobes void *trampoline
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	kretprobe_hash_unlock(current, &flags);
 
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
diff -puN arch/ia64/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/ia64/kernel/kprobes.c
@@ -423,7 +423,7 @@ int __kprobes trampoline_probe_handler(s
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address =
 		((struct fnptr *)kretprobe_trampoline)->ip;
@@ -444,7 +444,7 @@ int __kprobes trampoline_probe_handler(s
 	 *       real return address, and all the rest will point to
 	 *       kretprobe_trampoline
 	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -461,7 +461,7 @@ int __kprobes trampoline_probe_handler(s
 
 	regs->cr_iip = orig_ret_address;
 
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -487,7 +487,7 @@ int __kprobes trampoline_probe_handler(s
 	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
diff -puN arch/mips/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators arch/mips/kernel/kprobes.c
--- a/arch/mips/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/mips/kernel/kprobes.c
@@ -598,7 +598,7 @@ static int __kprobes trampoline_probe_ha
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address = (unsigned long)kretprobe_trampoline;
 
@@ -618,7 +618,7 @@ static int __kprobes trampoline_probe_ha
 	 *       real return address, and all the rest will point to
 	 *       kretprobe_trampoline
 	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -645,7 +645,7 @@ static int __kprobes trampoline_probe_ha
 	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
diff -puN arch/powerpc/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/powerpc/kernel/kprobes.c
@@ -310,7 +310,7 @@ static int __kprobes trampoline_probe_ha
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
 
@@ -330,7 +330,7 @@ static int __kprobes trampoline_probe_ha
 	 *       real return address, and all the rest will point to
 	 *       kretprobe_trampoline
 	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -357,7 +357,7 @@ static int __kprobes trampoline_probe_ha
 	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
diff -puN arch/powerpc/kvm/book3s_mmu_hpte.c~hlist-drop-the-node-parameter-from-iterators arch/powerpc/kvm/book3s_mmu_hpte.c
--- a/arch/powerpc/kvm/book3s_mmu_hpte.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/powerpc/kvm/book3s_mmu_hpte.c
@@ -124,7 +124,6 @@ static void kvmppc_mmu_pte_flush_all(str
 {
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	struct hpte_cache *pte;
-	struct hlist_node *node;
 	int i;
 
 	rcu_read_lock();
@@ -132,7 +131,7 @@ static void kvmppc_mmu_pte_flush_all(str
 	for (i = 0; i < HPTEG_HASH_NUM_VPTE_LONG; i++) {
 		struct hlist_head *list = &vcpu3s->hpte_hash_vpte_long[i];
 
-		hlist_for_each_entry_rcu(pte, node, list, list_vpte_long)
+		hlist_for_each_entry_rcu(pte, list, list_vpte_long)
 			invalidate_pte(vcpu, pte);
 	}
 
@@ -143,7 +142,6 @@ static void kvmppc_mmu_pte_flush_page(st
 {
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	struct hlist_head *list;
-	struct hlist_node *node;
 	struct hpte_cache *pte;
 
 	/* Find the list of entries in the map */
@@ -152,7 +150,7 @@ static void kvmppc_mmu_pte_flush_page(st
 	rcu_read_lock();
 
 	/* Check the list for matching entries and invalidate */
-	hlist_for_each_entry_rcu(pte, node, list, list_pte)
+	hlist_for_each_entry_rcu(pte, list, list_pte)
 		if ((pte->pte.eaddr & ~0xfffUL) == guest_ea)
 			invalidate_pte(vcpu, pte);
 
@@ -163,7 +161,6 @@ static void kvmppc_mmu_pte_flush_long(st
 {
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	struct hlist_head *list;
-	struct hlist_node *node;
 	struct hpte_cache *pte;
 
 	/* Find the list of entries in the map */
@@ -173,7 +170,7 @@ static void kvmppc_mmu_pte_flush_long(st
 	rcu_read_lock();
 
 	/* Check the list for matching entries and invalidate */
-	hlist_for_each_entry_rcu(pte, node, list, list_pte_long)
+	hlist_for_each_entry_rcu(pte, list, list_pte_long)
 		if ((pte->pte.eaddr & 0x0ffff000UL) == guest_ea)
 			invalidate_pte(vcpu, pte);
 
@@ -207,7 +204,6 @@ static void kvmppc_mmu_pte_vflush_short(
 {
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	struct hlist_head *list;
-	struct hlist_node *node;
 	struct hpte_cache *pte;
 	u64 vp_mask = 0xfffffffffULL;
 
@@ -216,7 +212,7 @@ static void kvmppc_mmu_pte_vflush_short(
 	rcu_read_lock();
 
 	/* Check the list for matching entries and invalidate */
-	hlist_for_each_entry_rcu(pte, node, list, list_vpte)
+	hlist_for_each_entry_rcu(pte, list, list_vpte)
 		if ((pte->pte.vpage & vp_mask) == guest_vp)
 			invalidate_pte(vcpu, pte);
 
@@ -228,7 +224,6 @@ static void kvmppc_mmu_pte_vflush_long(s
 {
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
 	struct hlist_head *list;
-	struct hlist_node *node;
 	struct hpte_cache *pte;
 	u64 vp_mask = 0xffffff000ULL;
 
@@ -238,7 +233,7 @@ static void kvmppc_mmu_pte_vflush_long(s
 	rcu_read_lock();
 
 	/* Check the list for matching entries and invalidate */
-	hlist_for_each_entry_rcu(pte, node, list, list_vpte_long)
+	hlist_for_each_entry_rcu(pte, list, list_vpte_long)
 		if ((pte->pte.vpage & vp_mask) == guest_vp)
 			invalidate_pte(vcpu, pte);
 
@@ -266,7 +261,6 @@ void kvmppc_mmu_pte_vflush(struct kvm_vc
 void kvmppc_mmu_pte_pflush(struct kvm_vcpu *vcpu, ulong pa_start, ulong pa_end)
 {
 	struct kvmppc_vcpu_book3s *vcpu3s = to_book3s(vcpu);
-	struct hlist_node *node;
 	struct hpte_cache *pte;
 	int i;
 
@@ -277,7 +271,7 @@ void kvmppc_mmu_pte_pflush(struct kvm_vc
 	for (i = 0; i < HPTEG_HASH_NUM_VPTE_LONG; i++) {
 		struct hlist_head *list = &vcpu3s->hpte_hash_vpte_long[i];
 
-		hlist_for_each_entry_rcu(pte, node, list, list_vpte_long)
+		hlist_for_each_entry_rcu(pte, list, list_vpte_long)
 			if ((pte->pte.raddr >= pa_start) &&
 			    (pte->pte.raddr < pa_end))
 				invalidate_pte(vcpu, pte);
diff -puN arch/s390/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/s390/kernel/kprobes.c
@@ -354,7 +354,7 @@ static int __kprobes trampoline_probe_ha
 {
 	struct kretprobe_instance *ri;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address;
 	unsigned long trampoline_address;
 	kprobe_opcode_t *correct_ret_addr;
@@ -379,7 +379,7 @@ static int __kprobes trampoline_probe_ha
 	orig_ret_address = 0;
 	correct_ret_addr = NULL;
 	trampoline_address = (unsigned long) &kretprobe_trampoline;
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -398,7 +398,7 @@ static int __kprobes trampoline_probe_ha
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 
 	correct_ret_addr = ri->ret_addr;
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -427,7 +427,7 @@ static int __kprobes trampoline_probe_ha
 	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
diff -puN arch/s390/pci/pci_msi.c~hlist-drop-the-node-parameter-from-iterators arch/s390/pci/pci_msi.c
--- a/arch/s390/pci/pci_msi.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/s390/pci/pci_msi.c
@@ -25,10 +25,9 @@ static DEFINE_SPINLOCK(msi_map_lock);
 
 struct msi_desc *__irq_get_msi_desc(unsigned int irq)
 {
-	struct hlist_node *entry;
 	struct msi_map *map;
 
-	hlist_for_each_entry_rcu(map, entry,
+	hlist_for_each_entry_rcu(map,
 			&msi_hash[msi_hashfn(irq)], msi_chain)
 		if (map->irq == irq)
 			return map->msi;
diff -puN arch/sh/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators arch/sh/kernel/kprobes.c
--- a/arch/sh/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/sh/kernel/kprobes.c
@@ -310,7 +310,7 @@ int __kprobes trampoline_probe_handler(s
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 
@@ -330,7 +330,7 @@ int __kprobes trampoline_probe_handler(s
 	 *       real return address, and all the rest will point to
 	 *       kretprobe_trampoline
 	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -360,7 +360,7 @@ int __kprobes trampoline_probe_handler(s
 
 	preempt_enable_no_resched();
 
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
diff -puN arch/sparc/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators arch/sparc/kernel/kprobes.c
--- a/arch/sparc/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/sparc/kernel/kprobes.c
@@ -511,7 +511,7 @@ int __kprobes trampoline_probe_handler(s
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
 
@@ -531,7 +531,7 @@ int __kprobes trampoline_probe_handler(s
 	 *       real return address, and all the rest will point to
 	 *       kretprobe_trampoline
 	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -559,7 +559,7 @@ int __kprobes trampoline_probe_handler(s
 	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
diff -puN arch/sparc/kernel/ldc.c~hlist-drop-the-node-parameter-from-iterators arch/sparc/kernel/ldc.c
--- a/arch/sparc/kernel/ldc.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/sparc/kernel/ldc.c
@@ -953,9 +953,8 @@ static HLIST_HEAD(ldc_channel_list);
 static int __ldc_channel_exists(unsigned long id)
 {
 	struct ldc_channel *lp;
-	struct hlist_node *n;
 
-	hlist_for_each_entry(lp, n, &ldc_channel_list, list) {
+	hlist_for_each_entry(lp, &ldc_channel_list, list) {
 		if (lp->id == id)
 			return 1;
 	}
diff -puN arch/x86/kernel/kprobes/core.c~hlist-drop-the-node-parameter-from-iterators arch/x86/kernel/kprobes/core.c
--- a/arch/x86/kernel/kprobes/core.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/x86/kernel/kprobes/core.c
@@ -652,7 +652,7 @@ static __used __kprobes void *trampoline
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 	kprobe_opcode_t *correct_ret_addr = NULL;
@@ -682,7 +682,7 @@ static __used __kprobes void *trampoline
 	 *	 will be the real return address, and all the rest will
 	 *	 point to kretprobe_trampoline.
 	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -701,7 +701,7 @@ static __used __kprobes void *trampoline
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 
 	correct_ret_addr = ri->ret_addr;
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
@@ -728,7 +728,7 @@ static __used __kprobes void *trampoline
 
 	kretprobe_hash_unlock(current, &flags);
 
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
diff -puN arch/x86/kvm/mmu.c~hlist-drop-the-node-parameter-from-iterators arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~hlist-drop-the-node-parameter-from-iterators
+++ a/arch/x86/kvm/mmu.c
@@ -1644,13 +1644,13 @@ static int kvm_mmu_prepare_zap_page(stru
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
-#define for_each_gfn_sp(kvm, sp, gfn, pos)				\
-  hlist_for_each_entry(sp, pos,						\
+#define for_each_gfn_sp(kvm, sp, gfn)					\
+  hlist_for_each_entry(sp,						\
    &(kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)	\
 	if ((sp)->gfn != (gfn)) {} else
 
-#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos)		\
-  hlist_for_each_entry(sp, pos,						\
+#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn)			\
+  hlist_for_each_entry(sp,						\
    &(kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)	\
 		if ((sp)->gfn != (gfn) || (sp)->role.direct ||		\
 			(sp)->role.invalid) {} else
@@ -1706,11 +1706,10 @@ static int kvm_sync_page(struct kvm_vcpu
 static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn) {
 		if (!s->unsync)
 			continue;
 
@@ -1848,7 +1847,6 @@ static struct kvm_mmu_page *kvm_mmu_get_
 	union kvm_mmu_page_role role;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node;
 	bool need_sync = false;
 
 	role = vcpu->arch.mmu.base_role;
@@ -1863,7 +1861,7 @@ static struct kvm_mmu_page *kvm_mmu_get_
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	for_each_gfn_sp(vcpu->kvm, sp, gfn, node) {
+	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
 		if (!need_sync && sp->unsync)
 			need_sync = true;
 
@@ -2151,14 +2149,13 @@ void kvm_mmu_change_mmu_pages(struct kvm
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	int r;
 
 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
 	spin_lock(&kvm->mmu_lock);
-	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
+	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
@@ -2288,9 +2285,8 @@ static void __kvm_unsync_page(struct kvm
 static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn) {
 		if (s->unsync)
 			continue;
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
@@ -2302,10 +2298,9 @@ static int mmu_need_write_protect(struct
 				  bool can_unsync)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node;
 	bool need_unsync = false;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn) {
 		if (!can_unsync)
 			return 1;
 
@@ -3933,7 +3928,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	union kvm_mmu_page_role mask = { .word = 0 };
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	u64 entry, gentry, *spte;
 	int npte;
@@ -3964,7 +3958,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
 
 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
 		if (detect_write_misaligned(sp, gpa, bytes) ||
 		      detect_write_flooding(sp)) {
 			zap_page |= !!kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
diff -puN block/blk-cgroup.c~hlist-drop-the-node-parameter-from-iterators block/blk-cgroup.c
--- a/block/blk-cgroup.c~hlist-drop-the-node-parameter-from-iterators
+++ a/block/blk-cgroup.c
@@ -357,7 +357,6 @@ static int blkcg_reset_stats(struct cgro
 {
 	struct blkcg *blkcg = cgroup_to_blkcg(cgroup);
 	struct blkcg_gq *blkg;
-	struct hlist_node *n;
 	int i;
 
 	mutex_lock(&blkcg_pol_mutex);
@@ -368,7 +367,7 @@ static int blkcg_reset_stats(struct cgro
 	 * stat updates.  This is a debug feature which shouldn't exist
 	 * anyway.  If you get hit by a race, retry.
 	 */
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];
 
@@ -415,11 +414,10 @@ void blkcg_print_blkgs(struct seq_file *
 		       bool show_total)
 {
 	struct blkcg_gq *blkg;
-	struct hlist_node *n;
 	u64 total = 0;
 
 	spin_lock_irq(&blkcg->lock);
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node)
 		if (blkcg_policy_enabled(blkg->q, pol))
 			total += prfill(sf, blkg->pd[pol->plid], data);
 	spin_unlock_irq(&blkcg->lock);
diff -puN block/blk-ioc.c~hlist-drop-the-node-parameter-from-iterators block/blk-ioc.c
--- a/block/blk-ioc.c~hlist-drop-the-node-parameter-from-iterators
+++ a/block/blk-ioc.c
@@ -164,7 +164,6 @@ EXPORT_SYMBOL(put_io_context);
  */
 void put_io_context_active(struct io_context *ioc)
 {
-	struct hlist_node *n;
 	unsigned long flags;
 	struct io_cq *icq;
 
@@ -180,7 +179,7 @@ void put_io_context_active(struct io_con
 	 */
 retry:
 	spin_lock_irqsave_nested(&ioc->lock, flags, 1);
-	hlist_for_each_entry(icq, n, &ioc->icq_list, ioc_node) {
+	hlist_for_each_entry(icq, &ioc->icq_list, ioc_node) {
 		if (icq->flags & ICQ_EXITED)
 			continue;
 		if (spin_trylock(icq->q->queue_lock)) {
diff -puN block/bsg.c~hlist-drop-the-node-parameter-from-iterators block/bsg.c
--- a/block/bsg.c~hlist-drop-the-node-parameter-from-iterators
+++ a/block/bsg.c
@@ -800,11 +800,10 @@ static struct bsg_device *bsg_add_device
 static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 {
 	struct bsg_device *bd;
-	struct hlist_node *entry;
 
 	mutex_lock(&bsg_mutex);
 
-	hlist_for_each_entry(bd, entry, bsg_dev_idx_hash(minor), dev_list) {
+	hlist_for_each_entry(bd, bsg_dev_idx_hash(minor), dev_list) {
 		if (bd->queue == q) {
 			atomic_inc(&bd->ref_count);
 			goto found;
diff -puN block/cfq-iosched.c~hlist-drop-the-node-parameter-from-iterators block/cfq-iosched.c
--- a/block/cfq-iosched.c~hlist-drop-the-node-parameter-from-iterators
+++ a/block/cfq-iosched.c
@@ -1435,7 +1435,6 @@ static int cfq_set_weight(struct cgroup 
 {
 	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
 	struct blkcg_gq *blkg;
-	struct hlist_node *n;
 
 	if (val < CFQ_WEIGHT_MIN || val > CFQ_WEIGHT_MAX)
 		return -EINVAL;
@@ -1443,7 +1442,7 @@ static int cfq_set_weight(struct cgroup 
 	spin_lock_irq(&blkcg->lock);
 	blkcg->cfq_weight = (unsigned int)val;
 
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
 		struct cfq_group *cfqg = blkg_to_cfqg(blkg);
 
 		if (cfqg && !cfqg->dev_weight)
diff -puN block/elevator.c~hlist-drop-the-node-parameter-from-iterators block/elevator.c
--- a/block/elevator.c~hlist-drop-the-node-parameter-from-iterators
+++ a/block/elevator.c
@@ -288,10 +288,10 @@ static struct request *elv_rqhash_find(s
 {
 	struct elevator_queue *e = q->elevator;
 	struct hlist_head *hash_list = &e->hash[ELV_HASH_FN(offset)];
-	struct hlist_node *entry, *next;
+	struct hlist_node *next;
 	struct request *rq;
 
-	hlist_for_each_entry_safe(rq, entry, next, hash_list, hash) {
+	hlist_for_each_entry_safe(rq, next, hash_list, hash) {
 		BUG_ON(!ELV_ON_HASH(rq));
 
 		if (unlikely(!rq_mergeable(rq))) {
diff -puN crypto/algapi.c~hlist-drop-the-node-parameter-from-iterators crypto/algapi.c
--- a/crypto/algapi.c~hlist-drop-the-node-parameter-from-iterators
+++ a/crypto/algapi.c
@@ -447,7 +447,7 @@ EXPORT_SYMBOL_GPL(crypto_register_templa
 void crypto_unregister_template(struct crypto_template *tmpl)
 {
 	struct crypto_instance *inst;
-	struct hlist_node *p, *n;
+	struct hlist_node *n;
 	struct hlist_head *list;
 	LIST_HEAD(users);
 
@@ -457,7 +457,7 @@ void crypto_unregister_template(struct c
 	list_del_init(&tmpl->list);
 
 	list = &tmpl->instances;
-	hlist_for_each_entry(inst, p, list, list) {
+	hlist_for_each_entry(inst, list, list) {
 		int err = crypto_remove_alg(&inst->alg, &users);
 		BUG_ON(err);
 	}
@@ -466,7 +466,7 @@ void crypto_unregister_template(struct c
 
 	up_write(&crypto_alg_sem);
 
-	hlist_for_each_entry_safe(inst, p, n, list, list) {
+	hlist_for_each_entry_safe(inst, n, list, list) {
 		BUG_ON(atomic_read(&inst->alg.cra_refcnt) != 1);
 		tmpl->free(inst);
 	}
diff -puN drivers/atm/atmtcp.c~hlist-drop-the-node-parameter-from-iterators drivers/atm/atmtcp.c
--- a/drivers/atm/atmtcp.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/atm/atmtcp.c
@@ -157,7 +157,6 @@ static int atmtcp_v_ioctl(struct atm_dev
 {
 	struct atm_cirange ci;
 	struct atm_vcc *vcc;
-	struct hlist_node *node;
 	struct sock *s;
 	int i;
 
@@ -171,7 +170,7 @@ static int atmtcp_v_ioctl(struct atm_dev
 	for(i = 0; i < VCC_HTABLE_SIZE; ++i) {
 		struct hlist_head *head = &vcc_hash[i];
 
-		sk_for_each(s, node, head) {
+		sk_for_each(s, head) {
 			vcc = atm_sk(s);
 			if (vcc->dev != dev)
 				continue;
@@ -264,12 +263,11 @@ static struct atm_vcc *find_vcc(struct a
 {
         struct hlist_head *head;
         struct atm_vcc *vcc;
-        struct hlist_node *node;
         struct sock *s;
 
         head = &vcc_hash[vci & (VCC_HTABLE_SIZE -1)];
 
-        sk_for_each(s, node, head) {
+	sk_for_each(s, head) {
                 vcc = atm_sk(s);
                 if (vcc->dev == dev &&
                     vcc->vci == vci && vcc->vpi == vpi &&
diff -puN drivers/atm/eni.c~hlist-drop-the-node-parameter-from-iterators drivers/atm/eni.c
--- a/drivers/atm/eni.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/atm/eni.c
@@ -2093,7 +2093,6 @@ static unsigned char eni_phy_get(struct 
 
 static int eni_proc_read(struct atm_dev *dev,loff_t *pos,char *page)
 {
-	struct hlist_node *node;
 	struct sock *s;
 	static const char *signal[] = { "LOST","unknown","okay" };
 	struct eni_dev *eni_dev = ENI_DEV(dev);
@@ -2171,7 +2170,7 @@ static int eni_proc_read(struct atm_dev 
 	for(i = 0; i < VCC_HTABLE_SIZE; ++i) {
 		struct hlist_head *head = &vcc_hash[i];
 
-		sk_for_each(s, node, head) {
+		sk_for_each(s, head) {
 			struct eni_vcc *eni_vcc;
 			int length;
 
diff -puN drivers/atm/he.c~hlist-drop-the-node-parameter-from-iterators drivers/atm/he.c
--- a/drivers/atm/he.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/atm/he.c
@@ -329,7 +329,6 @@ __find_vcc(struct he_dev *he_dev, unsign
 {
 	struct hlist_head *head;
 	struct atm_vcc *vcc;
-	struct hlist_node *node;
 	struct sock *s;
 	short vpi;
 	int vci;
@@ -338,7 +337,7 @@ __find_vcc(struct he_dev *he_dev, unsign
 	vci = cid & ((1 << he_dev->vcibits) - 1);
 	head = &vcc_hash[vci & (VCC_HTABLE_SIZE -1)];
 
-	sk_for_each(s, node, head) {
+	sk_for_each(s, head) {
 		vcc = atm_sk(s);
 		if (vcc->dev == he_dev->atm_dev &&
 		    vcc->vci == vci && vcc->vpi == vpi &&
diff -puN drivers/atm/solos-pci.c~hlist-drop-the-node-parameter-from-iterators drivers/atm/solos-pci.c
--- a/drivers/atm/solos-pci.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/atm/solos-pci.c
@@ -896,12 +896,11 @@ static struct atm_vcc *find_vcc(struct a
 {
 	struct hlist_head *head;
 	struct atm_vcc *vcc = NULL;
-	struct hlist_node *node;
 	struct sock *s;
 
 	read_lock(&vcc_sklist_lock);
 	head = &vcc_hash[vci & (VCC_HTABLE_SIZE -1)];
-	sk_for_each(s, node, head) {
+	sk_for_each(s, head) {
 		vcc = atm_sk(s);
 		if (vcc->dev == dev && vcc->vci == vci &&
 		    vcc->vpi == vpi && vcc->qos.rxtp.traffic_class != ATM_NONE &&
diff -puN drivers/clk/clk.c~hlist-drop-the-node-parameter-from-iterators drivers/clk/clk.c
--- a/drivers/clk/clk.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/clk/clk.c
@@ -52,31 +52,29 @@ static void clk_summary_show_subtree(str
 				     int level)
 {
 	struct clk *child;
-	struct hlist_node *tmp;
 
 	if (!c)
 		return;
 
 	clk_summary_show_one(s, c, level);
 
-	hlist_for_each_entry(child, tmp, &c->children, child_node)
+	hlist_for_each_entry(child, &c->children, child_node)
 		clk_summary_show_subtree(s, child, level + 1);
 }
 
 static int clk_summary_show(struct seq_file *s, void *data)
 {
 	struct clk *c;
-	struct hlist_node *tmp;
 
 	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate\n");
 	seq_printf(s, "---------------------------------------------------------------------\n");
 
 	mutex_lock(&prepare_lock);
 
-	hlist_for_each_entry(c, tmp, &clk_root_list, child_node)
+	hlist_for_each_entry(c, &clk_root_list, child_node)
 		clk_summary_show_subtree(s, c, 0);
 
-	hlist_for_each_entry(c, tmp, &clk_orphan_list, child_node)
+	hlist_for_each_entry(c, &clk_orphan_list, child_node)
 		clk_summary_show_subtree(s, c, 0);
 
 	mutex_unlock(&prepare_lock);
@@ -111,14 +109,13 @@ static void clk_dump_one(struct seq_file
 static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
 {
 	struct clk *child;
-	struct hlist_node *tmp;
 
 	if (!c)
 		return;
 
 	clk_dump_one(s, c, level);
 
-	hlist_for_each_entry(child, tmp, &c->children, child_node) {
+	hlist_for_each_entry(child, &c->children, child_node) {
 		seq_printf(s, ",");
 		clk_dump_subtree(s, child, level + 1);
 	}
@@ -129,21 +126,20 @@ static void clk_dump_subtree(struct seq_
 static int clk_dump(struct seq_file *s, void *data)
 {
 	struct clk *c;
-	struct hlist_node *tmp;
 	bool first_node = true;
 
 	seq_printf(s, "{");
 
 	mutex_lock(&prepare_lock);
 
-	hlist_for_each_entry(c, tmp, &clk_root_list, child_node) {
+	hlist_for_each_entry(c, &clk_root_list, child_node) {
 		if (!first_node)
 			seq_printf(s, ",");
 		first_node = false;
 		clk_dump_subtree(s, c, 0);
 	}
 
-	hlist_for_each_entry(c, tmp, &clk_orphan_list, child_node) {
+	hlist_for_each_entry(c, &clk_orphan_list, child_node) {
 		seq_printf(s, ",");
 		clk_dump_subtree(s, c, 0);
 	}
@@ -222,7 +218,6 @@ out:
 static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
 {
 	struct clk *child;
-	struct hlist_node *tmp;
 	int ret = -EINVAL;;
 
 	if (!clk || !pdentry)
@@ -233,7 +228,7 @@ static int clk_debug_create_subtree(stru
 	if (ret)
 		goto out;
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+	hlist_for_each_entry(child, &clk->children, child_node)
 		clk_debug_create_subtree(child, clk->dentry);
 
 	ret = 0;
@@ -299,7 +294,6 @@ out:
 static int __init clk_debug_init(void)
 {
 	struct clk *clk;
-	struct hlist_node *tmp;
 	struct dentry *d;
 
 	rootdir = debugfs_create_dir("clk", NULL);
@@ -324,10 +318,10 @@ static int __init clk_debug_init(void)
 
 	mutex_lock(&prepare_lock);
 
-	hlist_for_each_entry(clk, tmp, &clk_root_list, child_node)
+	hlist_for_each_entry(clk, &clk_root_list, child_node)
 		clk_debug_create_subtree(clk, rootdir);
 
-	hlist_for_each_entry(clk, tmp, &clk_orphan_list, child_node)
+	hlist_for_each_entry(clk, &clk_orphan_list, child_node)
 		clk_debug_create_subtree(clk, orphandir);
 
 	inited = 1;
@@ -345,13 +339,12 @@ static inline int clk_debug_register(str
 static void clk_disable_unused_subtree(struct clk *clk)
 {
 	struct clk *child;
-	struct hlist_node *tmp;
 	unsigned long flags;
 
 	if (!clk)
 		goto out;
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+	hlist_for_each_entry(child, &clk->children, child_node)
 		clk_disable_unused_subtree(child);
 
 	spin_lock_irqsave(&enable_lock, flags);
@@ -384,14 +377,13 @@ out:
 static int clk_disable_unused(void)
 {
 	struct clk *clk;
-	struct hlist_node *tmp;
 
 	mutex_lock(&prepare_lock);
 
-	hlist_for_each_entry(clk, tmp, &clk_root_list, child_node)
+	hlist_for_each_entry(clk, &clk_root_list, child_node)
 		clk_disable_unused_subtree(clk);
 
-	hlist_for_each_entry(clk, tmp, &clk_orphan_list, child_node)
+	hlist_for_each_entry(clk, &clk_orphan_list, child_node)
 		clk_disable_unused_subtree(clk);
 
 	mutex_unlock(&prepare_lock);
@@ -484,12 +476,11 @@ static struct clk *__clk_lookup_subtree(
 {
 	struct clk *child;
 	struct clk *ret;
-	struct hlist_node *tmp;
 
 	if (!strcmp(clk->name, name))
 		return clk;
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+	hlist_for_each_entry(child, &clk->children, child_node) {
 		ret = __clk_lookup_subtree(name, child);
 		if (ret)
 			return ret;
@@ -502,20 +493,19 @@ struct clk *__clk_lookup(const char *nam
 {
 	struct clk *root_clk;
 	struct clk *ret;
-	struct hlist_node *tmp;
 
 	if (!name)
 		return NULL;
 
 	/* search the 'proper' clk tree first */
-	hlist_for_each_entry(root_clk, tmp, &clk_root_list, child_node) {
+	hlist_for_each_entry(root_clk, &clk_root_list, child_node) {
 		ret = __clk_lookup_subtree(name, root_clk);
 		if (ret)
 			return ret;
 	}
 
 	/* if not found, then search the orphan tree */
-	hlist_for_each_entry(root_clk, tmp, &clk_orphan_list, child_node) {
+	hlist_for_each_entry(root_clk, &clk_orphan_list, child_node) {
 		ret = __clk_lookup_subtree(name, root_clk);
 		if (ret)
 			return ret;
@@ -812,7 +802,6 @@ static void __clk_recalc_rates(struct cl
 {
 	unsigned long old_rate;
 	unsigned long parent_rate = 0;
-	struct hlist_node *tmp;
 	struct clk *child;
 
 	old_rate = clk->rate;
@@ -832,7 +821,7 @@ static void __clk_recalc_rates(struct cl
 	if (clk->notifier_count && msg)
 		__clk_notify(clk, msg, old_rate, clk->rate);
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+	hlist_for_each_entry(child, &clk->children, child_node)
 		__clk_recalc_rates(child, msg);
 }
 
@@ -878,7 +867,6 @@ EXPORT_SYMBOL_GPL(clk_get_rate);
  */
 static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
 {
-	struct hlist_node *tmp;
 	struct clk *child;
 	unsigned long new_rate;
 	int ret = NOTIFY_DONE;
@@ -895,7 +883,7 @@ static int __clk_speculate_rates(struct 
 	if (ret == NOTIFY_BAD)
 		goto out;
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+	hlist_for_each_entry(child, &clk->children, child_node) {
 		ret = __clk_speculate_rates(child, new_rate);
 		if (ret == NOTIFY_BAD)
 			break;
@@ -908,11 +896,10 @@ out:
 static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
 {
 	struct clk *child;
-	struct hlist_node *tmp;
 
 	clk->new_rate = new_rate;
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+	hlist_for_each_entry(child, &clk->children, child_node) {
 		if (child->ops->recalc_rate)
 			child->new_rate = child->ops->recalc_rate(child->hw, new_rate);
 		else
@@ -983,7 +970,6 @@ out:
  */
 static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
 {
-	struct hlist_node *tmp;
 	struct clk *child, *fail_clk = NULL;
 	int ret = NOTIFY_DONE;
 
@@ -996,7 +982,7 @@ static struct clk *clk_propagate_rate_ch
 			fail_clk = clk;
 	}
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+	hlist_for_each_entry(child, &clk->children, child_node) {
 		clk = clk_propagate_rate_change(child, event);
 		if (clk)
 			fail_clk = clk;
@@ -1014,7 +1000,6 @@ static void clk_change_rate(struct clk *
 	struct clk *child;
 	unsigned long old_rate;
 	unsigned long best_parent_rate = 0;
-	struct hlist_node *tmp;
 
 	old_rate = clk->rate;
 
@@ -1032,7 +1017,7 @@ static void clk_change_rate(struct clk *
 	if (clk->notifier_count && old_rate != clk->rate)
 		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+	hlist_for_each_entry(child, &clk->children, child_node)
 		clk_change_rate(child);
 }
 
@@ -1348,7 +1333,7 @@ int __clk_init(struct device *dev, struc
 {
 	int i, ret = 0;
 	struct clk *orphan;
-	struct hlist_node *tmp, *tmp2;
+	struct hlist_node *tmp2;
 
 	if (!clk)
 		return -EINVAL;
@@ -1448,7 +1433,7 @@ int __clk_init(struct device *dev, struc
 	 * walk the list of orphan clocks and reparent any that are children of
 	 * this clock
 	 */
-	hlist_for_each_entry_safe(orphan, tmp, tmp2, &clk_orphan_list, child_node) {
+	hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
 		if (orphan->ops->get_parent) {
 			i = orphan->ops->get_parent(orphan->hw);
 			if (!strcmp(clk->name, orphan->parent_names[i]))
diff -puN drivers/gpu/drm/drm_hashtab.c~hlist-drop-the-node-parameter-from-iterators drivers/gpu/drm/drm_hashtab.c
--- a/drivers/gpu/drm/drm_hashtab.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/gpu/drm/drm_hashtab.c
@@ -60,14 +60,13 @@ void drm_ht_verbose_list(struct drm_open
 {
 	struct drm_hash_item *entry;
 	struct hlist_head *h_list;
-	struct hlist_node *list;
 	unsigned int hashed_key;
 	int count = 0;
 
 	hashed_key = hash_long(key, ht->order);
 	DRM_DEBUG("Key is 0x%08lx, Hashed key is 0x%08x\n", key, hashed_key);
 	h_list = &ht->table[hashed_key];
-	hlist_for_each_entry(entry, list, h_list, head)
+	hlist_for_each_entry(entry, h_list, head)
 		DRM_DEBUG("count %d, key: 0x%08lx\n", count++, entry->key);
 }
 
@@ -76,14 +75,13 @@ static struct hlist_node *drm_ht_find_ke
 {
 	struct drm_hash_item *entry;
 	struct hlist_head *h_list;
-	struct hlist_node *list;
 	unsigned int hashed_key;
 
 	hashed_key = hash_long(key, ht->order);
 	h_list = &ht->table[hashed_key];
-	hlist_for_each_entry(entry, list, h_list, head) {
+	hlist_for_each_entry(entry, h_list, head) {
 		if (entry->key == key)
-			return list;
+			return &entry->head;
 		if (entry->key > key)
 			break;
 	}
@@ -95,14 +93,13 @@ static struct hlist_node *drm_ht_find_ke
 {
 	struct drm_hash_item *entry;
 	struct hlist_head *h_list;
-	struct hlist_node *list;
 	unsigned int hashed_key;
 
 	hashed_key = hash_long(key, ht->order);
 	h_list = &ht->table[hashed_key];
-	hlist_for_each_entry_rcu(entry, list, h_list, head) {
+	hlist_for_each_entry_rcu(entry, h_list, head) {
 		if (entry->key == key)
-			return list;
+			return &entry->head;
 		if (entry->key > key)
 			break;
 	}
@@ -113,19 +110,19 @@ int drm_ht_insert_item(struct drm_open_h
 {
 	struct drm_hash_item *entry;
 	struct hlist_head *h_list;
-	struct hlist_node *list, *parent;
+	struct hlist_node *parent;
 	unsigned int hashed_key;
 	unsigned long key = item->key;
 
 	hashed_key = hash_long(key, ht->order);
 	h_list = &ht->table[hashed_key];
 	parent = NULL;
-	hlist_for_each_entry(entry, list, h_list, head) {
+	hlist_for_each_entry(entry, h_list, head) {
 		if (entry->key == key)
 			return -EINVAL;
 		if (entry->key > key)
 			break;
-		parent = list;
+		parent = &entry->head;
 	}
 	if (parent) {
 		hlist_add_after_rcu(parent, &item->head);
diff -puN drivers/infiniband/core/cma.c~hlist-drop-the-node-parameter-from-iterators drivers/infiniband/core/cma.c
--- a/drivers/infiniband/core/cma.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/infiniband/core/cma.c
@@ -2204,10 +2204,9 @@ static int cma_check_port(struct rdma_bi
 {
 	struct rdma_id_private *cur_id;
 	struct sockaddr *addr, *cur_addr;
-	struct hlist_node *node;
 
 	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
-	hlist_for_each_entry(cur_id, node, &bind_list->owners, node) {
+	hlist_for_each_entry(cur_id, &bind_list->owners, node) {
 		if (id_priv == cur_id)
 			continue;
 
diff -puN drivers/infiniband/core/fmr_pool.c~hlist-drop-the-node-parameter-from-iterators drivers/infiniband/core/fmr_pool.c
--- a/drivers/infiniband/core/fmr_pool.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/infiniband/core/fmr_pool.c
@@ -118,14 +118,13 @@ static inline struct ib_pool_fmr *ib_fmr
 {
 	struct hlist_head *bucket;
 	struct ib_pool_fmr *fmr;
-	struct hlist_node *pos;
 
 	if (!pool->cache_bucket)
 		return NULL;
 
 	bucket = pool->cache_bucket + ib_fmr_hash(*page_list);
 
-	hlist_for_each_entry(fmr, pos, bucket, cache_node)
+	hlist_for_each_entry(fmr, bucket, cache_node)
 		if (io_virtual_address == fmr->io_virtual_address &&
 		    page_list_len      == fmr->page_list_len      &&
 		    !memcmp(page_list, fmr->page_list,
diff -puN drivers/isdn/mISDN/socket.c~hlist-drop-the-node-parameter-from-iterators drivers/isdn/mISDN/socket.c
--- a/drivers/isdn/mISDN/socket.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/isdn/mISDN/socket.c
@@ -483,7 +483,6 @@ data_sock_bind(struct socket *sock, stru
 {
 	struct sockaddr_mISDN *maddr = (struct sockaddr_mISDN *) addr;
 	struct sock *sk = sock->sk;
-	struct hlist_node *node;
 	struct sock *csk;
 	int err = 0;
 
@@ -508,7 +507,7 @@ data_sock_bind(struct socket *sock, stru
 
 	if (sk->sk_protocol < ISDN_P_B_START) {
 		read_lock_bh(&data_sockets.lock);
-		sk_for_each(csk, node, &data_sockets.head) {
+		sk_for_each(csk, &data_sockets.head) {
 			if (sk == csk)
 				continue;
 			if (_pms(csk)->dev != _pms(sk)->dev)
diff -puN drivers/isdn/mISDN/stack.c~hlist-drop-the-node-parameter-from-iterators drivers/isdn/mISDN/stack.c
--- a/drivers/isdn/mISDN/stack.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/isdn/mISDN/stack.c
@@ -64,12 +64,11 @@ unlock:
 static void
 send_socklist(struct mISDN_sock_list *sl, struct sk_buff *skb)
 {
-	struct hlist_node	*node;
 	struct sock		*sk;
 	struct sk_buff		*cskb = NULL;
 
 	read_lock(&sl->lock);
-	sk_for_each(sk, node, &sl->head) {
+	sk_for_each(sk, &sl->head) {
 		if (sk->sk_state != MISDN_BOUND)
 			continue;
 		if (!cskb)
diff -puN drivers/md/dm-bio-prison.c~hlist-drop-the-node-parameter-from-iterators drivers/md/dm-bio-prison.c
--- a/drivers/md/dm-bio-prison.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/md/dm-bio-prison.c
@@ -106,9 +106,8 @@ static struct dm_bio_prison_cell *__sear
 						  struct dm_cell_key *key)
 {
 	struct dm_bio_prison_cell *cell;
-	struct hlist_node *tmp;
 
-	hlist_for_each_entry(cell, tmp, bucket, list)
+	hlist_for_each_entry(cell, bucket, list)
 		if (keys_equal(&cell->key, key))
 			return cell;
 
diff -puN drivers/md/dm-bufio.c~hlist-drop-the-node-parameter-from-iterators drivers/md/dm-bufio.c
--- a/drivers/md/dm-bufio.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/md/dm-bufio.c
@@ -859,9 +859,8 @@ static void __check_watermark(struct dm_
 static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t block)
 {
 	struct dm_buffer *b;
-	struct hlist_node *hn;
 
-	hlist_for_each_entry(b, hn, &c->cache_hash[DM_BUFIO_HASH(block)],
+	hlist_for_each_entry(b, &c->cache_hash[DM_BUFIO_HASH(block)],
 			     hash_list) {
 		dm_bufio_cond_resched();
 		if (b->block == block)
diff -puN drivers/md/dm-snap.c~hlist-drop-the-node-parameter-from-iterators drivers/md/dm-snap.c
--- a/drivers/md/dm-snap.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/md/dm-snap.c
@@ -227,12 +227,11 @@ static void stop_tracking_chunk(struct d
 static int __chunk_is_tracked(struct dm_snapshot *s, chunk_t chunk)
 {
 	struct dm_snap_tracked_chunk *c;
-	struct hlist_node *hn;
 	int found = 0;
 
 	spin_lock_irq(&s->tracked_chunk_lock);
 
-	hlist_for_each_entry(c, hn,
+	hlist_for_each_entry(c,
 	    &s->tracked_chunk_hash[DM_TRACKED_CHUNK_HASH(chunk)], node) {
 		if (c->chunk == chunk) {
 			found = 1;
diff -puN drivers/md/persistent-data/dm-transaction-manager.c~hlist-drop-the-node-parameter-from-iterators drivers/md/persistent-data/dm-transaction-manager.c
--- a/drivers/md/persistent-data/dm-transaction-manager.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/md/persistent-data/dm-transaction-manager.c
@@ -46,10 +46,9 @@ static int is_shadow(struct dm_transacti
 	int r = 0;
 	unsigned bucket = dm_hash_block(b, DM_HASH_MASK);
 	struct shadow_info *si;
-	struct hlist_node *n;
 
 	spin_lock(&tm->lock);
-	hlist_for_each_entry(si, n, tm->buckets + bucket, hlist)
+	hlist_for_each_entry(si, tm->buckets + bucket, hlist)
 		if (si->where == b) {
 			r = 1;
 			break;
@@ -81,14 +80,14 @@ static void insert_shadow(struct dm_tran
 static void wipe_shadow_table(struct dm_transaction_manager *tm)
 {
 	struct shadow_info *si;
-	struct hlist_node *n, *tmp;
+	struct hlist_node *tmp;
 	struct hlist_head *bucket;
 	int i;
 
 	spin_lock(&tm->lock);
 	for (i = 0; i < DM_HASH_SIZE; i++) {
 		bucket = tm->buckets + i;
-		hlist_for_each_entry_safe(si, n, tmp, bucket, hlist)
+		hlist_for_each_entry_safe(si, tmp, bucket, hlist)
 			kfree(si);
 
 		INIT_HLIST_HEAD(bucket);
diff -puN drivers/md/raid5.c~hlist-drop-the-node-parameter-from-iterators drivers/md/raid5.c
--- a/drivers/md/raid5.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/md/raid5.c
@@ -365,10 +365,9 @@ static struct stripe_head *__find_stripe
 					 short generation)
 {
 	struct stripe_head *sh;
-	struct hlist_node *hn;
 
 	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
-	hlist_for_each_entry(sh, hn, stripe_hash(conf, sector), hash)
+	hlist_for_each_entry(sh, stripe_hash(conf, sector), hash)
 		if (sh->sector == sector && sh->generation == generation)
 			return sh;
 	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);
diff -puN drivers/misc/sgi-gru/grutlbpurge.c~hlist-drop-the-node-parameter-from-iterators drivers/misc/sgi-gru/grutlbpurge.c
--- a/drivers/misc/sgi-gru/grutlbpurge.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/misc/sgi-gru/grutlbpurge.c
@@ -280,11 +280,10 @@ static struct mmu_notifier *mmu_find_ops
 			const struct mmu_notifier_ops *ops)
 {
 	struct mmu_notifier *mn, *gru_mn = NULL;
-	struct hlist_node *n;
 
 	if (mm->mmu_notifier_mm) {
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list,
+		hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list,
 					 hlist)
 		    if (mn->ops == ops) {
 			gru_mn = mn;
diff -puN drivers/misc/vmw_vmci/vmci_doorbell.c~hlist-drop-the-node-parameter-from-iterators drivers/misc/vmw_vmci/vmci_doorbell.c
--- a/drivers/misc/vmw_vmci/vmci_doorbell.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/misc/vmw_vmci/vmci_doorbell.c
@@ -127,9 +127,8 @@ static struct dbell_entry *dbell_index_t
 {
 	u32 bucket = VMCI_DOORBELL_HASH(idx);
 	struct dbell_entry *dbell;
-	struct hlist_node *node;
 
-	hlist_for_each_entry(dbell, node, &vmci_doorbell_it.entries[bucket],
+	hlist_for_each_entry(dbell, &vmci_doorbell_it.entries[bucket],
 			     node) {
 		if (idx == dbell->idx)
 			return dbell;
@@ -359,12 +358,10 @@ static void dbell_fire_entries(u32 notif
 {
 	u32 bucket = VMCI_DOORBELL_HASH(notify_idx);
 	struct dbell_entry *dbell;
-	struct hlist_node *node;
 
 	spin_lock_bh(&vmci_doorbell_it.lock);
 
-	hlist_for_each_entry(dbell, node,
-			     &vmci_doorbell_it.entries[bucket], node) {
+	hlist_for_each_entry(dbell, &vmci_doorbell_it.entries[bucket], node) {
 		if (dbell->idx == notify_idx &&
 		    atomic_read(&dbell->active) == 1) {
 			if (dbell->run_delayed) {
diff -puN drivers/misc/vmw_vmci/vmci_resource.c~hlist-drop-the-node-parameter-from-iterators drivers/misc/vmw_vmci/vmci_resource.c
--- a/drivers/misc/vmw_vmci/vmci_resource.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/misc/vmw_vmci/vmci_resource.c
@@ -46,11 +46,10 @@ static struct vmci_resource *vmci_resour
 						  enum vmci_resource_type type)
 {
 	struct vmci_resource *r, *resource = NULL;
-	struct hlist_node *node;
 	unsigned int idx = vmci_resource_hash(handle);
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(r, node,
+	hlist_for_each_entry_rcu(r,
 				 &vmci_resource_table.entries[idx], node) {
 		u32 cid = r->handle.context;
 		u32 rid = r->handle.resource;
@@ -146,12 +145,11 @@ void vmci_resource_remove(struct vmci_re
 	struct vmci_handle handle = resource->handle;
 	unsigned int idx = vmci_resource_hash(handle);
 	struct vmci_resource *r;
-	struct hlist_node *node;
 
 	/* Remove resource from hash table. */
 	spin_lock(&vmci_resource_table.lock);
 
-	hlist_for_each_entry(r, node, &vmci_resource_table.entries[idx], node) {
+	hlist_for_each_entry(r, &vmci_resource_table.entries[idx], node) {
 		if (vmci_handle_is_equal(r->handle, resource->handle)) {
 			hlist_del_init_rcu(&r->node);
 			break;
diff -puN drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c~hlist-drop-the-node-parameter-from-iterators drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2197,13 +2197,13 @@ static int ixgbe_get_ethtool_fdir_entry(
 	union ixgbe_atr_input *mask = &adapter->fdir_mask;
 	struct ethtool_rx_flow_spec *fsp =
 		(struct ethtool_rx_flow_spec *)&cmd->fs;
-	struct hlist_node *node, *node2;
+	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *rule = NULL;
 
 	/* report total rule count */
 	cmd->data = (1024 << adapter->fdir_pballoc) - 2;
 
-	hlist_for_each_entry_safe(rule, node, node2,
+	hlist_for_each_entry_safe(rule, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
 		if (fsp->location <= rule->sw_idx)
 			break;
@@ -2264,14 +2264,14 @@ static int ixgbe_get_ethtool_fdir_all(st
 				      struct ethtool_rxnfc *cmd,
 				      u32 *rule_locs)
 {
-	struct hlist_node *node, *node2;
+	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *rule;
 	int cnt = 0;
 
 	/* report total rule count */
 	cmd->data = (1024 << adapter->fdir_pballoc) - 2;
 
-	hlist_for_each_entry_safe(rule, node, node2,
+	hlist_for_each_entry_safe(rule, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
 		if (cnt == cmd->rule_cnt)
 			return -EMSGSIZE;
@@ -2358,19 +2358,19 @@ static int ixgbe_update_ethtool_fdir_ent
 					   u16 sw_idx)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
-	struct hlist_node *node, *node2, *parent;
-	struct ixgbe_fdir_filter *rule;
+	struct hlist_node *node2;
+	struct ixgbe_fdir_filter *rule, *parent;
 	int err = -EINVAL;
 
 	parent = NULL;
 	rule = NULL;
 
-	hlist_for_each_entry_safe(rule, node, node2,
+	hlist_for_each_entry_safe(rule, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
 		/* hash found, or no matching entry */
 		if (rule->sw_idx >= sw_idx)
 			break;
-		parent = node;
+		parent = rule;
 	}
 
 	/* if there is an old rule occupying our place remove it */
@@ -2399,7 +2399,7 @@ static int ixgbe_update_ethtool_fdir_ent
 
 	/* add filter to the list */
 	if (parent)
-		hlist_add_after(parent, &input->fdir_node);
+		hlist_add_after(&parent->fdir_node, &input->fdir_node);
 	else
 		hlist_add_head(&input->fdir_node,
 			       &adapter->fdir_filter_list);
diff -puN drivers/net/ethernet/intel/ixgbe/ixgbe_main.c~hlist-drop-the-node-parameter-from-iterators drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -3891,7 +3891,7 @@ static void ixgbe_configure_pb(struct ix
 static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
-	struct hlist_node *node, *node2;
+	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *filter;
 
 	spin_lock(&adapter->fdir_perfect_lock);
@@ -3899,7 +3899,7 @@ static void ixgbe_fdir_filter_restore(st
 	if (!hlist_empty(&adapter->fdir_filter_list))
 		ixgbe_fdir_set_input_mask_82599(hw, &adapter->fdir_mask);
 
-	hlist_for_each_entry_safe(filter, node, node2,
+	hlist_for_each_entry_safe(filter, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
 		ixgbe_fdir_write_perfect_filter_82599(hw,
 				&filter->filter,
@@ -4356,12 +4356,12 @@ static void ixgbe_clean_all_tx_rings(str
 
 static void ixgbe_fdir_filter_exit(struct ixgbe_adapter *adapter)
 {
-	struct hlist_node *node, *node2;
+	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *filter;
 
 	spin_lock(&adapter->fdir_perfect_lock);
 
-	hlist_for_each_entry_safe(filter, node, node2,
+	hlist_for_each_entry_safe(filter, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
 		hlist_del(&filter->fdir_node);
 		kfree(filter);
diff -puN drivers/net/ethernet/mellanox/mlx4/en_netdev.c~hlist-drop-the-node-parameter-from-iterators drivers/net/ethernet/mellanox/mlx4/en_netdev.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -225,11 +225,10 @@ static inline struct mlx4_en_filter *
 mlx4_en_filter_find(struct mlx4_en_priv *priv, __be32 src_ip, __be32 dst_ip,
 		    __be16 src_port, __be16 dst_port)
 {
-	struct hlist_node *elem;
 	struct mlx4_en_filter *filter;
 	struct mlx4_en_filter *ret = NULL;
 
-	hlist_for_each_entry(filter, elem,
+	hlist_for_each_entry(filter,
 			     filter_hash_bucket(priv, src_ip, dst_ip,
 						src_port, dst_port),
 			     filter_chain) {
@@ -574,13 +573,13 @@ static void mlx4_en_put_qp(struct mlx4_e
 
 	if (dev->caps.steering_mode != MLX4_STEERING_MODE_A0) {
 		struct mlx4_mac_entry *entry;
-		struct hlist_node *n, *tmp;
+		struct hlist_node *tmp;
 		struct hlist_head *bucket;
 		unsigned int mac_hash;
 
 		mac_hash = priv->dev->dev_addr[MLX4_EN_MAC_HASH_IDX];
 		bucket = &priv->mac_hash[mac_hash];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac,
 						    priv->dev->dev_addr)) {
 				en_dbg(DRV, priv, "Releasing qp: port %d, MAC %pM, qpn %d\n",
@@ -609,11 +608,11 @@ static int mlx4_en_replace_mac(struct ml
 		struct hlist_head *bucket;
 		unsigned int mac_hash;
 		struct mlx4_mac_entry *entry;
-		struct hlist_node *n, *tmp;
+		struct hlist_node *tmp;
 		u64 prev_mac_u64 = mlx4_en_mac_to_u64(prev_mac);
 
 		bucket = &priv->mac_hash[prev_mac[MLX4_EN_MAC_HASH_IDX]];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac, prev_mac)) {
 				mlx4_en_uc_steer_release(priv, entry->mac,
 							 qpn, entry->reg_id);
@@ -1019,7 +1018,7 @@ static void mlx4_en_do_uc_filter(struct 
 {
 	struct netdev_hw_addr *ha;
 	struct mlx4_mac_entry *entry;
-	struct hlist_node *n, *tmp;
+	struct hlist_node *tmp;
 	bool found;
 	u64 mac;
 	int err = 0;
@@ -1035,7 +1034,7 @@ static void mlx4_en_do_uc_filter(struct 
 	/* find what to remove */
 	for (i = 0; i < MLX4_EN_MAC_HASH_SIZE; ++i) {
 		bucket = &priv->mac_hash[i];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			found = false;
 			netdev_for_each_uc_addr(ha, dev) {
 				if (ether_addr_equal_64bits(entry->mac,
@@ -1078,7 +1077,7 @@ static void mlx4_en_do_uc_filter(struct 
 	netdev_for_each_uc_addr(ha, dev) {
 		found = false;
 		bucket = &priv->mac_hash[ha->addr[MLX4_EN_MAC_HASH_IDX]];
-		hlist_for_each_entry(entry, n, bucket, hlist) {
+		hlist_for_each_entry(entry, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac, ha->addr)) {
 				found = true;
 				break;
diff -puN drivers/net/ethernet/mellanox/mlx4/en_rx.c~hlist-drop-the-node-parameter-from-iterators drivers/net/ethernet/mellanox/mlx4/en_rx.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/mlx4/qp.h>
 #include <linux/skbuff.h>
+#include <linux/rculist.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
@@ -617,7 +618,6 @@ int mlx4_en_process_rx_cq(struct net_dev
 
 			if (is_multicast_ether_addr(ethh->h_dest)) {
 				struct mlx4_mac_entry *entry;
-				struct hlist_node *n;
 				struct hlist_head *bucket;
 				unsigned int mac_hash;
 
@@ -625,7 +625,7 @@ int mlx4_en_process_rx_cq(struct net_dev
 				mac_hash = ethh->h_source[MLX4_EN_MAC_HASH_IDX];
 				bucket = &priv->mac_hash[mac_hash];
 				rcu_read_lock();
-				hlist_for_each_entry_rcu(entry, n, bucket, hlist) {
+				hlist_for_each_entry_rcu(entry, bucket, hlist) {
 					if (ether_addr_equal_64bits(entry->mac,
 								    ethh->h_source)) {
 						rcu_read_unlock();
diff -puN drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c~hlist-drop-the-node-parameter-from-iterators drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -576,7 +576,7 @@ void qlcnic_free_mac_list(struct qlcnic_
 void qlcnic_prune_lb_filters(struct qlcnic_adapter *adapter)
 {
 	struct qlcnic_filter *tmp_fil;
-	struct hlist_node *tmp_hnode, *n;
+	struct hlist_node *n;
 	struct hlist_head *head;
 	int i;
 	unsigned long time;
@@ -584,7 +584,7 @@ void qlcnic_prune_lb_filters(struct qlcn
 
 	for (i = 0; i < adapter->fhash.fbucket_size; i++) {
 		head = &(adapter->fhash.fhead[i]);
-		hlist_for_each_entry_safe(tmp_fil, tmp_hnode, n, head, fnode) {
+		hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 			cmd =  tmp_fil->vlan_id ? QLCNIC_MAC_VLAN_DEL :
 						  QLCNIC_MAC_DEL;
 			time = tmp_fil->ftime;
@@ -604,7 +604,7 @@ void qlcnic_prune_lb_filters(struct qlcn
 	for (i = 0; i < adapter->rx_fhash.fbucket_size; i++) {
 		head = &(adapter->rx_fhash.fhead[i]);
 
-		hlist_for_each_entry_safe(tmp_fil, tmp_hnode, n, head, fnode)
+		hlist_for_each_entry_safe(tmp_fil, n, head, fnode)
 		{
 			time = tmp_fil->ftime;
 			if (jiffies > (QLCNIC_FILTER_AGE * HZ + time)) {
@@ -621,14 +621,14 @@ void qlcnic_prune_lb_filters(struct qlcn
 void qlcnic_delete_lb_filters(struct qlcnic_adapter *adapter)
 {
 	struct qlcnic_filter *tmp_fil;
-	struct hlist_node *tmp_hnode, *n;
+	struct hlist_node *n;
 	struct hlist_head *head;
 	int i;
 	u8 cmd;
 
 	for (i = 0; i < adapter->fhash.fbucket_size; i++) {
 		head = &(adapter->fhash.fhead[i]);
-		hlist_for_each_entry_safe(tmp_fil, tmp_hnode, n, head, fnode) {
+		hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 			cmd =  tmp_fil->vlan_id ? QLCNIC_MAC_VLAN_DEL :
 						  QLCNIC_MAC_DEL;
 			qlcnic_sre_macaddr_change(adapter,
diff -puN drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c~hlist-drop-the-node-parameter-from-iterators drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -162,7 +162,7 @@ void qlcnic_add_lb_filter(struct qlcnic_
 {
 	struct ethhdr *phdr = (struct ethhdr *)(skb->data);
 	struct qlcnic_filter *fil, *tmp_fil;
-	struct hlist_node *tmp_hnode, *n;
+	struct hlist_node *n;
 	struct hlist_head *head;
 	unsigned long time;
 	u64 src_addr = 0;
@@ -179,7 +179,7 @@ void qlcnic_add_lb_filter(struct qlcnic_
 			 (adapter->fhash.fbucket_size - 1);
 		head = &(adapter->rx_fhash.fhead[hindex]);
 
-		hlist_for_each_entry_safe(tmp_fil, tmp_hnode, n, head, fnode) {
+		hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 			if (!memcmp(tmp_fil->faddr, &src_addr, ETH_ALEN) &&
 			    tmp_fil->vlan_id == vlan_id) {
 				time = tmp_fil->ftime;
@@ -205,7 +205,7 @@ void qlcnic_add_lb_filter(struct qlcnic_
 			 (adapter->fhash.fbucket_size - 1);
 		head = &(adapter->rx_fhash.fhead[hindex]);
 		spin_lock(&adapter->rx_mac_learn_lock);
-		hlist_for_each_entry_safe(tmp_fil, tmp_hnode, n, head, fnode) {
+		hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 			if (!memcmp(tmp_fil->faddr, &src_addr, ETH_ALEN) &&
 			    tmp_fil->vlan_id == vlan_id) {
 				found = 1;
@@ -272,7 +272,7 @@ static void qlcnic_send_filter(struct ql
 			       struct sk_buff *skb)
 {
 	struct qlcnic_filter *fil, *tmp_fil;
-	struct hlist_node *tmp_hnode, *n;
+	struct hlist_node *n;
 	struct hlist_head *head;
 	struct net_device *netdev = adapter->netdev;
 	struct ethhdr *phdr = (struct ethhdr *)(skb->data);
@@ -294,7 +294,7 @@ static void qlcnic_send_filter(struct ql
 	hindex = qlcnic_mac_hash(src_addr) & (adapter->fhash.fbucket_size - 1);
 	head = &(adapter->fhash.fhead[hindex]);
 
-	hlist_for_each_entry_safe(tmp_fil, tmp_hnode, n, head, fnode) {
+	hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 		if (!memcmp(tmp_fil->faddr, &src_addr, ETH_ALEN) &&
 		    tmp_fil->vlan_id == vlan_id) {
 			if (jiffies > (QLCNIC_READD_AGE * HZ + tmp_fil->ftime))
diff -puN drivers/net/ethernet/sun/sunvnet.c~hlist-drop-the-node-parameter-from-iterators drivers/net/ethernet/sun/sunvnet.c
--- a/drivers/net/ethernet/sun/sunvnet.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/ethernet/sun/sunvnet.c
@@ -614,10 +614,9 @@ struct vnet_port *__tx_port_find(struct 
 {
 	unsigned int hash = vnet_hashfn(skb->data);
 	struct hlist_head *hp = &vp->port_hash[hash];
-	struct hlist_node *n;
 	struct vnet_port *port;
 
-	hlist_for_each_entry(port, n, hp, hash) {
+	hlist_for_each_entry(port, hp, hash) {
 		if (ether_addr_equal(port->raddr, skb->data))
 			return port;
 	}
diff -puN drivers/net/macvlan.c~hlist-drop-the-node-parameter-from-iterators drivers/net/macvlan.c
--- a/drivers/net/macvlan.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/macvlan.c
@@ -55,9 +55,8 @@ static struct macvlan_dev *macvlan_hash_
 					       const unsigned char *addr)
 {
 	struct macvlan_dev *vlan;
-	struct hlist_node *n;
 
-	hlist_for_each_entry_rcu(vlan, n, &port->vlan_hash[addr[5]], hlist) {
+	hlist_for_each_entry_rcu(vlan, &port->vlan_hash[addr[5]], hlist) {
 		if (ether_addr_equal_64bits(vlan->dev->dev_addr, addr))
 			return vlan;
 	}
@@ -149,7 +148,6 @@ static void macvlan_broadcast(struct sk_
 {
 	const struct ethhdr *eth = eth_hdr(skb);
 	const struct macvlan_dev *vlan;
-	struct hlist_node *n;
 	struct sk_buff *nskb;
 	unsigned int i;
 	int err;
@@ -159,7 +157,7 @@ static void macvlan_broadcast(struct sk_
 		return;
 
 	for (i = 0; i < MACVLAN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(vlan, n, &port->vlan_hash[i], hlist) {
+		hlist_for_each_entry_rcu(vlan, &port->vlan_hash[i], hlist) {
 			if (vlan->dev == src || !(vlan->mode & mode))
 				continue;
 
diff -puN drivers/net/tun.c~hlist-drop-the-node-parameter-from-iterators drivers/net/tun.c
--- a/drivers/net/tun.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/tun.c
@@ -197,9 +197,8 @@ static inline u32 tun_hashfn(u32 rxhash)
 static struct tun_flow_entry *tun_flow_find(struct hlist_head *head, u32 rxhash)
 {
 	struct tun_flow_entry *e;
-	struct hlist_node *n;
 
-	hlist_for_each_entry_rcu(e, n, head, hash_link) {
+	hlist_for_each_entry_rcu(e, head, hash_link) {
 		if (e->rxhash == rxhash)
 			return e;
 	}
@@ -241,9 +240,9 @@ static void tun_flow_flush(struct tun_st
 	spin_lock_bh(&tun->lock);
 	for (i = 0; i < TUN_NUM_FLOW_ENTRIES; i++) {
 		struct tun_flow_entry *e;
-		struct hlist_node *h, *n;
+		struct hlist_node *n;
 
-		hlist_for_each_entry_safe(e, h, n, &tun->flows[i], hash_link)
+		hlist_for_each_entry_safe(e, n, &tun->flows[i], hash_link)
 			tun_flow_delete(tun, e);
 	}
 	spin_unlock_bh(&tun->lock);
@@ -256,9 +255,9 @@ static void tun_flow_delete_by_queue(str
 	spin_lock_bh(&tun->lock);
 	for (i = 0; i < TUN_NUM_FLOW_ENTRIES; i++) {
 		struct tun_flow_entry *e;
-		struct hlist_node *h, *n;
+		struct hlist_node *n;
 
-		hlist_for_each_entry_safe(e, h, n, &tun->flows[i], hash_link) {
+		hlist_for_each_entry_safe(e, n, &tun->flows[i], hash_link) {
 			if (e->queue_index == queue_index)
 				tun_flow_delete(tun, e);
 		}
@@ -279,9 +278,9 @@ static void tun_flow_cleanup(unsigned lo
 	spin_lock_bh(&tun->lock);
 	for (i = 0; i < TUN_NUM_FLOW_ENTRIES; i++) {
 		struct tun_flow_entry *e;
-		struct hlist_node *h, *n;
+		struct hlist_node *n;
 
-		hlist_for_each_entry_safe(e, h, n, &tun->flows[i], hash_link) {
+		hlist_for_each_entry_safe(e, n, &tun->flows[i], hash_link) {
 			unsigned long this_timer;
 			count++;
 			this_timer = e->updated + delay;
diff -puN drivers/net/vxlan.c~hlist-drop-the-node-parameter-from-iterators drivers/net/vxlan.c
--- a/drivers/net/vxlan.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/vxlan.c
@@ -145,9 +145,8 @@ static inline struct hlist_head *vni_hea
 static struct vxlan_dev *vxlan_find_vni(struct net *net, u32 id)
 {
 	struct vxlan_dev *vxlan;
-	struct hlist_node *node;
 
-	hlist_for_each_entry_rcu(vxlan, node, vni_head(net, id), hlist) {
+	hlist_for_each_entry_rcu(vxlan, vni_head(net, id), hlist) {
 		if (vxlan->vni == id)
 			return vxlan;
 	}
@@ -292,9 +291,8 @@ static struct vxlan_fdb *vxlan_find_mac(
 {
 	struct hlist_head *head = vxlan_fdb_head(vxlan, mac);
 	struct vxlan_fdb *f;
-	struct hlist_node *node;
 
-	hlist_for_each_entry_rcu(f, node, head, hlist) {
+	hlist_for_each_entry_rcu(f, head, hlist) {
 		if (compare_ether_addr(mac, f->eth_addr) == 0)
 			return f;
 	}
@@ -422,10 +420,9 @@ static int vxlan_fdb_dump(struct sk_buff
 
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
 		struct vxlan_fdb *f;
-		struct hlist_node *n;
 		int err;
 
-		hlist_for_each_entry_rcu(f, n, &vxlan->fdb_head[h], hlist) {
+		hlist_for_each_entry_rcu(f, &vxlan->fdb_head[h], hlist) {
 			if (idx < cb->args[0])
 				goto skip;
 
@@ -483,11 +480,10 @@ static bool vxlan_group_used(struct vxla
 			     const struct vxlan_dev *this)
 {
 	const struct vxlan_dev *vxlan;
-	struct hlist_node *node;
 	unsigned h;
 
 	for (h = 0; h < VNI_HASH_SIZE; ++h)
-		hlist_for_each_entry(vxlan, node, &vn->vni_list[h], hlist) {
+		hlist_for_each_entry(vxlan, &vn->vni_list[h], hlist) {
 			if (vxlan == this)
 				continue;
 
diff -puN drivers/net/wireless/zd1201.c~hlist-drop-the-node-parameter-from-iterators drivers/net/wireless/zd1201.c
--- a/drivers/net/wireless/zd1201.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/net/wireless/zd1201.c
@@ -309,7 +309,6 @@ static void zd1201_usbrx(struct urb *urb
 	if (data[urb->actual_length-1] == ZD1201_PACKET_RXDATA) {
 		int datalen = urb->actual_length-1;
 		unsigned short len, fc, seq;
-		struct hlist_node *node;
 
 		len = ntohs(*(__be16 *)&data[datalen-2]);
 		if (len>datalen)
@@ -362,7 +361,7 @@ static void zd1201_usbrx(struct urb *urb
 				hlist_add_head(&frag->fnode, &zd->fraglist);
 				goto resubmit;
 			}
-			hlist_for_each_entry(frag, node, &zd->fraglist, fnode)
+			hlist_for_each_entry(frag, &zd->fraglist, fnode)
 				if (frag->seq == (seq&IEEE80211_SCTL_SEQ))
 					break;
 			if (!frag)
@@ -1831,14 +1830,14 @@ err_zd:
 static void zd1201_disconnect(struct usb_interface *interface)
 {
 	struct zd1201 *zd = usb_get_intfdata(interface);
-	struct hlist_node *node, *node2;
+	struct hlist_node *node2;
 	struct zd1201_frag *frag;
 
 	if (!zd)
 		return;
 	usb_set_intfdata(interface, NULL);
 
-	hlist_for_each_entry_safe(frag, node, node2, &zd->fraglist, fnode) {
+	hlist_for_each_entry_safe(frag, node2, &zd->fraglist, fnode) {
 		hlist_del_init(&frag->fnode);
 		kfree_skb(frag->skb);
 		kfree(frag);
diff -puN drivers/pci/pci.c~hlist-drop-the-node-parameter-from-iterators drivers/pci/pci.c
--- a/drivers/pci/pci.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/pci/pci.c
@@ -842,9 +842,8 @@ static struct pci_cap_saved_state *pci_f
 	struct pci_dev *pci_dev, char cap)
 {
 	struct pci_cap_saved_state *tmp;
-	struct hlist_node *pos;
 
-	hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space, next) {
+	hlist_for_each_entry(tmp, &pci_dev->saved_cap_space, next) {
 		if (tmp->cap.cap_nr == cap)
 			return tmp;
 	}
@@ -1041,7 +1040,6 @@ struct pci_saved_state *pci_store_saved_
 	struct pci_saved_state *state;
 	struct pci_cap_saved_state *tmp;
 	struct pci_cap_saved_data *cap;
-	struct hlist_node *pos;
 	size_t size;
 
 	if (!dev->state_saved)
@@ -1049,7 +1047,7 @@ struct pci_saved_state *pci_store_saved_
 
 	size = sizeof(*state) + sizeof(struct pci_cap_saved_data);
 
-	hlist_for_each_entry(tmp, pos, &dev->saved_cap_space, next)
+	hlist_for_each_entry(tmp, &dev->saved_cap_space, next)
 		size += sizeof(struct pci_cap_saved_data) + tmp->cap.size;
 
 	state = kzalloc(size, GFP_KERNEL);
@@ -1060,7 +1058,7 @@ struct pci_saved_state *pci_store_saved_
 	       sizeof(state->config_space));
 
 	cap = state->cap;
-	hlist_for_each_entry(tmp, pos, &dev->saved_cap_space, next) {
+	hlist_for_each_entry(tmp, &dev->saved_cap_space, next) {
 		size_t len = sizeof(struct pci_cap_saved_data) + tmp->cap.size;
 		memcpy(cap, &tmp->cap, len);
 		cap = (struct pci_cap_saved_data *)((u8 *)cap + len);
@@ -2038,9 +2036,9 @@ void pci_allocate_cap_save_buffers(struc
 void pci_free_cap_save_buffers(struct pci_dev *dev)
 {
 	struct pci_cap_saved_state *tmp;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 
-	hlist_for_each_entry_safe(tmp, pos, n, &dev->saved_cap_space, next)
+	hlist_for_each_entry_safe(tmp, n, &dev->saved_cap_space, next)
 		kfree(tmp);
 }
 
diff -puN drivers/staging/android/binder.c~hlist-drop-the-node-parameter-from-iterators drivers/staging/android/binder.c
--- a/drivers/staging/android/binder.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/staging/android/binder.c
@@ -2880,7 +2880,6 @@ static int binder_release(struct inode *
 
 static void binder_deferred_release(struct binder_proc *proc)
 {
-	struct hlist_node *pos;
 	struct binder_transaction *t;
 	struct rb_node *n;
 	int threads, nodes, incoming_refs, outgoing_refs, buffers, active_transactions, page_count;
@@ -2924,7 +2923,7 @@ static void binder_deferred_release(stru
 			node->local_weak_refs = 0;
 			hlist_add_head(&node->dead_node, &binder_dead_nodes);
 
-			hlist_for_each_entry(ref, pos, &node->refs, node_entry) {
+			hlist_for_each_entry(ref, &node->refs, node_entry) {
 				incoming_refs++;
 				if (ref->death) {
 					death++;
@@ -3156,12 +3155,11 @@ static void print_binder_thread(struct s
 static void print_binder_node(struct seq_file *m, struct binder_node *node)
 {
 	struct binder_ref *ref;
-	struct hlist_node *pos;
 	struct binder_work *w;
 	int count;
 
 	count = 0;
-	hlist_for_each_entry(ref, pos, &node->refs, node_entry)
+	hlist_for_each_entry(ref, &node->refs, node_entry)
 		count++;
 
 	seq_printf(m, "  node %d: u%p c%p hs %d hw %d ls %d lw %d is %d iw %d",
@@ -3171,7 +3169,7 @@ static void print_binder_node(struct seq
 		   node->internal_strong_refs, count);
 	if (count) {
 		seq_puts(m, " proc");
-		hlist_for_each_entry(ref, pos, &node->refs, node_entry)
+		hlist_for_each_entry(ref, &node->refs, node_entry)
 			seq_printf(m, " %d", ref->proc->pid);
 	}
 	seq_puts(m, "\n");
@@ -3369,7 +3367,6 @@ static void print_binder_proc_stats(stru
 static int binder_state_show(struct seq_file *m, void *unused)
 {
 	struct binder_proc *proc;
-	struct hlist_node *pos;
 	struct binder_node *node;
 	int do_lock = !binder_debug_no_lock;
 
@@ -3380,10 +3377,10 @@ static int binder_state_show(struct seq_
 
 	if (!hlist_empty(&binder_dead_nodes))
 		seq_puts(m, "dead nodes:\n");
-	hlist_for_each_entry(node, pos, &binder_dead_nodes, dead_node)
+	hlist_for_each_entry(node, &binder_dead_nodes, dead_node)
 		print_binder_node(m, node);
 
-	hlist_for_each_entry(proc, pos, &binder_procs, proc_node)
+	hlist_for_each_entry(proc, &binder_procs, proc_node)
 		print_binder_proc(m, proc, 1);
 	if (do_lock)
 		binder_unlock(__func__);
@@ -3393,7 +3390,6 @@ static int binder_state_show(struct seq_
 static int binder_stats_show(struct seq_file *m, void *unused)
 {
 	struct binder_proc *proc;
-	struct hlist_node *pos;
 	int do_lock = !binder_debug_no_lock;
 
 	if (do_lock)
@@ -3403,7 +3399,7 @@ static int binder_stats_show(struct seq_
 
 	print_binder_stats(m, "", &binder_stats);
 
-	hlist_for_each_entry(proc, pos, &binder_procs, proc_node)
+	hlist_for_each_entry(proc, &binder_procs, proc_node)
 		print_binder_proc_stats(m, proc);
 	if (do_lock)
 		binder_unlock(__func__);
@@ -3413,14 +3409,13 @@ static int binder_stats_show(struct seq_
 static int binder_transactions_show(struct seq_file *m, void *unused)
 {
 	struct binder_proc *proc;
-	struct hlist_node *pos;
 	int do_lock = !binder_debug_no_lock;
 
 	if (do_lock)
 		binder_lock(__func__);
 
 	seq_puts(m, "binder transactions:\n");
-	hlist_for_each_entry(proc, pos, &binder_procs, proc_node)
+	hlist_for_each_entry(proc, &binder_procs, proc_node)
 		print_binder_proc(m, proc, 0);
 	if (do_lock)
 		binder_unlock(__func__);
diff -puN drivers/target/tcm_fc/tfc_sess.c~hlist-drop-the-node-parameter-from-iterators drivers/target/tcm_fc/tfc_sess.c
--- a/drivers/target/tcm_fc/tfc_sess.c~hlist-drop-the-node-parameter-from-iterators
+++ a/drivers/target/tcm_fc/tfc_sess.c
@@ -169,7 +169,6 @@ static struct ft_sess *ft_sess_get(struc
 {
 	struct ft_tport *tport;
 	struct hlist_head *head;
-	struct hlist_node *pos;
 	struct ft_sess *sess;
 
 	rcu_read_lock();
@@ -178,7 +177,7 @@ static struct ft_sess *ft_sess_get(struc
 		goto out;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, pos, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash) {
 		if (sess->port_id == port_id) {
 			kref_get(&sess->kref);
 			rcu_read_unlock();
@@ -201,10 +200,9 @@ static struct ft_sess *ft_sess_create(st
 {
 	struct ft_sess *sess;
 	struct hlist_head *head;
-	struct hlist_node *pos;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, pos, head, hash)
+	hlist_for_each_entry_rcu(sess, head, hash)
 		if (sess->port_id == port_id)
 			return sess;
 
@@ -253,11 +251,10 @@ static void ft_sess_unhash(struct ft_ses
 static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
 {
 	struct hlist_head *head;
-	struct hlist_node *pos;
 	struct ft_sess *sess;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, pos, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash) {
 		if (sess->port_id == port_id) {
 			ft_sess_unhash(sess);
 			return sess;
@@ -273,12 +270,11 @@ static struct ft_sess *ft_sess_delete(st
 static void ft_sess_delete_all(struct ft_tport *tport)
 {
 	struct hlist_head *head;
-	struct hlist_node *pos;
 	struct ft_sess *sess;
 
 	for (head = tport->hash;
 	     head < &tport->hash[FT_SESS_HASH_SIZE]; head++) {
-		hlist_for_each_entry_rcu(sess, pos, head, hash) {
+		hlist_for_each_entry_rcu(sess, head, hash) {
 			ft_sess_unhash(sess);
 			transport_deregister_session_configfs(sess->se_sess);
 			ft_sess_put(sess);	/* release from table */
diff -puN fs/affs/amigaffs.c~hlist-drop-the-node-parameter-from-iterators fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/affs/amigaffs.c
@@ -125,9 +125,8 @@ static void
 affs_fix_dcache(struct inode *inode, u32 entry_ino)
 {
 	struct dentry *dentry;
-	struct hlist_node *p;
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		if (entry_ino == (u32)(long)dentry->d_fsdata) {
 			dentry->d_fsdata = (void *)inode->i_ino;
 			break;
diff -puN fs/aio.c~hlist-drop-the-node-parameter-from-iterators fs/aio.c
--- a/fs/aio.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/aio.c
@@ -591,11 +591,10 @@ static struct kioctx *lookup_ioctx(unsig
 {
 	struct mm_struct *mm = current->mm;
 	struct kioctx *ctx, *ret = NULL;
-	struct hlist_node *n;
 
 	rcu_read_lock();
 
-	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
+	hlist_for_each_entry_rcu(ctx, &mm->ioctx_list, list) {
 		/*
 		 * RCU protects us against accessing freed memory but
 		 * we have to be careful not to get a reference when the
diff -puN fs/cifs/inode.c~hlist-drop-the-node-parameter-from-iterators fs/cifs/inode.c
--- a/fs/cifs/inode.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/cifs/inode.c
@@ -816,10 +816,9 @@ static bool
 inode_has_hashed_dentries(struct inode *inode)
 {
 	struct dentry *dentry;
-	struct hlist_node *p;
 
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
 			spin_unlock(&inode->i_lock);
 			return true;
diff -puN fs/dcache.c~hlist-drop-the-node-parameter-from-iterators fs/dcache.c
--- a/fs/dcache.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/dcache.c
@@ -675,11 +675,10 @@ EXPORT_SYMBOL(dget_parent);
 static struct dentry *__d_find_alias(struct inode *inode, int want_discon)
 {
 	struct dentry *alias, *discon_alias;
-	struct hlist_node *p;
 
 again:
 	discon_alias = NULL;
-	hlist_for_each_entry(alias, p, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
@@ -730,10 +729,9 @@ EXPORT_SYMBOL(d_find_alias);
 void d_prune_aliases(struct inode *inode)
 {
 	struct dentry *dentry;
-	struct hlist_node *p;
 restart:
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_dlock(dentry);
@@ -1443,14 +1441,13 @@ static struct dentry *__d_instantiate_un
 	int len = entry->d_name.len;
 	const char *name = entry->d_name.name;
 	unsigned int hash = entry->d_name.hash;
-	struct hlist_node *p;
 
 	if (!inode) {
 		__d_instantiate(entry, NULL);
 		return NULL;
 	}
 
-	hlist_for_each_entry(alias, p, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		/*
 		 * Don't need alias->d_lock here, because aliases with
 		 * d_parent == entry->d_parent are not subject to name or
diff -puN fs/dlm/lowcomms.c~hlist-drop-the-node-parameter-from-iterators fs/dlm/lowcomms.c
--- a/fs/dlm/lowcomms.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/dlm/lowcomms.c
@@ -177,12 +177,11 @@ static inline int nodeid_hash(int nodeid
 static struct connection *__find_con(int nodeid)
 {
 	int r;
-	struct hlist_node *h;
 	struct connection *con;
 
 	r = nodeid_hash(nodeid);
 
-	hlist_for_each_entry(con, h, &connection_hash[r], list) {
+	hlist_for_each_entry(con, &connection_hash[r], list) {
 		if (con->nodeid == nodeid)
 			return con;
 	}
@@ -232,13 +231,12 @@ static struct connection *__nodeid2con(i
 static void foreach_conn(void (*conn_func)(struct connection *c))
 {
 	int i;
-	struct hlist_node *h, *n;
+	struct hlist_node *n;
 	struct connection *con;
 
 	for (i = 0; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry_safe(con, h, n, &connection_hash[i], list){
+		hlist_for_each_entry_safe(con, n, &connection_hash[i], list)
 			conn_func(con);
-		}
 	}
 }
 
@@ -257,13 +255,12 @@ static struct connection *nodeid2con(int
 static struct connection *assoc2con(int assoc_id)
 {
 	int i;
-	struct hlist_node *h;
 	struct connection *con;
 
 	mutex_lock(&connections_lock);
 
 	for (i = 0 ; i < CONN_HASH_SIZE; i++) {
-		hlist_for_each_entry(con, h, &connection_hash[i], list) {
+		hlist_for_each_entry(con, &connection_hash[i], list) {
 			if (con->sctp_assoc == assoc_id) {
 				mutex_unlock(&connections_lock);
 				return con;
diff -puN fs/ecryptfs/messaging.c~hlist-drop-the-node-parameter-from-iterators fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/ecryptfs/messaging.c
@@ -115,10 +115,9 @@ void ecryptfs_msg_ctx_alloc_to_free(stru
  */
 int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon)
 {
-	struct hlist_node *elem;
 	int rc;
 
-	hlist_for_each_entry(*daemon, elem,
+	hlist_for_each_entry(*daemon,
 			    &ecryptfs_daemon_hash[ecryptfs_current_euid_hash()],
 			    euid_chain) {
 		if (uid_eq((*daemon)->file->f_cred->euid, current_euid())) {
@@ -445,7 +444,6 @@ void ecryptfs_release_messaging(void)
 		mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
 	}
 	if (ecryptfs_daemon_hash) {
-		struct hlist_node *elem;
 		struct ecryptfs_daemon *daemon;
 		int i;
 
@@ -453,7 +451,7 @@ void ecryptfs_release_messaging(void)
 		for (i = 0; i < (1 << ecryptfs_hash_bits); i++) {
 			int rc;
 
-			hlist_for_each_entry(daemon, elem,
+			hlist_for_each_entry(daemon,
 					     &ecryptfs_daemon_hash[i],
 					     euid_chain) {
 				rc = ecryptfs_exorcise_daemon(daemon);
diff -puN fs/exportfs/expfs.c~hlist-drop-the-node-parameter-from-iterators fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/exportfs/expfs.c
@@ -44,14 +44,13 @@ find_acceptable_alias(struct dentry *res
 {
 	struct dentry *dentry, *toput = NULL;
 	struct inode *inode;
-	struct hlist_node *p;
 
 	if (acceptable(context, result))
 		return result;
 
 	inode = result->d_inode;
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		dget(dentry);
 		spin_unlock(&inode->i_lock);
 		if (toput)
diff -puN fs/fat/inode.c~hlist-drop-the-node-parameter-from-iterators fs/fat/inode.c
--- a/fs/fat/inode.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/fat/inode.c
@@ -341,12 +341,11 @@ struct inode *fat_iget(struct super_bloc
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct hlist_head *head = sbi->inode_hashtable + fat_hash(i_pos);
-	struct hlist_node *_p;
 	struct msdos_inode_info *i;
 	struct inode *inode = NULL;
 
 	spin_lock(&sbi->inode_hash_lock);
-	hlist_for_each_entry(i, _p, head, i_fat_hash) {
+	hlist_for_each_entry(i, head, i_fat_hash) {
 		BUG_ON(i->vfs_inode.i_sb != sb);
 		if (i->i_pos != i_pos)
 			continue;
diff -puN fs/fat/nfs.c~hlist-drop-the-node-parameter-from-iterators fs/fat/nfs.c
--- a/fs/fat/nfs.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/fat/nfs.c
@@ -21,13 +21,12 @@ static struct inode *fat_dget(struct sup
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct hlist_head *head;
-	struct hlist_node *_p;
 	struct msdos_inode_info *i;
 	struct inode *inode = NULL;
 
 	head = sbi->dir_hashtable + fat_dir_hash(i_logstart);
 	spin_lock(&sbi->dir_hash_lock);
-	hlist_for_each_entry(i, _p, head, i_dir_hash) {
+	hlist_for_each_entry(i, head, i_dir_hash) {
 		BUG_ON(i->vfs_inode.i_sb != sb);
 		if (i->i_logstart != i_logstart)
 			continue;
diff -puN fs/fscache/cookie.c~hlist-drop-the-node-parameter-from-iterators fs/fscache/cookie.c
--- a/fs/fscache/cookie.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/fscache/cookie.c
@@ -237,13 +237,12 @@ static int fscache_alloc_object(struct f
 				struct fscache_cookie *cookie)
 {
 	struct fscache_object *object;
-	struct hlist_node *_n;
 	int ret;
 
 	_enter("%p,%p{%s}", cache, cookie, cookie->def->name);
 
 	spin_lock(&cookie->lock);
-	hlist_for_each_entry(object, _n, &cookie->backing_objects,
+	hlist_for_each_entry(object, &cookie->backing_objects,
 			     cookie_link) {
 		if (object->cache == cache)
 			goto object_already_extant;
@@ -311,7 +310,6 @@ static int fscache_attach_object(struct 
 {
 	struct fscache_object *p;
 	struct fscache_cache *cache = object->cache;
-	struct hlist_node *_n;
 	int ret;
 
 	_enter("{%s},{OBJ%x}", cookie->def->name, object->debug_id);
@@ -321,7 +319,7 @@ static int fscache_attach_object(struct 
 	/* there may be multiple initial creations of this object, but we only
 	 * want one */
 	ret = -EEXIST;
-	hlist_for_each_entry(p, _n, &cookie->backing_objects, cookie_link) {
+	hlist_for_each_entry(p, &cookie->backing_objects, cookie_link) {
 		if (p->cache == object->cache) {
 			if (p->state >= FSCACHE_OBJECT_DYING)
 				ret = -ENOBUFS;
@@ -331,7 +329,7 @@ static int fscache_attach_object(struct 
 
 	/* pin the parent object */
 	spin_lock_nested(&cookie->parent->lock, 1);
-	hlist_for_each_entry(p, _n, &cookie->parent->backing_objects,
+	hlist_for_each_entry(p, &cookie->parent->backing_objects,
 			     cookie_link) {
 		if (p->cache == object->cache) {
 			if (p->state >= FSCACHE_OBJECT_DYING) {
@@ -435,7 +433,6 @@ EXPORT_SYMBOL(__fscache_wait_on_invalida
 void __fscache_update_cookie(struct fscache_cookie *cookie)
 {
 	struct fscache_object *object;
-	struct hlist_node *_p;
 
 	fscache_stat(&fscache_n_updates);
 
@@ -452,7 +449,7 @@ void __fscache_update_cookie(struct fsca
 	spin_lock(&cookie->lock);
 
 	/* update the index entry on disk in each cache backing this cookie */
-	hlist_for_each_entry(object, _p,
+	hlist_for_each_entry(object,
 			     &cookie->backing_objects, cookie_link) {
 		fscache_raise_event(object, FSCACHE_OBJECT_EV_UPDATE);
 	}
diff -puN fs/inode.c~hlist-drop-the-node-parameter-from-iterators fs/inode.c
--- a/fs/inode.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/inode.c
@@ -798,11 +798,10 @@ static struct inode *find_inode(struct s
 				int (*test)(struct inode *, void *),
 				void *data)
 {
-	struct hlist_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	hlist_for_each_entry(inode, head, i_hash) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_sb != sb) {
 			spin_unlock(&inode->i_lock);
@@ -830,11 +829,10 @@ repeat:
 static struct inode *find_inode_fast(struct super_block *sb,
 				struct hlist_head *head, unsigned long ino)
 {
-	struct hlist_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	hlist_for_each_entry(inode, head, i_hash) {
 		spin_lock(&inode->i_lock);
 		if (inode->i_ino != ino) {
 			spin_unlock(&inode->i_lock);
@@ -1132,11 +1130,10 @@ EXPORT_SYMBOL(iget_locked);
 static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 {
 	struct hlist_head *b = inode_hashtable + hash(sb, ino);
-	struct hlist_node *node;
 	struct inode *inode;
 
 	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, node, b, i_hash) {
+	hlist_for_each_entry(inode, b, i_hash) {
 		if (inode->i_ino == ino && inode->i_sb == sb) {
 			spin_unlock(&inode_hash_lock);
 			return 0;
@@ -1291,10 +1288,9 @@ int insert_inode_locked(struct inode *in
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 
 	while (1) {
-		struct hlist_node *node;
 		struct inode *old = NULL;
 		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		hlist_for_each_entry(old, head, i_hash) {
 			if (old->i_ino != ino)
 				continue;
 			if (old->i_sb != sb)
@@ -1306,7 +1302,7 @@ int insert_inode_locked(struct inode *in
 			}
 			break;
 		}
-		if (likely(!node)) {
+		if (likely(!old)) {
 			spin_lock(&inode->i_lock);
 			inode->i_state |= I_NEW;
 			hlist_add_head(&inode->i_hash, head);
@@ -1334,11 +1330,10 @@ int insert_inode_locked4(struct inode *i
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 
 	while (1) {
-		struct hlist_node *node;
 		struct inode *old = NULL;
 
 		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, node, head, i_hash) {
+		hlist_for_each_entry(old, head, i_hash) {
 			if (old->i_sb != sb)
 				continue;
 			if (!test(old, data))
@@ -1350,7 +1345,7 @@ int insert_inode_locked4(struct inode *i
 			}
 			break;
 		}
-		if (likely(!node)) {
+		if (likely(!old)) {
 			spin_lock(&inode->i_lock);
 			inode->i_state |= I_NEW;
 			hlist_add_head(&inode->i_hash, head);
diff -puN fs/lockd/host.c~hlist-drop-the-node-parameter-from-iterators fs/lockd/host.c
--- a/fs/lockd/host.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/lockd/host.c
@@ -32,15 +32,15 @@
 static struct hlist_head	nlm_server_hosts[NLM_HOST_NRHASH];
 static struct hlist_head	nlm_client_hosts[NLM_HOST_NRHASH];
 
-#define for_each_host(host, pos, chain, table) \
+#define for_each_host(host, chain, table) \
 	for ((chain) = (table); \
 	     (chain) < (table) + NLM_HOST_NRHASH; ++(chain)) \
-		hlist_for_each_entry((host), (pos), (chain), h_hash)
+		hlist_for_each_entry((host), (chain), h_hash)
 
-#define for_each_host_safe(host, pos, next, chain, table) \
+#define for_each_host_safe(host, next, chain, table) \
 	for ((chain) = (table); \
 	     (chain) < (table) + NLM_HOST_NRHASH; ++(chain)) \
-		hlist_for_each_entry_safe((host), (pos), (next), \
+		hlist_for_each_entry_safe((host), (next), \
 						(chain), h_hash)
 
 static unsigned long		nrhosts;
@@ -225,7 +225,6 @@ struct nlm_host *nlmclnt_lookup_host(con
 		.net		= net,
 	};
 	struct hlist_head *chain;
-	struct hlist_node *pos;
 	struct nlm_host	*host;
 	struct nsm_handle *nsm = NULL;
 	struct lockd_net *ln = net_generic(net, lockd_net_id);
@@ -237,7 +236,7 @@ struct nlm_host *nlmclnt_lookup_host(con
 	mutex_lock(&nlm_host_mutex);
 
 	chain = &nlm_client_hosts[nlm_hash_address(sap)];
-	hlist_for_each_entry(host, pos, chain, h_hash) {
+	hlist_for_each_entry(host, chain, h_hash) {
 		if (host->net != net)
 			continue;
 		if (!rpc_cmp_addr(nlm_addr(host), sap))
@@ -322,7 +321,6 @@ struct nlm_host *nlmsvc_lookup_host(cons
 				    const size_t hostname_len)
 {
 	struct hlist_head *chain;
-	struct hlist_node *pos;
 	struct nlm_host	*host = NULL;
 	struct nsm_handle *nsm = NULL;
 	struct sockaddr *src_sap = svc_daddr(rqstp);
@@ -350,7 +348,7 @@ struct nlm_host *nlmsvc_lookup_host(cons
 		nlm_gc_hosts(net);
 
 	chain = &nlm_server_hosts[nlm_hash_address(ni.sap)];
-	hlist_for_each_entry(host, pos, chain, h_hash) {
+	hlist_for_each_entry(host, chain, h_hash) {
 		if (host->net != net)
 			continue;
 		if (!rpc_cmp_addr(nlm_addr(host), ni.sap))
@@ -515,10 +513,9 @@ static struct nlm_host *next_host_state(
 {
 	struct nlm_host *host;
 	struct hlist_head *chain;
-	struct hlist_node *pos;
 
 	mutex_lock(&nlm_host_mutex);
-	for_each_host(host, pos, chain, cache) {
+	for_each_host(host, chain, cache) {
 		if (host->h_nsmhandle == nsm
 		    && host->h_nsmstate != info->state) {
 			host->h_nsmstate = info->state;
@@ -570,7 +567,6 @@ void nlm_host_rebooted(const struct nlm_
 static void nlm_complain_hosts(struct net *net)
 {
 	struct hlist_head *chain;
-	struct hlist_node *pos;
 	struct nlm_host	*host;
 
 	if (net) {
@@ -587,7 +583,7 @@ static void nlm_complain_hosts(struct ne
 		dprintk("lockd: %lu hosts left:\n", nrhosts);
 	}
 
-	for_each_host(host, pos, chain, nlm_server_hosts) {
+	for_each_host(host, chain, nlm_server_hosts) {
 		if (net && host->net != net)
 			continue;
 		dprintk("       %s (cnt %d use %d exp %ld net %p)\n",
@@ -600,14 +596,13 @@ void
 nlm_shutdown_hosts_net(struct net *net)
 {
 	struct hlist_head *chain;
-	struct hlist_node *pos;
 	struct nlm_host	*host;
 
 	mutex_lock(&nlm_host_mutex);
 
 	/* First, make all hosts eligible for gc */
 	dprintk("lockd: nuking all hosts in net %p...\n", net);
-	for_each_host(host, pos, chain, nlm_server_hosts) {
+	for_each_host(host, chain, nlm_server_hosts) {
 		if (net && host->net != net)
 			continue;
 		host->h_expires = jiffies - 1;
@@ -644,11 +639,11 @@ static void
 nlm_gc_hosts(struct net *net)
 {
 	struct hlist_head *chain;
-	struct hlist_node *pos, *next;
+	struct hlist_node *next;
 	struct nlm_host	*host;
 
 	dprintk("lockd: host garbage collection for net %p\n", net);
-	for_each_host(host, pos, chain, nlm_server_hosts) {
+	for_each_host(host, chain, nlm_server_hosts) {
 		if (net && host->net != net)
 			continue;
 		host->h_inuse = 0;
@@ -657,7 +652,7 @@ nlm_gc_hosts(struct net *net)
 	/* Mark all hosts that hold locks, blocks or shares */
 	nlmsvc_mark_resources(net);
 
-	for_each_host_safe(host, pos, next, chain, nlm_server_hosts) {
+	for_each_host_safe(host, next, chain, nlm_server_hosts) {
 		if (net && host->net != net)
 			continue;
 		if (atomic_read(&host->h_count) || host->h_inuse
diff -puN fs/lockd/svcsubs.c~hlist-drop-the-node-parameter-from-iterators fs/lockd/svcsubs.c
--- a/fs/lockd/svcsubs.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/lockd/svcsubs.c
@@ -84,7 +84,6 @@ __be32
 nlm_lookup_file(struct svc_rqst *rqstp, struct nlm_file **result,
 					struct nfs_fh *f)
 {
-	struct hlist_node *pos;
 	struct nlm_file	*file;
 	unsigned int	hash;
 	__be32		nfserr;
@@ -96,7 +95,7 @@ nlm_lookup_file(struct svc_rqst *rqstp, 
 	/* Lock file table */
 	mutex_lock(&nlm_file_mutex);
 
-	hlist_for_each_entry(file, pos, &nlm_files[hash], f_list)
+	hlist_for_each_entry(file, &nlm_files[hash], f_list)
 		if (!nfs_compare_fh(&file->f_handle, f))
 			goto found;
 
@@ -248,13 +247,13 @@ static int
 nlm_traverse_files(void *data, nlm_host_match_fn_t match,
 		int (*is_failover_file)(void *data, struct nlm_file *file))
 {
-	struct hlist_node *pos, *next;
+	struct hlist_node *next;
 	struct nlm_file	*file;
 	int i, ret = 0;
 
 	mutex_lock(&nlm_file_mutex);
 	for (i = 0; i < FILE_NRHASH; i++) {
-		hlist_for_each_entry_safe(file, pos, next, &nlm_files[i], f_list) {
+		hlist_for_each_entry_safe(file, next, &nlm_files[i], f_list) {
 			if (is_failover_file && !is_failover_file(data, file))
 				continue;
 			file->f_count++;
diff -puN fs/nfs/pnfs_dev.c~hlist-drop-the-node-parameter-from-iterators fs/nfs/pnfs_dev.c
--- a/fs/nfs/pnfs_dev.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/nfs/pnfs_dev.c
@@ -77,9 +77,8 @@ _lookup_deviceid(const struct pnfs_layou
 		 long hash)
 {
 	struct nfs4_deviceid_node *d;
-	struct hlist_node *n;
 
-	hlist_for_each_entry_rcu(d, n, &nfs4_deviceid_cache[hash], node)
+	hlist_for_each_entry_rcu(d, &nfs4_deviceid_cache[hash], node)
 		if (d->ld == ld && d->nfs_client == clp &&
 		    !memcmp(&d->deviceid, id, sizeof(*id))) {
 			if (atomic_read(&d->ref))
@@ -248,12 +247,11 @@ static void
 _deviceid_purge_client(const struct nfs_client *clp, long hash)
 {
 	struct nfs4_deviceid_node *d;
-	struct hlist_node *n;
 	HLIST_HEAD(tmp);
 
 	spin_lock(&nfs4_deviceid_lock);
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(d, n, &nfs4_deviceid_cache[hash], node)
+	hlist_for_each_entry_rcu(d, &nfs4_deviceid_cache[hash], node)
 		if (d->nfs_client == clp && atomic_read(&d->ref)) {
 			hlist_del_init_rcu(&d->node);
 			hlist_add_head(&d->tmpnode, &tmp);
@@ -291,12 +289,11 @@ void
 nfs4_deviceid_mark_client_invalid(struct nfs_client *clp)
 {
 	struct nfs4_deviceid_node *d;
-	struct hlist_node *n;
 	int i;
 
 	rcu_read_lock();
 	for (i = 0; i < NFS4_DEVICE_ID_HASH_SIZE; i ++){
-		hlist_for_each_entry_rcu(d, n, &nfs4_deviceid_cache[i], node)
+		hlist_for_each_entry_rcu(d, &nfs4_deviceid_cache[i], node)
 			if (d->nfs_client == clp)
 				set_bit(NFS_DEVICEID_INVALID, &d->flags);
 	}
diff -puN fs/nfsd/nfscache.c~hlist-drop-the-node-parameter-from-iterators fs/nfsd/nfscache.c
--- a/fs/nfsd/nfscache.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/nfsd/nfscache.c
@@ -120,7 +120,6 @@ hash_refile(struct svc_cacherep *rp)
 int
 nfsd_cache_lookup(struct svc_rqst *rqstp)
 {
-	struct hlist_node	*hn;
 	struct hlist_head 	*rh;
 	struct svc_cacherep	*rp;
 	__be32			xid = rqstp->rq_xid;
@@ -141,7 +140,7 @@ nfsd_cache_lookup(struct svc_rqst *rqstp
 	rtn = RC_DOIT;
 
 	rh = &cache_hash[request_hash(xid)];
-	hlist_for_each_entry(rp, hn, rh, c_hash) {
+	hlist_for_each_entry(rp, rh, c_hash) {
 		if (rp->c_state != RC_UNUSED &&
 		    xid == rp->c_xid && proc == rp->c_proc &&
 		    proto == rp->c_prot && vers == rp->c_vers &&
diff -puN fs/notify/fsnotify.c~hlist-drop-the-node-parameter-from-iterators fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/notify/fsnotify.c
@@ -52,7 +52,6 @@ void __fsnotify_vfsmount_delete(struct v
 void __fsnotify_update_child_dentry_flags(struct inode *inode)
 {
 	struct dentry *alias;
-	struct hlist_node *p;
 	int watched;
 
 	if (!S_ISDIR(inode->i_mode))
@@ -64,7 +63,7 @@ void __fsnotify_update_child_dentry_flag
 	spin_lock(&inode->i_lock);
 	/* run all of the dentries associated with this inode.  Since this is a
 	 * directory, there damn well better only be one item on this list */
-	hlist_for_each_entry(alias, p, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
 
 		/* run all of the children of the original inode and fix their
diff -puN fs/notify/inode_mark.c~hlist-drop-the-node-parameter-from-iterators fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/notify/inode_mark.c
@@ -36,12 +36,11 @@
 static void fsnotify_recalc_inode_mask_locked(struct inode *inode)
 {
 	struct fsnotify_mark *mark;
-	struct hlist_node *pos;
 	__u32 new_mask = 0;
 
 	assert_spin_locked(&inode->i_lock);
 
-	hlist_for_each_entry(mark, pos, &inode->i_fsnotify_marks, i.i_list)
+	hlist_for_each_entry(mark, &inode->i_fsnotify_marks, i.i_list)
 		new_mask |= mark->mask;
 	inode->i_fsnotify_mask = new_mask;
 }
@@ -87,11 +86,11 @@ void fsnotify_destroy_inode_mark(struct 
 void fsnotify_clear_marks_by_inode(struct inode *inode)
 {
 	struct fsnotify_mark *mark, *lmark;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 	LIST_HEAD(free_list);
 
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry_safe(mark, pos, n, &inode->i_fsnotify_marks, i.i_list) {
+	hlist_for_each_entry_safe(mark, n, &inode->i_fsnotify_marks, i.i_list) {
 		list_add(&mark->i.free_i_list, &free_list);
 		hlist_del_init_rcu(&mark->i.i_list);
 		fsnotify_get_mark(mark);
@@ -129,11 +128,10 @@ static struct fsnotify_mark *fsnotify_fi
 		struct inode *inode)
 {
 	struct fsnotify_mark *mark;
-	struct hlist_node *pos;
 
 	assert_spin_locked(&inode->i_lock);
 
-	hlist_for_each_entry(mark, pos, &inode->i_fsnotify_marks, i.i_list) {
+	hlist_for_each_entry(mark, &inode->i_fsnotify_marks, i.i_list) {
 		if (mark->group == group) {
 			fsnotify_get_mark(mark);
 			return mark;
@@ -194,8 +192,7 @@ int fsnotify_add_inode_mark(struct fsnot
 			    struct fsnotify_group *group, struct inode *inode,
 			    int allow_dups)
 {
-	struct fsnotify_mark *lmark;
-	struct hlist_node *node, *last = NULL;
+	struct fsnotify_mark *lmark, *last = NULL;
 	int ret = 0;
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
@@ -214,8 +211,8 @@ int fsnotify_add_inode_mark(struct fsnot
 	}
 
 	/* should mark be in the middle of the current list? */
-	hlist_for_each_entry(lmark, node, &inode->i_fsnotify_marks, i.i_list) {
-		last = node;
+	hlist_for_each_entry(lmark, &inode->i_fsnotify_marks, i.i_list) {
+		last = lmark;
 
 		if ((lmark->group == group) && !allow_dups) {
 			ret = -EEXIST;
@@ -235,7 +232,7 @@ int fsnotify_add_inode_mark(struct fsnot
 
 	BUG_ON(last == NULL);
 	/* mark should be the last entry.  last is the current last entry */
-	hlist_add_after_rcu(last, &mark->i.i_list);
+	hlist_add_after_rcu(&last->i.i_list, &mark->i.i_list);
 out:
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
diff -puN fs/notify/vfsmount_mark.c~hlist-drop-the-node-parameter-from-iterators fs/notify/vfsmount_mark.c
--- a/fs/notify/vfsmount_mark.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/notify/vfsmount_mark.c
@@ -33,12 +33,12 @@
 void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
 {
 	struct fsnotify_mark *mark, *lmark;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 	struct mount *m = real_mount(mnt);
 	LIST_HEAD(free_list);
 
 	spin_lock(&mnt->mnt_root->d_lock);
-	hlist_for_each_entry_safe(mark, pos, n, &m->mnt_fsnotify_marks, m.m_list) {
+	hlist_for_each_entry_safe(mark, n, &m->mnt_fsnotify_marks, m.m_list) {
 		list_add(&mark->m.free_m_list, &free_list);
 		hlist_del_init_rcu(&mark->m.m_list);
 		fsnotify_get_mark(mark);
@@ -71,12 +71,11 @@ static void fsnotify_recalc_vfsmount_mas
 {
 	struct mount *m = real_mount(mnt);
 	struct fsnotify_mark *mark;
-	struct hlist_node *pos;
 	__u32 new_mask = 0;
 
 	assert_spin_locked(&mnt->mnt_root->d_lock);
 
-	hlist_for_each_entry(mark, pos, &m->mnt_fsnotify_marks, m.m_list)
+	hlist_for_each_entry(mark, &m->mnt_fsnotify_marks, m.m_list)
 		new_mask |= mark->mask;
 	m->mnt_fsnotify_mask = new_mask;
 }
@@ -114,11 +113,10 @@ static struct fsnotify_mark *fsnotify_fi
 {
 	struct mount *m = real_mount(mnt);
 	struct fsnotify_mark *mark;
-	struct hlist_node *pos;
 
 	assert_spin_locked(&mnt->mnt_root->d_lock);
 
-	hlist_for_each_entry(mark, pos, &m->mnt_fsnotify_marks, m.m_list) {
+	hlist_for_each_entry(mark, &m->mnt_fsnotify_marks, m.m_list) {
 		if (mark->group == group) {
 			fsnotify_get_mark(mark);
 			return mark;
@@ -153,8 +151,7 @@ int fsnotify_add_vfsmount_mark(struct fs
 			       int allow_dups)
 {
 	struct mount *m = real_mount(mnt);
-	struct fsnotify_mark *lmark;
-	struct hlist_node *node, *last = NULL;
+	struct fsnotify_mark *lmark, *last = NULL;
 	int ret = 0;
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
@@ -173,8 +170,8 @@ int fsnotify_add_vfsmount_mark(struct fs
 	}
 
 	/* should mark be in the middle of the current list? */
-	hlist_for_each_entry(lmark, node, &m->mnt_fsnotify_marks, m.m_list) {
-		last = node;
+	hlist_for_each_entry(lmark, &m->mnt_fsnotify_marks, m.m_list) {
+		last = lmark;
 
 		if ((lmark->group == group) && !allow_dups) {
 			ret = -EEXIST;
@@ -194,7 +191,7 @@ int fsnotify_add_vfsmount_mark(struct fs
 
 	BUG_ON(last == NULL);
 	/* mark should be the last entry.  last is the current last entry */
-	hlist_add_after_rcu(last, &mark->m.m_list);
+	hlist_add_after_rcu(&last->m.m_list, &mark->m.m_list);
 out:
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 	spin_unlock(&mnt->mnt_root->d_lock);
diff -puN fs/ocfs2/dcache.c~hlist-drop-the-node-parameter-from-iterators fs/ocfs2/dcache.c
--- a/fs/ocfs2/dcache.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/ocfs2/dcache.c
@@ -169,11 +169,10 @@ struct dentry *ocfs2_find_local_alias(st
 				      u64 parent_blkno,
 				      int skip_unhashed)
 {
-	struct hlist_node *p;
 	struct dentry *dentry;
 
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
+	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
 			trace_ocfs2_find_local_alias(dentry->d_name.len,
diff -puN fs/ocfs2/dlm/dlmrecovery.c~hlist-drop-the-node-parameter-from-iterators fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2083,7 +2083,6 @@ static void dlm_finish_local_lockres_rec
 					      u8 dead_node, u8 new_master)
 {
 	int i;
-	struct hlist_node *hash_iter;
 	struct hlist_head *bucket;
 	struct dlm_lock_resource *res, *next;
 
@@ -2114,7 +2113,7 @@ static void dlm_finish_local_lockres_rec
 	 * if necessary */
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_lockres_hash(dlm, i);
-		hlist_for_each_entry(res, hash_iter, bucket, hash_node) {
+		hlist_for_each_entry(res, bucket, hash_node) {
 			if (!(res->state & DLM_LOCK_RES_RECOVERING))
 				continue;
 
@@ -2273,7 +2272,6 @@ static void dlm_free_dead_locks(struct d
 
 static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
 {
-	struct hlist_node *iter;
 	struct dlm_lock_resource *res;
 	int i;
 	struct hlist_head *bucket;
@@ -2299,7 +2297,7 @@ static void dlm_do_local_recovery_cleanu
 	 */
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_lockres_hash(dlm, i);
-		hlist_for_each_entry(res, iter, bucket, hash_node) {
+		hlist_for_each_entry(res, bucket, hash_node) {
  			/* always prune any $RECOVERY entries for dead nodes,
  			 * otherwise hangs can occur during later recovery */
 			if (dlm_is_recovery_lock(res->lockname.name,
diff -puN fs/super.c~hlist-drop-the-node-parameter-from-iterators fs/super.c
--- a/fs/super.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/super.c
@@ -447,14 +447,13 @@ struct super_block *sget(struct file_sys
 			void *data)
 {
 	struct super_block *s = NULL;
-	struct hlist_node *node;
 	struct super_block *old;
 	int err;
 
 retry:
 	spin_lock(&sb_lock);
 	if (test) {
-		hlist_for_each_entry(old, node, &type->fs_supers, s_instances) {
+		hlist_for_each_entry(old, &type->fs_supers, s_instances) {
 			if (!test(old, data))
 				continue;
 			if (!grab_super(old))
@@ -554,10 +553,9 @@ void iterate_supers_type(struct file_sys
 	void (*f)(struct super_block *, void *), void *arg)
 {
 	struct super_block *sb, *p = NULL;
-	struct hlist_node *node;
 
 	spin_lock(&sb_lock);
-	hlist_for_each_entry(sb, node, &type->fs_supers, s_instances) {
+	hlist_for_each_entry(sb, &type->fs_supers, s_instances) {
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 
diff -puN fs/sysfs/bin.c~hlist-drop-the-node-parameter-from-iterators fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/sysfs/bin.c
@@ -461,14 +461,13 @@ const struct file_operations bin_fops = 
 void unmap_bin_file(struct sysfs_dirent *attr_sd)
 {
 	struct bin_buffer *bb;
-	struct hlist_node *tmp;
 
 	if (sysfs_type(attr_sd) != SYSFS_KOBJ_BIN_ATTR)
 		return;
 
 	mutex_lock(&sysfs_bin_lock);
 
-	hlist_for_each_entry(bb, tmp, &attr_sd->s_bin_attr.buffers, list) {
+	hlist_for_each_entry(bb, &attr_sd->s_bin_attr.buffers, list) {
 		struct inode *inode = file_inode(bb->file);
 
 		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
diff -puN fs/xfs/xfs_log_recover.c~hlist-drop-the-node-parameter-from-iterators fs/xfs/xfs_log_recover.c
--- a/fs/xfs/xfs_log_recover.c~hlist-drop-the-node-parameter-from-iterators
+++ a/fs/xfs/xfs_log_recover.c
@@ -1442,9 +1442,8 @@ xlog_recover_find_tid(
 	xlog_tid_t		tid)
 {
 	xlog_recover_t		*trans;
-	struct hlist_node	*n;
 
-	hlist_for_each_entry(trans, n, head, r_list) {
+	hlist_for_each_entry(trans, head, r_list) {
 		if (trans->r_log_tid == tid)
 			return trans;
 	}
diff -puN include/linux/hashtable.h~hlist-drop-the-node-parameter-from-iterators include/linux/hashtable.h
--- a/include/linux/hashtable.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/linux/hashtable.h
@@ -115,51 +115,50 @@ static inline void hash_del_rcu(struct h
  * hash_for_each - iterate over a hashtable
  * @name: hashtable to iterate
  * @bkt: integer to use as bucket loop cursor
- * @node: the &struct list_head to use as a loop cursor for each entry
  * @obj: the type * to use as a loop cursor for each entry
  * @member: the name of the hlist_node within the struct
  */
-#define hash_for_each(name, bkt, node, obj, member)				\
-	for ((bkt) = 0, node = NULL; node == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\
-		hlist_for_each_entry(obj, node, &name[bkt], member)
+#define hash_for_each(name, bkt, obj, member)				\
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name);\
+			(bkt)++)\
+		hlist_for_each_entry(obj, &name[bkt], member)
 
 /**
  * hash_for_each_rcu - iterate over a rcu enabled hashtable
  * @name: hashtable to iterate
  * @bkt: integer to use as bucket loop cursor
- * @node: the &struct list_head to use as a loop cursor for each entry
  * @obj: the type * to use as a loop cursor for each entry
  * @member: the name of the hlist_node within the struct
  */
-#define hash_for_each_rcu(name, bkt, node, obj, member)				\
-	for ((bkt) = 0, node = NULL; node == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\
-		hlist_for_each_entry_rcu(obj, node, &name[bkt], member)
+#define hash_for_each_rcu(name, bkt, obj, member)			\
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name);\
+			(bkt)++)\
+		hlist_for_each_entry_rcu(obj, &name[bkt], member)
 
 /**
  * hash_for_each_safe - iterate over a hashtable safe against removal of
  * hash entry
  * @name: hashtable to iterate
  * @bkt: integer to use as bucket loop cursor
- * @node: the &struct list_head to use as a loop cursor for each entry
  * @tmp: a &struct used for temporary storage
  * @obj: the type * to use as a loop cursor for each entry
  * @member: the name of the hlist_node within the struct
  */
-#define hash_for_each_safe(name, bkt, node, tmp, obj, member)			\
-	for ((bkt) = 0, node = NULL; node == NULL && (bkt) < HASH_SIZE(name); (bkt)++)\
-		hlist_for_each_entry_safe(obj, node, tmp, &name[bkt], member)
+#define hash_for_each_safe(name, bkt, tmp, obj, member)			\
+	for ((bkt) = 0, obj = NULL; obj == NULL && (bkt) < HASH_SIZE(name);\
+			(bkt)++)\
+		hlist_for_each_entry_safe(obj, tmp, &name[bkt], member)
 
 /**
  * hash_for_each_possible - iterate over all possible objects hashing to the
  * same bucket
  * @name: hashtable to iterate
  * @obj: the type * to use as a loop cursor for each entry
- * @node: the &struct list_head to use as a loop cursor for each entry
  * @member: the name of the hlist_node within the struct
  * @key: the key of the objects to iterate over
  */
-#define hash_for_each_possible(name, obj, node, member, key)			\
-	hlist_for_each_entry(obj, node,	&name[hash_min(key, HASH_BITS(name))], member)
+#define hash_for_each_possible(name, obj, member, key)			\
+	hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
 
 /**
  * hash_for_each_possible_rcu - iterate over all possible objects hashing to the
@@ -167,25 +166,24 @@ static inline void hash_del_rcu(struct h
  * in a rcu enabled hashtable
  * @name: hashtable to iterate
  * @obj: the type * to use as a loop cursor for each entry
- * @node: the &struct list_head to use as a loop cursor for each entry
  * @member: the name of the hlist_node within the struct
  * @key: the key of the objects to iterate over
  */
-#define hash_for_each_possible_rcu(name, obj, node, member, key)		\
-	hlist_for_each_entry_rcu(obj, node, &name[hash_min(key, HASH_BITS(name))], member)
+#define hash_for_each_possible_rcu(name, obj, member, key)		\
+	hlist_for_each_entry_rcu(obj, &name[hash_min(key, HASH_BITS(name))],\
+		member)
 
 /**
  * hash_for_each_possible_safe - iterate over all possible objects hashing to the
  * same bucket safe against removals
  * @name: hashtable to iterate
  * @obj: the type * to use as a loop cursor for each entry
- * @node: the &struct list_head to use as a loop cursor for each entry
  * @tmp: a &struct used for temporary storage
  * @member: the name of the hlist_node within the struct
  * @key: the key of the objects to iterate over
  */
-#define hash_for_each_possible_safe(name, obj, node, tmp, member, key)		\
-	hlist_for_each_entry_safe(obj, node, tmp,				\
+#define hash_for_each_possible_safe(name, obj, tmp, member, key)	\
+	hlist_for_each_entry_safe(obj, tmp,\
 		&name[hash_min(key, HASH_BITS(name))], member)
 
 
diff -puN include/linux/if_team.h~hlist-drop-the-node-parameter-from-iterators include/linux/if_team.h
--- a/include/linux/if_team.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/linux/if_team.h
@@ -216,11 +216,10 @@ static inline struct hlist_head *team_po
 static inline struct team_port *team_get_port_by_index(struct team *team,
 						       int port_index)
 {
-	struct hlist_node *p;
 	struct team_port *port;
 	struct hlist_head *head = team_port_index_hash(team, port_index);
 
-	hlist_for_each_entry(port, p, head, hlist)
+	hlist_for_each_entry(port, head, hlist)
 		if (port->index == port_index)
 			return port;
 	return NULL;
@@ -228,11 +227,10 @@ static inline struct team_port *team_get
 static inline struct team_port *team_get_port_by_index_rcu(struct team *team,
 							   int port_index)
 {
-	struct hlist_node *p;
 	struct team_port *port;
 	struct hlist_head *head = team_port_index_hash(team, port_index);
 
-	hlist_for_each_entry_rcu(port, p, head, hlist)
+	hlist_for_each_entry_rcu(port, head, hlist)
 		if (port->index == port_index)
 			return port;
 	return NULL;
diff -puN include/linux/list.h~hlist-drop-the-node-parameter-from-iterators include/linux/list.h
--- a/include/linux/list.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/linux/list.h
@@ -666,54 +666,49 @@ static inline void hlist_move_list(struc
 	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
 	     pos = n)
 
+#define hlist_entry_safe(ptr, type, member) \
+	(ptr) ? hlist_entry(ptr, type, member) : NULL
+
 /**
  * hlist_for_each_entry	- iterate over list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry(tpos, pos, head, member)			 \
-	for (pos = (head)->first;					 \
-	     pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+#define hlist_for_each_entry(pos, head, member)				\
+	for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
+	     pos;							\
+	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_continue - iterate over a hlist continuing after current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue(tpos, pos, member)		 \
-	for (pos = (pos)->next;						 \
-	     pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+#define hlist_for_each_entry_continue(pos, member)			\
+	for (pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member);\
+	     pos;							\
+	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_from - iterate over a hlist continuing from current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
+#define hlist_for_each_entry_from(pos, member)				\
+	for (; pos;							\
+	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @n:		another &struct hlist_node to use as temporary storage
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
-	for (pos = (head)->first;					 \
-	     pos && ({ n = pos->next; 1; }) && 				 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = n)
+#define hlist_for_each_entry_safe(pos, n, head, member) 		\
+	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);\
+	     pos && ({ n = pos->member.next; 1; });			\
+	     pos = hlist_entry_safe(n, typeof(*pos), member))
 
 #endif
diff -puN include/linux/pid.h~hlist-drop-the-node-parameter-from-iterators include/linux/pid.h
--- a/include/linux/pid.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/linux/pid.h
@@ -176,9 +176,8 @@ pid_t pid_vnr(struct pid *pid);
 
 #define do_each_pid_task(pid, type, task)				\
 	do {								\
-		struct hlist_node *pos___;				\
 		if ((pid) != NULL)					\
-			hlist_for_each_entry_rcu((task), pos___,	\
+			hlist_for_each_entry_rcu((task),		\
 				&(pid)->tasks[type], pids[type].node) {
 
 			/*
diff -puN include/linux/rculist.h~hlist-drop-the-node-parameter-from-iterators include/linux/rculist.h
--- a/include/linux/rculist.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/linux/rculist.h
@@ -445,8 +445,7 @@ static inline void hlist_add_after_rcu(s
 
 /**
  * hlist_for_each_entry_rcu - iterate over rcu list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  *
@@ -454,16 +453,16 @@ static inline void hlist_add_after_rcu(s
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu(tpos, pos, head, member)		\
-	for (pos = rcu_dereference_raw(hlist_first_rcu(head));		\
-		pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_raw(hlist_next_rcu(pos)))
+#define hlist_for_each_entry_rcu(pos, head, member)			\
+	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
+			typeof(*(pos)), member);			\
+		pos;							\
+		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
+			&(pos)->member)), typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_rcu_bh - iterate over rcu list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  *
@@ -471,35 +470,36 @@ static inline void hlist_add_after_rcu(s
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu_bh(tpos, pos, head, member)		 \
-	for (pos = rcu_dereference_bh((head)->first);			 \
-		pos &&							 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference_bh(pos->next))
+#define hlist_for_each_entry_rcu_bh(pos, head, member)			\
+	for (pos = hlist_entry_safe(rcu_dereference_bh(hlist_first_rcu(head)),\
+			typeof(*(pos)), member);			\
+		pos;							\
+		pos = hlist_entry_safe(rcu_dereference_bh(hlist_next_rcu(\
+			&(pos)->member)), typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_continue_rcu - iterate over a hlist continuing after current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
-	for (pos = rcu_dereference((pos)->next);			\
-	     pos &&							\
-	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
-	     pos = rcu_dereference(pos->next))
+#define hlist_for_each_entry_continue_rcu(pos, member)			\
+	for (pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
+			typeof(*(pos)), member);			\
+	     pos;							\
+	     pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
+	     		typeof(*(pos)), member))
 
 /**
  * hlist_for_each_entry_continue_rcu_bh - iterate over a hlist continuing after current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @pos:	the type * to use as a loop cursor.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_continue_rcu_bh(tpos, pos, member)		\
-	for (pos = rcu_dereference_bh((pos)->next);			\
-	     pos &&							\
-	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
-	     pos = rcu_dereference_bh(pos->next))
+#define hlist_for_each_entry_continue_rcu_bh(pos, member)		\
+	for (pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),\
+			typeof(*(pos)), member);			\
+	     pos;							\
+	     pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),\
+	     		typeof(*(pos)), member))
 
 
 #endif	/* __KERNEL__ */
diff -puN include/net/ax25.h~hlist-drop-the-node-parameter-from-iterators include/net/ax25.h
--- a/include/net/ax25.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/net/ax25.h
@@ -161,8 +161,8 @@ typedef struct ax25_uid_assoc {
 	ax25_address		call;
 } ax25_uid_assoc;
 
-#define ax25_uid_for_each(__ax25, node, list) \
-	hlist_for_each_entry(__ax25, node, list, uid_node)
+#define ax25_uid_for_each(__ax25, list) \
+	hlist_for_each_entry(__ax25, list, uid_node)
 
 #define ax25_uid_hold(ax25) \
 	atomic_inc(&((ax25)->refcount))
@@ -247,8 +247,8 @@ typedef struct ax25_cb {
 
 #define ax25_sk(__sk) ((ax25_cb *)(__sk)->sk_protinfo)
 
-#define ax25_for_each(__ax25, node, list) \
-	hlist_for_each_entry(__ax25, node, list, ax25_node)
+#define ax25_for_each(__ax25, list) \
+	hlist_for_each_entry(__ax25, list, ax25_node)
 
 #define ax25_cb_hold(__ax25) \
 	atomic_inc(&((__ax25)->refcount))
diff -puN include/net/inet_hashtables.h~hlist-drop-the-node-parameter-from-iterators include/net/inet_hashtables.h
--- a/include/net/inet_hashtables.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/net/inet_hashtables.h
@@ -94,8 +94,8 @@ static inline struct net *ib_net(struct 
 	return read_pnet(&ib->ib_net);
 }
 
-#define inet_bind_bucket_for_each(tb, pos, head) \
-	hlist_for_each_entry(tb, pos, head, node)
+#define inet_bind_bucket_for_each(tb, head) \
+	hlist_for_each_entry(tb, head, node)
 
 struct inet_bind_hashbucket {
 	spinlock_t		lock;
diff -puN include/net/inet_timewait_sock.h~hlist-drop-the-node-parameter-from-iterators include/net/inet_timewait_sock.h
--- a/include/net/inet_timewait_sock.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/net/inet_timewait_sock.h
@@ -178,11 +178,11 @@ static inline int inet_twsk_del_dead_nod
 #define inet_twsk_for_each(tw, node, head) \
 	hlist_nulls_for_each_entry(tw, node, head, tw_node)
 
-#define inet_twsk_for_each_inmate(tw, node, jail) \
-	hlist_for_each_entry(tw, node, jail, tw_death_node)
+#define inet_twsk_for_each_inmate(tw, jail) \
+	hlist_for_each_entry(tw, jail, tw_death_node)
 
-#define inet_twsk_for_each_inmate_safe(tw, node, safe, jail) \
-	hlist_for_each_entry_safe(tw, node, safe, jail, tw_death_node)
+#define inet_twsk_for_each_inmate_safe(tw, safe, jail) \
+	hlist_for_each_entry_safe(tw, safe, jail, tw_death_node)
 
 static inline struct inet_timewait_sock *inet_twsk(const struct sock *sk)
 {
diff -puN include/net/netrom.h~hlist-drop-the-node-parameter-from-iterators include/net/netrom.h
--- a/include/net/netrom.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/net/netrom.h
@@ -154,17 +154,17 @@ static __inline__ void nr_node_unlock(st
 	nr_node_put(nr_node);
 }
 
-#define nr_neigh_for_each(__nr_neigh, node, list) \
-	hlist_for_each_entry(__nr_neigh, node, list, neigh_node)
+#define nr_neigh_for_each(__nr_neigh, list) \
+	hlist_for_each_entry(__nr_neigh, list, neigh_node)
 
-#define nr_neigh_for_each_safe(__nr_neigh, node, node2, list) \
-	hlist_for_each_entry_safe(__nr_neigh, node, node2, list, neigh_node)
+#define nr_neigh_for_each_safe(__nr_neigh, node2, list) \
+	hlist_for_each_entry_safe(__nr_neigh, node2, list, neigh_node)
 
-#define nr_node_for_each(__nr_node, node, list) \
-	hlist_for_each_entry(__nr_node, node, list, node_node)
+#define nr_node_for_each(__nr_node, list) \
+	hlist_for_each_entry(__nr_node, list, node_node)
 
-#define nr_node_for_each_safe(__nr_node, node, node2, list) \
-	hlist_for_each_entry_safe(__nr_node, node, node2, list, node_node)
+#define nr_node_for_each_safe(__nr_node, node2, list) \
+	hlist_for_each_entry_safe(__nr_node, node2, list, node_node)
 
 
 /*********************************************************************/
diff -puN include/net/sch_generic.h~hlist-drop-the-node-parameter-from-iterators include/net/sch_generic.h
--- a/include/net/sch_generic.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/net/sch_generic.h
@@ -339,11 +339,10 @@ static inline struct Qdisc_class_common 
 qdisc_class_find(const struct Qdisc_class_hash *hash, u32 id)
 {
 	struct Qdisc_class_common *cl;
-	struct hlist_node *n;
 	unsigned int h;
 
 	h = qdisc_class_hash(id, hash->hashmask);
-	hlist_for_each_entry(cl, n, &hash->hash[h], hnode) {
+	hlist_for_each_entry(cl, &hash->hash[h], hnode) {
 		if (cl->classid == id)
 			return cl;
 	}
diff -puN include/net/sctp/sctp.h~hlist-drop-the-node-parameter-from-iterators include/net/sctp/sctp.h
--- a/include/net/sctp/sctp.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/net/sctp/sctp.h
@@ -675,8 +675,8 @@ static inline int sctp_vtag_hashfn(__u16
 	return h & (sctp_assoc_hashsize - 1);
 }
 
-#define sctp_for_each_hentry(epb, node, head) \
-	hlist_for_each_entry(epb, node, head, node)
+#define sctp_for_each_hentry(epb, head) \
+	hlist_for_each_entry(epb, head, node)
 
 /* Is a socket of this style? */
 #define sctp_style(sk, style) __sctp_style((sk), (SCTP_SOCKET_##style))
diff -puN include/net/sock.h~hlist-drop-the-node-parameter-from-iterators include/net/sock.h
--- a/include/net/sock.h~hlist-drop-the-node-parameter-from-iterators
+++ a/include/net/sock.h
@@ -606,24 +606,23 @@ static inline void sk_add_bind_node(stru
 	hlist_add_head(&sk->sk_bind_node, list);
 }
 
-#define sk_for_each(__sk, node, list) \
-	hlist_for_each_entry(__sk, node, list, sk_node)
-#define sk_for_each_rcu(__sk, node, list) \
-	hlist_for_each_entry_rcu(__sk, node, list, sk_node)
+#define sk_for_each(__sk, list) \
+	hlist_for_each_entry(__sk, list, sk_node)
+#define sk_for_each_rcu(__sk, list) \
+	hlist_for_each_entry_rcu(__sk, list, sk_node)
 #define sk_nulls_for_each(__sk, node, list) \
 	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
 #define sk_nulls_for_each_rcu(__sk, node, list) \
 	hlist_nulls_for_each_entry_rcu(__sk, node, list, sk_nulls_node)
-#define sk_for_each_from(__sk, node) \
-	if (__sk && ({ node = &(__sk)->sk_node; 1; })) \
-		hlist_for_each_entry_from(__sk, node, sk_node)
+#define sk_for_each_from(__sk) \
+	hlist_for_each_entry_from(__sk, sk_node)
 #define sk_nulls_for_each_from(__sk, node) \
 	if (__sk && ({ node = &(__sk)->sk_nulls_node; 1; })) \
 		hlist_nulls_for_each_entry_from(__sk, node, sk_nulls_node)
-#define sk_for_each_safe(__sk, node, tmp, list) \
-	hlist_for_each_entry_safe(__sk, node, tmp, list, sk_node)
-#define sk_for_each_bound(__sk, node, list) \
-	hlist_for_each_entry(__sk, node, list, sk_bind_node)
+#define sk_for_each_safe(__sk, tmp, list) \
+	hlist_for_each_entry_safe(__sk, tmp, list, sk_node)
+#define sk_for_each_bound(__sk, list) \
+	hlist_for_each_entry(__sk, list, sk_bind_node)
 
 static inline struct user_namespace *sk_user_ns(struct sock *sk)
 {
diff -puN kernel/cgroup.c~hlist-drop-the-node-parameter-from-iterators kernel/cgroup.c
--- a/kernel/cgroup.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/cgroup.c
@@ -554,7 +554,6 @@ static struct css_set *find_existing_css
 {
 	int i;
 	struct cgroupfs_root *root = cgrp->root;
-	struct hlist_node *node;
 	struct css_set *cg;
 	unsigned long key;
 
@@ -577,7 +576,7 @@ static struct css_set *find_existing_css
 	}
 
 	key = css_set_hash(template);
-	hash_for_each_possible(css_set_table, cg, node, hlist, key) {
+	hash_for_each_possible(css_set_table, cg, hlist, key) {
 		if (!compare_css_sets(cg, oldcg, cgrp, template))
 			continue;
 
@@ -1611,7 +1610,6 @@ static struct dentry *cgroup_mount(struc
 		struct cgroupfs_root *existing_root;
 		const struct cred *cred;
 		int i;
-		struct hlist_node *node;
 		struct css_set *cg;
 
 		BUG_ON(sb->s_root != NULL);
@@ -1666,7 +1664,7 @@ static struct dentry *cgroup_mount(struc
 		/* Link the top cgroup in this hierarchy into all
 		 * the css_set objects */
 		write_lock(&css_set_lock);
-		hash_for_each(css_set_table, i, node, cg, hlist)
+		hash_for_each(css_set_table, i, cg, hlist)
 			link_css_set(&tmp_cg_links, cg, root_cgrp);
 		write_unlock(&css_set_lock);
 
@@ -4493,7 +4491,7 @@ int __init_or_module cgroup_load_subsys(
 {
 	struct cgroup_subsys_state *css;
 	int i, ret;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	struct css_set *cg;
 	unsigned long key;
 
@@ -4561,7 +4559,7 @@ int __init_or_module cgroup_load_subsys(
 	 * this is all done under the css_set_lock.
 	 */
 	write_lock(&css_set_lock);
-	hash_for_each_safe(css_set_table, i, node, tmp, cg, hlist) {
+	hash_for_each_safe(css_set_table, i, tmp, cg, hlist) {
 		/* skip entries that we already rehashed */
 		if (cg->subsys[ss->subsys_id])
 			continue;
@@ -4571,7 +4569,7 @@ int __init_or_module cgroup_load_subsys(
 		cg->subsys[ss->subsys_id] = css;
 		/* recompute hash and restore entry */
 		key = css_set_hash(cg->subsys);
-		hash_add(css_set_table, node, key);
+		hash_add(css_set_table, &cg->hlist, key);
 	}
 	write_unlock(&css_set_lock);
 
diff -puN kernel/events/core.c~hlist-drop-the-node-parameter-from-iterators kernel/events/core.c
--- a/kernel/events/core.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/events/core.c
@@ -5126,7 +5126,6 @@ static void do_perf_sw_event(enum perf_t
 {
 	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
 	struct perf_event *event;
-	struct hlist_node *node;
 	struct hlist_head *head;
 
 	rcu_read_lock();
@@ -5134,7 +5133,7 @@ static void do_perf_sw_event(enum perf_t
 	if (!head)
 		goto end;
 
-	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
+	hlist_for_each_entry_rcu(event, head, hlist_entry) {
 		if (perf_swevent_match(event, type, event_id, data, regs))
 			perf_swevent_event(event, nr, data, regs);
 	}
@@ -5419,7 +5418,6 @@ void perf_tp_event(u64 addr, u64 count, 
 {
 	struct perf_sample_data data;
 	struct perf_event *event;
-	struct hlist_node *node;
 
 	struct perf_raw_record raw = {
 		.size = entry_size,
@@ -5429,7 +5427,7 @@ void perf_tp_event(u64 addr, u64 count, 
 	perf_sample_data_init(&data, addr, 0);
 	data.raw = &raw;
 
-	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
+	hlist_for_each_entry_rcu(event, head, hlist_entry) {
 		if (perf_tp_event_match(event, &data, regs))
 			perf_swevent_event(event, count, &data, regs);
 	}
diff -puN kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators kernel/kprobes.c
--- a/kernel/kprobes.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/kprobes.c
@@ -334,11 +334,10 @@ static inline void reset_kprobe_instance
 struct kprobe __kprobes *get_kprobe(void *addr)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct kprobe *p;
 
 	head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
-	hlist_for_each_entry_rcu(p, node, head, hlist) {
+	hlist_for_each_entry_rcu(p, head, hlist) {
 		if (p->addr == addr)
 			return p;
 	}
@@ -799,7 +798,6 @@ out:
 static void __kprobes optimize_all_kprobes(void)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct kprobe *p;
 	unsigned int i;
 
@@ -810,7 +808,7 @@ static void __kprobes optimize_all_kprob
 	kprobes_allow_optimization = true;
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry_rcu(p, node, head, hlist)
+		hlist_for_each_entry_rcu(p, head, hlist)
 			if (!kprobe_disabled(p))
 				optimize_kprobe(p);
 	}
@@ -821,7 +819,6 @@ static void __kprobes optimize_all_kprob
 static void __kprobes unoptimize_all_kprobes(void)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct kprobe *p;
 	unsigned int i;
 
@@ -832,7 +829,7 @@ static void __kprobes unoptimize_all_kpr
 	kprobes_allow_optimization = false;
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry_rcu(p, node, head, hlist) {
+		hlist_for_each_entry_rcu(p, head, hlist) {
 			if (!kprobe_disabled(p))
 				unoptimize_kprobe(p, false);
 		}
@@ -1148,7 +1145,7 @@ void __kprobes kprobe_flush_task(struct 
 {
 	struct kretprobe_instance *ri;
 	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	unsigned long hash, flags = 0;
 
 	if (unlikely(!kprobes_initialized))
@@ -1159,12 +1156,12 @@ void __kprobes kprobe_flush_task(struct 
 	hash = hash_ptr(tk, KPROBE_HASH_BITS);
 	head = &kretprobe_inst_table[hash];
 	kretprobe_table_lock(hash, &flags);
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task == tk)
 			recycle_rp_inst(ri, &empty_rp);
 	}
 	kretprobe_table_unlock(hash, &flags);
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
@@ -1173,9 +1170,9 @@ void __kprobes kprobe_flush_task(struct 
 static inline void free_rp_inst(struct kretprobe *rp)
 {
 	struct kretprobe_instance *ri;
-	struct hlist_node *pos, *next;
+	struct hlist_node *next;
 
-	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, hlist) {
+	hlist_for_each_entry_safe(ri, next, &rp->free_instances, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
@@ -1185,14 +1182,14 @@ static void __kprobes cleanup_rp_inst(st
 {
 	unsigned long flags, hash;
 	struct kretprobe_instance *ri;
-	struct hlist_node *pos, *next;
+	struct hlist_node *next;
 	struct hlist_head *head;
 
 	/* No race here */
 	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
 		kretprobe_table_lock(hash, &flags);
 		head = &kretprobe_inst_table[hash];
-		hlist_for_each_entry_safe(ri, pos, next, head, hlist) {
+		hlist_for_each_entry_safe(ri, next, head, hlist) {
 			if (ri->rp == rp)
 				ri->rp = NULL;
 		}
@@ -2028,7 +2025,6 @@ static int __kprobes kprobes_module_call
 {
 	struct module *mod = data;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct kprobe *p;
 	unsigned int i;
 	int checkcore = (val == MODULE_STATE_GOING);
@@ -2045,7 +2041,7 @@ static int __kprobes kprobes_module_call
 	mutex_lock(&kprobe_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry_rcu(p, node, head, hlist)
+		hlist_for_each_entry_rcu(p, head, hlist)
 			if (within_module_init((unsigned long)p->addr, mod) ||
 			    (checkcore &&
 			     within_module_core((unsigned long)p->addr, mod))) {
@@ -2192,7 +2188,6 @@ static void __kprobes kprobe_seq_stop(st
 static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct kprobe *p, *kp;
 	const char *sym = NULL;
 	unsigned int i = *(loff_t *) v;
@@ -2201,7 +2196,7 @@ static int __kprobes show_kprobe_addr(st
 
 	head = &kprobe_table[i];
 	preempt_disable();
-	hlist_for_each_entry_rcu(p, node, head, hlist) {
+	hlist_for_each_entry_rcu(p, head, hlist) {
 		sym = kallsyms_lookup((unsigned long)p->addr, NULL,
 					&offset, &modname, namebuf);
 		if (kprobe_aggrprobe(p)) {
@@ -2236,7 +2231,6 @@ static const struct file_operations debu
 static void __kprobes arm_all_kprobes(void)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct kprobe *p;
 	unsigned int i;
 
@@ -2249,7 +2243,7 @@ static void __kprobes arm_all_kprobes(vo
 	/* Arming kprobes doesn't optimize kprobe itself */
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry_rcu(p, node, head, hlist)
+		hlist_for_each_entry_rcu(p, head, hlist)
 			if (!kprobe_disabled(p))
 				arm_kprobe(p);
 	}
@@ -2265,7 +2259,6 @@ already_enabled:
 static void __kprobes disarm_all_kprobes(void)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct kprobe *p;
 	unsigned int i;
 
@@ -2282,7 +2275,7 @@ static void __kprobes disarm_all_kprobes
 
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry_rcu(p, node, head, hlist) {
+		hlist_for_each_entry_rcu(p, head, hlist) {
 			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
 				disarm_kprobe(p, false);
 		}
diff -puN kernel/pid.c~hlist-drop-the-node-parameter-from-iterators kernel/pid.c
--- a/kernel/pid.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/pid.c
@@ -350,10 +350,9 @@ void disable_pid_allocation(struct pid_n
 
 struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
 {
-	struct hlist_node *elem;
 	struct upid *pnr;
 
-	hlist_for_each_entry_rcu(pnr, elem,
+	hlist_for_each_entry_rcu(pnr,
 			&pid_hash[pid_hashfn(nr, ns)], pid_chain)
 		if (pnr->nr == nr && pnr->ns == ns)
 			return container_of(pnr, struct pid,
diff -puN kernel/sched/core.c~hlist-drop-the-node-parameter-from-iterators kernel/sched/core.c
--- a/kernel/sched/core.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/sched/core.c
@@ -1752,9 +1752,8 @@ EXPORT_SYMBOL_GPL(preempt_notifier_unreg
 static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
 {
 	struct preempt_notifier *notifier;
-	struct hlist_node *node;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	hlist_for_each_entry(notifier, &curr->preempt_notifiers, link)
 		notifier->ops->sched_in(notifier, raw_smp_processor_id());
 }
 
@@ -1763,9 +1762,8 @@ fire_sched_out_preempt_notifiers(struct 
 				 struct task_struct *next)
 {
 	struct preempt_notifier *notifier;
-	struct hlist_node *node;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	hlist_for_each_entry(notifier, &curr->preempt_notifiers, link)
 		notifier->ops->sched_out(notifier, next);
 }
 
diff -puN kernel/smpboot.c~hlist-drop-the-node-parameter-from-iterators kernel/smpboot.c
--- a/kernel/smpboot.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/smpboot.c
@@ -131,7 +131,7 @@ static int smpboot_thread_fn(void *data)
 			continue;
 		}
 
-		BUG_ON(td->cpu != smp_processor_id());
+		//BUG_ON(td->cpu != smp_processor_id());
 
 		/* Check for state change setup */
 		switch (td->status) {
diff -puN kernel/trace/ftrace.c~hlist-drop-the-node-parameter-from-iterators kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/trace/ftrace.c
@@ -762,7 +762,6 @@ ftrace_find_profiled_func(struct ftrace_
 {
 	struct ftrace_profile *rec;
 	struct hlist_head *hhd;
-	struct hlist_node *n;
 	unsigned long key;
 
 	key = hash_long(ip, ftrace_profile_bits);
@@ -771,7 +770,7 @@ ftrace_find_profiled_func(struct ftrace_
 	if (hlist_empty(hhd))
 		return NULL;
 
-	hlist_for_each_entry_rcu(rec, n, hhd, node) {
+	hlist_for_each_entry_rcu(rec, hhd, node) {
 		if (rec->ip == ip)
 			return rec;
 	}
@@ -1133,7 +1132,6 @@ ftrace_lookup_ip(struct ftrace_hash *has
 	unsigned long key;
 	struct ftrace_func_entry *entry;
 	struct hlist_head *hhd;
-	struct hlist_node *n;
 
 	if (ftrace_hash_empty(hash))
 		return NULL;
@@ -1145,7 +1143,7 @@ ftrace_lookup_ip(struct ftrace_hash *has
 
 	hhd = &hash->buckets[key];
 
-	hlist_for_each_entry_rcu(entry, n, hhd, hlist) {
+	hlist_for_each_entry_rcu(entry, hhd, hlist) {
 		if (entry->ip == ip)
 			return entry;
 	}
@@ -1202,7 +1200,7 @@ remove_hash_entry(struct ftrace_hash *ha
 static void ftrace_hash_clear(struct ftrace_hash *hash)
 {
 	struct hlist_head *hhd;
-	struct hlist_node *tp, *tn;
+	struct hlist_node *tn;
 	struct ftrace_func_entry *entry;
 	int size = 1 << hash->size_bits;
 	int i;
@@ -1212,7 +1210,7 @@ static void ftrace_hash_clear(struct ftr
 
 	for (i = 0; i < size; i++) {
 		hhd = &hash->buckets[i];
-		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist)
+		hlist_for_each_entry_safe(entry, tn, hhd, hlist)
 			free_hash_entry(hash, entry);
 	}
 	FTRACE_WARN_ON(hash->count);
@@ -1275,7 +1273,6 @@ alloc_and_copy_ftrace_hash(int size_bits
 {
 	struct ftrace_func_entry *entry;
 	struct ftrace_hash *new_hash;
-	struct hlist_node *tp;
 	int size;
 	int ret;
 	int i;
@@ -1290,7 +1287,7 @@ alloc_and_copy_ftrace_hash(int size_bits
 
 	size = 1 << hash->size_bits;
 	for (i = 0; i < size; i++) {
-		hlist_for_each_entry(entry, tp, &hash->buckets[i], hlist) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
 			ret = add_hash_entry(new_hash, entry->ip);
 			if (ret < 0)
 				goto free_hash;
@@ -1316,7 +1313,7 @@ ftrace_hash_move(struct ftrace_ops *ops,
 		 struct ftrace_hash **dst, struct ftrace_hash *src)
 {
 	struct ftrace_func_entry *entry;
-	struct hlist_node *tp, *tn;
+	struct hlist_node *tn;
 	struct hlist_head *hhd;
 	struct ftrace_hash *old_hash;
 	struct ftrace_hash *new_hash;
@@ -1362,7 +1359,7 @@ ftrace_hash_move(struct ftrace_ops *ops,
 	size = 1 << src->size_bits;
 	for (i = 0; i < size; i++) {
 		hhd = &src->buckets[i];
-		hlist_for_each_entry_safe(entry, tp, tn, hhd, hlist) {
+		hlist_for_each_entry_safe(entry, tn, hhd, hlist) {
 			if (bits > 0)
 				key = hash_long(entry->ip, bits);
 			else
@@ -2901,7 +2898,6 @@ static void function_trace_probe_call(un
 {
 	struct ftrace_func_probe *entry;
 	struct hlist_head *hhd;
-	struct hlist_node *n;
 	unsigned long key;
 
 	key = hash_long(ip, FTRACE_HASH_BITS);
@@ -2917,7 +2913,7 @@ static void function_trace_probe_call(un
 	 * on the hash. rcu_read_lock is too dangerous here.
 	 */
 	preempt_disable_notrace();
-	hlist_for_each_entry_rcu(entry, n, hhd, node) {
+	hlist_for_each_entry_rcu(entry, hhd, node) {
 		if (entry->ip == ip)
 			entry->ops->func(ip, parent_ip, &entry->data);
 	}
@@ -3068,7 +3064,7 @@ __unregister_ftrace_function_probe(char 
 				  void *data, int flags)
 {
 	struct ftrace_func_probe *entry;
-	struct hlist_node *n, *tmp;
+	struct hlist_node *tmp;
 	char str[KSYM_SYMBOL_LEN];
 	int type = MATCH_FULL;
 	int i, len = 0;
@@ -3091,7 +3087,7 @@ __unregister_ftrace_function_probe(char 
 	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
 		struct hlist_head *hhd = &ftrace_func_hash[i];
 
-		hlist_for_each_entry_safe(entry, n, tmp, hhd, node) {
+		hlist_for_each_entry_safe(entry, tmp, hhd, node) {
 
 			/* break up if statements for readability */
 			if ((flags & PROBE_TEST_FUNC) && entry->ops != ops)
diff -puN kernel/trace/trace_output.c~hlist-drop-the-node-parameter-from-iterators kernel/trace/trace_output.c
--- a/kernel/trace/trace_output.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/trace/trace_output.c
@@ -739,12 +739,11 @@ static int task_state_char(unsigned long
 struct trace_event *ftrace_find_event(int type)
 {
 	struct trace_event *event;
-	struct hlist_node *n;
 	unsigned key;
 
 	key = type & (EVENT_HASHSIZE - 1);
 
-	hlist_for_each_entry(event, n, &event_hash[key], node) {
+	hlist_for_each_entry(event, &event_hash[key], node) {
 		if (event->type == type)
 			return event;
 	}
diff -puN kernel/tracepoint.c~hlist-drop-the-node-parameter-from-iterators kernel/tracepoint.c
--- a/kernel/tracepoint.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/tracepoint.c
@@ -192,12 +192,11 @@ tracepoint_entry_remove_probe(struct tra
 static struct tracepoint_entry *get_tracepoint(const char *name)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct tracepoint_entry *e;
 	u32 hash = jhash(name, strlen(name), 0);
 
 	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
+	hlist_for_each_entry(e, head, hlist) {
 		if (!strcmp(name, e->name))
 			return e;
 	}
@@ -211,13 +210,12 @@ static struct tracepoint_entry *get_trac
 static struct tracepoint_entry *add_tracepoint(const char *name)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct tracepoint_entry *e;
 	size_t name_len = strlen(name) + 1;
 	u32 hash = jhash(name, name_len-1, 0);
 
 	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
+	hlist_for_each_entry(e, head, hlist) {
 		if (!strcmp(name, e->name)) {
 			printk(KERN_NOTICE
 				"tracepoint %s busy\n", name);
diff -puN kernel/user-return-notifier.c~hlist-drop-the-node-parameter-from-iterators kernel/user-return-notifier.c
--- a/kernel/user-return-notifier.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/user-return-notifier.c
@@ -34,11 +34,11 @@ EXPORT_SYMBOL_GPL(user_return_notifier_u
 void fire_user_return_notifiers(void)
 {
 	struct user_return_notifier *urn;
-	struct hlist_node *tmp1, *tmp2;
+	struct hlist_node *tmp2;
 	struct hlist_head *head;
 
 	head = &get_cpu_var(return_notifier_list);
-	hlist_for_each_entry_safe(urn, tmp1, tmp2, head, link)
+	hlist_for_each_entry_safe(urn, tmp2, head, link)
 		urn->on_user_return(urn);
 	put_cpu_var(return_notifier_list);
 }
diff -puN kernel/user.c~hlist-drop-the-node-parameter-from-iterators kernel/user.c
--- a/kernel/user.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/user.c
@@ -105,9 +105,8 @@ static void uid_hash_remove(struct user_
 static struct user_struct *uid_hash_find(kuid_t uid, struct hlist_head *hashent)
 {
 	struct user_struct *user;
-	struct hlist_node *h;
 
-	hlist_for_each_entry(user, h, hashent, uidhash_node) {
+	hlist_for_each_entry(user, hashent, uidhash_node) {
 		if (uid_eq(user->uid, uid)) {
 			atomic_inc(&user->__count);
 			return user;
diff -puN kernel/workqueue.c~hlist-drop-the-node-parameter-from-iterators kernel/workqueue.c
--- a/kernel/workqueue.c~hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/workqueue.c
@@ -251,8 +251,8 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 	for ((pool) = &std_worker_pools(cpu)[0];			\
 	     (pool) < &std_worker_pools(cpu)[NR_STD_WORKER_POOLS]; (pool)++)
 
-#define for_each_busy_worker(worker, i, pos, pool)			\
-	hash_for_each(pool->busy_hash, i, pos, worker, hentry)
+#define for_each_busy_worker(worker, i, pool)				\
+	hash_for_each(pool->busy_hash, i, worker, hentry)
 
 static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 				unsigned int sw)
@@ -909,9 +909,8 @@ static struct worker *find_worker_execut
 						 struct work_struct *work)
 {
 	struct worker *worker;
-	struct hlist_node *tmp;
 
-	hash_for_each_possible(pool->busy_hash, worker, tmp, hentry,
+	hash_for_each_possible(pool->busy_hash, worker, hentry,
 			       (unsigned long)work)
 		if (worker->current_work == work &&
 		    worker->current_func == work->func)
@@ -1626,7 +1625,6 @@ static void busy_worker_rebind_fn(struct
 static void rebind_workers(struct worker_pool *pool)
 {
 	struct worker *worker, *n;
-	struct hlist_node *pos;
 	int i;
 
 	lockdep_assert_held(&pool->assoc_mutex);
@@ -1648,7 +1646,7 @@ static void rebind_workers(struct worker
 	}
 
 	/* rebind busy workers */
-	for_each_busy_worker(worker, i, pos, pool) {
+	for_each_busy_worker(worker, i, pool) {
 		struct work_struct *rebind_work = &worker->rebind_work;
 		struct workqueue_struct *wq;
 
@@ -3423,7 +3421,6 @@ static void wq_unbind_fn(struct work_str
 	int cpu = smp_processor_id();
 	struct worker_pool *pool;
 	struct worker *worker;
-	struct hlist_node *pos;
 	int i;
 
 	for_each_std_worker_pool(pool, cpu) {
@@ -3442,7 +3439,7 @@ static void wq_unbind_fn(struct work_str
 		list_for_each_entry(worker, &pool->idle_list, entry)
 			worker->flags |= WORKER_UNBOUND;
 
-		for_each_busy_worker(worker, i, pos, pool)
+		for_each_busy_worker(worker, i, pool)
 			worker->flags |= WORKER_UNBOUND;
 
 		pool->flags |= POOL_DISASSOCIATED;
diff -puN lib/debugobjects.c~hlist-drop-the-node-parameter-from-iterators lib/debugobjects.c
--- a/lib/debugobjects.c~hlist-drop-the-node-parameter-from-iterators
+++ a/lib/debugobjects.c
@@ -109,11 +109,10 @@ static void fill_pool(void)
  */
 static struct debug_obj *lookup_object(void *addr, struct debug_bucket *b)
 {
-	struct hlist_node *node;
 	struct debug_obj *obj;
 	int cnt = 0;
 
-	hlist_for_each_entry(obj, node, &b->list, node) {
+	hlist_for_each_entry(obj, &b->list, node) {
 		cnt++;
 		if (obj->object == addr)
 			return obj;
@@ -213,7 +212,7 @@ static void free_object(struct debug_obj
 static void debug_objects_oom(void)
 {
 	struct debug_bucket *db = obj_hash;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	HLIST_HEAD(freelist);
 	struct debug_obj *obj;
 	unsigned long flags;
@@ -227,7 +226,7 @@ static void debug_objects_oom(void)
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 
 		/* Now free them */
-		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
+		hlist_for_each_entry_safe(obj, tmp, &freelist, node) {
 			hlist_del(&obj->node);
 			free_object(obj);
 		}
@@ -658,7 +657,7 @@ debug_object_active_state(void *addr, st
 static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 {
 	unsigned long flags, oaddr, saddr, eaddr, paddr, chunks;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	HLIST_HEAD(freelist);
 	struct debug_obj_descr *descr;
 	enum debug_obj_state state;
@@ -678,7 +677,7 @@ static void __debug_check_no_obj_freed(c
 repeat:
 		cnt = 0;
 		raw_spin_lock_irqsave(&db->lock, flags);
-		hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
+		hlist_for_each_entry_safe(obj, tmp, &db->list, node) {
 			cnt++;
 			oaddr = (unsigned long) obj->object;
 			if (oaddr < saddr || oaddr >= eaddr)
@@ -702,7 +701,7 @@ repeat:
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 
 		/* Now free them */
-		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
+		hlist_for_each_entry_safe(obj, tmp, &freelist, node) {
 			hlist_del(&obj->node);
 			free_object(obj);
 		}
@@ -1013,7 +1012,7 @@ void __init debug_objects_early_init(voi
 static int __init debug_objects_replace_static_objects(void)
 {
 	struct debug_bucket *db = obj_hash;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	struct debug_obj *obj, *new;
 	HLIST_HEAD(objects);
 	int i, cnt = 0;
@@ -1033,7 +1032,7 @@ static int __init debug_objects_replace_
 	local_irq_disable();
 
 	/* Remove the statically allocated objects from the pool */
-	hlist_for_each_entry_safe(obj, node, tmp, &obj_pool, node)
+	hlist_for_each_entry_safe(obj, tmp, &obj_pool, node)
 		hlist_del(&obj->node);
 	/* Move the allocated objects to the pool */
 	hlist_move_list(&objects, &obj_pool);
@@ -1042,7 +1041,7 @@ static int __init debug_objects_replace_
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
 		hlist_move_list(&db->list, &objects);
 
-		hlist_for_each_entry(obj, node, &objects, node) {
+		hlist_for_each_entry(obj, &objects, node) {
 			new = hlist_entry(obj_pool.first, typeof(*obj), node);
 			hlist_del(&new->node);
 			/* copy object data */
@@ -1057,7 +1056,7 @@ static int __init debug_objects_replace_
 	       obj_pool_used);
 	return 0;
 free:
-	hlist_for_each_entry_safe(obj, node, tmp, &objects, node) {
+	hlist_for_each_entry_safe(obj, tmp, &objects, node) {
 		hlist_del(&obj->node);
 		kmem_cache_free(obj_cache, obj);
 	}
diff -puN lib/lru_cache.c~hlist-drop-the-node-parameter-from-iterators lib/lru_cache.c
--- a/lib/lru_cache.c~hlist-drop-the-node-parameter-from-iterators
+++ a/lib/lru_cache.c
@@ -262,12 +262,11 @@ static struct hlist_head *lc_hash_slot(s
 static struct lc_element *__lc_find(struct lru_cache *lc, unsigned int enr,
 		bool include_changing)
 {
-	struct hlist_node *n;
 	struct lc_element *e;
 
 	BUG_ON(!lc);
 	BUG_ON(!lc->nr_elements);
-	hlist_for_each_entry(e, n, lc_hash_slot(lc, enr), colision) {
+	hlist_for_each_entry(e, lc_hash_slot(lc, enr), colision) {
 		/* "about to be changed" elements, pending transaction commit,
 		 * are hashed by their "new number". "Normal" elements have
 		 * lc_number == lc_new_number. */
diff -puN mm/huge_memory.c~hlist-drop-the-node-parameter-from-iterators mm/huge_memory.c
--- a/mm/huge_memory.c~hlist-drop-the-node-parameter-from-iterators
+++ a/mm/huge_memory.c
@@ -1906,9 +1906,8 @@ static inline void free_mm_slot(struct m
 static struct mm_slot *get_mm_slot(struct mm_struct *mm)
 {
 	struct mm_slot *mm_slot;
-	struct hlist_node *node;
 
-	hash_for_each_possible(mm_slots_hash, mm_slot, node, hash, (unsigned long)mm)
+	hash_for_each_possible(mm_slots_hash, mm_slot, hash, (unsigned long)mm)
 		if (mm == mm_slot->mm)
 			return mm_slot;
 
diff -puN mm/kmemleak.c~hlist-drop-the-node-parameter-from-iterators mm/kmemleak.c
--- a/mm/kmemleak.c~hlist-drop-the-node-parameter-from-iterators
+++ a/mm/kmemleak.c
@@ -436,7 +436,7 @@ static int get_object(struct kmemleak_ob
  */
 static void free_object_rcu(struct rcu_head *rcu)
 {
-	struct hlist_node *elem, *tmp;
+	struct hlist_node *tmp;
 	struct kmemleak_scan_area *area;
 	struct kmemleak_object *object =
 		container_of(rcu, struct kmemleak_object, rcu);
@@ -445,8 +445,8 @@ static void free_object_rcu(struct rcu_h
 	 * Once use_count is 0 (guaranteed by put_object), there is no other
 	 * code accessing this object, hence no need for locking.
 	 */
-	hlist_for_each_entry_safe(area, elem, tmp, &object->area_list, node) {
-		hlist_del(elem);
+	hlist_for_each_entry_safe(area, tmp, &object->area_list, node) {
+		hlist_del(&area->node);
 		kmem_cache_free(scan_area_cache, area);
 	}
 	kmem_cache_free(object_cache, object);
@@ -1177,7 +1177,6 @@ static void scan_block(void *_start, voi
 static void scan_object(struct kmemleak_object *object)
 {
 	struct kmemleak_scan_area *area;
-	struct hlist_node *elem;
 	unsigned long flags;
 
 	/*
@@ -1205,7 +1204,7 @@ static void scan_object(struct kmemleak_
 			spin_lock_irqsave(&object->lock, flags);
 		}
 	} else
-		hlist_for_each_entry(area, elem, &object->area_list, node)
+		hlist_for_each_entry(area, &object->area_list, node)
 			scan_block((void *)area->start,
 				   (void *)(area->start + area->size),
 				   object, 0);
diff -puN mm/ksm.c~hlist-drop-the-node-parameter-from-iterators mm/ksm.c
--- a/mm/ksm.c~hlist-drop-the-node-parameter-from-iterators
+++ a/mm/ksm.c
@@ -320,10 +320,9 @@ static inline void free_mm_slot(struct m
 
 static struct mm_slot *get_mm_slot(struct mm_struct *mm)
 {
-	struct hlist_node *node;
 	struct mm_slot *slot;
 
-	hash_for_each_possible(mm_slots_hash, slot, node, link, (unsigned long)mm)
+	hash_for_each_possible(mm_slots_hash, slot, link, (unsigned long)mm)
 		if (slot->mm == mm)
 			return slot;
 
@@ -496,9 +495,8 @@ static inline int get_kpfn_nid(unsigned 
 static void remove_node_from_stable_tree(struct stable_node *stable_node)
 {
 	struct rmap_item *rmap_item;
-	struct hlist_node *hlist;
 
-	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
+	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		if (rmap_item->hlist.next)
 			ksm_pages_sharing--;
 		else
@@ -1898,7 +1896,6 @@ int page_referenced_ksm(struct page *pag
 {
 	struct stable_node *stable_node;
 	struct rmap_item *rmap_item;
-	struct hlist_node *hlist;
 	unsigned int mapcount = page_mapcount(page);
 	int referenced = 0;
 	int search_new_forks = 0;
@@ -1910,7 +1907,7 @@ int page_referenced_ksm(struct page *pag
 	if (!stable_node)
 		return 0;
 again:
-	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
+	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -1952,7 +1949,6 @@ out:
 int try_to_unmap_ksm(struct page *page, enum ttu_flags flags)
 {
 	struct stable_node *stable_node;
-	struct hlist_node *hlist;
 	struct rmap_item *rmap_item;
 	int ret = SWAP_AGAIN;
 	int search_new_forks = 0;
@@ -1964,7 +1960,7 @@ int try_to_unmap_ksm(struct page *page, 
 	if (!stable_node)
 		return SWAP_FAIL;
 again:
-	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
+	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -2005,7 +2001,6 @@ int rmap_walk_ksm(struct page *page, int
 		  struct vm_area_struct *, unsigned long, void *), void *arg)
 {
 	struct stable_node *stable_node;
-	struct hlist_node *hlist;
 	struct rmap_item *rmap_item;
 	int ret = SWAP_AGAIN;
 	int search_new_forks = 0;
@@ -2017,7 +2012,7 @@ int rmap_walk_ksm(struct page *page, int
 	if (!stable_node)
 		return ret;
 again:
-	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
+	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
diff -puN mm/mmu_notifier.c~hlist-drop-the-node-parameter-from-iterators mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~hlist-drop-the-node-parameter-from-iterators
+++ a/mm/mmu_notifier.c
@@ -95,11 +95,10 @@ int __mmu_notifier_clear_flush_young(str
 					unsigned long address)
 {
 	struct mmu_notifier *mn;
-	struct hlist_node *n;
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->clear_flush_young)
 			young |= mn->ops->clear_flush_young(mn, mm, address);
 	}
@@ -112,11 +111,10 @@ int __mmu_notifier_test_young(struct mm_
 			      unsigned long address)
 {
 	struct mmu_notifier *mn;
-	struct hlist_node *n;
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->test_young) {
 			young = mn->ops->test_young(mn, mm, address);
 			if (young)
@@ -132,11 +130,10 @@ void __mmu_notifier_change_pte(struct mm
 			       pte_t pte)
 {
 	struct mmu_notifier *mn;
-	struct hlist_node *n;
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->change_pte)
 			mn->ops->change_pte(mn, mm, address, pte);
 	}
@@ -147,11 +144,10 @@ void __mmu_notifier_invalidate_page(stru
 					  unsigned long address)
 {
 	struct mmu_notifier *mn;
-	struct hlist_node *n;
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->invalidate_page)
 			mn->ops->invalidate_page(mn, mm, address);
 	}
@@ -162,11 +158,10 @@ void __mmu_notifier_invalidate_range_sta
 				  unsigned long start, unsigned long end)
 {
 	struct mmu_notifier *mn;
-	struct hlist_node *n;
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->invalidate_range_start)
 			mn->ops->invalidate_range_start(mn, mm, start, end);
 	}
@@ -178,11 +173,10 @@ void __mmu_notifier_invalidate_range_end
 				  unsigned long start, unsigned long end)
 {
 	struct mmu_notifier *mn;
-	struct hlist_node *n;
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->invalidate_range_end)
 			mn->ops->invalidate_range_end(mn, mm, start, end);
 	}
diff -puN net/9p/error.c~hlist-drop-the-node-parameter-from-iterators net/9p/error.c
--- a/net/9p/error.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/9p/error.c
@@ -221,15 +221,13 @@ EXPORT_SYMBOL(p9_error_init);
 int p9_errstr2errno(char *errstr, int len)
 {
 	int errno;
-	struct hlist_node *p;
 	struct errormap *c;
 	int bucket;
 
 	errno = 0;
-	p = NULL;
 	c = NULL;
 	bucket = jhash(errstr, len, 0) % ERRHASHSZ;
-	hlist_for_each_entry(c, p, &hash_errmap[bucket], list) {
+	hlist_for_each_entry(c, &hash_errmap[bucket], list) {
 		if (c->namelen == len && !memcmp(c->name, errstr, len)) {
 			errno = c->val;
 			break;
diff -puN net/9p/trans_virtio.c~hlist-drop-the-node-parameter-from-iterators net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/9p/trans_virtio.c
@@ -655,7 +655,7 @@ static struct p9_trans_module p9_virtio_
 	.create = p9_virtio_create,
 	.close = p9_virtio_close,
 	.request = p9_virtio_request,
-	.zc_request = p9_virtio_zc_request,
+	//.zc_request = p9_virtio_zc_request,
 	.cancel = p9_virtio_cancel,
 	/*
 	 * We leave one entry for input and one entry for response
diff -puN net/appletalk/ddp.c~hlist-drop-the-node-parameter-from-iterators net/appletalk/ddp.c
--- a/net/appletalk/ddp.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/appletalk/ddp.c
@@ -93,10 +93,9 @@ static struct sock *atalk_search_socket(
 					struct atalk_iface *atif)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	read_lock_bh(&atalk_sockets_lock);
-	sk_for_each(s, node, &atalk_sockets) {
+	sk_for_each(s, &atalk_sockets) {
 		struct atalk_sock *at = at_sk(s);
 
 		if (to->sat_port != at->src_port)
@@ -141,11 +140,10 @@ static struct sock *atalk_find_or_insert
 						struct sockaddr_at *sat)
 {
 	struct sock *s;
-	struct hlist_node *node;
 	struct atalk_sock *at;
 
 	write_lock_bh(&atalk_sockets_lock);
-	sk_for_each(s, node, &atalk_sockets) {
+	sk_for_each(s, &atalk_sockets) {
 		at = at_sk(s);
 
 		if (at->src_net == sat->sat_addr.s_net &&
@@ -1084,9 +1082,8 @@ static int atalk_pick_and_bind_port(stru
 	     sat->sat_port < ATPORT_LAST;
 	     sat->sat_port++) {
 		struct sock *s;
-		struct hlist_node *node;
 
-		sk_for_each(s, node, &atalk_sockets) {
+		sk_for_each(s, &atalk_sockets) {
 			struct atalk_sock *at = at_sk(s);
 
 			if (at->src_net == sat->sat_addr.s_net &&
diff -puN net/atm/common.c~hlist-drop-the-node-parameter-from-iterators net/atm/common.c
--- a/net/atm/common.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/atm/common.c
@@ -270,11 +270,11 @@ void atm_dev_release_vccs(struct atm_dev
 	write_lock_irq(&vcc_sklist_lock);
 	for (i = 0; i < VCC_HTABLE_SIZE; i++) {
 		struct hlist_head *head = &vcc_hash[i];
-		struct hlist_node *node, *tmp;
+		struct hlist_node *tmp;
 		struct sock *s;
 		struct atm_vcc *vcc;
 
-		sk_for_each_safe(s, node, tmp, head) {
+		sk_for_each_safe(s, tmp, head) {
 			vcc = atm_sk(s);
 			if (vcc->dev == dev) {
 				vcc_release_async(vcc, -EPIPE);
@@ -317,11 +317,10 @@ static int adjust_tp(struct atm_trafprm 
 static int check_ci(const struct atm_vcc *vcc, short vpi, int vci)
 {
 	struct hlist_head *head = &vcc_hash[vci & (VCC_HTABLE_SIZE - 1)];
-	struct hlist_node *node;
 	struct sock *s;
 	struct atm_vcc *walk;
 
-	sk_for_each(s, node, head) {
+	sk_for_each(s, head) {
 		walk = atm_sk(s);
 		if (walk->dev != vcc->dev)
 			continue;
diff -puN net/atm/lec.c~hlist-drop-the-node-parameter-from-iterators net/atm/lec.c
--- a/net/atm/lec.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/atm/lec.c
@@ -842,7 +842,9 @@ static void *lec_tbl_walk(struct lec_sta
 		--*l;
 	}
 
-	hlist_for_each_entry_from(tmp, e, next) {
+	tmp = container_of(e, struct lec_arp_table, next);
+
+	hlist_for_each_entry_from(tmp, next) {
 		if (--*l < 0)
 			break;
 	}
@@ -1307,7 +1309,6 @@ lec_arp_add(struct lec_priv *priv, struc
 static int
 lec_arp_remove(struct lec_priv *priv, struct lec_arp_table *to_remove)
 {
-	struct hlist_node *node;
 	struct lec_arp_table *entry;
 	int i, remove_vcc = 1;
 
@@ -1326,7 +1327,7 @@ lec_arp_remove(struct lec_priv *priv, st
 		 * ESI_FLUSH_PENDING, ESI_FORWARD_DIRECT
 		 */
 		for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-			hlist_for_each_entry(entry, node,
+			hlist_for_each_entry(entry,
 					     &priv->lec_arp_tables[i], next) {
 				if (memcmp(to_remove->atm_addr,
 					   entry->atm_addr, ATM_ESA_LEN) == 0) {
@@ -1364,14 +1365,13 @@ static const char *get_status_string(uns
 
 static void dump_arp_table(struct lec_priv *priv)
 {
-	struct hlist_node *node;
 	struct lec_arp_table *rulla;
 	char buf[256];
 	int i, j, offset;
 
 	pr_info("Dump %p:\n", priv);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-		hlist_for_each_entry(rulla, node,
+		hlist_for_each_entry(rulla,
 				     &priv->lec_arp_tables[i], next) {
 			offset = 0;
 			offset += sprintf(buf, "%d: %p\n", i, rulla);
@@ -1403,7 +1403,7 @@ static void dump_arp_table(struct lec_pr
 
 	if (!hlist_empty(&priv->lec_no_forward))
 		pr_info("No forward\n");
-	hlist_for_each_entry(rulla, node, &priv->lec_no_forward, next) {
+	hlist_for_each_entry(rulla, &priv->lec_no_forward, next) {
 		offset = 0;
 		offset += sprintf(buf + offset, "Mac: %pM", rulla->mac_addr);
 		offset += sprintf(buf + offset, " Atm:");
@@ -1428,7 +1428,7 @@ static void dump_arp_table(struct lec_pr
 
 	if (!hlist_empty(&priv->lec_arp_empty_ones))
 		pr_info("Empty ones\n");
-	hlist_for_each_entry(rulla, node, &priv->lec_arp_empty_ones, next) {
+	hlist_for_each_entry(rulla, &priv->lec_arp_empty_ones, next) {
 		offset = 0;
 		offset += sprintf(buf + offset, "Mac: %pM", rulla->mac_addr);
 		offset += sprintf(buf + offset, " Atm:");
@@ -1453,7 +1453,7 @@ static void dump_arp_table(struct lec_pr
 
 	if (!hlist_empty(&priv->mcast_fwds))
 		pr_info("Multicast Forward VCCs\n");
-	hlist_for_each_entry(rulla, node, &priv->mcast_fwds, next) {
+	hlist_for_each_entry(rulla, &priv->mcast_fwds, next) {
 		offset = 0;
 		offset += sprintf(buf + offset, "Mac: %pM", rulla->mac_addr);
 		offset += sprintf(buf + offset, " Atm:");
@@ -1487,7 +1487,7 @@ static void dump_arp_table(struct lec_pr
 static void lec_arp_destroy(struct lec_priv *priv)
 {
 	unsigned long flags;
-	struct hlist_node *node, *next;
+	struct hlist_node *next;
 	struct lec_arp_table *entry;
 	int i;
 
@@ -1499,7 +1499,7 @@ static void lec_arp_destroy(struct lec_p
 
 	spin_lock_irqsave(&priv->lec_arp_lock, flags);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-		hlist_for_each_entry_safe(entry, node, next,
+		hlist_for_each_entry_safe(entry, next,
 					  &priv->lec_arp_tables[i], next) {
 			lec_arp_remove(priv, entry);
 			lec_arp_put(entry);
@@ -1507,7 +1507,7 @@ static void lec_arp_destroy(struct lec_p
 		INIT_HLIST_HEAD(&priv->lec_arp_tables[i]);
 	}
 
-	hlist_for_each_entry_safe(entry, node, next,
+	hlist_for_each_entry_safe(entry, next,
 				  &priv->lec_arp_empty_ones, next) {
 		del_timer_sync(&entry->timer);
 		lec_arp_clear_vccs(entry);
@@ -1516,7 +1516,7 @@ static void lec_arp_destroy(struct lec_p
 	}
 	INIT_HLIST_HEAD(&priv->lec_arp_empty_ones);
 
-	hlist_for_each_entry_safe(entry, node, next,
+	hlist_for_each_entry_safe(entry, next,
 				  &priv->lec_no_forward, next) {
 		del_timer_sync(&entry->timer);
 		lec_arp_clear_vccs(entry);
@@ -1525,7 +1525,7 @@ static void lec_arp_destroy(struct lec_p
 	}
 	INIT_HLIST_HEAD(&priv->lec_no_forward);
 
-	hlist_for_each_entry_safe(entry, node, next, &priv->mcast_fwds, next) {
+	hlist_for_each_entry_safe(entry, next, &priv->mcast_fwds, next) {
 		/* No timer, LANEv2 7.1.20 and 2.3.5.3 */
 		lec_arp_clear_vccs(entry);
 		hlist_del(&entry->next);
@@ -1542,14 +1542,13 @@ static void lec_arp_destroy(struct lec_p
 static struct lec_arp_table *lec_arp_find(struct lec_priv *priv,
 					  const unsigned char *mac_addr)
 {
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct lec_arp_table *entry;
 
 	pr_debug("%pM\n", mac_addr);
 
 	head = &priv->lec_arp_tables[HASH(mac_addr[ETH_ALEN - 1])];
-	hlist_for_each_entry(entry, node, head, next) {
+	hlist_for_each_entry(entry, head, next) {
 		if (ether_addr_equal(mac_addr, entry->mac_addr))
 			return entry;
 	}
@@ -1686,7 +1685,7 @@ static void lec_arp_check_expire(struct 
 	unsigned long flags;
 	struct lec_priv *priv =
 		container_of(work, struct lec_priv, lec_arp_work.work);
-	struct hlist_node *node, *next;
+	struct hlist_node *next;
 	struct lec_arp_table *entry;
 	unsigned long now;
 	int i;
@@ -1696,7 +1695,7 @@ static void lec_arp_check_expire(struct 
 restart:
 	spin_lock_irqsave(&priv->lec_arp_lock, flags);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-		hlist_for_each_entry_safe(entry, node, next,
+		hlist_for_each_entry_safe(entry, next,
 					  &priv->lec_arp_tables[i], next) {
 			if (__lec_arp_check_expire(entry, now, priv)) {
 				struct sk_buff *skb;
@@ -1823,14 +1822,14 @@ lec_addr_delete(struct lec_priv *priv, c
 		unsigned long permanent)
 {
 	unsigned long flags;
-	struct hlist_node *node, *next;
+	struct hlist_node *next;
 	struct lec_arp_table *entry;
 	int i;
 
 	pr_debug("\n");
 	spin_lock_irqsave(&priv->lec_arp_lock, flags);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-		hlist_for_each_entry_safe(entry, node, next,
+		hlist_for_each_entry_safe(entry, next,
 					  &priv->lec_arp_tables[i], next) {
 			if (!memcmp(atm_addr, entry->atm_addr, ATM_ESA_LEN) &&
 			    (permanent ||
@@ -1855,7 +1854,7 @@ lec_arp_update(struct lec_priv *priv, co
 	       unsigned int targetless_le_arp)
 {
 	unsigned long flags;
-	struct hlist_node *node, *next;
+	struct hlist_node *next;
 	struct lec_arp_table *entry, *tmp;
 	int i;
 
@@ -1870,7 +1869,7 @@ lec_arp_update(struct lec_priv *priv, co
 				 * we have no entry in the cache. 7.1.30
 				 */
 	if (!hlist_empty(&priv->lec_arp_empty_ones)) {
-		hlist_for_each_entry_safe(entry, node, next,
+		hlist_for_each_entry_safe(entry, next,
 					  &priv->lec_arp_empty_ones, next) {
 			if (memcmp(entry->atm_addr, atm_addr, ATM_ESA_LEN) == 0) {
 				hlist_del(&entry->next);
@@ -1915,7 +1914,7 @@ lec_arp_update(struct lec_priv *priv, co
 	memcpy(entry->atm_addr, atm_addr, ATM_ESA_LEN);
 	del_timer(&entry->timer);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-		hlist_for_each_entry(tmp, node,
+		hlist_for_each_entry(tmp,
 				     &priv->lec_arp_tables[i], next) {
 			if (entry != tmp &&
 			    !memcmp(tmp->atm_addr, atm_addr, ATM_ESA_LEN)) {
@@ -1956,7 +1955,6 @@ lec_vcc_added(struct lec_priv *priv, con
 	      void (*old_push) (struct atm_vcc *vcc, struct sk_buff *skb))
 {
 	unsigned long flags;
-	struct hlist_node *node;
 	struct lec_arp_table *entry;
 	int i, found_entry = 0;
 
@@ -2026,7 +2024,7 @@ lec_vcc_added(struct lec_priv *priv, con
 		 ioc_data->atm_addr[16], ioc_data->atm_addr[17],
 		 ioc_data->atm_addr[18], ioc_data->atm_addr[19]);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-		hlist_for_each_entry(entry, node,
+		hlist_for_each_entry(entry,
 				     &priv->lec_arp_tables[i], next) {
 			if (memcmp
 			    (ioc_data->atm_addr, entry->atm_addr,
@@ -2103,7 +2101,6 @@ out:
 static void lec_flush_complete(struct lec_priv *priv, unsigned long tran_id)
 {
 	unsigned long flags;
-	struct hlist_node *node;
 	struct lec_arp_table *entry;
 	int i;
 
@@ -2111,7 +2108,7 @@ static void lec_flush_complete(struct le
 restart:
 	spin_lock_irqsave(&priv->lec_arp_lock, flags);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-		hlist_for_each_entry(entry, node,
+		hlist_for_each_entry(entry,
 				     &priv->lec_arp_tables[i], next) {
 			if (entry->flush_tran_id == tran_id &&
 			    entry->status == ESI_FLUSH_PENDING) {
@@ -2140,13 +2137,12 @@ lec_set_flush_tran_id(struct lec_priv *p
 		      const unsigned char *atm_addr, unsigned long tran_id)
 {
 	unsigned long flags;
-	struct hlist_node *node;
 	struct lec_arp_table *entry;
 	int i;
 
 	spin_lock_irqsave(&priv->lec_arp_lock, flags);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++)
-		hlist_for_each_entry(entry, node,
+		hlist_for_each_entry(entry,
 				     &priv->lec_arp_tables[i], next) {
 			if (!memcmp(atm_addr, entry->atm_addr, ATM_ESA_LEN)) {
 				entry->flush_tran_id = tran_id;
@@ -2198,7 +2194,7 @@ out:
 static void lec_vcc_close(struct lec_priv *priv, struct atm_vcc *vcc)
 {
 	unsigned long flags;
-	struct hlist_node *node, *next;
+	struct hlist_node *next;
 	struct lec_arp_table *entry;
 	int i;
 
@@ -2208,7 +2204,7 @@ static void lec_vcc_close(struct lec_pri
 	spin_lock_irqsave(&priv->lec_arp_lock, flags);
 
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
-		hlist_for_each_entry_safe(entry, node, next,
+		hlist_for_each_entry_safe(entry, next,
 					  &priv->lec_arp_tables[i], next) {
 			if (vcc == entry->vcc) {
 				lec_arp_remove(priv, entry);
@@ -2219,7 +2215,7 @@ static void lec_vcc_close(struct lec_pri
 		}
 	}
 
-	hlist_for_each_entry_safe(entry, node, next,
+	hlist_for_each_entry_safe(entry, next,
 				  &priv->lec_arp_empty_ones, next) {
 		if (entry->vcc == vcc) {
 			lec_arp_clear_vccs(entry);
@@ -2229,7 +2225,7 @@ static void lec_vcc_close(struct lec_pri
 		}
 	}
 
-	hlist_for_each_entry_safe(entry, node, next,
+	hlist_for_each_entry_safe(entry, next,
 				  &priv->lec_no_forward, next) {
 		if (entry->recv_vcc == vcc) {
 			lec_arp_clear_vccs(entry);
@@ -2239,7 +2235,7 @@ static void lec_vcc_close(struct lec_pri
 		}
 	}
 
-	hlist_for_each_entry_safe(entry, node, next, &priv->mcast_fwds, next) {
+	hlist_for_each_entry_safe(entry, next, &priv->mcast_fwds, next) {
 		if (entry->recv_vcc == vcc) {
 			lec_arp_clear_vccs(entry);
 			/* No timer, LANEv2 7.1.20 and 2.3.5.3 */
@@ -2257,13 +2253,13 @@ lec_arp_check_empties(struct lec_priv *p
 		      struct atm_vcc *vcc, struct sk_buff *skb)
 {
 	unsigned long flags;
-	struct hlist_node *node, *next;
+	struct hlist_node *next;
 	struct lec_arp_table *entry, *tmp;
 	struct lecdatahdr_8023 *hdr = (struct lecdatahdr_8023 *)skb->data;
 	unsigned char *src = hdr->h_source;
 
 	spin_lock_irqsave(&priv->lec_arp_lock, flags);
-	hlist_for_each_entry_safe(entry, node, next,
+	hlist_for_each_entry_safe(entry, next,
 				  &priv->lec_arp_empty_ones, next) {
 		if (vcc == entry->vcc) {
 			del_timer(&entry->timer);
diff -puN net/atm/signaling.c~hlist-drop-the-node-parameter-from-iterators net/atm/signaling.c
--- a/net/atm/signaling.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/atm/signaling.c
@@ -217,7 +217,6 @@ static void purge_vcc(struct atm_vcc *vc
 
 static void sigd_close(struct atm_vcc *vcc)
 {
-	struct hlist_node *node;
 	struct sock *s;
 	int i;
 
@@ -231,7 +230,7 @@ static void sigd_close(struct atm_vcc *v
 	for (i = 0; i < VCC_HTABLE_SIZE; ++i) {
 		struct hlist_head *head = &vcc_hash[i];
 
-		sk_for_each(s, node, head) {
+		sk_for_each(s, head) {
 			vcc = atm_sk(s);
 
 			purge_vcc(vcc);
diff -puN net/ax25/af_ax25.c~hlist-drop-the-node-parameter-from-iterators net/ax25/af_ax25.c
--- a/net/ax25/af_ax25.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ax25/af_ax25.c
@@ -81,14 +81,13 @@ static void ax25_kill_by_device(struct n
 {
 	ax25_dev *ax25_dev;
 	ax25_cb *s;
-	struct hlist_node *node;
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
 
 	spin_lock_bh(&ax25_list_lock);
 again:
-	ax25_for_each(s, node, &ax25_list) {
+	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
 			s->ax25_dev = NULL;
 			spin_unlock_bh(&ax25_list_lock);
@@ -158,10 +157,9 @@ struct sock *ax25_find_listener(ax25_add
 	struct net_device *dev, int type)
 {
 	ax25_cb *s;
-	struct hlist_node *node;
 
 	spin_lock(&ax25_list_lock);
-	ax25_for_each(s, node, &ax25_list) {
+	ax25_for_each(s, &ax25_list) {
 		if ((s->iamdigi && !digi) || (!s->iamdigi && digi))
 			continue;
 		if (s->sk && !ax25cmp(&s->source_addr, addr) &&
@@ -187,10 +185,9 @@ struct sock *ax25_get_socket(ax25_addres
 {
 	struct sock *sk = NULL;
 	ax25_cb *s;
-	struct hlist_node *node;
 
 	spin_lock(&ax25_list_lock);
-	ax25_for_each(s, node, &ax25_list) {
+	ax25_for_each(s, &ax25_list) {
 		if (s->sk && !ax25cmp(&s->source_addr, my_addr) &&
 		    !ax25cmp(&s->dest_addr, dest_addr) &&
 		    s->sk->sk_type == type) {
@@ -213,10 +210,9 @@ ax25_cb *ax25_find_cb(ax25_address *src_
 	ax25_digi *digi, struct net_device *dev)
 {
 	ax25_cb *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&ax25_list_lock);
-	ax25_for_each(s, node, &ax25_list) {
+	ax25_for_each(s, &ax25_list) {
 		if (s->sk && s->sk->sk_type != SOCK_SEQPACKET)
 			continue;
 		if (s->ax25_dev == NULL)
@@ -248,10 +244,9 @@ void ax25_send_to_raw(ax25_address *addr
 {
 	ax25_cb *s;
 	struct sk_buff *copy;
-	struct hlist_node *node;
 
 	spin_lock(&ax25_list_lock);
-	ax25_for_each(s, node, &ax25_list) {
+	ax25_for_each(s, &ax25_list) {
 		if (s->sk != NULL && ax25cmp(&s->source_addr, addr) == 0 &&
 		    s->sk->sk_type == SOCK_RAW &&
 		    s->sk->sk_protocol == proto &&
diff -puN net/ax25/ax25_ds_subr.c~hlist-drop-the-node-parameter-from-iterators net/ax25/ax25_ds_subr.c
--- a/net/ax25/ax25_ds_subr.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ax25/ax25_ds_subr.c
@@ -39,7 +39,6 @@ void ax25_ds_nr_error_recovery(ax25_cb *
 void ax25_ds_enquiry_response(ax25_cb *ax25)
 {
 	ax25_cb *ax25o;
-	struct hlist_node *node;
 
 	/* Please note that neither DK4EG's nor DG2FEF's
 	 * DAMA spec mention the following behaviour as seen
@@ -80,7 +79,7 @@ void ax25_ds_enquiry_response(ax25_cb *a
 	ax25_ds_set_timer(ax25->ax25_dev);
 
 	spin_lock(&ax25_list_lock);
-	ax25_for_each(ax25o, node, &ax25_list) {
+	ax25_for_each(ax25o, &ax25_list) {
 		if (ax25o == ax25)
 			continue;
 
@@ -159,10 +158,9 @@ static int ax25_check_dama_slave(ax25_de
 {
 	ax25_cb *ax25;
 	int res = 0;
-	struct hlist_node *node;
 
 	spin_lock(&ax25_list_lock);
-	ax25_for_each(ax25, node, &ax25_list)
+	ax25_for_each(ax25, &ax25_list)
 		if (ax25->ax25_dev == ax25_dev && (ax25->condition & AX25_COND_DAMA_MODE) && ax25->state > AX25_STATE_1) {
 			res = 1;
 			break;
diff -puN net/ax25/ax25_ds_timer.c~hlist-drop-the-node-parameter-from-iterators net/ax25/ax25_ds_timer.c
--- a/net/ax25/ax25_ds_timer.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ax25/ax25_ds_timer.c
@@ -70,7 +70,6 @@ static void ax25_ds_timeout(unsigned lon
 {
 	ax25_dev *ax25_dev = (struct ax25_dev *) arg;
 	ax25_cb *ax25;
-	struct hlist_node *node;
 
 	if (ax25_dev == NULL || !ax25_dev->dama.slave)
 		return;			/* Yikes! */
@@ -81,7 +80,7 @@ static void ax25_ds_timeout(unsigned lon
 	}
 
 	spin_lock(&ax25_list_lock);
-	ax25_for_each(ax25, node, &ax25_list) {
+	ax25_for_each(ax25, &ax25_list) {
 		if (ax25->ax25_dev != ax25_dev || !(ax25->condition & AX25_COND_DAMA_MODE))
 			continue;
 
diff -puN net/ax25/ax25_iface.c~hlist-drop-the-node-parameter-from-iterators net/ax25/ax25_iface.c
--- a/net/ax25/ax25_iface.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ax25/ax25_iface.c
@@ -193,10 +193,9 @@ int ax25_listen_mine(ax25_address *calls
 void ax25_link_failed(ax25_cb *ax25, int reason)
 {
 	struct ax25_linkfail *lf;
-	struct hlist_node *node;
 
 	spin_lock_bh(&linkfail_lock);
-	hlist_for_each_entry(lf, node, &ax25_linkfail_list, lf_node)
+	hlist_for_each_entry(lf, &ax25_linkfail_list, lf_node)
 		lf->func(ax25, reason);
 	spin_unlock_bh(&linkfail_lock);
 }
diff -puN net/ax25/ax25_uid.c~hlist-drop-the-node-parameter-from-iterators net/ax25/ax25_uid.c
--- a/net/ax25/ax25_uid.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ax25/ax25_uid.c
@@ -54,10 +54,9 @@ EXPORT_SYMBOL(ax25_uid_policy);
 ax25_uid_assoc *ax25_findbyuid(kuid_t uid)
 {
 	ax25_uid_assoc *ax25_uid, *res = NULL;
-	struct hlist_node *node;
 
 	read_lock(&ax25_uid_lock);
-	ax25_uid_for_each(ax25_uid, node, &ax25_uid_list) {
+	ax25_uid_for_each(ax25_uid, &ax25_uid_list) {
 		if (uid_eq(ax25_uid->uid, uid)) {
 			ax25_uid_hold(ax25_uid);
 			res = ax25_uid;
@@ -74,7 +73,6 @@ EXPORT_SYMBOL(ax25_findbyuid);
 int ax25_uid_ioctl(int cmd, struct sockaddr_ax25 *sax)
 {
 	ax25_uid_assoc *ax25_uid;
-	struct hlist_node *node;
 	ax25_uid_assoc *user;
 	unsigned long res;
 
@@ -82,7 +80,7 @@ int ax25_uid_ioctl(int cmd, struct socka
 	case SIOCAX25GETUID:
 		res = -ENOENT;
 		read_lock(&ax25_uid_lock);
-		ax25_uid_for_each(ax25_uid, node, &ax25_uid_list) {
+		ax25_uid_for_each(ax25_uid, &ax25_uid_list) {
 			if (ax25cmp(&sax->sax25_call, &ax25_uid->call) == 0) {
 				res = from_kuid_munged(current_user_ns(), ax25_uid->uid);
 				break;
@@ -126,7 +124,7 @@ int ax25_uid_ioctl(int cmd, struct socka
 
 		ax25_uid = NULL;
 		write_lock(&ax25_uid_lock);
-		ax25_uid_for_each(ax25_uid, node, &ax25_uid_list) {
+		ax25_uid_for_each(ax25_uid, &ax25_uid_list) {
 			if (ax25cmp(&sax->sax25_call, &ax25_uid->call) == 0)
 				break;
 		}
@@ -212,11 +210,10 @@ const struct file_operations ax25_uid_fo
 void __exit ax25_uid_free(void)
 {
 	ax25_uid_assoc *ax25_uid;
-	struct hlist_node *node;
 
 	write_lock(&ax25_uid_lock);
 again:
-	ax25_uid_for_each(ax25_uid, node, &ax25_uid_list) {
+	ax25_uid_for_each(ax25_uid, &ax25_uid_list) {
 		hlist_del_init(&ax25_uid->uid_node);
 		ax25_uid_put(ax25_uid);
 		goto again;
diff -puN net/batman-adv/bat_iv_ogm.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/bat_iv_ogm.c
--- a/net/batman-adv/bat_iv_ogm.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/bat_iv_ogm.c
@@ -487,7 +487,6 @@ static void batadv_iv_ogm_queue_add(stru
 	 */
 	struct batadv_forw_packet *forw_packet_aggr = NULL;
 	struct batadv_forw_packet *forw_packet_pos = NULL;
-	struct hlist_node *tmp_node;
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	bool direct_link;
 	unsigned long max_aggregation_jiffies;
@@ -500,7 +499,7 @@ static void batadv_iv_ogm_queue_add(stru
 	spin_lock_bh(&bat_priv->forw_bat_list_lock);
 	/* own packets are not to be aggregated */
 	if ((atomic_read(&bat_priv->aggregated_ogms)) && (!own_packet)) {
-		hlist_for_each_entry(forw_packet_pos, tmp_node,
+		hlist_for_each_entry(forw_packet_pos,
 				     &bat_priv->forw_bat_list, list) {
 			if (batadv_iv_ogm_can_aggregate(batadv_ogm_packet,
 							bat_priv, packet_len,
@@ -655,7 +654,6 @@ batadv_iv_ogm_orig_update(struct batadv_
 	struct batadv_neigh_node *neigh_node = NULL, *tmp_neigh_node = NULL;
 	struct batadv_neigh_node *router = NULL;
 	struct batadv_orig_node *orig_node_tmp;
-	struct hlist_node *node;
 	int if_num;
 	uint8_t sum_orig, sum_neigh;
 	uint8_t *neigh_addr;
@@ -665,7 +663,7 @@ batadv_iv_ogm_orig_update(struct batadv_
 		   "update_originator(): Searching and updating originator entry of received packet\n");
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(tmp_neigh_node, node,
+	hlist_for_each_entry_rcu(tmp_neigh_node,
 				 &orig_node->neigh_list, list) {
 		neigh_addr = tmp_neigh_node->addr;
 		if (batadv_compare_eth(neigh_addr, ethhdr->h_source) &&
@@ -801,7 +799,6 @@ static int batadv_iv_ogm_calc_tq(struct 
 {
 	struct batadv_priv *bat_priv = netdev_priv(if_incoming->soft_iface);
 	struct batadv_neigh_node *neigh_node = NULL, *tmp_neigh_node;
-	struct hlist_node *node;
 	uint8_t total_count;
 	uint8_t orig_eq_count, neigh_rq_count, neigh_rq_inv, tq_own;
 	unsigned int neigh_rq_inv_cube, neigh_rq_max_cube;
@@ -810,7 +807,7 @@ static int batadv_iv_ogm_calc_tq(struct 
 
 	/* find corresponding one hop neighbor */
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(tmp_neigh_node, node,
+	hlist_for_each_entry_rcu(tmp_neigh_node,
 				 &orig_neigh_node->neigh_list, list) {
 		if (!batadv_compare_eth(tmp_neigh_node->addr,
 					orig_neigh_node->orig))
@@ -920,7 +917,6 @@ batadv_iv_ogm_update_seqnos(const struct
 	struct batadv_priv *bat_priv = netdev_priv(if_incoming->soft_iface);
 	struct batadv_orig_node *orig_node;
 	struct batadv_neigh_node *tmp_neigh_node;
-	struct hlist_node *node;
 	int is_duplicate = 0;
 	int32_t seq_diff;
 	int need_update = 0;
@@ -943,7 +939,7 @@ batadv_iv_ogm_update_seqnos(const struct
 		goto out;
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(tmp_neigh_node, node,
+	hlist_for_each_entry_rcu(tmp_neigh_node,
 				 &orig_node->neigh_list, list) {
 		is_duplicate |= batadv_test_bit(tmp_neigh_node->real_bits,
 						orig_node->last_real_seqno,
diff -puN net/batman-adv/bridge_loop_avoidance.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/bridge_loop_avoidance.c
--- a/net/batman-adv/bridge_loop_avoidance.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/bridge_loop_avoidance.c
@@ -144,7 +144,6 @@ static struct batadv_bla_claim
 {
 	struct batadv_hashtable *hash = bat_priv->bla.claim_hash;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_bla_claim *claim;
 	struct batadv_bla_claim *claim_tmp = NULL;
 	int index;
@@ -156,7 +155,7 @@ static struct batadv_bla_claim
 	head = &hash->table[index];
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(claim, node, head, hash_entry) {
+	hlist_for_each_entry_rcu(claim, head, hash_entry) {
 		if (!batadv_compare_claim(&claim->hash_entry, data))
 			continue;
 
@@ -185,7 +184,6 @@ batadv_backbone_hash_find(struct batadv_
 {
 	struct batadv_hashtable *hash = bat_priv->bla.backbone_hash;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_bla_backbone_gw search_entry, *backbone_gw;
 	struct batadv_bla_backbone_gw *backbone_gw_tmp = NULL;
 	int index;
@@ -200,7 +198,7 @@ batadv_backbone_hash_find(struct batadv_
 	head = &hash->table[index];
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(backbone_gw, node, head, hash_entry) {
+	hlist_for_each_entry_rcu(backbone_gw, head, hash_entry) {
 		if (!batadv_compare_backbone_gw(&backbone_gw->hash_entry,
 						&search_entry))
 			continue;
@@ -221,7 +219,7 @@ static void
 batadv_bla_del_backbone_claims(struct batadv_bla_backbone_gw *backbone_gw)
 {
 	struct batadv_hashtable *hash;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	struct batadv_bla_claim *claim;
 	int i;
@@ -236,13 +234,13 @@ batadv_bla_del_backbone_claims(struct ba
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(claim, node, node_tmp,
+		hlist_for_each_entry_safe(claim, node_tmp,
 					  head, hash_entry) {
 			if (claim->backbone_gw != backbone_gw)
 				continue;
 
 			batadv_claim_free_ref(claim);
-			hlist_del_rcu(node);
+			hlist_del_rcu(&claim->hash_entry);
 		}
 		spin_unlock_bh(list_lock);
 	}
@@ -460,7 +458,6 @@ static void batadv_bla_answer_request(st
 				      struct batadv_hard_iface *primary_if,
 				      short vid)
 {
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_hashtable *hash;
 	struct batadv_bla_claim *claim;
@@ -481,7 +478,7 @@ static void batadv_bla_answer_request(st
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(claim, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(claim, head, hash_entry) {
 			/* only own claims are interesting */
 			if (claim->backbone_gw != backbone_gw)
 				continue;
@@ -958,7 +955,7 @@ static int batadv_bla_process_claim(stru
 static void batadv_bla_purge_backbone_gw(struct batadv_priv *bat_priv, int now)
 {
 	struct batadv_bla_backbone_gw *backbone_gw;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	struct batadv_hashtable *hash;
 	spinlock_t *list_lock;	/* protects write access to the hash lists */
@@ -973,7 +970,7 @@ static void batadv_bla_purge_backbone_gw
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(backbone_gw, node, node_tmp,
+		hlist_for_each_entry_safe(backbone_gw, node_tmp,
 					  head, hash_entry) {
 			if (now)
 				goto purge_now;
@@ -992,7 +989,7 @@ purge_now:
 
 			batadv_bla_del_backbone_claims(backbone_gw);
 
-			hlist_del_rcu(node);
+			hlist_del_rcu(&backbone_gw->hash_entry);
 			batadv_backbone_gw_free_ref(backbone_gw);
 		}
 		spin_unlock_bh(list_lock);
@@ -1013,7 +1010,6 @@ static void batadv_bla_purge_claims(stru
 				    int now)
 {
 	struct batadv_bla_claim *claim;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_hashtable *hash;
 	int i;
@@ -1026,7 +1022,7 @@ static void batadv_bla_purge_claims(stru
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(claim, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(claim, head, hash_entry) {
 			if (now)
 				goto purge_now;
 			if (!batadv_compare_eth(claim->backbone_gw->orig,
@@ -1062,7 +1058,6 @@ void batadv_bla_update_orig_address(stru
 				    struct batadv_hard_iface *oldif)
 {
 	struct batadv_bla_backbone_gw *backbone_gw;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_hashtable *hash;
 	__be16 group;
@@ -1086,7 +1081,7 @@ void batadv_bla_update_orig_address(stru
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(backbone_gw, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(backbone_gw, head, hash_entry) {
 			/* own orig still holds the old value. */
 			if (!batadv_compare_eth(backbone_gw->orig,
 						oldif->net_dev->dev_addr))
@@ -1112,7 +1107,6 @@ static void batadv_bla_periodic_work(str
 	struct delayed_work *delayed_work;
 	struct batadv_priv *bat_priv;
 	struct batadv_priv_bla *priv_bla;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_hashtable *hash;
@@ -1140,7 +1134,7 @@ static void batadv_bla_periodic_work(str
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(backbone_gw, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(backbone_gw, head, hash_entry) {
 			if (!batadv_compare_eth(backbone_gw->orig,
 						primary_if->net_dev->dev_addr))
 				continue;
@@ -1322,7 +1316,6 @@ int batadv_bla_is_backbone_gw_orig(struc
 {
 	struct batadv_hashtable *hash = bat_priv->bla.backbone_hash;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_bla_backbone_gw *backbone_gw;
 	int i;
 
@@ -1336,7 +1329,7 @@ int batadv_bla_is_backbone_gw_orig(struc
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(backbone_gw, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(backbone_gw, head, hash_entry) {
 			if (batadv_compare_eth(backbone_gw->orig, orig)) {
 				rcu_read_unlock();
 				return 1;
@@ -1607,7 +1600,6 @@ int batadv_bla_claim_table_seq_print_tex
 	struct batadv_hashtable *hash = bat_priv->bla.claim_hash;
 	struct batadv_bla_claim *claim;
 	struct batadv_hard_iface *primary_if;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	uint32_t i;
 	bool is_own;
@@ -1628,7 +1620,7 @@ int batadv_bla_claim_table_seq_print_tex
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(claim, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(claim, head, hash_entry) {
 			is_own = batadv_compare_eth(claim->backbone_gw->orig,
 						    primary_addr);
 			seq_printf(seq,	" * %pM on % 5d by %pM [%c] (%#.4x)\n",
@@ -1652,7 +1644,6 @@ int batadv_bla_backbone_table_seq_print_
 	struct batadv_hashtable *hash = bat_priv->bla.backbone_hash;
 	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_hard_iface *primary_if;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	int secs, msecs;
 	uint32_t i;
@@ -1674,7 +1665,7 @@ int batadv_bla_backbone_table_seq_print_
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(backbone_gw, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(backbone_gw, head, hash_entry) {
 			msecs = jiffies_to_msecs(jiffies -
 						 backbone_gw->lasttime);
 			secs = msecs / 1000;
diff -puN net/batman-adv/distributed-arp-table.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/distributed-arp-table.c
--- a/net/batman-adv/distributed-arp-table.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/distributed-arp-table.c
@@ -83,7 +83,7 @@ static void __batadv_dat_purge(struct ba
 {
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 	struct batadv_dat_entry *dat_entry;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	uint32_t i;
 
@@ -95,7 +95,7 @@ static void __batadv_dat_purge(struct ba
 		list_lock = &bat_priv->dat.hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(dat_entry, node, node_tmp, head,
+		hlist_for_each_entry_safe(dat_entry, node_tmp, head,
 					  hash_entry) {
 			/* if an helper function has been passed as parameter,
 			 * ask it if the entry has to be purged or not
@@ -103,7 +103,7 @@ static void __batadv_dat_purge(struct ba
 			if (to_purge && !to_purge(dat_entry))
 				continue;
 
-			hlist_del_rcu(node);
+			hlist_del_rcu(&dat_entry->hash_entry);
 			batadv_dat_entry_free_ref(dat_entry);
 		}
 		spin_unlock_bh(list_lock);
@@ -235,7 +235,6 @@ static struct batadv_dat_entry *
 batadv_dat_entry_hash_find(struct batadv_priv *bat_priv, __be32 ip)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_dat_entry *dat_entry, *dat_entry_tmp = NULL;
 	struct batadv_hashtable *hash = bat_priv->dat.hash;
 	uint32_t index;
@@ -247,7 +246,7 @@ batadv_dat_entry_hash_find(struct batadv
 	head = &hash->table[index];
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(dat_entry, node, head, hash_entry) {
+	hlist_for_each_entry_rcu(dat_entry, head, hash_entry) {
 		if (dat_entry->ip != ip)
 			continue;
 
@@ -465,7 +464,6 @@ static void batadv_choose_next_candidate
 	batadv_dat_addr_t max = 0, tmp_max = 0;
 	struct batadv_orig_node *orig_node, *max_orig_node = NULL;
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	int i;
 
@@ -481,7 +479,7 @@ static void batadv_choose_next_candidate
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 			/* the dht space is a ring and addresses are unsigned */
 			tmp_max = BATADV_DAT_ADDR_MAX - orig_node->dat_addr +
 				  ip_key;
@@ -686,7 +684,6 @@ int batadv_dat_cache_seq_print_text(stru
 	struct batadv_hashtable *hash = bat_priv->dat.hash;
 	struct batadv_dat_entry *dat_entry;
 	struct batadv_hard_iface *primary_if;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	unsigned long last_seen_jiffies;
 	int last_seen_msecs, last_seen_secs, last_seen_mins;
@@ -704,7 +701,7 @@ int batadv_dat_cache_seq_print_text(stru
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(dat_entry, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(dat_entry, head, hash_entry) {
 			last_seen_jiffies = jiffies - dat_entry->last_update;
 			last_seen_msecs = jiffies_to_msecs(last_seen_jiffies);
 			last_seen_mins = last_seen_msecs / 60000;
diff -puN net/batman-adv/gateway_client.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/gateway_client.c
--- a/net/batman-adv/gateway_client.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/gateway_client.c
@@ -114,7 +114,6 @@ static struct batadv_gw_node *
 batadv_gw_get_best_gw_node(struct batadv_priv *bat_priv)
 {
 	struct batadv_neigh_node *router;
-	struct hlist_node *node;
 	struct batadv_gw_node *gw_node, *curr_gw = NULL;
 	uint32_t max_gw_factor = 0, tmp_gw_factor = 0;
 	uint32_t gw_divisor;
@@ -127,7 +126,7 @@ batadv_gw_get_best_gw_node(struct batadv
 	gw_divisor *= 64;
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(gw_node, node, &bat_priv->gw.list, list) {
+	hlist_for_each_entry_rcu(gw_node, &bat_priv->gw.list, list) {
 		if (gw_node->deleted)
 			continue;
 
@@ -344,7 +343,6 @@ void batadv_gw_node_update(struct batadv
 			   struct batadv_orig_node *orig_node,
 			   uint8_t new_gwflags)
 {
-	struct hlist_node *node;
 	struct batadv_gw_node *gw_node, *curr_gw;
 
 	/* Note: We don't need a NULL check here, since curr_gw never gets
@@ -355,7 +353,7 @@ void batadv_gw_node_update(struct batadv
 	curr_gw = batadv_gw_get_selected_gw_node(bat_priv);
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(gw_node, node, &bat_priv->gw.list, list) {
+	hlist_for_each_entry_rcu(gw_node, &bat_priv->gw.list, list) {
 		if (gw_node->orig_node != orig_node)
 			continue;
 
@@ -403,7 +401,7 @@ void batadv_gw_node_delete(struct batadv
 void batadv_gw_node_purge(struct batadv_priv *bat_priv)
 {
 	struct batadv_gw_node *gw_node, *curr_gw;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	unsigned long timeout = msecs_to_jiffies(2 * BATADV_PURGE_TIMEOUT);
 	int do_deselect = 0;
 
@@ -411,7 +409,7 @@ void batadv_gw_node_purge(struct batadv_
 
 	spin_lock_bh(&bat_priv->gw.list_lock);
 
-	hlist_for_each_entry_safe(gw_node, node, node_tmp,
+	hlist_for_each_entry_safe(gw_node, node_tmp,
 				  &bat_priv->gw.list, list) {
 		if (((!gw_node->deleted) ||
 		     (time_before(jiffies, gw_node->deleted + timeout))) &&
@@ -476,7 +474,6 @@ int batadv_gw_client_seq_print_text(stru
 	struct batadv_priv *bat_priv = netdev_priv(net_dev);
 	struct batadv_hard_iface *primary_if;
 	struct batadv_gw_node *gw_node;
-	struct hlist_node *node;
 	int gw_count = 0;
 
 	primary_if = batadv_seq_print_text_primary_if_get(seq);
@@ -490,7 +487,7 @@ int batadv_gw_client_seq_print_text(stru
 		   primary_if->net_dev->dev_addr, net_dev->name);
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(gw_node, node, &bat_priv->gw.list, list) {
+	hlist_for_each_entry_rcu(gw_node, &bat_priv->gw.list, list) {
 		if (gw_node->deleted)
 			continue;
 
diff -puN net/batman-adv/main.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/main.c
--- a/net/batman-adv/main.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/main.c
@@ -345,9 +345,8 @@ void batadv_recv_handler_unregister(uint
 static struct batadv_algo_ops *batadv_algo_get(char *name)
 {
 	struct batadv_algo_ops *bat_algo_ops = NULL, *bat_algo_ops_tmp;
-	struct hlist_node *node;
 
-	hlist_for_each_entry(bat_algo_ops_tmp, node, &batadv_algo_list, list) {
+	hlist_for_each_entry(bat_algo_ops_tmp, &batadv_algo_list, list) {
 		if (strcmp(bat_algo_ops_tmp->name, name) != 0)
 			continue;
 
@@ -411,11 +410,10 @@ out:
 int batadv_algo_seq_print_text(struct seq_file *seq, void *offset)
 {
 	struct batadv_algo_ops *bat_algo_ops;
-	struct hlist_node *node;
 
 	seq_printf(seq, "Available routing algorithms:\n");
 
-	hlist_for_each_entry(bat_algo_ops, node, &batadv_algo_list, list) {
+	hlist_for_each_entry(bat_algo_ops, &batadv_algo_list, list) {
 		seq_printf(seq, "%s\n", bat_algo_ops->name);
 	}
 
diff -puN net/batman-adv/originator.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/originator.c
--- a/net/batman-adv/originator.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/originator.c
@@ -118,7 +118,7 @@ out:
 
 static void batadv_orig_node_free_rcu(struct rcu_head *rcu)
 {
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct batadv_neigh_node *neigh_node, *tmp_neigh_node;
 	struct batadv_orig_node *orig_node;
 
@@ -134,7 +134,7 @@ static void batadv_orig_node_free_rcu(st
 	}
 
 	/* for all neighbors towards this originator ... */
-	hlist_for_each_entry_safe(neigh_node, node, node_tmp,
+	hlist_for_each_entry_safe(neigh_node, node_tmp,
 				  &orig_node->neigh_list, list) {
 		hlist_del_rcu(&neigh_node->list);
 		batadv_neigh_node_free_ref(neigh_node);
@@ -161,7 +161,7 @@ void batadv_orig_node_free_ref(struct ba
 void batadv_originator_free(struct batadv_priv *bat_priv)
 {
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	spinlock_t *list_lock; /* spinlock to protect write access */
 	struct batadv_orig_node *orig_node;
@@ -179,9 +179,9 @@ void batadv_originator_free(struct batad
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(orig_node, node, node_tmp,
+		hlist_for_each_entry_safe(orig_node, node_tmp,
 					  head, hash_entry) {
-			hlist_del_rcu(node);
+			hlist_del_rcu(&orig_node->hash_entry);
 			batadv_orig_node_free_ref(orig_node);
 		}
 		spin_unlock_bh(list_lock);
@@ -274,7 +274,7 @@ batadv_purge_orig_neighbors(struct batad
 			    struct batadv_orig_node *orig_node,
 			    struct batadv_neigh_node **best_neigh_node)
 {
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct batadv_neigh_node *neigh_node;
 	bool neigh_purged = false;
 	unsigned long last_seen;
@@ -285,7 +285,7 @@ batadv_purge_orig_neighbors(struct batad
 	spin_lock_bh(&orig_node->neigh_list_lock);
 
 	/* for all neighbors towards this originator ... */
-	hlist_for_each_entry_safe(neigh_node, node, node_tmp,
+	hlist_for_each_entry_safe(neigh_node, node_tmp,
 				  &orig_node->neigh_list, list) {
 		last_seen = neigh_node->last_seen;
 		if_incoming = neigh_node->if_incoming;
@@ -348,7 +348,7 @@ static bool batadv_purge_orig_node(struc
 static void _batadv_purge_orig(struct batadv_priv *bat_priv)
 {
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	spinlock_t *list_lock; /* spinlock to protect write access */
 	struct batadv_orig_node *orig_node;
@@ -363,13 +363,13 @@ static void _batadv_purge_orig(struct ba
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(orig_node, node, node_tmp,
+		hlist_for_each_entry_safe(orig_node, node_tmp,
 					  head, hash_entry) {
 			if (batadv_purge_orig_node(bat_priv, orig_node)) {
 				if (orig_node->gw_flags)
 					batadv_gw_node_delete(bat_priv,
 							      orig_node);
-				hlist_del_rcu(node);
+				hlist_del_rcu(&orig_node->hash_entry);
 				batadv_orig_node_free_ref(orig_node);
 				continue;
 			}
@@ -408,7 +408,6 @@ int batadv_orig_seq_print_text(struct se
 	struct net_device *net_dev = (struct net_device *)seq->private;
 	struct batadv_priv *bat_priv = netdev_priv(net_dev);
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node, *node_tmp;
 	struct hlist_head *head;
 	struct batadv_hard_iface *primary_if;
 	struct batadv_orig_node *orig_node;
@@ -434,7 +433,7 @@ int batadv_orig_seq_print_text(struct se
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 			neigh_node = batadv_orig_node_get_router(orig_node);
 			if (!neigh_node)
 				continue;
@@ -453,7 +452,7 @@ int batadv_orig_seq_print_text(struct se
 				   neigh_node->addr,
 				   neigh_node->if_incoming->net_dev->name);
 
-			hlist_for_each_entry_rcu(neigh_node_tmp, node_tmp,
+			hlist_for_each_entry_rcu(neigh_node_tmp,
 						 &orig_node->neigh_list, list) {
 				seq_printf(seq, " %pM (%3i)",
 					   neigh_node_tmp->addr,
@@ -511,7 +510,6 @@ int batadv_orig_hash_add_if(struct batad
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_orig_node *orig_node;
 	uint32_t i;
@@ -524,7 +522,7 @@ int batadv_orig_hash_add_if(struct batad
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 			spin_lock_bh(&orig_node->ogm_cnt_lock);
 			ret = batadv_orig_node_add_if(orig_node, max_if_num);
 			spin_unlock_bh(&orig_node->ogm_cnt_lock);
@@ -595,7 +593,6 @@ int batadv_orig_hash_del_if(struct batad
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_hard_iface *hard_iface_tmp;
 	struct batadv_orig_node *orig_node;
@@ -609,7 +606,7 @@ int batadv_orig_hash_del_if(struct batad
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 			spin_lock_bh(&orig_node->ogm_cnt_lock);
 			ret = batadv_orig_node_del_if(orig_node, max_if_num,
 						      hard_iface->if_num);
diff -puN net/batman-adv/originator.h~hlist-drop-the-node-parameter-from-iterators net/batman-adv/originator.h
--- a/net/batman-adv/originator.h~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/originator.h
@@ -68,7 +68,6 @@ batadv_orig_hash_find(struct batadv_priv
 {
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_orig_node *orig_node, *orig_node_tmp = NULL;
 	int index;
 
@@ -79,7 +78,7 @@ batadv_orig_hash_find(struct batadv_priv
 	head = &hash->table[index];
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+	hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 		if (!batadv_compare_eth(orig_node, data))
 			continue;
 
diff -puN net/batman-adv/routing.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/routing.c
--- a/net/batman-adv/routing.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/routing.c
@@ -37,7 +37,6 @@ void batadv_slide_own_bcast_window(struc
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_orig_node *orig_node;
 	unsigned long *word;
@@ -49,7 +48,7 @@ void batadv_slide_own_bcast_window(struc
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 			spin_lock_bh(&orig_node->ogm_cnt_lock);
 			word_index = hard_iface->if_num * BATADV_NUM_WORDS;
 			word = &(orig_node->bcast_own[word_index]);
@@ -146,7 +145,6 @@ out:
 void batadv_bonding_candidate_add(struct batadv_orig_node *orig_node,
 				  struct batadv_neigh_node *neigh_node)
 {
-	struct hlist_node *node;
 	struct batadv_neigh_node *tmp_neigh_node, *router = NULL;
 	uint8_t interference_candidate = 0;
 
@@ -169,7 +167,7 @@ void batadv_bonding_candidate_add(struct
 	 * interface. If we do, we won't select this candidate because of
 	 * possible interference.
 	 */
-	hlist_for_each_entry_rcu(tmp_neigh_node, node,
+	hlist_for_each_entry_rcu(tmp_neigh_node,
 				 &orig_node->neigh_list, list) {
 		if (tmp_neigh_node == neigh_node)
 			continue;
diff -puN net/batman-adv/send.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/send.c
--- a/net/batman-adv/send.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/send.c
@@ -316,7 +316,7 @@ batadv_purge_outstanding_packets(struct 
 				 const struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_forw_packet *forw_packet;
-	struct hlist_node *tmp_node, *safe_tmp_node;
+	struct hlist_node *safe_tmp_node;
 	bool pending;
 
 	if (hard_iface)
@@ -329,7 +329,7 @@ batadv_purge_outstanding_packets(struct 
 
 	/* free bcast list */
 	spin_lock_bh(&bat_priv->forw_bcast_list_lock);
-	hlist_for_each_entry_safe(forw_packet, tmp_node, safe_tmp_node,
+	hlist_for_each_entry_safe(forw_packet, safe_tmp_node,
 				  &bat_priv->forw_bcast_list, list) {
 		/* if purge_outstanding_packets() was called with an argument
 		 * we delete only packets belonging to the given interface
@@ -355,7 +355,7 @@ batadv_purge_outstanding_packets(struct 
 
 	/* free batman packet list */
 	spin_lock_bh(&bat_priv->forw_bat_list_lock);
-	hlist_for_each_entry_safe(forw_packet, tmp_node, safe_tmp_node,
+	hlist_for_each_entry_safe(forw_packet, safe_tmp_node,
 				  &bat_priv->forw_bat_list, list) {
 		/* if purge_outstanding_packets() was called with an argument
 		 * we delete only packets belonging to the given interface
diff -puN net/batman-adv/translation-table.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/translation-table.c
--- a/net/batman-adv/translation-table.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/translation-table.c
@@ -56,7 +56,6 @@ static struct batadv_tt_common_entry *
 batadv_tt_hash_find(struct batadv_hashtable *hash, const void *data)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_common_entry *tt_common_entry_tmp = NULL;
 	uint32_t index;
@@ -68,7 +67,7 @@ batadv_tt_hash_find(struct batadv_hashta
 	head = &hash->table[index];
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(tt_common_entry, node, head, hash_entry) {
+	hlist_for_each_entry_rcu(tt_common_entry, head, hash_entry) {
 		if (!batadv_compare_eth(tt_common_entry, data))
 			continue;
 
@@ -257,7 +256,6 @@ void batadv_tt_local_add(struct net_devi
 	struct batadv_tt_local_entry *tt_local;
 	struct batadv_tt_global_entry *tt_global;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_tt_orig_list_entry *orig_entry;
 	int hash_added;
 	bool roamed_back = false;
@@ -339,7 +337,7 @@ check_roaming:
 		/* These node are probably going to update their tt table */
 		head = &tt_global->orig_list;
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_entry, node, head, list) {
+		hlist_for_each_entry_rcu(orig_entry, head, list) {
 			batadv_send_roam_adv(bat_priv, tt_global->common.addr,
 					     orig_entry->orig_node);
 		}
@@ -470,7 +468,6 @@ int batadv_tt_local_seq_print_text(struc
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_local_entry *tt_local;
 	struct batadv_hard_iface *primary_if;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	uint32_t i;
 	int last_seen_secs;
@@ -494,7 +491,7 @@ int batadv_tt_local_seq_print_text(struc
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(tt_common_entry, node,
+		hlist_for_each_entry_rcu(tt_common_entry,
 					 head, hash_entry) {
 			tt_local = container_of(tt_common_entry,
 						struct batadv_tt_local_entry,
@@ -605,9 +602,9 @@ static void batadv_tt_local_purge_list(s
 {
 	struct batadv_tt_local_entry *tt_local_entry;
 	struct batadv_tt_common_entry *tt_common_entry;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 
-	hlist_for_each_entry_safe(tt_common_entry, node, node_tmp, head,
+	hlist_for_each_entry_safe(tt_common_entry, node_tmp, head,
 				  hash_entry) {
 		tt_local_entry = container_of(tt_common_entry,
 					      struct batadv_tt_local_entry,
@@ -651,7 +648,7 @@ static void batadv_tt_local_table_free(s
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_local_entry *tt_local;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	uint32_t i;
 
@@ -665,9 +662,9 @@ static void batadv_tt_local_table_free(s
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(tt_common_entry, node, node_tmp,
+		hlist_for_each_entry_safe(tt_common_entry, node_tmp,
 					  head, hash_entry) {
-			hlist_del_rcu(node);
+			hlist_del_rcu(&tt_common_entry->hash_entry);
 			tt_local = container_of(tt_common_entry,
 						struct batadv_tt_local_entry,
 						common);
@@ -724,11 +721,10 @@ batadv_tt_global_orig_entry_find(const s
 {
 	struct batadv_tt_orig_list_entry *tmp_orig_entry, *orig_entry = NULL;
 	const struct hlist_head *head;
-	struct hlist_node *node;
 
 	rcu_read_lock();
 	head = &entry->orig_list;
-	hlist_for_each_entry_rcu(tmp_orig_entry, node, head, list) {
+	hlist_for_each_entry_rcu(tmp_orig_entry, head, list) {
 		if (tmp_orig_entry->orig_node != orig_node)
 			continue;
 		if (!atomic_inc_not_zero(&tmp_orig_entry->refcount))
@@ -940,12 +936,11 @@ batadv_transtable_best_orig(struct batad
 {
 	struct batadv_neigh_node *router = NULL;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_tt_orig_list_entry *orig_entry, *best_entry = NULL;
 	int best_tq = 0;
 
 	head = &tt_global_entry->orig_list;
-	hlist_for_each_entry_rcu(orig_entry, node, head, list) {
+	hlist_for_each_entry_rcu(orig_entry, head, list) {
 		router = batadv_orig_node_get_router(orig_entry->orig_node);
 		if (!router)
 			continue;
@@ -973,7 +968,6 @@ batadv_tt_global_print_entry(struct bata
 			     struct seq_file *seq)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_tt_orig_list_entry *orig_entry, *best_entry;
 	struct batadv_tt_common_entry *tt_common_entry;
 	uint16_t flags;
@@ -997,7 +991,7 @@ batadv_tt_global_print_entry(struct bata
 
 	head = &tt_global_entry->orig_list;
 
-	hlist_for_each_entry_rcu(orig_entry, node, head, list) {
+	hlist_for_each_entry_rcu(orig_entry, head, list) {
 		if (best_entry == orig_entry)
 			continue;
 
@@ -1020,7 +1014,6 @@ int batadv_tt_global_seq_print_text(stru
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_global_entry *tt_global;
 	struct batadv_hard_iface *primary_if;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	uint32_t i;
 
@@ -1039,7 +1032,7 @@ int batadv_tt_global_seq_print_text(stru
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(tt_common_entry, node,
+		hlist_for_each_entry_rcu(tt_common_entry,
 					 head, hash_entry) {
 			tt_global = container_of(tt_common_entry,
 						 struct batadv_tt_global_entry,
@@ -1059,13 +1052,13 @@ static void
 batadv_tt_global_del_orig_list(struct batadv_tt_global_entry *tt_global_entry)
 {
 	struct hlist_head *head;
-	struct hlist_node *node, *safe;
+	struct hlist_node *safe;
 	struct batadv_tt_orig_list_entry *orig_entry;
 
 	spin_lock_bh(&tt_global_entry->list_lock);
 	head = &tt_global_entry->orig_list;
-	hlist_for_each_entry_safe(orig_entry, node, safe, head, list) {
-		hlist_del_rcu(node);
+	hlist_for_each_entry_safe(orig_entry, safe, head, list) {
+		hlist_del_rcu(&orig_entry->list);
 		batadv_tt_orig_list_entry_free_ref(orig_entry);
 	}
 	spin_unlock_bh(&tt_global_entry->list_lock);
@@ -1078,18 +1071,18 @@ batadv_tt_global_del_orig_entry(struct b
 				const char *message)
 {
 	struct hlist_head *head;
-	struct hlist_node *node, *safe;
+	struct hlist_node *safe;
 	struct batadv_tt_orig_list_entry *orig_entry;
 
 	spin_lock_bh(&tt_global_entry->list_lock);
 	head = &tt_global_entry->orig_list;
-	hlist_for_each_entry_safe(orig_entry, node, safe, head, list) {
+	hlist_for_each_entry_safe(orig_entry, safe, head, list) {
 		if (orig_entry->orig_node == orig_node) {
 			batadv_dbg(BATADV_DBG_TT, bat_priv,
 				   "Deleting %pM from global tt entry %pM: %s\n",
 				   orig_node->orig,
 				   tt_global_entry->common.addr, message);
-			hlist_del_rcu(node);
+			hlist_del_rcu(&orig_entry->list);
 			batadv_tt_orig_list_entry_free_ref(orig_entry);
 		}
 	}
@@ -1108,7 +1101,6 @@ batadv_tt_global_del_roaming(struct bata
 {
 	bool last_entry = true;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_tt_orig_list_entry *orig_entry;
 
 	/* no local entry exists, case 1:
@@ -1117,7 +1109,7 @@ batadv_tt_global_del_roaming(struct bata
 
 	rcu_read_lock();
 	head = &tt_global_entry->orig_list;
-	hlist_for_each_entry_rcu(orig_entry, node, head, list) {
+	hlist_for_each_entry_rcu(orig_entry, head, list) {
 		if (orig_entry->orig_node != orig_node) {
 			last_entry = false;
 			break;
@@ -1202,7 +1194,7 @@ void batadv_tt_global_del_orig(struct ba
 	struct batadv_tt_common_entry *tt_common_entry;
 	uint32_t i;
 	struct batadv_hashtable *hash = bat_priv->tt.global_hash;
-	struct hlist_node *node, *safe;
+	struct hlist_node *safe;
 	struct hlist_head *head;
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 
@@ -1214,7 +1206,7 @@ void batadv_tt_global_del_orig(struct ba
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(tt_common_entry, node, safe,
+		hlist_for_each_entry_safe(tt_common_entry, safe,
 					  head, hash_entry) {
 			tt_global = container_of(tt_common_entry,
 						 struct batadv_tt_global_entry,
@@ -1227,7 +1219,7 @@ void batadv_tt_global_del_orig(struct ba
 				batadv_dbg(BATADV_DBG_TT, bat_priv,
 					   "Deleting global tt entry %pM: %s\n",
 					   tt_global->common.addr, message);
-				hlist_del_rcu(node);
+				hlist_del_rcu(&tt_common_entry->hash_entry);
 				batadv_tt_global_entry_free_ref(tt_global);
 			}
 		}
@@ -1262,7 +1254,7 @@ static void batadv_tt_global_purge(struc
 {
 	struct batadv_hashtable *hash = bat_priv->tt.global_hash;
 	struct hlist_head *head;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 	uint32_t i;
 	char *msg = NULL;
@@ -1274,7 +1266,7 @@ static void batadv_tt_global_purge(struc
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(tt_common, node, node_tmp, head,
+		hlist_for_each_entry_safe(tt_common, node_tmp, head,
 					  hash_entry) {
 			tt_global = container_of(tt_common,
 						 struct batadv_tt_global_entry,
@@ -1287,7 +1279,7 @@ static void batadv_tt_global_purge(struc
 				   "Deleting global tt entry (%pM): %s\n",
 				   tt_global->common.addr, msg);
 
-			hlist_del_rcu(node);
+			hlist_del_rcu(&tt_common->hash_entry);
 
 			batadv_tt_global_entry_free_ref(tt_global);
 		}
@@ -1301,7 +1293,7 @@ static void batadv_tt_global_table_free(
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_global_entry *tt_global;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	uint32_t i;
 
@@ -1315,9 +1307,9 @@ static void batadv_tt_global_table_free(
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(tt_common_entry, node, node_tmp,
+		hlist_for_each_entry_safe(tt_common_entry, node_tmp,
 					  head, hash_entry) {
-			hlist_del_rcu(node);
+			hlist_del_rcu(&tt_common_entry->hash_entry);
 			tt_global = container_of(tt_common_entry,
 						 struct batadv_tt_global_entry,
 						 common);
@@ -1397,7 +1389,6 @@ static uint16_t batadv_tt_global_crc(str
 	struct batadv_hashtable *hash = bat_priv->tt.global_hash;
 	struct batadv_tt_common_entry *tt_common;
 	struct batadv_tt_global_entry *tt_global;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	uint32_t i;
 	int j;
@@ -1406,7 +1397,7 @@ static uint16_t batadv_tt_global_crc(str
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(tt_common, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(tt_common, head, hash_entry) {
 			tt_global = container_of(tt_common,
 						 struct batadv_tt_global_entry,
 						 common);
@@ -1449,7 +1440,6 @@ static uint16_t batadv_tt_local_crc(stru
 	uint16_t total = 0, total_one;
 	struct batadv_hashtable *hash = bat_priv->tt.local_hash;
 	struct batadv_tt_common_entry *tt_common;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	uint32_t i;
 	int j;
@@ -1458,7 +1448,7 @@ static uint16_t batadv_tt_local_crc(stru
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(tt_common, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(tt_common, head, hash_entry) {
 			/* not yet committed clients have not to be taken into
 			 * account while computing the CRC
 			 */
@@ -1597,7 +1587,6 @@ batadv_tt_response_fill_table(uint16_t t
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_query_packet *tt_response;
 	struct batadv_tt_change *tt_change;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct sk_buff *skb = NULL;
 	uint16_t tt_tot, tt_count;
@@ -1627,7 +1616,7 @@ batadv_tt_response_fill_table(uint16_t t
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
 
-		hlist_for_each_entry_rcu(tt_common_entry, node,
+		hlist_for_each_entry_rcu(tt_common_entry,
 					 head, hash_entry) {
 			if (tt_count == tt_tot)
 				break;
@@ -2307,7 +2296,6 @@ static uint16_t batadv_tt_set_flags(stru
 	uint32_t i;
 	uint16_t changed_num = 0;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_tt_common_entry *tt_common_entry;
 
 	if (!hash)
@@ -2317,7 +2305,7 @@ static uint16_t batadv_tt_set_flags(stru
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(tt_common_entry, node,
+		hlist_for_each_entry_rcu(tt_common_entry,
 					 head, hash_entry) {
 			if (enable) {
 				if ((tt_common_entry->flags & flags) == flags)
@@ -2342,7 +2330,7 @@ static void batadv_tt_local_purge_pendin
 	struct batadv_hashtable *hash = bat_priv->tt.local_hash;
 	struct batadv_tt_common_entry *tt_common;
 	struct batadv_tt_local_entry *tt_local;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 	uint32_t i;
@@ -2355,7 +2343,7 @@ static void batadv_tt_local_purge_pendin
 		list_lock = &hash->list_locks[i];
 
 		spin_lock_bh(list_lock);
-		hlist_for_each_entry_safe(tt_common, node, node_tmp, head,
+		hlist_for_each_entry_safe(tt_common, node_tmp, head,
 					  hash_entry) {
 			if (!(tt_common->flags & BATADV_TT_CLIENT_PENDING))
 				continue;
@@ -2365,7 +2353,7 @@ static void batadv_tt_local_purge_pendin
 				   tt_common->addr);
 
 			atomic_dec(&bat_priv->tt.local_entry_num);
-			hlist_del_rcu(node);
+			hlist_del_rcu(&tt_common->hash_entry);
 			tt_local = container_of(tt_common,
 						struct batadv_tt_local_entry,
 						common);
diff -puN net/batman-adv/vis.c~hlist-drop-the-node-parameter-from-iterators net/batman-adv/vis.c
--- a/net/batman-adv/vis.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/batman-adv/vis.c
@@ -97,7 +97,6 @@ batadv_vis_hash_find(struct batadv_priv 
 {
 	struct batadv_hashtable *hash = bat_priv->vis.hash;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct batadv_vis_info *vis_info, *vis_info_tmp = NULL;
 	uint32_t index;
 
@@ -108,8 +107,8 @@ batadv_vis_hash_find(struct batadv_priv 
 	head = &hash->table[index];
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(vis_info, node, head, hash_entry) {
-		if (!batadv_vis_info_cmp(node, data))
+	hlist_for_each_entry_rcu(vis_info, head, hash_entry) {
+		if (!batadv_vis_info_cmp(&vis_info->hash_entry, data))
 			continue;
 
 		vis_info_tmp = vis_info;
@@ -128,9 +127,8 @@ static void batadv_vis_data_insert_inter
 					     bool primary)
 {
 	struct batadv_vis_if_list_entry *entry;
-	struct hlist_node *pos;
 
-	hlist_for_each_entry(entry, pos, if_list, list) {
+	hlist_for_each_entry(entry, if_list, list) {
 		if (batadv_compare_eth(entry->addr, interface))
 			return;
 	}
@@ -148,9 +146,8 @@ static void batadv_vis_data_read_prim_se
 					  const struct hlist_head *if_list)
 {
 	struct batadv_vis_if_list_entry *entry;
-	struct hlist_node *pos;
 
-	hlist_for_each_entry(entry, pos, if_list, list) {
+	hlist_for_each_entry(entry, if_list, list) {
 		if (entry->primary)
 			seq_printf(seq, "PRIMARY, ");
 		else
@@ -198,9 +195,8 @@ static void batadv_vis_data_read_entries
 {
 	int i;
 	struct batadv_vis_if_list_entry *entry;
-	struct hlist_node *pos;
 
-	hlist_for_each_entry(entry, pos, list, list) {
+	hlist_for_each_entry(entry, list, list) {
 		seq_printf(seq, "%pM,", entry->addr);
 
 		for (i = 0; i < packet->entries; i++)
@@ -218,17 +214,16 @@ static void batadv_vis_data_read_entries
 static void batadv_vis_seq_print_text_bucket(struct seq_file *seq,
 					     const struct hlist_head *head)
 {
-	struct hlist_node *node;
 	struct batadv_vis_info *info;
 	struct batadv_vis_packet *packet;
 	uint8_t *entries_pos;
 	struct batadv_vis_info_entry *entries;
 	struct batadv_vis_if_list_entry *entry;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 
 	HLIST_HEAD(vis_if_list);
 
-	hlist_for_each_entry_rcu(info, node, head, hash_entry) {
+	hlist_for_each_entry_rcu(info, head, hash_entry) {
 		packet = (struct batadv_vis_packet *)info->skb_packet->data;
 		entries_pos = (uint8_t *)packet + sizeof(*packet);
 		entries = (struct batadv_vis_info_entry *)entries_pos;
@@ -240,7 +235,7 @@ static void batadv_vis_seq_print_text_bu
 		batadv_vis_data_read_entries(seq, &vis_if_list, packet,
 					     entries);
 
-		hlist_for_each_entry_safe(entry, pos, n, &vis_if_list, list) {
+		hlist_for_each_entry_safe(entry, n, &vis_if_list, list) {
 			hlist_del(&entry->list);
 			kfree(entry);
 		}
@@ -519,7 +514,6 @@ static int batadv_find_best_vis_server(s
 {
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
 	struct batadv_neigh_node *router;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_orig_node *orig_node;
 	struct batadv_vis_packet *packet;
@@ -532,7 +526,7 @@ static int batadv_find_best_vis_server(s
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 			router = batadv_orig_node_get_router(orig_node);
 			if (!router)
 				continue;
@@ -571,7 +565,6 @@ static bool batadv_vis_packet_full(const
 static int batadv_generate_vis_packet(struct batadv_priv *bat_priv)
 {
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_orig_node *orig_node;
 	struct batadv_neigh_node *router;
@@ -605,7 +598,7 @@ static int batadv_generate_vis_packet(st
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 			router = batadv_orig_node_get_router(orig_node);
 			if (!router)
 				continue;
@@ -644,7 +637,7 @@ next:
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(tt_common_entry, node, head,
+		hlist_for_each_entry_rcu(tt_common_entry, head,
 					 hash_entry) {
 			packet_pos = skb_put(info->skb_packet, sizeof(*entry));
 			entry = (struct batadv_vis_info_entry *)packet_pos;
@@ -673,14 +666,14 @@ static void batadv_purge_vis_packets(str
 {
 	uint32_t i;
 	struct batadv_hashtable *hash = bat_priv->vis.hash;
-	struct hlist_node *node, *node_tmp;
+	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	struct batadv_vis_info *info;
 
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
 
-		hlist_for_each_entry_safe(info, node, node_tmp,
+		hlist_for_each_entry_safe(info, node_tmp,
 					  head, hash_entry) {
 			/* never purge own data. */
 			if (info == bat_priv->vis.my_info)
@@ -688,7 +681,7 @@ static void batadv_purge_vis_packets(str
 
 			if (batadv_has_timed_out(info->first_seen,
 						 BATADV_VIS_TIMEOUT)) {
-				hlist_del(node);
+				hlist_del(&info->hash_entry);
 				batadv_send_list_del(info);
 				kref_put(&info->refcount, batadv_free_info);
 			}
@@ -700,7 +693,6 @@ static void batadv_broadcast_vis_packet(
 					struct batadv_vis_info *info)
 {
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	struct batadv_orig_node *orig_node;
 	struct batadv_vis_packet *packet;
@@ -715,7 +707,7 @@ static void batadv_broadcast_vis_packet(
 		head = &hash->table[i];
 
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(orig_node, node, head, hash_entry) {
+		hlist_for_each_entry_rcu(orig_node, head, hash_entry) {
 			/* if it's a vis server and reachable, send it. */
 			if (!(orig_node->flags & BATADV_VIS_SERVER))
 				continue;
diff -puN net/bluetooth/hci_sock.c~hlist-drop-the-node-parameter-from-iterators net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/bluetooth/hci_sock.c
@@ -70,14 +70,13 @@ static struct bt_sock_list hci_sk_list =
 void hci_send_to_sock(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 	struct sk_buff *skb_copy = NULL;
 
 	BT_DBG("hdev %p len %d", hdev, skb->len);
 
 	read_lock(&hci_sk_list.lock);
 
-	sk_for_each(sk, node, &hci_sk_list.head) {
+	sk_for_each(sk, &hci_sk_list.head) {
 		struct hci_filter *flt;
 		struct sk_buff *nskb;
 
@@ -142,13 +141,12 @@ void hci_send_to_sock(struct hci_dev *hd
 void hci_send_to_control(struct sk_buff *skb, struct sock *skip_sk)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 
 	BT_DBG("len %d", skb->len);
 
 	read_lock(&hci_sk_list.lock);
 
-	sk_for_each(sk, node, &hci_sk_list.head) {
+	sk_for_each(sk, &hci_sk_list.head) {
 		struct sk_buff *nskb;
 
 		/* Skip the original socket */
@@ -176,7 +174,6 @@ void hci_send_to_control(struct sk_buff 
 void hci_send_to_monitor(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 	struct sk_buff *skb_copy = NULL;
 	__le16 opcode;
 
@@ -210,7 +207,7 @@ void hci_send_to_monitor(struct hci_dev 
 
 	read_lock(&hci_sk_list.lock);
 
-	sk_for_each(sk, node, &hci_sk_list.head) {
+	sk_for_each(sk, &hci_sk_list.head) {
 		struct sk_buff *nskb;
 
 		if (sk->sk_state != BT_BOUND)
@@ -251,13 +248,12 @@ void hci_send_to_monitor(struct hci_dev 
 static void send_monitor_event(struct sk_buff *skb)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 
 	BT_DBG("len %d", skb->len);
 
 	read_lock(&hci_sk_list.lock);
 
-	sk_for_each(sk, node, &hci_sk_list.head) {
+	sk_for_each(sk, &hci_sk_list.head) {
 		struct sk_buff *nskb;
 
 		if (sk->sk_state != BT_BOUND)
@@ -393,11 +389,10 @@ void hci_sock_dev_event(struct hci_dev *
 
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
-		struct hlist_node *node;
 
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
-		sk_for_each(sk, node, &hci_sk_list.head) {
+		sk_for_each(sk, &hci_sk_list.head) {
 			bh_lock_sock_nested(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
diff -puN net/bluetooth/rfcomm/sock.c~hlist-drop-the-node-parameter-from-iterators net/bluetooth/rfcomm/sock.c
--- a/net/bluetooth/rfcomm/sock.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/bluetooth/rfcomm/sock.c
@@ -107,15 +107,14 @@ static void rfcomm_sk_state_change(struc
 static struct sock *__rfcomm_get_sock_by_addr(u8 channel, bdaddr_t *src)
 {
 	struct sock *sk = NULL;
-	struct hlist_node *node;
 
-	sk_for_each(sk, node, &rfcomm_sk_list.head) {
+	sk_for_each(sk, &rfcomm_sk_list.head) {
 		if (rfcomm_pi(sk)->channel == channel &&
 				!bacmp(&bt_sk(sk)->src, src))
 			break;
 	}
 
-	return node ? sk : NULL;
+	return sk ? sk : NULL;
 }
 
 /* Find socket with channel and source bdaddr.
@@ -124,11 +123,10 @@ static struct sock *__rfcomm_get_sock_by
 static struct sock *rfcomm_get_sock_by_channel(int state, u8 channel, bdaddr_t *src)
 {
 	struct sock *sk = NULL, *sk1 = NULL;
-	struct hlist_node *node;
 
 	read_lock(&rfcomm_sk_list.lock);
 
-	sk_for_each(sk, node, &rfcomm_sk_list.head) {
+	sk_for_each(sk, &rfcomm_sk_list.head) {
 		if (state && sk->sk_state != state)
 			continue;
 
@@ -145,7 +143,7 @@ static struct sock *rfcomm_get_sock_by_c
 
 	read_unlock(&rfcomm_sk_list.lock);
 
-	return node ? sk : sk1;
+	return sk ? sk : sk1;
 }
 
 static void rfcomm_sock_destruct(struct sock *sk)
@@ -970,11 +968,10 @@ done:
 static int rfcomm_sock_debugfs_show(struct seq_file *f, void *p)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 
 	read_lock(&rfcomm_sk_list.lock);
 
-	sk_for_each(sk, node, &rfcomm_sk_list.head) {
+	sk_for_each(sk, &rfcomm_sk_list.head) {
 		seq_printf(f, "%pMR %pMR %d %d\n",
 			   &bt_sk(sk)->src, &bt_sk(sk)->dst,
 			   sk->sk_state, rfcomm_pi(sk)->channel);
diff -puN net/bluetooth/sco.c~hlist-drop-the-node-parameter-from-iterators net/bluetooth/sco.c
--- a/net/bluetooth/sco.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/bluetooth/sco.c
@@ -259,10 +259,9 @@ drop:
 /* -------- Socket interface ---------- */
 static struct sock *__sco_get_sock_listen_by_addr(bdaddr_t *ba)
 {
-	struct hlist_node *node;
 	struct sock *sk;
 
-	sk_for_each(sk, node, &sco_sk_list.head) {
+	sk_for_each(sk, &sco_sk_list.head) {
 		if (sk->sk_state != BT_LISTEN)
 			continue;
 
@@ -279,11 +278,10 @@ static struct sock *__sco_get_sock_liste
 static struct sock *sco_get_sock_listen(bdaddr_t *src)
 {
 	struct sock *sk = NULL, *sk1 = NULL;
-	struct hlist_node *node;
 
 	read_lock(&sco_sk_list.lock);
 
-	sk_for_each(sk, node, &sco_sk_list.head) {
+	sk_for_each(sk, &sco_sk_list.head) {
 		if (sk->sk_state != BT_LISTEN)
 			continue;
 
@@ -298,7 +296,7 @@ static struct sock *sco_get_sock_listen(
 
 	read_unlock(&sco_sk_list.lock);
 
-	return node ? sk : sk1;
+	return sk ? sk : sk1;
 }
 
 static void sco_sock_destruct(struct sock *sk)
@@ -951,14 +949,13 @@ static void sco_conn_ready(struct sco_co
 int sco_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 	int lm = 0;
 
 	BT_DBG("hdev %s, bdaddr %pMR", hdev->name, bdaddr);
 
 	/* Find listening sockets */
 	read_lock(&sco_sk_list.lock);
-	sk_for_each(sk, node, &sco_sk_list.head) {
+	sk_for_each(sk, &sco_sk_list.head) {
 		if (sk->sk_state != BT_LISTEN)
 			continue;
 
@@ -1018,11 +1015,10 @@ drop:
 static int sco_debugfs_show(struct seq_file *f, void *p)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 
 	read_lock(&sco_sk_list.lock);
 
-	sk_for_each(sk, node, &sco_sk_list.head) {
+	sk_for_each(sk, &sco_sk_list.head) {
 		seq_printf(f, "%pMR %pMR %d\n", &bt_sk(sk)->src,
 			   &bt_sk(sk)->dst, sk->sk_state);
 	}
diff -puN net/bridge/br_fdb.c~hlist-drop-the-node-parameter-from-iterators net/bridge/br_fdb.c
--- a/net/bridge/br_fdb.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/bridge/br_fdb.c
@@ -181,9 +181,9 @@ void br_fdb_cleanup(unsigned long _data)
 	spin_lock(&br->hash_lock);
 	for (i = 0; i < BR_HASH_SIZE; i++) {
 		struct net_bridge_fdb_entry *f;
-		struct hlist_node *h, *n;
+		struct hlist_node *n;
 
-		hlist_for_each_entry_safe(f, h, n, &br->hash[i], hlist) {
+		hlist_for_each_entry_safe(f, n, &br->hash[i], hlist) {
 			unsigned long this_timer;
 			if (f->is_static)
 				continue;
@@ -207,8 +207,8 @@ void br_fdb_flush(struct net_bridge *br)
 	spin_lock_bh(&br->hash_lock);
 	for (i = 0; i < BR_HASH_SIZE; i++) {
 		struct net_bridge_fdb_entry *f;
-		struct hlist_node *h, *n;
-		hlist_for_each_entry_safe(f, h, n, &br->hash[i], hlist) {
+		struct hlist_node *n;
+		hlist_for_each_entry_safe(f, n, &br->hash[i], hlist) {
 			if (!f->is_static)
 				fdb_delete(br, f);
 		}
@@ -266,10 +266,9 @@ struct net_bridge_fdb_entry *__br_fdb_ge
 					  const unsigned char *addr,
 					  __u16 vid)
 {
-	struct hlist_node *h;
 	struct net_bridge_fdb_entry *fdb;
 
-	hlist_for_each_entry_rcu(fdb, h,
+	hlist_for_each_entry_rcu(fdb,
 				&br->hash[br_mac_hash(addr, vid)], hlist) {
 		if (ether_addr_equal(fdb->addr.addr, addr) &&
 		    fdb->vlan_id == vid) {
@@ -315,14 +314,13 @@ int br_fdb_fillbuf(struct net_bridge *br
 {
 	struct __fdb_entry *fe = buf;
 	int i, num = 0;
-	struct hlist_node *h;
 	struct net_bridge_fdb_entry *f;
 
 	memset(buf, 0, maxnum*sizeof(struct __fdb_entry));
 
 	rcu_read_lock();
 	for (i = 0; i < BR_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(f, h, &br->hash[i], hlist) {
+		hlist_for_each_entry_rcu(f, &br->hash[i], hlist) {
 			if (num >= maxnum)
 				goto out;
 
@@ -363,10 +361,9 @@ static struct net_bridge_fdb_entry *fdb_
 					     const unsigned char *addr,
 					     __u16 vid)
 {
-	struct hlist_node *h;
 	struct net_bridge_fdb_entry *fdb;
 
-	hlist_for_each_entry(fdb, h, head, hlist) {
+	hlist_for_each_entry(fdb, head, hlist) {
 		if (ether_addr_equal(fdb->addr.addr, addr) &&
 		    fdb->vlan_id == vid)
 			return fdb;
@@ -378,10 +375,9 @@ static struct net_bridge_fdb_entry *fdb_
 						 const unsigned char *addr,
 						 __u16 vid)
 {
-	struct hlist_node *h;
 	struct net_bridge_fdb_entry *fdb;
 
-	hlist_for_each_entry_rcu(fdb, h, head, hlist) {
+	hlist_for_each_entry_rcu(fdb, head, hlist) {
 		if (ether_addr_equal(fdb->addr.addr, addr) &&
 		    fdb->vlan_id == vid)
 			return fdb;
@@ -593,10 +589,9 @@ int br_fdb_dump(struct sk_buff *skb,
 		goto out;
 
 	for (i = 0; i < BR_HASH_SIZE; i++) {
-		struct hlist_node *h;
 		struct net_bridge_fdb_entry *f;
 
-		hlist_for_each_entry_rcu(f, h, &br->hash[i], hlist) {
+		hlist_for_each_entry_rcu(f, &br->hash[i], hlist) {
 			if (idx < cb->args[0])
 				goto skip;
 
diff -puN net/bridge/br_mdb.c~hlist-drop-the-node-parameter-from-iterators net/bridge/br_mdb.c
--- a/net/bridge/br_mdb.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/bridge/br_mdb.c
@@ -18,7 +18,6 @@ static int br_rports_fill_info(struct sk
 {
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_port *p;
-	struct hlist_node *n;
 	struct nlattr *nest;
 
 	if (!br->multicast_router || hlist_empty(&br->router_list))
@@ -28,7 +27,7 @@ static int br_rports_fill_info(struct sk
 	if (nest == NULL)
 		return -EMSGSIZE;
 
-	hlist_for_each_entry_rcu(p, n, &br->router_list, rlist) {
+	hlist_for_each_entry_rcu(p, &br->router_list, rlist) {
 		if (p && nla_put_u32(skb, MDBA_ROUTER_PORT, p->dev->ifindex))
 			goto fail;
 	}
@@ -61,12 +60,11 @@ static int br_mdb_fill_info(struct sk_bu
 		return -EMSGSIZE;
 
 	for (i = 0; i < mdb->max; i++) {
-		struct hlist_node *h;
 		struct net_bridge_mdb_entry *mp;
 		struct net_bridge_port_group *p, **pp;
 		struct net_bridge_port *port;
 
-		hlist_for_each_entry_rcu(mp, h, &mdb->mhash[i], hlist[mdb->ver]) {
+		hlist_for_each_entry_rcu(mp, &mdb->mhash[i], hlist[mdb->ver]) {
 			if (idx < s_idx)
 				goto skip;
 
diff -puN net/bridge/br_multicast.c~hlist-drop-the-node-parameter-from-iterators net/bridge/br_multicast.c
--- a/net/bridge/br_multicast.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/bridge/br_multicast.c
@@ -86,9 +86,8 @@ static struct net_bridge_mdb_entry *__br
 	struct net_bridge_mdb_htable *mdb, struct br_ip *dst, int hash)
 {
 	struct net_bridge_mdb_entry *mp;
-	struct hlist_node *p;
 
-	hlist_for_each_entry_rcu(mp, p, &mdb->mhash[hash], hlist[mdb->ver]) {
+	hlist_for_each_entry_rcu(mp, &mdb->mhash[hash], hlist[mdb->ver]) {
 		if (br_ip_equal(&mp->addr, dst))
 			return mp;
 	}
@@ -178,13 +177,12 @@ static int br_mdb_copy(struct net_bridge
 		       int elasticity)
 {
 	struct net_bridge_mdb_entry *mp;
-	struct hlist_node *p;
 	int maxlen;
 	int len;
 	int i;
 
 	for (i = 0; i < old->max; i++)
-		hlist_for_each_entry(mp, p, &old->mhash[i], hlist[old->ver])
+		hlist_for_each_entry(mp, &old->mhash[i], hlist[old->ver])
 			hlist_add_head(&mp->hlist[new->ver],
 				       &new->mhash[br_ip_hash(new, &mp->addr)]);
 
@@ -194,7 +192,7 @@ static int br_mdb_copy(struct net_bridge
 	maxlen = 0;
 	for (i = 0; i < new->max; i++) {
 		len = 0;
-		hlist_for_each_entry(mp, p, &new->mhash[i], hlist[new->ver])
+		hlist_for_each_entry(mp, &new->mhash[i], hlist[new->ver])
 			len++;
 		if (len > maxlen)
 			maxlen = len;
@@ -510,14 +508,13 @@ static struct net_bridge_mdb_entry *br_m
 {
 	struct net_bridge_mdb_htable *mdb;
 	struct net_bridge_mdb_entry *mp;
-	struct hlist_node *p;
 	unsigned int count = 0;
 	unsigned int max;
 	int elasticity;
 	int err;
 
 	mdb = rcu_dereference_protected(br->mdb, 1);
-	hlist_for_each_entry(mp, p, &mdb->mhash[hash], hlist[mdb->ver]) {
+	hlist_for_each_entry(mp, &mdb->mhash[hash], hlist[mdb->ver]) {
 		count++;
 		if (unlikely(br_ip_equal(group, &mp->addr)))
 			return mp;
@@ -882,10 +879,10 @@ void br_multicast_disable_port(struct ne
 {
 	struct net_bridge *br = port->br;
 	struct net_bridge_port_group *pg;
-	struct hlist_node *p, *n;
+	struct hlist_node *n;
 
 	spin_lock(&br->multicast_lock);
-	hlist_for_each_entry_safe(pg, p, n, &port->mglist, mglist)
+	hlist_for_each_entry_safe(pg, n, &port->mglist, mglist)
 		br_multicast_del_pg(br, pg);
 
 	if (!hlist_unhashed(&port->rlist))
@@ -1025,12 +1022,12 @@ static void br_multicast_add_router(stru
 				    struct net_bridge_port *port)
 {
 	struct net_bridge_port *p;
-	struct hlist_node *n, *slot = NULL;
+	struct hlist_node *slot = NULL;
 
-	hlist_for_each_entry(p, n, &br->router_list, rlist) {
+	hlist_for_each_entry(p, &br->router_list, rlist) {
 		if ((unsigned long) port >= (unsigned long) p)
 			break;
-		slot = n;
+		slot = &p->rlist;
 	}
 
 	if (slot)
@@ -1653,7 +1650,7 @@ void br_multicast_stop(struct net_bridge
 {
 	struct net_bridge_mdb_htable *mdb;
 	struct net_bridge_mdb_entry *mp;
-	struct hlist_node *p, *n;
+	struct hlist_node *n;
 	u32 ver;
 	int i;
 
@@ -1670,7 +1667,7 @@ void br_multicast_stop(struct net_bridge
 
 	ver = mdb->ver;
 	for (i = 0; i < mdb->max; i++) {
-		hlist_for_each_entry_safe(mp, p, n, &mdb->mhash[i],
+		hlist_for_each_entry_safe(mp, n, &mdb->mhash[i],
 					  hlist[ver]) {
 			del_timer(&mp->timer);
 			call_rcu_bh(&mp->rcu, br_multicast_free_group);
diff -puN net/can/af_can.c~hlist-drop-the-node-parameter-from-iterators net/can/af_can.c
--- a/net/can/af_can.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/can/af_can.c
@@ -516,7 +516,6 @@ void can_rx_unregister(struct net_device
 {
 	struct receiver *r = NULL;
 	struct hlist_head *rl;
-	struct hlist_node *next;
 	struct dev_rcv_lists *d;
 
 	if (dev && dev->type != ARPHRD_CAN)
@@ -540,7 +539,7 @@ void can_rx_unregister(struct net_device
 	 * been registered before.
 	 */
 
-	hlist_for_each_entry_rcu(r, next, rl, list) {
+	hlist_for_each_entry_rcu(r, rl, list) {
 		if (r->can_id == can_id && r->mask == mask &&
 		    r->func == func && r->data == data)
 			break;
@@ -552,7 +551,7 @@ void can_rx_unregister(struct net_device
 	 * will be NULL, while r will point to the last item of the list.
 	 */
 
-	if (!next) {
+	if (!r) {
 		printk(KERN_ERR "BUG: receive list entry not found for "
 		       "dev %s, id %03X, mask %03X\n",
 		       DNAME(dev), can_id, mask);
@@ -590,7 +589,6 @@ static inline void deliver(struct sk_buf
 static int can_rcv_filter(struct dev_rcv_lists *d, struct sk_buff *skb)
 {
 	struct receiver *r;
-	struct hlist_node *n;
 	int matches = 0;
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	canid_t can_id = cf->can_id;
@@ -600,7 +598,7 @@ static int can_rcv_filter(struct dev_rcv
 
 	if (can_id & CAN_ERR_FLAG) {
 		/* check for error message frame entries only */
-		hlist_for_each_entry_rcu(r, n, &d->rx[RX_ERR], list) {
+		hlist_for_each_entry_rcu(r, &d->rx[RX_ERR], list) {
 			if (can_id & r->mask) {
 				deliver(skb, r);
 				matches++;
@@ -610,13 +608,13 @@ static int can_rcv_filter(struct dev_rcv
 	}
 
 	/* check for unfiltered entries */
-	hlist_for_each_entry_rcu(r, n, &d->rx[RX_ALL], list) {
+	hlist_for_each_entry_rcu(r, &d->rx[RX_ALL], list) {
 		deliver(skb, r);
 		matches++;
 	}
 
 	/* check for can_id/mask entries */
-	hlist_for_each_entry_rcu(r, n, &d->rx[RX_FIL], list) {
+	hlist_for_each_entry_rcu(r, &d->rx[RX_FIL], list) {
 		if ((can_id & r->mask) == r->can_id) {
 			deliver(skb, r);
 			matches++;
@@ -624,7 +622,7 @@ static int can_rcv_filter(struct dev_rcv
 	}
 
 	/* check for inverted can_id/mask entries */
-	hlist_for_each_entry_rcu(r, n, &d->rx[RX_INV], list) {
+	hlist_for_each_entry_rcu(r, &d->rx[RX_INV], list) {
 		if ((can_id & r->mask) != r->can_id) {
 			deliver(skb, r);
 			matches++;
@@ -636,7 +634,7 @@ static int can_rcv_filter(struct dev_rcv
 		return matches;
 
 	if (can_id & CAN_EFF_FLAG) {
-		hlist_for_each_entry_rcu(r, n, &d->rx[RX_EFF], list) {
+		hlist_for_each_entry_rcu(r, &d->rx[RX_EFF], list) {
 			if (r->can_id == can_id) {
 				deliver(skb, r);
 				matches++;
@@ -644,7 +642,7 @@ static int can_rcv_filter(struct dev_rcv
 		}
 	} else {
 		can_id &= CAN_SFF_MASK;
-		hlist_for_each_entry_rcu(r, n, &d->rx_sff[can_id], list) {
+		hlist_for_each_entry_rcu(r, &d->rx_sff[can_id], list) {
 			deliver(skb, r);
 			matches++;
 		}
diff -puN net/can/gw.c~hlist-drop-the-node-parameter-from-iterators net/can/gw.c
--- a/net/can/gw.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/can/gw.c
@@ -457,11 +457,11 @@ static int cgw_notifier(struct notifier_
 	if (msg == NETDEV_UNREGISTER) {
 
 		struct cgw_job *gwj = NULL;
-		struct hlist_node *n, *nx;
+		struct hlist_node *nx;
 
 		ASSERT_RTNL();
 
-		hlist_for_each_entry_safe(gwj, n, nx, &cgw_list, list) {
+		hlist_for_each_entry_safe(gwj, nx, &cgw_list, list) {
 
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
@@ -575,12 +575,11 @@ cancel:
 static int cgw_dump_jobs(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct cgw_job *gwj = NULL;
-	struct hlist_node *n;
 	int idx = 0;
 	int s_idx = cb->args[0];
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(gwj, n, &cgw_list, list) {
+	hlist_for_each_entry_rcu(gwj, &cgw_list, list) {
 		if (idx < s_idx)
 			goto cont;
 
@@ -858,11 +857,11 @@ out:
 static void cgw_remove_all_jobs(void)
 {
 	struct cgw_job *gwj = NULL;
-	struct hlist_node *n, *nx;
+	struct hlist_node *nx;
 
 	ASSERT_RTNL();
 
-	hlist_for_each_entry_safe(gwj, n, nx, &cgw_list, list) {
+	hlist_for_each_entry_safe(gwj, nx, &cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
 		kfree(gwj);
@@ -872,7 +871,7 @@ static void cgw_remove_all_jobs(void)
 static int cgw_remove_job(struct sk_buff *skb,  struct nlmsghdr *nlh, void *arg)
 {
 	struct cgw_job *gwj = NULL;
-	struct hlist_node *n, *nx;
+	struct hlist_node *nx;
 	struct rtcanmsg *r;
 	struct cf_mod mod;
 	struct can_can_gw ccgw;
@@ -907,7 +906,7 @@ static int cgw_remove_job(struct sk_buff
 	ASSERT_RTNL();
 
 	/* remove only the first matching entry */
-	hlist_for_each_entry_safe(gwj, n, nx, &cgw_list, list) {
+	hlist_for_each_entry_safe(gwj, nx, &cgw_list, list) {
 
 		if (gwj->flags != r->flags)
 			continue;
diff -puN net/can/proc.c~hlist-drop-the-node-parameter-from-iterators net/can/proc.c
--- a/net/can/proc.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/can/proc.c
@@ -195,9 +195,8 @@ static void can_print_rcvlist(struct seq
 			      struct net_device *dev)
 {
 	struct receiver *r;
-	struct hlist_node *n;
 
-	hlist_for_each_entry_rcu(r, n, rx_list, list) {
+	hlist_for_each_entry_rcu(r, rx_list, list) {
 		char *fmt = (r->can_id & CAN_EFF_FLAG)?
 			"   %-5s  %08x  %08x  %pK  %pK  %8ld  %s\n" :
 			"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";
diff -puN net/core/dev.c~hlist-drop-the-node-parameter-from-iterators net/core/dev.c
--- a/net/core/dev.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/core/dev.c
@@ -658,11 +658,10 @@ __setup("netdev=", netdev_boot_setup);
 
 struct net_device *__dev_get_by_name(struct net *net, const char *name)
 {
-	struct hlist_node *p;
 	struct net_device *dev;
 	struct hlist_head *head = dev_name_hash(net, name);
 
-	hlist_for_each_entry(dev, p, head, name_hlist)
+	hlist_for_each_entry(dev, head, name_hlist)
 		if (!strncmp(dev->name, name, IFNAMSIZ))
 			return dev;
 
@@ -684,11 +683,10 @@ EXPORT_SYMBOL(__dev_get_by_name);
 
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
 {
-	struct hlist_node *p;
 	struct net_device *dev;
 	struct hlist_head *head = dev_name_hash(net, name);
 
-	hlist_for_each_entry_rcu(dev, p, head, name_hlist)
+	hlist_for_each_entry_rcu(dev, head, name_hlist)
 		if (!strncmp(dev->name, name, IFNAMSIZ))
 			return dev;
 
@@ -735,11 +733,10 @@ EXPORT_SYMBOL(dev_get_by_name);
 
 struct net_device *__dev_get_by_index(struct net *net, int ifindex)
 {
-	struct hlist_node *p;
 	struct net_device *dev;
 	struct hlist_head *head = dev_index_hash(net, ifindex);
 
-	hlist_for_each_entry(dev, p, head, index_hlist)
+	hlist_for_each_entry(dev, head, index_hlist)
 		if (dev->ifindex == ifindex)
 			return dev;
 
@@ -760,11 +757,10 @@ EXPORT_SYMBOL(__dev_get_by_index);
 
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex)
 {
-	struct hlist_node *p;
 	struct net_device *dev;
 	struct hlist_head *head = dev_index_hash(net, ifindex);
 
-	hlist_for_each_entry_rcu(dev, p, head, index_hlist)
+	hlist_for_each_entry_rcu(dev, head, index_hlist)
 		if (dev->ifindex == ifindex)
 			return dev;
 
diff -puN net/core/flow.c~hlist-drop-the-node-parameter-from-iterators net/core/flow.c
--- a/net/core/flow.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/core/flow.c
@@ -132,14 +132,14 @@ static void __flow_cache_shrink(struct f
 				int shrink_to)
 {
 	struct flow_cache_entry *fle;
-	struct hlist_node *entry, *tmp;
+	struct hlist_node *tmp;
 	LIST_HEAD(gc_list);
 	int i, deleted = 0;
 
 	for (i = 0; i < flow_cache_hash_size(fc); i++) {
 		int saved = 0;
 
-		hlist_for_each_entry_safe(fle, entry, tmp,
+		hlist_for_each_entry_safe(fle, tmp,
 					  &fcp->hash_table[i], u.hlist) {
 			if (saved < shrink_to &&
 			    flow_entry_valid(fle)) {
@@ -211,7 +211,6 @@ flow_cache_lookup(struct net *net, const
 	struct flow_cache *fc = &flow_cache_global;
 	struct flow_cache_percpu *fcp;
 	struct flow_cache_entry *fle, *tfle;
-	struct hlist_node *entry;
 	struct flow_cache_object *flo;
 	size_t keysize;
 	unsigned int hash;
@@ -235,7 +234,7 @@ flow_cache_lookup(struct net *net, const
 		flow_new_hash_rnd(fc, fcp);
 
 	hash = flow_hash_code(fc, fcp, key, keysize);
-	hlist_for_each_entry(tfle, entry, &fcp->hash_table[hash], u.hlist) {
+	hlist_for_each_entry(tfle, &fcp->hash_table[hash], u.hlist) {
 		if (tfle->net == net &&
 		    tfle->family == family &&
 		    tfle->dir == dir &&
@@ -301,13 +300,13 @@ static void flow_cache_flush_tasklet(uns
 	struct flow_cache *fc = info->cache;
 	struct flow_cache_percpu *fcp;
 	struct flow_cache_entry *fle;
-	struct hlist_node *entry, *tmp;
+	struct hlist_node *tmp;
 	LIST_HEAD(gc_list);
 	int i, deleted = 0;
 
 	fcp = this_cpu_ptr(fc->percpu);
 	for (i = 0; i < flow_cache_hash_size(fc); i++) {
-		hlist_for_each_entry_safe(fle, entry, tmp,
+		hlist_for_each_entry_safe(fle, tmp,
 					  &fcp->hash_table[i], u.hlist) {
 			if (flow_entry_valid(fle))
 				continue;
diff -puN net/core/net-procfs.c~hlist-drop-the-node-parameter-from-iterators net/core/net-procfs.c
--- a/net/core/net-procfs.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/core/net-procfs.c
@@ -16,12 +16,11 @@ static inline struct net_device *dev_fro
 {
 	struct net *net = seq_file_net(seq);
 	struct net_device *dev;
-	struct hlist_node *p;
 	struct hlist_head *h;
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_name_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, p, h, name_hlist) {
+	hlist_for_each_entry_rcu(dev, h, name_hlist) {
 		if (++count == offset)
 			return dev;
 	}
diff -puN net/core/rtnetlink.c~hlist-drop-the-node-parameter-from-iterators net/core/rtnetlink.c
--- a/net/core/rtnetlink.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/core/rtnetlink.c
@@ -1060,7 +1060,6 @@ static int rtnl_dump_ifinfo(struct sk_bu
 	int idx = 0, s_idx;
 	struct net_device *dev;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct nlattr *tb[IFLA_MAX+1];
 	u32 ext_filter_mask = 0;
 
@@ -1080,7 +1079,7 @@ static int rtnl_dump_ifinfo(struct sk_bu
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
 		head = &net->dev_index_head[h];
-		hlist_for_each_entry_rcu(dev, node, head, index_hlist) {
+		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
 			if (rtnl_fill_ifinfo(skb, dev, RTM_NEWLINK,
diff -puN net/decnet/af_decnet.c~hlist-drop-the-node-parameter-from-iterators net/decnet/af_decnet.c
--- a/net/decnet/af_decnet.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/decnet/af_decnet.c
@@ -175,12 +175,11 @@ static struct hlist_head *dn_find_list(s
 static int check_port(__le16 port)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 
 	if (port == 0)
 		return -1;
 
-	sk_for_each(sk, node, &dn_sk_hash[le16_to_cpu(port) & DN_SK_HASH_MASK]) {
+	sk_for_each(sk, &dn_sk_hash[le16_to_cpu(port) & DN_SK_HASH_MASK]) {
 		struct dn_scp *scp = DN_SK(sk);
 		if (scp->addrloc == port)
 			return -1;
@@ -374,11 +373,10 @@ int dn_username2sockaddr(unsigned char *
 struct sock *dn_sklist_find_listener(struct sockaddr_dn *addr)
 {
 	struct hlist_head *list = listen_hash(addr);
-	struct hlist_node *node;
 	struct sock *sk;
 
 	read_lock(&dn_hash_lock);
-	sk_for_each(sk, node, list) {
+	sk_for_each(sk, list) {
 		struct dn_scp *scp = DN_SK(sk);
 		if (sk->sk_state != TCP_LISTEN)
 			continue;
@@ -414,11 +412,10 @@ struct sock *dn_find_by_skb(struct sk_bu
 {
 	struct dn_skb_cb *cb = DN_SKB_CB(skb);
 	struct sock *sk;
-	struct hlist_node *node;
 	struct dn_scp *scp;
 
 	read_lock(&dn_hash_lock);
-	sk_for_each(sk, node, &dn_sk_hash[le16_to_cpu(cb->dst_port) & DN_SK_HASH_MASK]) {
+	sk_for_each(sk, &dn_sk_hash[le16_to_cpu(cb->dst_port) & DN_SK_HASH_MASK]) {
 		scp = DN_SK(sk);
 		if (cb->src != dn_saddr2dn(&scp->peer))
 			continue;
diff -puN net/decnet/dn_table.c~hlist-drop-the-node-parameter-from-iterators net/decnet/dn_table.c
--- a/net/decnet/dn_table.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/decnet/dn_table.c
@@ -483,7 +483,6 @@ int dn_fib_dump(struct sk_buff *skb, str
 	unsigned int h, s_h;
 	unsigned int e = 0, s_e;
 	struct dn_fib_table *tb;
-	struct hlist_node *node;
 	int dumped = 0;
 
 	if (!net_eq(net, &init_net))
@@ -498,7 +497,7 @@ int dn_fib_dump(struct sk_buff *skb, str
 
 	for (h = s_h; h < DN_FIB_TABLE_HASHSZ; h++, s_h = 0) {
 		e = 0;
-		hlist_for_each_entry(tb, node, &dn_fib_table_hash[h], hlist) {
+		hlist_for_each_entry(tb, &dn_fib_table_hash[h], hlist) {
 			if (e < s_e)
 				goto next;
 			if (dumped)
@@ -828,7 +827,6 @@ out:
 struct dn_fib_table *dn_fib_get_table(u32 n, int create)
 {
 	struct dn_fib_table *t;
-	struct hlist_node *node;
 	unsigned int h;
 
 	if (n < RT_TABLE_MIN)
@@ -839,7 +837,7 @@ struct dn_fib_table *dn_fib_get_table(u3
 
 	h = n & (DN_FIB_TABLE_HASHSZ - 1);
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(t, node, &dn_fib_table_hash[h], hlist) {
+	hlist_for_each_entry_rcu(t, &dn_fib_table_hash[h], hlist) {
 		if (t->n == n) {
 			rcu_read_unlock();
 			return t;
@@ -885,11 +883,10 @@ void dn_fib_flush(void)
 {
 	int flushed = 0;
 	struct dn_fib_table *tb;
-	struct hlist_node *node;
 	unsigned int h;
 
 	for (h = 0; h < DN_FIB_TABLE_HASHSZ; h++) {
-		hlist_for_each_entry(tb, node, &dn_fib_table_hash[h], hlist)
+		hlist_for_each_entry(tb, &dn_fib_table_hash[h], hlist)
 			flushed += tb->flush(tb);
 	}
 
@@ -908,12 +905,12 @@ void __init dn_fib_table_init(void)
 void __exit dn_fib_table_cleanup(void)
 {
 	struct dn_fib_table *t;
-	struct hlist_node *node, *next;
+	struct hlist_node *next;
 	unsigned int h;
 
 	write_lock(&dn_fib_tables_lock);
 	for (h = 0; h < DN_FIB_TABLE_HASHSZ; h++) {
-		hlist_for_each_entry_safe(t, node, next, &dn_fib_table_hash[h],
+		hlist_for_each_entry_safe(t, next, &dn_fib_table_hash[h],
 					  hlist) {
 			hlist_del(&t->hlist);
 			kfree(t);
diff -puN net/ieee802154/dgram.c~hlist-drop-the-node-parameter-from-iterators net/ieee802154/dgram.c
--- a/net/ieee802154/dgram.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ieee802154/dgram.c
@@ -350,7 +350,6 @@ static inline int ieee802154_match_sock(
 int ieee802154_dgram_deliver(struct net_device *dev, struct sk_buff *skb)
 {
 	struct sock *sk, *prev = NULL;
-	struct hlist_node *node;
 	int ret = NET_RX_SUCCESS;
 	u16 pan_id, short_addr;
 
@@ -361,7 +360,7 @@ int ieee802154_dgram_deliver(struct net_
 	short_addr = ieee802154_mlme_ops(dev)->get_short_addr(dev);
 
 	read_lock(&dgram_lock);
-	sk_for_each(sk, node, &dgram_head) {
+	sk_for_each(sk, &dgram_head) {
 		if (ieee802154_match_sock(dev->dev_addr, pan_id, short_addr,
 					dgram_sk(sk))) {
 			if (prev) {
diff -puN net/ieee802154/raw.c~hlist-drop-the-node-parameter-from-iterators net/ieee802154/raw.c
--- a/net/ieee802154/raw.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ieee802154/raw.c
@@ -221,10 +221,9 @@ static int raw_rcv_skb(struct sock *sk, 
 void ieee802154_raw_deliver(struct net_device *dev, struct sk_buff *skb)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 
 	read_lock(&raw_lock);
-	sk_for_each(sk, node, &raw_head) {
+	sk_for_each(sk, &raw_head) {
 		bh_lock_sock(sk);
 		if (!sk->sk_bound_dev_if ||
 		    sk->sk_bound_dev_if == dev->ifindex) {
diff -puN net/ipv4/devinet.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/devinet.c
--- a/net/ipv4/devinet.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/devinet.c
@@ -139,10 +139,9 @@ struct net_device *__ip_dev_find(struct 
 	u32 hash = inet_addr_hash(net, addr);
 	struct net_device *result = NULL;
 	struct in_ifaddr *ifa;
-	struct hlist_node *node;
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(ifa, node, &inet_addr_lst[hash], hash) {
+	hlist_for_each_entry_rcu(ifa, &inet_addr_lst[hash], hash) {
 		if (ifa->ifa_local == addr) {
 			struct net_device *dev = ifa->ifa_dev->dev;
 
@@ -588,7 +587,6 @@ static void check_lifetime(struct work_s
 {
 	unsigned long now, next, next_sec, next_sched;
 	struct in_ifaddr *ifa;
-	struct hlist_node *node;
 	int i;
 
 	now = jiffies;
@@ -596,8 +594,7 @@ static void check_lifetime(struct work_s
 
 	rcu_read_lock();
 	for (i = 0; i < IN4_ADDR_HSIZE; i++) {
-		hlist_for_each_entry_rcu(ifa, node,
-					 &inet_addr_lst[i], hash) {
+		hlist_for_each_entry_rcu(ifa, &inet_addr_lst[i], hash) {
 			unsigned long age;
 
 			if (ifa->ifa_flags & IFA_F_PERMANENT)
@@ -1493,7 +1490,6 @@ static int inet_dump_ifaddr(struct sk_bu
 	struct in_device *in_dev;
 	struct in_ifaddr *ifa;
 	struct hlist_head *head;
-	struct hlist_node *node;
 
 	s_h = cb->args[0];
 	s_idx = idx = cb->args[1];
@@ -1503,7 +1499,7 @@ static int inet_dump_ifaddr(struct sk_bu
 		idx = 0;
 		head = &net->dev_index_head[h];
 		rcu_read_lock();
-		hlist_for_each_entry_rcu(dev, node, head, index_hlist) {
+		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
 			if (h > s_h || idx > s_idx)
diff -puN net/ipv4/fib_frontend.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/fib_frontend.c
--- a/net/ipv4/fib_frontend.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/fib_frontend.c
@@ -112,7 +112,6 @@ struct fib_table *fib_new_table(struct n
 struct fib_table *fib_get_table(struct net *net, u32 id)
 {
 	struct fib_table *tb;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	unsigned int h;
 
@@ -122,7 +121,7 @@ struct fib_table *fib_get_table(struct n
 
 	rcu_read_lock();
 	head = &net->ipv4.fib_table_hash[h];
-	hlist_for_each_entry_rcu(tb, node, head, tb_hlist) {
+	hlist_for_each_entry_rcu(tb, head, tb_hlist) {
 		if (tb->tb_id == id) {
 			rcu_read_unlock();
 			return tb;
@@ -137,13 +136,12 @@ static void fib_flush(struct net *net)
 {
 	int flushed = 0;
 	struct fib_table *tb;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	unsigned int h;
 
 	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
 		head = &net->ipv4.fib_table_hash[h];
-		hlist_for_each_entry(tb, node, head, tb_hlist)
+		hlist_for_each_entry(tb, head, tb_hlist)
 			flushed += fib_table_flush(tb);
 	}
 
@@ -656,7 +654,6 @@ static int inet_dump_fib(struct sk_buff 
 	unsigned int h, s_h;
 	unsigned int e = 0, s_e;
 	struct fib_table *tb;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	int dumped = 0;
 
@@ -670,7 +667,7 @@ static int inet_dump_fib(struct sk_buff 
 	for (h = s_h; h < FIB_TABLE_HASHSZ; h++, s_e = 0) {
 		e = 0;
 		head = &net->ipv4.fib_table_hash[h];
-		hlist_for_each_entry(tb, node, head, tb_hlist) {
+		hlist_for_each_entry(tb, head, tb_hlist) {
 			if (e < s_e)
 				goto next;
 			if (dumped)
@@ -1117,11 +1114,11 @@ static void ip_fib_net_exit(struct net *
 	for (i = 0; i < FIB_TABLE_HASHSZ; i++) {
 		struct fib_table *tb;
 		struct hlist_head *head;
-		struct hlist_node *node, *tmp;
+		struct hlist_node *tmp;
 
 		head = &net->ipv4.fib_table_hash[i];
-		hlist_for_each_entry_safe(tb, node, tmp, head, tb_hlist) {
-			hlist_del(node);
+		hlist_for_each_entry_safe(tb, tmp, head, tb_hlist) {
+			hlist_del(&tb->tb_hlist);
 			fib_table_flush(tb);
 			fib_free_table(tb);
 		}
diff -puN net/ipv4/fib_semantics.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/fib_semantics.c
--- a/net/ipv4/fib_semantics.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/fib_semantics.c
@@ -298,14 +298,13 @@ static inline unsigned int fib_info_hash
 static struct fib_info *fib_find_info(const struct fib_info *nfi)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct fib_info *fi;
 	unsigned int hash;
 
 	hash = fib_info_hashfn(nfi);
 	head = &fib_info_hash[hash];
 
-	hlist_for_each_entry(fi, node, head, fib_hash) {
+	hlist_for_each_entry(fi, head, fib_hash) {
 		if (!net_eq(fi->fib_net, nfi->fib_net))
 			continue;
 		if (fi->fib_nhs != nfi->fib_nhs)
@@ -331,7 +330,6 @@ static struct fib_info *fib_find_info(co
 int ip_fib_check_default(__be32 gw, struct net_device *dev)
 {
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct fib_nh *nh;
 	unsigned int hash;
 
@@ -339,7 +337,7 @@ int ip_fib_check_default(__be32 gw, stru
 
 	hash = fib_devindex_hashfn(dev->ifindex);
 	head = &fib_info_devhash[hash];
-	hlist_for_each_entry(nh, node, head, nh_hash) {
+	hlist_for_each_entry(nh, head, nh_hash) {
 		if (nh->nh_dev == dev &&
 		    nh->nh_gw == gw &&
 		    !(nh->nh_flags & RTNH_F_DEAD)) {
@@ -721,10 +719,10 @@ static void fib_info_hash_move(struct hl
 
 	for (i = 0; i < old_size; i++) {
 		struct hlist_head *head = &fib_info_hash[i];
-		struct hlist_node *node, *n;
+		struct hlist_node *n;
 		struct fib_info *fi;
 
-		hlist_for_each_entry_safe(fi, node, n, head, fib_hash) {
+		hlist_for_each_entry_safe(fi, n, head, fib_hash) {
 			struct hlist_head *dest;
 			unsigned int new_hash;
 
@@ -739,10 +737,10 @@ static void fib_info_hash_move(struct hl
 
 	for (i = 0; i < old_size; i++) {
 		struct hlist_head *lhead = &fib_info_laddrhash[i];
-		struct hlist_node *node, *n;
+		struct hlist_node *n;
 		struct fib_info *fi;
 
-		hlist_for_each_entry_safe(fi, node, n, lhead, fib_lhash) {
+		hlist_for_each_entry_safe(fi, n, lhead, fib_lhash) {
 			struct hlist_head *ldest;
 			unsigned int new_hash;
 
@@ -1096,13 +1094,12 @@ int fib_sync_down_addr(struct net *net, 
 	int ret = 0;
 	unsigned int hash = fib_laddr_hashfn(local);
 	struct hlist_head *head = &fib_info_laddrhash[hash];
-	struct hlist_node *node;
 	struct fib_info *fi;
 
 	if (fib_info_laddrhash == NULL || local == 0)
 		return 0;
 
-	hlist_for_each_entry(fi, node, head, fib_lhash) {
+	hlist_for_each_entry(fi, head, fib_lhash) {
 		if (!net_eq(fi->fib_net, net))
 			continue;
 		if (fi->fib_prefsrc == local) {
@@ -1120,13 +1117,12 @@ int fib_sync_down_dev(struct net_device 
 	struct fib_info *prev_fi = NULL;
 	unsigned int hash = fib_devindex_hashfn(dev->ifindex);
 	struct hlist_head *head = &fib_info_devhash[hash];
-	struct hlist_node *node;
 	struct fib_nh *nh;
 
 	if (force)
 		scope = -1;
 
-	hlist_for_each_entry(nh, node, head, nh_hash) {
+	hlist_for_each_entry(nh, head, nh_hash) {
 		struct fib_info *fi = nh->nh_parent;
 		int dead;
 
@@ -1232,7 +1228,6 @@ int fib_sync_up(struct net_device *dev)
 	struct fib_info *prev_fi;
 	unsigned int hash;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	struct fib_nh *nh;
 	int ret;
 
@@ -1244,7 +1239,7 @@ int fib_sync_up(struct net_device *dev)
 	head = &fib_info_devhash[hash];
 	ret = 0;
 
-	hlist_for_each_entry(nh, node, head, nh_hash) {
+	hlist_for_each_entry(nh, head, nh_hash) {
 		struct fib_info *fi = nh->nh_parent;
 		int alive;
 
diff -puN net/ipv4/fib_trie.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/fib_trie.c
@@ -920,10 +920,9 @@ nomem:
 static struct leaf_info *find_leaf_info(struct leaf *l, int plen)
 {
 	struct hlist_head *head = &l->list;
-	struct hlist_node *node;
 	struct leaf_info *li;
 
-	hlist_for_each_entry_rcu(li, node, head, hlist)
+	hlist_for_each_entry_rcu(li, head, hlist)
 		if (li->plen == plen)
 			return li;
 
@@ -943,12 +942,11 @@ static inline struct list_head *get_fa_h
 static void insert_leaf_info(struct hlist_head *head, struct leaf_info *new)
 {
 	struct leaf_info *li = NULL, *last = NULL;
-	struct hlist_node *node;
 
 	if (hlist_empty(head)) {
 		hlist_add_head_rcu(&new->hlist, head);
 	} else {
-		hlist_for_each_entry(li, node, head, hlist) {
+		hlist_for_each_entry(li, head, hlist) {
 			if (new->plen > li->plen)
 				break;
 
@@ -1354,9 +1352,8 @@ static int check_leaf(struct fib_table *
 {
 	struct leaf_info *li;
 	struct hlist_head *hhead = &l->list;
-	struct hlist_node *node;
 
-	hlist_for_each_entry_rcu(li, node, hhead, hlist) {
+	hlist_for_each_entry_rcu(li, hhead, hlist) {
 		struct fib_alias *fa;
 
 		if (l->key != (key & li->mask_plen))
@@ -1740,10 +1737,10 @@ static int trie_flush_leaf(struct leaf *
 {
 	int found = 0;
 	struct hlist_head *lih = &l->list;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	struct leaf_info *li = NULL;
 
-	hlist_for_each_entry_safe(li, node, tmp, lih, hlist) {
+	hlist_for_each_entry_safe(li, tmp, lih, hlist) {
 		found += trie_flush_list(&li->falh);
 
 		if (list_empty(&li->falh)) {
@@ -1895,14 +1892,13 @@ static int fn_trie_dump_leaf(struct leaf
 			struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct leaf_info *li;
-	struct hlist_node *node;
 	int i, s_i;
 
 	s_i = cb->args[4];
 	i = 0;
 
 	/* rcu_read_lock is hold by caller */
-	hlist_for_each_entry_rcu(li, node, &l->list, hlist) {
+	hlist_for_each_entry_rcu(li, &l->list, hlist) {
 		if (i < s_i) {
 			i++;
 			continue;
@@ -2092,14 +2088,13 @@ static void trie_collect_stats(struct tr
 		if (IS_LEAF(n)) {
 			struct leaf *l = (struct leaf *)n;
 			struct leaf_info *li;
-			struct hlist_node *tmp;
 
 			s->leaves++;
 			s->totdepth += iter.depth;
 			if (iter.depth > s->maxdepth)
 				s->maxdepth = iter.depth;
 
-			hlist_for_each_entry_rcu(li, tmp, &l->list, hlist)
+			hlist_for_each_entry_rcu(li, &l->list, hlist)
 				++s->prefixes;
 		} else {
 			const struct tnode *tn = (const struct tnode *) n;
@@ -2200,10 +2195,9 @@ static int fib_triestat_seq_show(struct 
 
 	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
 		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
-		struct hlist_node *node;
 		struct fib_table *tb;
 
-		hlist_for_each_entry_rcu(tb, node, head, tb_hlist) {
+		hlist_for_each_entry_rcu(tb, head, tb_hlist) {
 			struct trie *t = (struct trie *) tb->tb_data;
 			struct trie_stat stat;
 
@@ -2245,10 +2239,9 @@ static struct rt_trie_node *fib_trie_get
 
 	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
 		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
-		struct hlist_node *node;
 		struct fib_table *tb;
 
-		hlist_for_each_entry_rcu(tb, node, head, tb_hlist) {
+		hlist_for_each_entry_rcu(tb, head, tb_hlist) {
 			struct rt_trie_node *n;
 
 			for (n = fib_trie_get_first(iter,
@@ -2298,7 +2291,7 @@ static void *fib_trie_seq_next(struct se
 	/* new hash chain */
 	while (++h < FIB_TABLE_HASHSZ) {
 		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
-		hlist_for_each_entry_rcu(tb, tb_node, head, tb_hlist) {
+		hlist_for_each_entry_rcu(tb, head, tb_hlist) {
 			n = fib_trie_get_first(iter, (struct trie *) tb->tb_data);
 			if (n)
 				goto found;
@@ -2381,13 +2374,12 @@ static int fib_trie_seq_show(struct seq_
 	} else {
 		struct leaf *l = (struct leaf *) n;
 		struct leaf_info *li;
-		struct hlist_node *node;
 		__be32 val = htonl(l->key);
 
 		seq_indent(seq, iter->depth);
 		seq_printf(seq, "  |-- %pI4\n", &val);
 
-		hlist_for_each_entry_rcu(li, node, &l->list, hlist) {
+		hlist_for_each_entry_rcu(li, &l->list, hlist) {
 			struct fib_alias *fa;
 
 			list_for_each_entry_rcu(fa, &li->falh, fa_list) {
@@ -2532,7 +2524,6 @@ static int fib_route_seq_show(struct seq
 {
 	struct leaf *l = v;
 	struct leaf_info *li;
-	struct hlist_node *node;
 
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(seq, "%-127s\n", "Iface\tDestination\tGateway "
@@ -2541,7 +2532,7 @@ static int fib_route_seq_show(struct seq
 		return 0;
 	}
 
-	hlist_for_each_entry_rcu(li, node, &l->list, hlist) {
+	hlist_for_each_entry_rcu(li, &l->list, hlist) {
 		struct fib_alias *fa;
 		__be32 mask, prefix;
 
diff -puN net/ipv4/inet_connection_sock.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/inet_connection_sock.c
--- a/net/ipv4/inet_connection_sock.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/inet_connection_sock.c
@@ -57,7 +57,6 @@ int inet_csk_bind_conflict(const struct 
 			   const struct inet_bind_bucket *tb, bool relax)
 {
 	struct sock *sk2;
-	struct hlist_node *node;
 	int reuse = sk->sk_reuse;
 	int reuseport = sk->sk_reuseport;
 	kuid_t uid = sock_i_uid((struct sock *)sk);
@@ -69,7 +68,7 @@ int inet_csk_bind_conflict(const struct 
 	 * one this bucket belongs to.
 	 */
 
-	sk_for_each_bound(sk2, node, &tb->owners) {
+	sk_for_each_bound(sk2, &tb->owners) {
 		if (sk != sk2 &&
 		    !inet_v6_ipv6only(sk2) &&
 		    (!sk->sk_bound_dev_if ||
@@ -95,7 +94,7 @@ int inet_csk_bind_conflict(const struct 
 			}
 		}
 	}
-	return node != NULL;
+	return sk2 != NULL;
 }
 EXPORT_SYMBOL_GPL(inet_csk_bind_conflict);
 
@@ -106,7 +105,6 @@ int inet_csk_get_port(struct sock *sk, u
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct inet_bind_hashbucket *head;
-	struct hlist_node *node;
 	struct inet_bind_bucket *tb;
 	int ret, attempts = 5;
 	struct net *net = sock_net(sk);
@@ -129,7 +127,7 @@ again:
 			head = &hashinfo->bhash[inet_bhashfn(net, rover,
 					hashinfo->bhash_size)];
 			spin_lock(&head->lock);
-			inet_bind_bucket_for_each(tb, node, &head->chain)
+			inet_bind_bucket_for_each(tb, &head->chain)
 				if (net_eq(ib_net(tb), net) && tb->port == rover) {
 					if (((tb->fastreuse > 0 &&
 					      sk->sk_reuse &&
@@ -183,7 +181,7 @@ have_snum:
 		head = &hashinfo->bhash[inet_bhashfn(net, snum,
 				hashinfo->bhash_size)];
 		spin_lock(&head->lock);
-		inet_bind_bucket_for_each(tb, node, &head->chain)
+		inet_bind_bucket_for_each(tb, &head->chain)
 			if (net_eq(ib_net(tb), net) && tb->port == snum)
 				goto tb_found;
 	}
diff -puN net/ipv4/inet_fragment.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/inet_fragment.c
--- a/net/ipv4/inet_fragment.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/inet_fragment.c
@@ -33,9 +33,9 @@ static void inet_frag_secret_rebuild(uns
 	get_random_bytes(&f->rnd, sizeof(u32));
 	for (i = 0; i < INETFRAGS_HASHSZ; i++) {
 		struct inet_frag_queue *q;
-		struct hlist_node *p, *n;
+		struct hlist_node *n;
 
-		hlist_for_each_entry_safe(q, p, n, &f->hash[i], list) {
+		hlist_for_each_entry_safe(q, n, &f->hash[i], list) {
 			unsigned int hval = f->hashfn(q);
 
 			if (hval != i) {
@@ -203,7 +203,6 @@ static struct inet_frag_queue *inet_frag
 {
 	struct inet_frag_queue *qp;
 #ifdef CONFIG_SMP
-	struct hlist_node *n;
 #endif
 	unsigned int hash;
 
@@ -219,7 +218,7 @@ static struct inet_frag_queue *inet_frag
 	 * such entry could be created on other cpu, while we
 	 * promoted read lock to write lock.
 	 */
-	hlist_for_each_entry(qp, n, &f->hash[hash], list) {
+	hlist_for_each_entry(qp, &f->hash[hash], list) {
 		if (qp->net == nf && f->match(qp, arg)) {
 			atomic_inc(&qp->refcnt);
 			write_unlock(&f->lock);
@@ -278,9 +277,8 @@ struct inet_frag_queue *inet_frag_find(s
 	__releases(&f->lock)
 {
 	struct inet_frag_queue *q;
-	struct hlist_node *n;
 
-	hlist_for_each_entry(q, n, &f->hash[hash], list) {
+	hlist_for_each_entry(q, &f->hash[hash], list) {
 		if (q->net == nf && f->match(q, key)) {
 			atomic_inc(&q->refcnt);
 			read_unlock(&f->lock);
diff -puN net/ipv4/inet_hashtables.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/inet_hashtables.c
--- a/net/ipv4/inet_hashtables.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/inet_hashtables.c
@@ -120,13 +120,12 @@ int __inet_inherit_port(struct sock *sk,
 		 * that the listener socket's icsk_bind_hash is the same
 		 * as that of the child socket. We have to look up or
 		 * create a new bind bucket for the child here. */
-		struct hlist_node *node;
-		inet_bind_bucket_for_each(tb, node, &head->chain) {
+		inet_bind_bucket_for_each(tb, &head->chain) {
 			if (net_eq(ib_net(tb), sock_net(sk)) &&
 			    tb->port == port)
 				break;
 		}
-		if (!node) {
+		if (!tb) {
 			tb = inet_bind_bucket_create(table->bind_bucket_cachep,
 						     sock_net(sk), head, port);
 			if (!tb) {
@@ -493,7 +492,6 @@ int __inet_hash_connect(struct inet_time
 		int i, remaining, low, high, port;
 		static u32 hint;
 		u32 offset = hint + port_offset;
-		struct hlist_node *node;
 		struct inet_timewait_sock *tw = NULL;
 
 		inet_get_local_port_range(&low, &high);
@@ -512,7 +510,7 @@ int __inet_hash_connect(struct inet_time
 			 * because the established check is already
 			 * unique enough.
 			 */
-			inet_bind_bucket_for_each(tb, node, &head->chain) {
+			inet_bind_bucket_for_each(tb, &head->chain) {
 				if (net_eq(ib_net(tb), net) &&
 				    tb->port == port) {
 					if (tb->fastreuse >= 0 ||
diff -puN net/ipv4/inet_timewait_sock.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/inet_timewait_sock.c
--- a/net/ipv4/inet_timewait_sock.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/inet_timewait_sock.c
@@ -216,7 +216,6 @@ static int inet_twdr_do_twkill_work(stru
 				    const int slot)
 {
 	struct inet_timewait_sock *tw;
-	struct hlist_node *node;
 	unsigned int killed;
 	int ret;
 
@@ -229,7 +228,7 @@ static int inet_twdr_do_twkill_work(stru
 	killed = 0;
 	ret = 0;
 rescan:
-	inet_twsk_for_each_inmate(tw, node, &twdr->cells[slot]) {
+	inet_twsk_for_each_inmate(tw, &twdr->cells[slot]) {
 		__inet_twsk_del_dead_node(tw);
 		spin_unlock(&twdr->death_lock);
 		__inet_twsk_kill(tw, twdr->hashinfo);
@@ -438,10 +437,10 @@ void inet_twdr_twcal_tick(unsigned long 
 
 	for (n = 0; n < INET_TWDR_RECYCLE_SLOTS; n++) {
 		if (time_before_eq(j, now)) {
-			struct hlist_node *node, *safe;
+			struct hlist_node *safe;
 			struct inet_timewait_sock *tw;
 
-			inet_twsk_for_each_inmate_safe(tw, node, safe,
+			inet_twsk_for_each_inmate_safe(tw, safe,
 						       &twdr->twcal_row[slot]) {
 				__inet_twsk_del_dead_node(tw);
 				__inet_twsk_kill(tw, twdr->hashinfo);
diff -puN net/ipv4/raw.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/raw.c
--- a/net/ipv4/raw.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/raw.c
@@ -111,9 +111,7 @@ EXPORT_SYMBOL_GPL(raw_unhash_sk);
 static struct sock *__raw_v4_lookup(struct net *net, struct sock *sk,
 		unsigned short num, __be32 raddr, __be32 laddr, int dif)
 {
-	struct hlist_node *node;
-
-	sk_for_each_from(sk, node) {
+	sk_for_each_from(sk) {
 		struct inet_sock *inet = inet_sk(sk);
 
 		if (net_eq(sock_net(sk), net) && inet->inet_num == num	&&
@@ -914,9 +912,7 @@ static struct sock *raw_get_first(struct
 
 	for (state->bucket = 0; state->bucket < RAW_HTABLE_SIZE;
 			++state->bucket) {
-		struct hlist_node *node;
-
-		sk_for_each(sk, node, &state->h->ht[state->bucket])
+		sk_for_each(sk, &state->h->ht[state->bucket])
 			if (sock_net(sk) == seq_file_net(seq))
 				goto found;
 	}
diff -puN net/ipv4/tcp_ipv4.c~hlist-drop-the-node-parameter-from-iterators net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv4/tcp_ipv4.c
@@ -954,7 +954,6 @@ struct tcp_md5sig_key *tcp_md5_do_lookup
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
-	struct hlist_node *pos;
 	unsigned int size = sizeof(struct in_addr);
 	struct tcp_md5sig_info *md5sig;
 
@@ -968,7 +967,7 @@ struct tcp_md5sig_key *tcp_md5_do_lookup
 	if (family == AF_INET6)
 		size = sizeof(struct in6_addr);
 #endif
-	hlist_for_each_entry_rcu(key, pos, &md5sig->head, node) {
+	hlist_for_each_entry_rcu(key, &md5sig->head, node) {
 		if (key->family != family)
 			continue;
 		if (!memcmp(&key->addr, addr, size))
@@ -1069,14 +1068,14 @@ static void tcp_clear_md5_list(struct so
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 	struct tcp_md5sig_info *md5sig;
 
 	md5sig = rcu_dereference_protected(tp->md5sig_info, 1);
 
 	if (!hlist_empty(&md5sig->head))
 		tcp_free_md5sig_pool();
-	hlist_for_each_entry_safe(key, pos, n, &md5sig->head, node) {
+	hlist_for_each_entry_safe(key, n, &md5sig->head, node) {
 		hlist_del_rcu(&key->node);
 		atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
 		kfree_rcu(key, rcu);
diff -puN net/ipv6/addrconf.c~hlist-drop-the-node-parameter-from-iterators net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv6/addrconf.c
@@ -1419,11 +1419,10 @@ int ipv6_chk_addr(struct net *net, const
 		  struct net_device *dev, int strict)
 {
 	struct inet6_ifaddr *ifp;
-	struct hlist_node *node;
 	unsigned int hash = inet6_addr_hash(addr);
 
 	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu(ifp, node, &inet6_addr_lst[hash], addr_lst) {
+	hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
 		if (!net_eq(dev_net(ifp->idev->dev), net))
 			continue;
 		if (ipv6_addr_equal(&ifp->addr, addr) &&
@@ -1445,9 +1444,8 @@ static bool ipv6_chk_same_addr(struct ne
 {
 	unsigned int hash = inet6_addr_hash(addr);
 	struct inet6_ifaddr *ifp;
-	struct hlist_node *node;
 
-	hlist_for_each_entry(ifp, node, &inet6_addr_lst[hash], addr_lst) {
+	hlist_for_each_entry(ifp, &inet6_addr_lst[hash], addr_lst) {
 		if (!net_eq(dev_net(ifp->idev->dev), net))
 			continue;
 		if (ipv6_addr_equal(&ifp->addr, addr)) {
@@ -1487,10 +1485,9 @@ struct inet6_ifaddr *ipv6_get_ifaddr(str
 {
 	struct inet6_ifaddr *ifp, *result = NULL;
 	unsigned int hash = inet6_addr_hash(addr);
-	struct hlist_node *node;
 
 	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu_bh(ifp, node, &inet6_addr_lst[hash], addr_lst) {
+	hlist_for_each_entry_rcu_bh(ifp, &inet6_addr_lst[hash], addr_lst) {
 		if (!net_eq(dev_net(ifp->idev->dev), net))
 			continue;
 		if (ipv6_addr_equal(&ifp->addr, addr)) {
@@ -2907,11 +2904,10 @@ static int addrconf_ifdown(struct net_de
 	/* Step 2: clear hash table */
 	for (i = 0; i < IN6_ADDR_HSIZE; i++) {
 		struct hlist_head *h = &inet6_addr_lst[i];
-		struct hlist_node *n;
 
 		spin_lock_bh(&addrconf_hash_lock);
 	restart:
-		hlist_for_each_entry_rcu(ifa, n, h, addr_lst) {
+		hlist_for_each_entry_rcu(ifa, h, addr_lst) {
 			if (ifa->idev == idev) {
 				hlist_del_init_rcu(&ifa->addr_lst);
 				addrconf_del_timer(ifa);
@@ -3218,8 +3214,7 @@ static struct inet6_ifaddr *if6_get_firs
 	}
 
 	for (; state->bucket < IN6_ADDR_HSIZE; ++state->bucket) {
-		struct hlist_node *n;
-		hlist_for_each_entry_rcu_bh(ifa, n, &inet6_addr_lst[state->bucket],
+		hlist_for_each_entry_rcu_bh(ifa, &inet6_addr_lst[state->bucket],
 					 addr_lst) {
 			if (!net_eq(dev_net(ifa->idev->dev), net))
 				continue;
@@ -3244,9 +3239,8 @@ static struct inet6_ifaddr *if6_get_next
 {
 	struct if6_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
-	struct hlist_node *n = &ifa->addr_lst;
 
-	hlist_for_each_entry_continue_rcu_bh(ifa, n, addr_lst) {
+	hlist_for_each_entry_continue_rcu_bh(ifa, addr_lst) {
 		if (!net_eq(dev_net(ifa->idev->dev), net))
 			continue;
 		state->offset++;
@@ -3255,7 +3249,7 @@ static struct inet6_ifaddr *if6_get_next
 
 	while (++state->bucket < IN6_ADDR_HSIZE) {
 		state->offset = 0;
-		hlist_for_each_entry_rcu_bh(ifa, n,
+		hlist_for_each_entry_rcu_bh(ifa,
 				     &inet6_addr_lst[state->bucket], addr_lst) {
 			if (!net_eq(dev_net(ifa->idev->dev), net))
 				continue;
@@ -3357,11 +3351,10 @@ int ipv6_chk_home_addr(struct net *net, 
 {
 	int ret = 0;
 	struct inet6_ifaddr *ifp = NULL;
-	struct hlist_node *n;
 	unsigned int hash = inet6_addr_hash(addr);
 
 	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu_bh(ifp, n, &inet6_addr_lst[hash], addr_lst) {
+	hlist_for_each_entry_rcu_bh(ifp, &inet6_addr_lst[hash], addr_lst) {
 		if (!net_eq(dev_net(ifp->idev->dev), net))
 			continue;
 		if (ipv6_addr_equal(&ifp->addr, addr) &&
@@ -3383,7 +3376,6 @@ static void addrconf_verify(unsigned lon
 {
 	unsigned long now, next, next_sec, next_sched;
 	struct inet6_ifaddr *ifp;
-	struct hlist_node *node;
 	int i;
 
 	rcu_read_lock_bh();
@@ -3395,7 +3387,7 @@ static void addrconf_verify(unsigned lon
 
 	for (i = 0; i < IN6_ADDR_HSIZE; i++) {
 restart:
-		hlist_for_each_entry_rcu_bh(ifp, node,
+		hlist_for_each_entry_rcu_bh(ifp,
 					 &inet6_addr_lst[i], addr_lst) {
 			unsigned long age;
 
@@ -3866,7 +3858,6 @@ static int inet6_dump_addr(struct sk_buf
 	struct net_device *dev;
 	struct inet6_dev *idev;
 	struct hlist_head *head;
-	struct hlist_node *node;
 
 	s_h = cb->args[0];
 	s_idx = idx = cb->args[1];
@@ -3876,7 +3867,7 @@ static int inet6_dump_addr(struct sk_buf
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
 		head = &net->dev_index_head[h];
-		hlist_for_each_entry_rcu(dev, node, head, index_hlist) {
+		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
 			if (h > s_h || idx > s_idx)
@@ -4222,7 +4213,6 @@ static int inet6_dump_ifinfo(struct sk_b
 	struct net_device *dev;
 	struct inet6_dev *idev;
 	struct hlist_head *head;
-	struct hlist_node *node;
 
 	s_h = cb->args[0];
 	s_idx = cb->args[1];
@@ -4231,7 +4221,7 @@ static int inet6_dump_ifinfo(struct sk_b
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
 		head = &net->dev_index_head[h];
-		hlist_for_each_entry_rcu(dev, node, head, index_hlist) {
+		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
 			idev = __in6_dev_get(dev);
diff -puN net/ipv6/addrlabel.c~hlist-drop-the-node-parameter-from-iterators net/ipv6/addrlabel.c
--- a/net/ipv6/addrlabel.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv6/addrlabel.c
@@ -173,9 +173,8 @@ static struct ip6addrlbl_entry *__ipv6_a
 						  const struct in6_addr *addr,
 						  int type, int ifindex)
 {
-	struct hlist_node *pos;
 	struct ip6addrlbl_entry *p;
-	hlist_for_each_entry_rcu(p, pos, &ip6addrlbl_table.head, list) {
+	hlist_for_each_entry_rcu(p, &ip6addrlbl_table.head, list) {
 		if (__ip6addrlbl_match(net, p, addr, type, ifindex))
 			return p;
 	}
@@ -261,9 +260,9 @@ static int __ip6addrlbl_add(struct ip6ad
 	if (hlist_empty(&ip6addrlbl_table.head)) {
 		hlist_add_head_rcu(&newp->list, &ip6addrlbl_table.head);
 	} else {
-		struct hlist_node *pos, *n;
+		struct hlist_node *n;
 		struct ip6addrlbl_entry *p = NULL;
-		hlist_for_each_entry_safe(p, pos, n,
+		hlist_for_each_entry_safe(p, n,
 					  &ip6addrlbl_table.head, list) {
 			if (p->prefixlen == newp->prefixlen &&
 			    net_eq(ip6addrlbl_net(p), ip6addrlbl_net(newp)) &&
@@ -319,13 +318,13 @@ static int __ip6addrlbl_del(struct net *
 			    int ifindex)
 {
 	struct ip6addrlbl_entry *p = NULL;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 	int ret = -ESRCH;
 
 	ADDRLABEL(KERN_DEBUG "%s(prefix=%pI6, prefixlen=%d, ifindex=%d)\n",
 		  __func__, prefix, prefixlen, ifindex);
 
-	hlist_for_each_entry_safe(p, pos, n, &ip6addrlbl_table.head, list) {
+	hlist_for_each_entry_safe(p, n, &ip6addrlbl_table.head, list) {
 		if (p->prefixlen == prefixlen &&
 		    net_eq(ip6addrlbl_net(p), net) &&
 		    p->ifindex == ifindex &&
@@ -380,11 +379,11 @@ static int __net_init ip6addrlbl_net_ini
 static void __net_exit ip6addrlbl_net_exit(struct net *net)
 {
 	struct ip6addrlbl_entry *p = NULL;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 
 	/* Remove all labels belonging to the exiting net */
 	spin_lock(&ip6addrlbl_table.lock);
-	hlist_for_each_entry_safe(p, pos, n, &ip6addrlbl_table.head, list) {
+	hlist_for_each_entry_safe(p, n, &ip6addrlbl_table.head, list) {
 		if (net_eq(ip6addrlbl_net(p), net)) {
 			hlist_del_rcu(&p->list);
 			ip6addrlbl_put(p);
@@ -505,12 +504,11 @@ static int ip6addrlbl_dump(struct sk_buf
 {
 	struct net *net = sock_net(skb->sk);
 	struct ip6addrlbl_entry *p;
-	struct hlist_node *pos;
 	int idx = 0, s_idx = cb->args[0];
 	int err;
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(p, pos, &ip6addrlbl_table.head, list) {
+	hlist_for_each_entry_rcu(p, &ip6addrlbl_table.head, list) {
 		if (idx >= s_idx &&
 		    net_eq(ip6addrlbl_net(p), net)) {
 			if ((err = ip6addrlbl_fill(skb, p,
diff -puN net/ipv6/inet6_connection_sock.c~hlist-drop-the-node-parameter-from-iterators net/ipv6/inet6_connection_sock.c
--- a/net/ipv6/inet6_connection_sock.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv6/inet6_connection_sock.c
@@ -31,7 +31,6 @@ int inet6_csk_bind_conflict(const struct
 			    const struct inet_bind_bucket *tb, bool relax)
 {
 	const struct sock *sk2;
-	const struct hlist_node *node;
 	int reuse = sk->sk_reuse;
 	int reuseport = sk->sk_reuseport;
 	kuid_t uid = sock_i_uid((struct sock *)sk);
@@ -41,7 +40,7 @@ int inet6_csk_bind_conflict(const struct
 	 * See comment in inet_csk_bind_conflict about sock lookup
 	 * vs net namespaces issues.
 	 */
-	sk_for_each_bound(sk2, node, &tb->owners) {
+	sk_for_each_bound(sk2, &tb->owners) {
 		if (sk != sk2 &&
 		    (!sk->sk_bound_dev_if ||
 		     !sk2->sk_bound_dev_if ||
@@ -58,7 +57,7 @@ int inet6_csk_bind_conflict(const struct
 		}
 	}
 
-	return node != NULL;
+	return sk2 != NULL;
 }
 
 EXPORT_SYMBOL_GPL(inet6_csk_bind_conflict);
diff -puN net/ipv6/ip6_fib.c~hlist-drop-the-node-parameter-from-iterators net/ipv6/ip6_fib.c
--- a/net/ipv6/ip6_fib.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv6/ip6_fib.c
@@ -224,7 +224,6 @@ struct fib6_table *fib6_get_table(struct
 {
 	struct fib6_table *tb;
 	struct hlist_head *head;
-	struct hlist_node *node;
 	unsigned int h;
 
 	if (id == 0)
@@ -232,7 +231,7 @@ struct fib6_table *fib6_get_table(struct
 	h = id & (FIB6_TABLE_HASHSZ - 1);
 	rcu_read_lock();
 	head = &net->ipv6.fib_table_hash[h];
-	hlist_for_each_entry_rcu(tb, node, head, tb6_hlist) {
+	hlist_for_each_entry_rcu(tb, head, tb6_hlist) {
 		if (tb->tb6_id == id) {
 			rcu_read_unlock();
 			return tb;
@@ -363,7 +362,6 @@ static int inet6_dump_fib(struct sk_buff
 	struct rt6_rtnl_dump_arg arg;
 	struct fib6_walker_t *w;
 	struct fib6_table *tb;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	int res = 0;
 
@@ -398,7 +396,7 @@ static int inet6_dump_fib(struct sk_buff
 	for (h = s_h; h < FIB6_TABLE_HASHSZ; h++, s_e = 0) {
 		e = 0;
 		head = &net->ipv6.fib_table_hash[h];
-		hlist_for_each_entry_rcu(tb, node, head, tb6_hlist) {
+		hlist_for_each_entry_rcu(tb, head, tb6_hlist) {
 			if (e < s_e)
 				goto next;
 			res = fib6_dump_table(tb, skb, cb);
@@ -1520,14 +1518,13 @@ void fib6_clean_all_ro(struct net *net, 
 		    int prune, void *arg)
 {
 	struct fib6_table *table;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	unsigned int h;
 
 	rcu_read_lock();
 	for (h = 0; h < FIB6_TABLE_HASHSZ; h++) {
 		head = &net->ipv6.fib_table_hash[h];
-		hlist_for_each_entry_rcu(table, node, head, tb6_hlist) {
+		hlist_for_each_entry_rcu(table, head, tb6_hlist) {
 			read_lock_bh(&table->tb6_lock);
 			fib6_clean_tree(net, &table->tb6_root,
 					func, prune, arg);
@@ -1540,14 +1537,13 @@ void fib6_clean_all(struct net *net, int
 		    int prune, void *arg)
 {
 	struct fib6_table *table;
-	struct hlist_node *node;
 	struct hlist_head *head;
 	unsigned int h;
 
 	rcu_read_lock();
 	for (h = 0; h < FIB6_TABLE_HASHSZ; h++) {
 		head = &net->ipv6.fib_table_hash[h];
-		hlist_for_each_entry_rcu(table, node, head, tb6_hlist) {
+		hlist_for_each_entry_rcu(table, head, tb6_hlist) {
 			write_lock_bh(&table->tb6_lock);
 			fib6_clean_tree(net, &table->tb6_root,
 					func, prune, arg);
diff -puN net/ipv6/raw.c~hlist-drop-the-node-parameter-from-iterators net/ipv6/raw.c
--- a/net/ipv6/raw.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv6/raw.c
@@ -71,10 +71,9 @@ static struct sock *__raw_v6_lookup(stru
 		unsigned short num, const struct in6_addr *loc_addr,
 		const struct in6_addr *rmt_addr, int dif)
 {
-	struct hlist_node *node;
 	bool is_multicast = ipv6_addr_is_multicast(loc_addr);
 
-	sk_for_each_from(sk, node)
+	sk_for_each_from(sk)
 		if (inet_sk(sk)->inet_num == num) {
 			struct ipv6_pinfo *np = inet6_sk(sk);
 
diff -puN net/ipv6/xfrm6_tunnel.c~hlist-drop-the-node-parameter-from-iterators net/ipv6/xfrm6_tunnel.c
--- a/net/ipv6/xfrm6_tunnel.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipv6/xfrm6_tunnel.c
@@ -89,9 +89,8 @@ static struct xfrm6_tunnel_spi *__xfrm6_
 {
 	struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
 	struct xfrm6_tunnel_spi *x6spi;
-	struct hlist_node *pos;
 
-	hlist_for_each_entry_rcu(x6spi, pos,
+	hlist_for_each_entry_rcu(x6spi,
 			     &xfrm6_tn->spi_byaddr[xfrm6_tunnel_spi_hash_byaddr(saddr)],
 			     list_byaddr) {
 		if (xfrm6_addr_equal(&x6spi->addr, saddr))
@@ -120,9 +119,8 @@ static int __xfrm6_tunnel_spi_check(stru
 	struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
 	struct xfrm6_tunnel_spi *x6spi;
 	int index = xfrm6_tunnel_spi_hash_byspi(spi);
-	struct hlist_node *pos;
 
-	hlist_for_each_entry(x6spi, pos,
+	hlist_for_each_entry(x6spi,
 			     &xfrm6_tn->spi_byspi[index],
 			     list_byspi) {
 		if (x6spi->spi == spi)
@@ -203,11 +201,11 @@ static void xfrm6_tunnel_free_spi(struct
 {
 	struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
 	struct xfrm6_tunnel_spi *x6spi;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 
 	spin_lock_bh(&xfrm6_tunnel_spi_lock);
 
-	hlist_for_each_entry_safe(x6spi, pos, n,
+	hlist_for_each_entry_safe(x6spi, n,
 				  &xfrm6_tn->spi_byaddr[xfrm6_tunnel_spi_hash_byaddr(saddr)],
 				  list_byaddr)
 	{
diff -puN net/ipx/af_ipx.c~hlist-drop-the-node-parameter-from-iterators net/ipx/af_ipx.c
--- a/net/ipx/af_ipx.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipx/af_ipx.c
@@ -228,9 +228,8 @@ static struct sock *__ipxitf_find_socket
 					 __be16 port)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
-	sk_for_each(s, node, &intrfc->if_sklist)
+	sk_for_each(s, &intrfc->if_sklist)
 		if (ipx_sk(s)->port == port)
 			goto found;
 	s = NULL;
@@ -259,12 +258,11 @@ static struct sock *ipxitf_find_internal
 						__be16 port)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	ipxitf_hold(intrfc);
 	spin_lock_bh(&intrfc->if_sklist_lock);
 
-	sk_for_each(s, node, &intrfc->if_sklist) {
+	sk_for_each(s, &intrfc->if_sklist) {
 		struct ipx_sock *ipxs = ipx_sk(s);
 
 		if (ipxs->port == port &&
@@ -282,14 +280,14 @@ found:
 static void __ipxitf_down(struct ipx_interface *intrfc)
 {
 	struct sock *s;
-	struct hlist_node *node, *t;
+	struct hlist_node *t;
 
 	/* Delete all routes associated with this interface */
 	ipxrtr_del_routes(intrfc);
 
 	spin_lock_bh(&intrfc->if_sklist_lock);
 	/* error sockets */
-	sk_for_each_safe(s, node, t, &intrfc->if_sklist) {
+	sk_for_each_safe(s, t, &intrfc->if_sklist) {
 		struct ipx_sock *ipxs = ipx_sk(s);
 
 		s->sk_err = ENOLINK;
@@ -385,12 +383,11 @@ static int ipxitf_demux_socket(struct ip
 	int is_broadcast = !memcmp(ipx->ipx_dest.node, ipx_broadcast_node,
 				   IPX_NODE_LEN);
 	struct sock *s;
-	struct hlist_node *node;
 	int rc;
 
 	spin_lock_bh(&intrfc->if_sklist_lock);
 
-	sk_for_each(s, node, &intrfc->if_sklist) {
+	sk_for_each(s, &intrfc->if_sklist) {
 		struct ipx_sock *ipxs = ipx_sk(s);
 
 		if (ipxs->port == ipx->ipx_dest.sock &&
@@ -446,12 +443,11 @@ static struct sock *ncp_connection_hack(
 		connection = (((int) *(ncphdr + 9)) << 8) | (int) *(ncphdr + 8);
 
 	if (connection) {
-		struct hlist_node *node;
 		/* Now we have to look for a special NCP connection handling
 		 * socket. Only these sockets have ipx_ncp_conn != 0, set by
 		 * SIOCIPXNCPCONN. */
 		spin_lock_bh(&intrfc->if_sklist_lock);
-		sk_for_each(sk, node, &intrfc->if_sklist)
+		sk_for_each(sk, &intrfc->if_sklist)
 			if (ipx_sk(sk)->ipx_ncp_conn == connection) {
 				sock_hold(sk);
 				goto found;
diff -puN net/ipx/ipx_proc.c~hlist-drop-the-node-parameter-from-iterators net/ipx/ipx_proc.c
--- a/net/ipx/ipx_proc.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/ipx/ipx_proc.c
@@ -103,19 +103,18 @@ out:
 static __inline__ struct sock *ipx_get_socket_idx(loff_t pos)
 {
 	struct sock *s = NULL;
-	struct hlist_node *node;
 	struct ipx_interface *i;
 
 	list_for_each_entry(i, &ipx_interfaces, node) {
 		spin_lock_bh(&i->if_sklist_lock);
-		sk_for_each(s, node, &i->if_sklist) {
+		sk_for_each(s, &i->if_sklist) {
 			if (!pos)
 				break;
 			--pos;
 		}
 		spin_unlock_bh(&i->if_sklist_lock);
 		if (!pos) {
-			if (node)
+			if (s)
 				goto found;
 			break;
 		}
diff -puN net/iucv/af_iucv.c~hlist-drop-the-node-parameter-from-iterators net/iucv/af_iucv.c
--- a/net/iucv/af_iucv.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/iucv/af_iucv.c
@@ -156,14 +156,13 @@ static int afiucv_pm_freeze(struct devic
 {
 	struct iucv_sock *iucv;
 	struct sock *sk;
-	struct hlist_node *node;
 	int err = 0;
 
 #ifdef CONFIG_PM_DEBUG
 	printk(KERN_WARNING "afiucv_pm_freeze\n");
 #endif
 	read_lock(&iucv_sk_list.lock);
-	sk_for_each(sk, node, &iucv_sk_list.head) {
+	sk_for_each(sk, &iucv_sk_list.head) {
 		iucv = iucv_sk(sk);
 		switch (sk->sk_state) {
 		case IUCV_DISCONN:
@@ -194,13 +193,12 @@ static int afiucv_pm_freeze(struct devic
 static int afiucv_pm_restore_thaw(struct device *dev)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 
 #ifdef CONFIG_PM_DEBUG
 	printk(KERN_WARNING "afiucv_pm_restore_thaw\n");
 #endif
 	read_lock(&iucv_sk_list.lock);
-	sk_for_each(sk, node, &iucv_sk_list.head) {
+	sk_for_each(sk, &iucv_sk_list.head) {
 		switch (sk->sk_state) {
 		case IUCV_CONNECTED:
 			sk->sk_err = EPIPE;
@@ -390,9 +388,8 @@ static int afiucv_hs_send(struct iucv_me
 static struct sock *__iucv_get_sock_by_name(char *nm)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 
-	sk_for_each(sk, node, &iucv_sk_list.head)
+	sk_for_each(sk, &iucv_sk_list.head)
 		if (!memcmp(&iucv_sk(sk)->src_name, nm, 8))
 			return sk;
 
@@ -1678,7 +1675,6 @@ static int iucv_callback_connreq(struct 
 	unsigned char user_data[16];
 	unsigned char nuser_data[16];
 	unsigned char src_name[8];
-	struct hlist_node *node;
 	struct sock *sk, *nsk;
 	struct iucv_sock *iucv, *niucv;
 	int err;
@@ -1689,7 +1685,7 @@ static int iucv_callback_connreq(struct 
 	read_lock(&iucv_sk_list.lock);
 	iucv = NULL;
 	sk = NULL;
-	sk_for_each(sk, node, &iucv_sk_list.head)
+	sk_for_each(sk, &iucv_sk_list.head)
 		if (sk->sk_state == IUCV_LISTEN &&
 		    !memcmp(&iucv_sk(sk)->src_name, src_name, 8)) {
 			/*
@@ -2115,7 +2111,6 @@ static int afiucv_hs_callback_rx(struct 
 static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct packet_type *pt, struct net_device *orig_dev)
 {
-	struct hlist_node *node;
 	struct sock *sk;
 	struct iucv_sock *iucv;
 	struct af_iucv_trans_hdr *trans_hdr;
@@ -2132,7 +2127,7 @@ static int afiucv_hs_rcv(struct sk_buff 
 	iucv = NULL;
 	sk = NULL;
 	read_lock(&iucv_sk_list.lock);
-	sk_for_each(sk, node, &iucv_sk_list.head) {
+	sk_for_each(sk, &iucv_sk_list.head) {
 		if (trans_hdr->flags == AF_IUCV_FLAG_SYN) {
 			if ((!memcmp(&iucv_sk(sk)->src_name,
 				     trans_hdr->destAppName, 8)) &&
@@ -2225,10 +2220,9 @@ static void afiucv_hs_callback_txnotify(
 	struct sk_buff *list_skb;
 	struct sk_buff *nskb;
 	unsigned long flags;
-	struct hlist_node *node;
 
 	read_lock_irqsave(&iucv_sk_list.lock, flags);
-	sk_for_each(sk, node, &iucv_sk_list.head)
+	sk_for_each(sk, &iucv_sk_list.head)
 		if (sk == isk) {
 			iucv = iucv_sk(sk);
 			break;
@@ -2299,14 +2293,13 @@ static int afiucv_netdev_event(struct no
 			       unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = (struct net_device *)ptr;
-	struct hlist_node *node;
 	struct sock *sk;
 	struct iucv_sock *iucv;
 
 	switch (event) {
 	case NETDEV_REBOOT:
 	case NETDEV_GOING_DOWN:
-		sk_for_each(sk, node, &iucv_sk_list.head) {
+		sk_for_each(sk, &iucv_sk_list.head) {
 			iucv = iucv_sk(sk);
 			if ((iucv->hs_dev == event_dev) &&
 			    (sk->sk_state == IUCV_CONNECTED)) {
diff -puN net/key/af_key.c~hlist-drop-the-node-parameter-from-iterators net/key/af_key.c
--- a/net/key/af_key.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/key/af_key.c
@@ -225,7 +225,6 @@ static int pfkey_broadcast(struct sk_buf
 {
 	struct netns_pfkey *net_pfkey = net_generic(net, pfkey_net_id);
 	struct sock *sk;
-	struct hlist_node *node;
 	struct sk_buff *skb2 = NULL;
 	int err = -ESRCH;
 
@@ -236,7 +235,7 @@ static int pfkey_broadcast(struct sk_buf
 		return -ENOMEM;
 
 	rcu_read_lock();
-	sk_for_each_rcu(sk, node, &net_pfkey->table) {
+	sk_for_each_rcu(sk, &net_pfkey->table) {
 		struct pfkey_sock *pfk = pfkey_sk(sk);
 		int err2;
 
diff -puN net/l2tp/l2tp_core.c~hlist-drop-the-node-parameter-from-iterators net/l2tp/l2tp_core.c
--- a/net/l2tp/l2tp_core.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/l2tp/l2tp_core.c
@@ -221,10 +221,9 @@ static struct l2tp_session *l2tp_session
 	struct hlist_head *session_list =
 		l2tp_session_id_hash_2(pn, session_id);
 	struct l2tp_session *session;
-	struct hlist_node *walk;
 
 	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu(session, walk, session_list, global_hlist) {
+	hlist_for_each_entry_rcu(session, session_list, global_hlist) {
 		if (session->session_id == session_id) {
 			rcu_read_unlock_bh();
 			return session;
@@ -253,7 +252,6 @@ struct l2tp_session *l2tp_session_find(s
 {
 	struct hlist_head *session_list;
 	struct l2tp_session *session;
-	struct hlist_node *walk;
 
 	/* In L2TPv3, session_ids are unique over all tunnels and we
 	 * sometimes need to look them up before we know the
@@ -264,7 +262,7 @@ struct l2tp_session *l2tp_session_find(s
 
 	session_list = l2tp_session_id_hash(tunnel, session_id);
 	read_lock_bh(&tunnel->hlist_lock);
-	hlist_for_each_entry(session, walk, session_list, hlist) {
+	hlist_for_each_entry(session, session_list, hlist) {
 		if (session->session_id == session_id) {
 			read_unlock_bh(&tunnel->hlist_lock);
 			return session;
@@ -279,13 +277,12 @@ EXPORT_SYMBOL_GPL(l2tp_session_find);
 struct l2tp_session *l2tp_session_find_nth(struct l2tp_tunnel *tunnel, int nth)
 {
 	int hash;
-	struct hlist_node *walk;
 	struct l2tp_session *session;
 	int count = 0;
 
 	read_lock_bh(&tunnel->hlist_lock);
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
-		hlist_for_each_entry(session, walk, &tunnel->session_hlist[hash], hlist) {
+		hlist_for_each_entry(session, &tunnel->session_hlist[hash], hlist) {
 			if (++count > nth) {
 				read_unlock_bh(&tunnel->hlist_lock);
 				return session;
@@ -306,12 +303,11 @@ struct l2tp_session *l2tp_session_find_b
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 	int hash;
-	struct hlist_node *walk;
 	struct l2tp_session *session;
 
 	rcu_read_lock_bh();
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++) {
-		hlist_for_each_entry_rcu(session, walk, &pn->l2tp_session_hlist[hash], global_hlist) {
+		hlist_for_each_entry_rcu(session, &pn->l2tp_session_hlist[hash], global_hlist) {
 			if (!strcmp(session->ifname, ifname)) {
 				rcu_read_unlock_bh();
 				return session;
diff -puN net/l2tp/l2tp_ip.c~hlist-drop-the-node-parameter-from-iterators net/l2tp/l2tp_ip.c
--- a/net/l2tp/l2tp_ip.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/l2tp/l2tp_ip.c
@@ -49,10 +49,9 @@ static inline struct l2tp_ip_sock *l2tp_
 
 static struct sock *__l2tp_ip_bind_lookup(struct net *net, __be32 laddr, int dif, u32 tunnel_id)
 {
-	struct hlist_node *node;
 	struct sock *sk;
 
-	sk_for_each_bound(sk, node, &l2tp_ip_bind_table) {
+	sk_for_each_bound(sk, &l2tp_ip_bind_table) {
 		struct inet_sock *inet = inet_sk(sk);
 		struct l2tp_ip_sock *l2tp = l2tp_ip_sk(sk);
 
diff -puN net/l2tp/l2tp_ip6.c~hlist-drop-the-node-parameter-from-iterators net/l2tp/l2tp_ip6.c
--- a/net/l2tp/l2tp_ip6.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/l2tp/l2tp_ip6.c
@@ -60,10 +60,9 @@ static struct sock *__l2tp_ip6_bind_look
 					   struct in6_addr *laddr,
 					   int dif, u32 tunnel_id)
 {
-	struct hlist_node *node;
 	struct sock *sk;
 
-	sk_for_each_bound(sk, node, &l2tp_ip6_bind_table) {
+	sk_for_each_bound(sk, &l2tp_ip6_bind_table) {
 		struct in6_addr *addr = inet6_rcv_saddr(sk);
 		struct l2tp_ip6_sock *l2tp = l2tp_ip6_sk(sk);
 
diff -puN net/llc/llc_sap.c~hlist-drop-the-node-parameter-from-iterators net/llc/llc_sap.c
--- a/net/llc/llc_sap.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/llc/llc_sap.c
@@ -393,12 +393,11 @@ static void llc_sap_mcast(struct llc_sap
 {
 	int i = 0, count = 256 / sizeof(struct sock *);
 	struct sock *sk, *stack[count];
-	struct hlist_node *node;
 	struct llc_sock *llc;
 	struct hlist_head *dev_hb = llc_sk_dev_hash(sap, skb->dev->ifindex);
 
 	spin_lock_bh(&sap->sk_lock);
-	hlist_for_each_entry(llc, node, dev_hb, dev_hash_node) {
+	hlist_for_each_entry(llc, dev_hb, dev_hash_node) {
 
 		sk = &llc->sk;
 
diff -puN net/mac80211/mesh_pathtbl.c~hlist-drop-the-node-parameter-from-iterators net/mac80211/mesh_pathtbl.c
--- a/net/mac80211/mesh_pathtbl.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/mac80211/mesh_pathtbl.c
@@ -72,9 +72,9 @@ static inline struct mesh_table *resize_
  * it's used twice. So it is illegal to do
  *	for_each_mesh_entry(rcu_dereference(...), ...)
  */
-#define for_each_mesh_entry(tbl, p, node, i) \
+#define for_each_mesh_entry(tbl, node, i) \
 	for (i = 0; i <= tbl->hash_mask; i++) \
-		hlist_for_each_entry_rcu(node, p, &tbl->hash_buckets[i], list)
+		hlist_for_each_entry_rcu(node, &tbl->hash_buckets[i], list)
 
 
 static struct mesh_table *mesh_table_alloc(int size_order)
@@ -139,7 +139,7 @@ static void mesh_table_free(struct mesh_
 	}
 	if (free_leafs) {
 		spin_lock_bh(&tbl->gates_lock);
-		hlist_for_each_entry_safe(gate, p, q,
+		hlist_for_each_entry_safe(gate, q,
 					 tbl->known_gates, list) {
 			hlist_del(&gate->list);
 			kfree(gate);
@@ -333,12 +333,11 @@ static struct mesh_path *mpath_lookup(st
 				      struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
-	struct hlist_node *n;
 	struct hlist_head *bucket;
 	struct mpath_node *node;
 
 	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
-	hlist_for_each_entry_rcu(node, n, bucket, list) {
+	hlist_for_each_entry_rcu(node, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
 		    ether_addr_equal(dst, mpath->dst)) {
@@ -389,11 +388,10 @@ mesh_path_lookup_by_idx(struct ieee80211
 {
 	struct mesh_table *tbl = rcu_dereference(mesh_paths);
 	struct mpath_node *node;
-	struct hlist_node *p;
 	int i;
 	int j = 0;
 
-	for_each_mesh_entry(tbl, p, node, i) {
+	for_each_mesh_entry(tbl, node, i) {
 		if (sdata && node->mpath->sdata != sdata)
 			continue;
 		if (j++ == idx) {
@@ -417,13 +415,12 @@ int mesh_path_add_gate(struct mesh_path 
 {
 	struct mesh_table *tbl;
 	struct mpath_node *gate, *new_gate;
-	struct hlist_node *n;
 	int err;
 
 	rcu_read_lock();
 	tbl = rcu_dereference(mesh_paths);
 
-	hlist_for_each_entry_rcu(gate, n, tbl->known_gates, list)
+	hlist_for_each_entry_rcu(gate, tbl->known_gates, list)
 		if (gate->mpath == mpath) {
 			err = -EEXIST;
 			goto err_rcu;
@@ -460,9 +457,9 @@ err_rcu:
 static void mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
 {
 	struct mpath_node *gate;
-	struct hlist_node *p, *q;
+	struct hlist_node *q;
 
-	hlist_for_each_entry_safe(gate, p, q, tbl->known_gates, list) {
+	hlist_for_each_entry_safe(gate, q, tbl->known_gates, list) {
 		if (gate->mpath != mpath)
 			continue;
 		spin_lock_bh(&tbl->gates_lock);
@@ -504,7 +501,6 @@ int mesh_path_add(struct ieee80211_sub_i
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
 	struct hlist_head *bucket;
-	struct hlist_node *n;
 	int grow = 0;
 	int err = 0;
 	u32 hash_idx;
@@ -550,7 +546,7 @@ int mesh_path_add(struct ieee80211_sub_i
 	spin_lock(&tbl->hashwlock[hash_idx]);
 
 	err = -EEXIST;
-	hlist_for_each_entry(node, n, bucket, list) {
+	hlist_for_each_entry(node, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
 		    ether_addr_equal(dst, mpath->dst))
@@ -640,7 +636,6 @@ int mpp_path_add(struct ieee80211_sub_if
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
 	struct hlist_head *bucket;
-	struct hlist_node *n;
 	int grow = 0;
 	int err = 0;
 	u32 hash_idx;
@@ -680,7 +675,7 @@ int mpp_path_add(struct ieee80211_sub_if
 	spin_lock(&tbl->hashwlock[hash_idx]);
 
 	err = -EEXIST;
-	hlist_for_each_entry(node, n, bucket, list) {
+	hlist_for_each_entry(node, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
 		    ether_addr_equal(dst, mpath->dst))
@@ -725,14 +720,13 @@ void mesh_plink_broken(struct sta_info *
 	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
 	struct mpath_node *node;
-	struct hlist_node *p;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	int i;
 	__le16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_DEST_UNREACHABLE);
 
 	rcu_read_lock();
 	tbl = rcu_dereference(mesh_paths);
-	for_each_mesh_entry(tbl, p, node, i) {
+	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
 		if (rcu_dereference(mpath->next_hop) == sta &&
 		    mpath->flags & MESH_PATH_ACTIVE &&
@@ -792,13 +786,12 @@ void mesh_path_flush_by_nexthop(struct s
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
-	struct hlist_node *p;
 	int i;
 
 	rcu_read_lock();
 	read_lock_bh(&pathtbl_resize_lock);
 	tbl = resize_dereference_mesh_paths();
-	for_each_mesh_entry(tbl, p, node, i) {
+	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
 		if (rcu_dereference(mpath->next_hop) == sta) {
 			spin_lock(&tbl->hashwlock[i]);
@@ -815,11 +808,10 @@ static void table_flush_by_iface(struct 
 {
 	struct mesh_path *mpath;
 	struct mpath_node *node;
-	struct hlist_node *p;
 	int i;
 
 	WARN_ON(!rcu_read_lock_held());
-	for_each_mesh_entry(tbl, p, node, i) {
+	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
 		if (mpath->sdata != sdata)
 			continue;
@@ -865,7 +857,6 @@ int mesh_path_del(struct ieee80211_sub_i
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_head *bucket;
-	struct hlist_node *n;
 	int hash_idx;
 	int err = 0;
 
@@ -875,7 +866,7 @@ int mesh_path_del(struct ieee80211_sub_i
 	bucket = &tbl->hash_buckets[hash_idx];
 
 	spin_lock(&tbl->hashwlock[hash_idx]);
-	hlist_for_each_entry(node, n, bucket, list) {
+	hlist_for_each_entry(node, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
 		    ether_addr_equal(addr, mpath->dst)) {
@@ -920,7 +911,6 @@ void mesh_path_tx_pending(struct mesh_pa
 int mesh_path_send_to_gates(struct mesh_path *mpath)
 {
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
-	struct hlist_node *n;
 	struct mesh_table *tbl;
 	struct mesh_path *from_mpath = mpath;
 	struct mpath_node *gate = NULL;
@@ -935,7 +925,7 @@ int mesh_path_send_to_gates(struct mesh_
 	if (!known_gates)
 		return -EHOSTUNREACH;
 
-	hlist_for_each_entry_rcu(gate, n, known_gates, list) {
+	hlist_for_each_entry_rcu(gate, known_gates, list) {
 		if (gate->mpath->sdata != sdata)
 			continue;
 
@@ -951,7 +941,7 @@ int mesh_path_send_to_gates(struct mesh_
 		}
 	}
 
-	hlist_for_each_entry_rcu(gate, n, known_gates, list)
+	hlist_for_each_entry_rcu(gate, known_gates, list)
 		if (gate->mpath->sdata == sdata) {
 			mpath_dbg(sdata, "Sending to %pM\n", gate->mpath->dst);
 			mesh_path_tx_pending(gate->mpath);
@@ -1096,12 +1086,11 @@ void mesh_path_expire(struct ieee80211_s
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
-	struct hlist_node *p;
 	int i;
 
 	rcu_read_lock();
 	tbl = rcu_dereference(mesh_paths);
-	for_each_mesh_entry(tbl, p, node, i) {
+	for_each_mesh_entry(tbl, node, i) {
 		if (node->mpath->sdata != sdata)
 			continue;
 		mpath = node->mpath;
diff -puN net/netfilter/ipvs/ip_vs_conn.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/ipvs/ip_vs_conn.c
--- a/net/netfilter/ipvs/ip_vs_conn.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/ipvs/ip_vs_conn.c
@@ -259,13 +259,12 @@ __ip_vs_conn_in_get(const struct ip_vs_c
 {
 	unsigned int hash;
 	struct ip_vs_conn *cp;
-	struct hlist_node *n;
 
 	hash = ip_vs_conn_hashkey_param(p, false);
 
 	ct_read_lock(hash);
 
-	hlist_for_each_entry(cp, n, &ip_vs_conn_tab[hash], c_list) {
+	hlist_for_each_entry(cp, &ip_vs_conn_tab[hash], c_list) {
 		if (cp->af == p->af &&
 		    p->cport == cp->cport && p->vport == cp->vport &&
 		    ip_vs_addr_equal(p->af, p->caddr, &cp->caddr) &&
@@ -344,13 +343,12 @@ struct ip_vs_conn *ip_vs_ct_in_get(const
 {
 	unsigned int hash;
 	struct ip_vs_conn *cp;
-	struct hlist_node *n;
 
 	hash = ip_vs_conn_hashkey_param(p, false);
 
 	ct_read_lock(hash);
 
-	hlist_for_each_entry(cp, n, &ip_vs_conn_tab[hash], c_list) {
+	hlist_for_each_entry(cp, &ip_vs_conn_tab[hash], c_list) {
 		if (!ip_vs_conn_net_eq(cp, p->net))
 			continue;
 		if (p->pe_data && p->pe->ct_match) {
@@ -394,7 +392,6 @@ struct ip_vs_conn *ip_vs_conn_out_get(co
 {
 	unsigned int hash;
 	struct ip_vs_conn *cp, *ret=NULL;
-	struct hlist_node *n;
 
 	/*
 	 *	Check for "full" addressed entries
@@ -403,7 +400,7 @@ struct ip_vs_conn *ip_vs_conn_out_get(co
 
 	ct_read_lock(hash);
 
-	hlist_for_each_entry(cp, n, &ip_vs_conn_tab[hash], c_list) {
+	hlist_for_each_entry(cp, &ip_vs_conn_tab[hash], c_list) {
 		if (cp->af == p->af &&
 		    p->vport == cp->cport && p->cport == cp->dport &&
 		    ip_vs_addr_equal(p->af, p->vaddr, &cp->caddr) &&
@@ -953,11 +950,10 @@ static void *ip_vs_conn_array(struct seq
 	int idx;
 	struct ip_vs_conn *cp;
 	struct ip_vs_iter_state *iter = seq->private;
-	struct hlist_node *n;
 
 	for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
 		ct_read_lock_bh(idx);
-		hlist_for_each_entry(cp, n, &ip_vs_conn_tab[idx], c_list) {
+		hlist_for_each_entry(cp, &ip_vs_conn_tab[idx], c_list) {
 			if (pos-- == 0) {
 				iter->l = &ip_vs_conn_tab[idx];
 				return cp;
@@ -981,7 +977,6 @@ static void *ip_vs_conn_seq_next(struct 
 {
 	struct ip_vs_conn *cp = v;
 	struct ip_vs_iter_state *iter = seq->private;
-	struct hlist_node *e;
 	struct hlist_head *l = iter->l;
 	int idx;
 
@@ -990,15 +985,15 @@ static void *ip_vs_conn_seq_next(struct 
 		return ip_vs_conn_array(seq, 0);
 
 	/* more on same hash chain? */
-	if ((e = cp->c_list.next))
-		return hlist_entry(e, struct ip_vs_conn, c_list);
+	if (cp->c_list.next)
+		return hlist_entry(cp->c_list.next, struct ip_vs_conn, c_list);
 
 	idx = l - ip_vs_conn_tab;
 	ct_read_unlock_bh(idx);
 
 	while (++idx < ip_vs_conn_tab_size) {
 		ct_read_lock_bh(idx);
-		hlist_for_each_entry(cp, e, &ip_vs_conn_tab[idx], c_list) {
+		hlist_for_each_entry(cp, &ip_vs_conn_tab[idx], c_list) {
 			iter->l = &ip_vs_conn_tab[idx];
 			return cp;
 		}
@@ -1200,14 +1195,13 @@ void ip_vs_random_dropentry(struct net *
 	 */
 	for (idx = 0; idx < (ip_vs_conn_tab_size>>5); idx++) {
 		unsigned int hash = net_random() & ip_vs_conn_tab_mask;
-		struct hlist_node *n;
 
 		/*
 		 *  Lock is actually needed in this loop.
 		 */
 		ct_write_lock_bh(hash);
 
-		hlist_for_each_entry(cp, n, &ip_vs_conn_tab[hash], c_list) {
+		hlist_for_each_entry(cp, &ip_vs_conn_tab[hash], c_list) {
 			if (cp->flags & IP_VS_CONN_F_TEMPLATE)
 				/* connection template */
 				continue;
@@ -1255,14 +1249,12 @@ static void ip_vs_conn_flush(struct net 
 
 flush_again:
 	for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
-		struct hlist_node *n;
-
 		/*
 		 *  Lock is actually needed in this loop.
 		 */
 		ct_write_lock_bh(idx);
 
-		hlist_for_each_entry(cp, n, &ip_vs_conn_tab[idx], c_list) {
+		hlist_for_each_entry(cp, &ip_vs_conn_tab[idx], c_list) {
 			if (!ip_vs_conn_net_eq(cp, net))
 				continue;
 			IP_VS_DBG(4, "del connection\n");
diff -puN net/netfilter/nf_conntrack_expect.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/nf_conntrack_expect.c
--- a/net/netfilter/nf_conntrack_expect.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/nf_conntrack_expect.c
@@ -90,14 +90,13 @@ __nf_ct_expect_find(struct net *net, u16
 		    const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
-	struct hlist_node *n;
 	unsigned int h;
 
 	if (!net->ct.expect_count)
 		return NULL;
 
 	h = nf_ct_expect_dst_hash(tuple);
-	hlist_for_each_entry_rcu(i, n, &net->ct.expect_hash[h], hnode) {
+	hlist_for_each_entry_rcu(i, &net->ct.expect_hash[h], hnode) {
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
 		    nf_ct_zone(i->master) == zone)
 			return i;
@@ -130,14 +129,13 @@ nf_ct_find_expectation(struct net *net, 
 		       const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i, *exp = NULL;
-	struct hlist_node *n;
 	unsigned int h;
 
 	if (!net->ct.expect_count)
 		return NULL;
 
 	h = nf_ct_expect_dst_hash(tuple);
-	hlist_for_each_entry(i, n, &net->ct.expect_hash[h], hnode) {
+	hlist_for_each_entry(i, &net->ct.expect_hash[h], hnode) {
 		if (!(i->flags & NF_CT_EXPECT_INACTIVE) &&
 		    nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
 		    nf_ct_zone(i->master) == zone) {
@@ -172,13 +170,13 @@ void nf_ct_remove_expectations(struct nf
 {
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_expect *exp;
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 
 	/* Optimization: most connection never expect any others. */
 	if (!help)
 		return;
 
-	hlist_for_each_entry_safe(exp, n, next, &help->expectations, lnode) {
+	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
 		if (del_timer(&exp->timeout)) {
 			nf_ct_unlink_expect(exp);
 			nf_ct_expect_put(exp);
@@ -348,9 +346,8 @@ static void evict_oldest_expect(struct n
 {
 	struct nf_conn_help *master_help = nfct_help(master);
 	struct nf_conntrack_expect *exp, *last = NULL;
-	struct hlist_node *n;
 
-	hlist_for_each_entry(exp, n, &master_help->expectations, lnode) {
+	hlist_for_each_entry(exp, &master_help->expectations, lnode) {
 		if (exp->class == new->class)
 			last = exp;
 	}
@@ -369,7 +366,7 @@ static inline int __nf_ct_expect_check(s
 	struct nf_conn_help *master_help = nfct_help(master);
 	struct nf_conntrack_helper *helper;
 	struct net *net = nf_ct_exp_net(expect);
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	unsigned int h;
 	int ret = 1;
 
@@ -378,7 +375,7 @@ static inline int __nf_ct_expect_check(s
 		goto out;
 	}
 	h = nf_ct_expect_dst_hash(&expect->tuple);
-	hlist_for_each_entry_safe(i, n, next, &net->ct.expect_hash[h], hnode) {
+	hlist_for_each_entry_safe(i, next, &net->ct.expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
 			if (del_timer(&i->timeout)) {
 				nf_ct_unlink_expect(i);
diff -puN net/netfilter/nf_conntrack_helper.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/nf_conntrack_helper.c
--- a/net/netfilter/nf_conntrack_helper.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/nf_conntrack_helper.c
@@ -116,14 +116,13 @@ __nf_ct_helper_find(const struct nf_conn
 {
 	struct nf_conntrack_helper *helper;
 	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
-	struct hlist_node *n;
 	unsigned int h;
 
 	if (!nf_ct_helper_count)
 		return NULL;
 
 	h = helper_hash(tuple);
-	hlist_for_each_entry_rcu(helper, n, &nf_ct_helper_hash[h], hnode) {
+	hlist_for_each_entry_rcu(helper, &nf_ct_helper_hash[h], hnode) {
 		if (nf_ct_tuple_src_mask_cmp(tuple, &helper->tuple, &mask))
 			return helper;
 	}
@@ -134,11 +133,10 @@ struct nf_conntrack_helper *
 __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 {
 	struct nf_conntrack_helper *h;
-	struct hlist_node *n;
 	unsigned int i;
 
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_rcu(h, n, &nf_ct_helper_hash[i], hnode) {
+		hlist_for_each_entry_rcu(h, &nf_ct_helper_hash[i], hnode) {
 			if (!strcmp(h->name, name) &&
 			    h->tuple.src.l3num == l3num &&
 			    h->tuple.dst.protonum == protonum)
@@ -357,7 +355,6 @@ int nf_conntrack_helper_register(struct 
 {
 	int ret = 0;
 	struct nf_conntrack_helper *cur;
-	struct hlist_node *n;
 	unsigned int h = helper_hash(&me->tuple);
 
 	BUG_ON(me->expect_policy == NULL);
@@ -365,7 +362,7 @@ int nf_conntrack_helper_register(struct 
 	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
 
 	mutex_lock(&nf_ct_helper_mutex);
-	hlist_for_each_entry(cur, n, &nf_ct_helper_hash[h], hnode) {
+	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
 		if (strncmp(cur->name, me->name, NF_CT_HELPER_NAME_LEN) == 0 &&
 		    cur->tuple.src.l3num == me->tuple.src.l3num &&
 		    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
@@ -386,13 +383,13 @@ static void __nf_conntrack_helper_unregi
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
-	const struct hlist_node *n, *next;
+	const struct hlist_node *next;
 	const struct hlist_nulls_node *nn;
 	unsigned int i;
 
 	/* Get rid of expectations */
 	for (i = 0; i < nf_ct_expect_hsize; i++) {
-		hlist_for_each_entry_safe(exp, n, next,
+		hlist_for_each_entry_safe(exp, next,
 					  &net->ct.expect_hash[i], hnode) {
 			struct nf_conn_help *help = nfct_help(exp->master);
 			if ((rcu_dereference_protected(
diff -puN net/netfilter/nf_conntrack_netlink.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/nf_conntrack_netlink.c
--- a/net/netfilter/nf_conntrack_netlink.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/nf_conntrack_netlink.c
@@ -2370,14 +2370,13 @@ ctnetlink_exp_dump_table(struct sk_buff 
 	struct net *net = sock_net(skb->sk);
 	struct nf_conntrack_expect *exp, *last;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	struct hlist_node *n;
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	rcu_read_lock();
 	last = (struct nf_conntrack_expect *)cb->args[1];
 	for (; cb->args[0] < nf_ct_expect_hsize; cb->args[0]++) {
 restart:
-		hlist_for_each_entry(exp, n, &net->ct.expect_hash[cb->args[0]],
+		hlist_for_each_entry(exp, &net->ct.expect_hash[cb->args[0]],
 				     hnode) {
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
@@ -2510,7 +2509,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	u_int8_t u3 = nfmsg->nfgen_family;
 	unsigned int i;
 	u16 zone;
@@ -2557,7 +2556,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 		/* delete all expectations for this helper */
 		spin_lock_bh(&nf_conntrack_lock);
 		for (i = 0; i < nf_ct_expect_hsize; i++) {
-			hlist_for_each_entry_safe(exp, n, next,
+			hlist_for_each_entry_safe(exp, next,
 						  &net->ct.expect_hash[i],
 						  hnode) {
 				m_help = nfct_help(exp->master);
@@ -2575,7 +2574,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 		/* This basically means we have to flush everything*/
 		spin_lock_bh(&nf_conntrack_lock);
 		for (i = 0; i < nf_ct_expect_hsize; i++) {
-			hlist_for_each_entry_safe(exp, n, next,
+			hlist_for_each_entry_safe(exp, next,
 						  &net->ct.expect_hash[i],
 						  hnode) {
 				if (del_timer(&exp->timeout)) {
diff -puN net/netfilter/nf_conntrack_sip.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/nf_conntrack_sip.c
--- a/net/netfilter/nf_conntrack_sip.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/nf_conntrack_sip.c
@@ -855,11 +855,11 @@ static int refresh_signalling_expectatio
 {
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_expect *exp;
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	int found = 0;
 
 	spin_lock_bh(&nf_conntrack_lock);
-	hlist_for_each_entry_safe(exp, n, next, &help->expectations, lnode) {
+	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
 		if (exp->class != SIP_EXPECT_SIGNALLING ||
 		    !nf_inet_addr_cmp(&exp->tuple.dst.u3, addr) ||
 		    exp->tuple.dst.protonum != proto ||
@@ -881,10 +881,10 @@ static void flush_expectations(struct nf
 {
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_expect *exp;
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 
 	spin_lock_bh(&nf_conntrack_lock);
-	hlist_for_each_entry_safe(exp, n, next, &help->expectations, lnode) {
+	hlist_for_each_entry_safe(exp, next, &help->expectations, lnode) {
 		if ((exp->class != SIP_EXPECT_SIGNALLING) ^ media)
 			continue;
 		if (!del_timer(&exp->timeout))
diff -puN net/netfilter/nf_nat_core.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/nf_nat_core.c
--- a/net/netfilter/nf_nat_core.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/nf_nat_core.c
@@ -191,9 +191,8 @@ find_appropriate_src(struct net *net, u1
 	unsigned int h = hash_by_src(net, zone, tuple);
 	const struct nf_conn_nat *nat;
 	const struct nf_conn *ct;
-	const struct hlist_node *n;
 
-	hlist_for_each_entry_rcu(nat, n, &net->ct.nat_bysource[h], bysource) {
+	hlist_for_each_entry_rcu(nat, &net->ct.nat_bysource[h], bysource) {
 		ct = nat->ct;
 		if (same_src(ct, tuple) && nf_ct_zone(ct) == zone) {
 			/* Copy source part from reply tuple. */
diff -puN net/netfilter/nfnetlink_cthelper.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/nfnetlink_cthelper.c
--- a/net/netfilter/nfnetlink_cthelper.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/nfnetlink_cthelper.c
@@ -282,7 +282,6 @@ nfnl_cthelper_new(struct sock *nfnl, str
 	const char *helper_name;
 	struct nf_conntrack_helper *cur, *helper = NULL;
 	struct nf_conntrack_tuple tuple;
-	struct hlist_node *n;
 	int ret = 0, i;
 
 	if (!tb[NFCTH_NAME] || !tb[NFCTH_TUPLE])
@@ -296,7 +295,7 @@ nfnl_cthelper_new(struct sock *nfnl, str
 
 	rcu_read_lock();
 	for (i = 0; i < nf_ct_helper_hsize && !helper; i++) {
-		hlist_for_each_entry_rcu(cur, n, &nf_ct_helper_hash[i], hnode) {
+		hlist_for_each_entry_rcu(cur, &nf_ct_helper_hash[i], hnode) {
 
 			/* skip non-userspace conntrack helpers. */
 			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
@@ -452,13 +451,12 @@ static int
 nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_conntrack_helper *cur, *last;
-	struct hlist_node *n;
 
 	rcu_read_lock();
 	last = (struct nf_conntrack_helper *)cb->args[1];
 	for (; cb->args[0] < nf_ct_helper_hsize; cb->args[0]++) {
 restart:
-		hlist_for_each_entry_rcu(cur, n,
+		hlist_for_each_entry_rcu(cur,
 				&nf_ct_helper_hash[cb->args[0]], hnode) {
 
 			/* skip non-userspace conntrack helpers. */
@@ -495,7 +493,6 @@ nfnl_cthelper_get(struct sock *nfnl, str
 {
 	int ret = -ENOENT, i;
 	struct nf_conntrack_helper *cur;
-	struct hlist_node *n;
 	struct sk_buff *skb2;
 	char *helper_name = NULL;
 	struct nf_conntrack_tuple tuple;
@@ -520,7 +517,7 @@ nfnl_cthelper_get(struct sock *nfnl, str
 	}
 
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_rcu(cur, n, &nf_ct_helper_hash[i], hnode) {
+		hlist_for_each_entry_rcu(cur, &nf_ct_helper_hash[i], hnode) {
 
 			/* skip non-userspace conntrack helpers. */
 			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
@@ -568,7 +565,7 @@ nfnl_cthelper_del(struct sock *nfnl, str
 {
 	char *helper_name = NULL;
 	struct nf_conntrack_helper *cur;
-	struct hlist_node *n, *tmp;
+	struct hlist_node *tmp;
 	struct nf_conntrack_tuple tuple;
 	bool tuple_set = false, found = false;
 	int i, j = 0, ret;
@@ -585,7 +582,7 @@ nfnl_cthelper_del(struct sock *nfnl, str
 	}
 
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_safe(cur, n, tmp, &nf_ct_helper_hash[i],
+		hlist_for_each_entry_safe(cur, tmp, &nf_ct_helper_hash[i],
 								hnode) {
 			/* skip non-userspace conntrack helpers. */
 			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
@@ -654,13 +651,13 @@ err_out:
 static void __exit nfnl_cthelper_exit(void)
 {
 	struct nf_conntrack_helper *cur;
-	struct hlist_node *n, *tmp;
+	struct hlist_node *tmp;
 	int i;
 
 	nfnetlink_subsys_unregister(&nfnl_cthelper_subsys);
 
 	for (i=0; i<nf_ct_helper_hsize; i++) {
-		hlist_for_each_entry_safe(cur, n, tmp, &nf_ct_helper_hash[i],
+		hlist_for_each_entry_safe(cur, tmp, &nf_ct_helper_hash[i],
 									hnode) {
 			/* skip non-userspace conntrack helpers. */
 			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
diff -puN net/netfilter/nfnetlink_log.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/nfnetlink_log.c
--- a/net/netfilter/nfnetlink_log.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/nfnetlink_log.c
@@ -87,11 +87,10 @@ static struct nfulnl_instance *
 __instance_lookup(u_int16_t group_num)
 {
 	struct hlist_head *head;
-	struct hlist_node *pos;
 	struct nfulnl_instance *inst;
 
 	head = &instance_table[instance_hashfn(group_num)];
-	hlist_for_each_entry_rcu(inst, pos, head, hlist) {
+	hlist_for_each_entry_rcu(inst, head, hlist) {
 		if (inst->group_num == group_num)
 			return inst;
 	}
@@ -717,11 +716,11 @@ nfulnl_rcv_nl_event(struct notifier_bloc
 		/* destroy all instances for this portid */
 		spin_lock_bh(&instances_lock);
 		for  (i = 0; i < INSTANCE_BUCKETS; i++) {
-			struct hlist_node *tmp, *t2;
+			struct hlist_node *t2;
 			struct nfulnl_instance *inst;
 			struct hlist_head *head = &instance_table[i];
 
-			hlist_for_each_entry_safe(inst, tmp, t2, head, hlist) {
+			hlist_for_each_entry_safe(inst, t2, head, hlist) {
 				if ((net_eq(n->net, &init_net)) &&
 				    (n->portid == inst->peer_portid))
 					__instance_destroy(inst);
diff -puN net/netfilter/nfnetlink_queue_core.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/nfnetlink_queue_core.c
--- a/net/netfilter/nfnetlink_queue_core.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/nfnetlink_queue_core.c
@@ -80,11 +80,10 @@ static struct nfqnl_instance *
 instance_lookup(u_int16_t queue_num)
 {
 	struct hlist_head *head;
-	struct hlist_node *pos;
 	struct nfqnl_instance *inst;
 
 	head = &instance_table[instance_hashfn(queue_num)];
-	hlist_for_each_entry_rcu(inst, pos, head, hlist) {
+	hlist_for_each_entry_rcu(inst, head, hlist) {
 		if (inst->queue_num == queue_num)
 			return inst;
 	}
@@ -583,11 +582,10 @@ nfqnl_dev_drop(int ifindex)
 	rcu_read_lock();
 
 	for (i = 0; i < INSTANCE_BUCKETS; i++) {
-		struct hlist_node *tmp;
 		struct nfqnl_instance *inst;
 		struct hlist_head *head = &instance_table[i];
 
-		hlist_for_each_entry_rcu(inst, tmp, head, hlist)
+		hlist_for_each_entry_rcu(inst, head, hlist)
 			nfqnl_flush(inst, dev_cmp, ifindex);
 	}
 
@@ -627,11 +625,11 @@ nfqnl_rcv_nl_event(struct notifier_block
 		/* destroy all instances for this portid */
 		spin_lock(&instances_lock);
 		for (i = 0; i < INSTANCE_BUCKETS; i++) {
-			struct hlist_node *tmp, *t2;
+			struct hlist_node *t2;
 			struct nfqnl_instance *inst;
 			struct hlist_head *head = &instance_table[i];
 
-			hlist_for_each_entry_safe(inst, tmp, t2, head, hlist) {
+			hlist_for_each_entry_safe(inst, t2, head, hlist) {
 				if ((n->net == &init_net) &&
 				    (n->portid == inst->peer_portid))
 					__instance_destroy(inst);
diff -puN net/netfilter/xt_RATEEST.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/xt_RATEEST.c
--- a/net/netfilter/xt_RATEEST.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/xt_RATEEST.c
@@ -43,12 +43,11 @@ static void xt_rateest_hash_insert(struc
 struct xt_rateest *xt_rateest_lookup(const char *name)
 {
 	struct xt_rateest *est;
-	struct hlist_node *n;
 	unsigned int h;
 
 	h = xt_rateest_hash(name);
 	mutex_lock(&xt_rateest_mutex);
-	hlist_for_each_entry(est, n, &rateest_hash[h], list) {
+	hlist_for_each_entry(est, &rateest_hash[h], list) {
 		if (strcmp(est->name, name) == 0) {
 			est->refcnt++;
 			mutex_unlock(&xt_rateest_mutex);
diff -puN net/netfilter/xt_connlimit.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/xt_connlimit.c
--- a/net/netfilter/xt_connlimit.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/xt_connlimit.c
@@ -101,7 +101,7 @@ static int count_them(struct net *net,
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct xt_connlimit_conn *conn;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 	struct nf_conn *found_ct;
 	struct hlist_head *hash;
 	bool addit = true;
@@ -115,7 +115,7 @@ static int count_them(struct net *net,
 	rcu_read_lock();
 
 	/* check the saved connections */
-	hlist_for_each_entry_safe(conn, pos, n, hash, node) {
+	hlist_for_each_entry_safe(conn, n, hash, node) {
 		found    = nf_conntrack_find_get(net, NF_CT_DEFAULT_ZONE,
 						 &conn->tuple);
 		found_ct = NULL;
@@ -258,14 +258,14 @@ static void connlimit_mt_destroy(const s
 {
 	const struct xt_connlimit_info *info = par->matchinfo;
 	struct xt_connlimit_conn *conn;
-	struct hlist_node *pos, *n;
+	struct hlist_node *n;
 	struct hlist_head *hash = info->data->iphash;
 	unsigned int i;
 
 	nf_ct_l3proto_module_put(par->family);
 
 	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i) {
-		hlist_for_each_entry_safe(conn, pos, n, &hash[i], node) {
+		hlist_for_each_entry_safe(conn, n, &hash[i], node) {
 			hlist_del(&conn->node);
 			kfree(conn);
 		}
diff -puN net/netfilter/xt_hashlimit.c~hlist-drop-the-node-parameter-from-iterators net/netfilter/xt_hashlimit.c
--- a/net/netfilter/xt_hashlimit.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netfilter/xt_hashlimit.c
@@ -141,11 +141,10 @@ dsthash_find(const struct xt_hashlimit_h
 	     const struct dsthash_dst *dst)
 {
 	struct dsthash_ent *ent;
-	struct hlist_node *pos;
 	u_int32_t hash = hash_dst(ht, dst);
 
 	if (!hlist_empty(&ht->hash[hash])) {
-		hlist_for_each_entry_rcu(ent, pos, &ht->hash[hash], node)
+		hlist_for_each_entry_rcu(ent, &ht->hash[hash], node)
 			if (dst_cmp(ent, dst)) {
 				spin_lock(&ent->lock);
 				return ent;
@@ -297,8 +296,8 @@ static void htable_selective_cleanup(str
 	spin_lock_bh(&ht->lock);
 	for (i = 0; i < ht->cfg.size; i++) {
 		struct dsthash_ent *dh;
-		struct hlist_node *pos, *n;
-		hlist_for_each_entry_safe(dh, pos, n, &ht->hash[i], node) {
+		struct hlist_node *n;
+		hlist_for_each_entry_safe(dh, n, &ht->hash[i], node) {
 			if ((*select)(ht, dh))
 				dsthash_free(ht, dh);
 		}
@@ -343,9 +342,8 @@ static struct xt_hashlimit_htable *htabl
 {
 	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
 	struct xt_hashlimit_htable *hinfo;
-	struct hlist_node *pos;
 
-	hlist_for_each_entry(hinfo, pos, &hashlimit_net->htables, node) {
+	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
 		if (!strcmp(name, hinfo->pde->name) &&
 		    hinfo->family == family) {
 			hinfo->use++;
@@ -821,10 +819,9 @@ static int dl_seq_show(struct seq_file *
 	struct xt_hashlimit_htable *htable = s->private;
 	unsigned int *bucket = (unsigned int *)v;
 	struct dsthash_ent *ent;
-	struct hlist_node *pos;
 
 	if (!hlist_empty(&htable->hash[*bucket])) {
-		hlist_for_each_entry(ent, pos, &htable->hash[*bucket], node)
+		hlist_for_each_entry(ent, &htable->hash[*bucket], node)
 			if (dl_seq_real_show(ent, htable->family, s))
 				return -1;
 	}
@@ -877,7 +874,6 @@ static int __net_init hashlimit_proc_net
 static void __net_exit hashlimit_proc_net_exit(struct net *net)
 {
 	struct xt_hashlimit_htable *hinfo;
-	struct hlist_node *pos;
 	struct proc_dir_entry *pde;
 	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
 
@@ -890,7 +886,7 @@ static void __net_exit hashlimit_proc_ne
 	if (pde == NULL)
 		pde = hashlimit_net->ip6t_hashlimit;
 
-	hlist_for_each_entry(hinfo, pos, &hashlimit_net->htables, node)
+	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node)
 		remove_proc_entry(hinfo->pde->name, pde);
 
 	hashlimit_net->ipt_hashlimit = NULL;
diff -puN net/netlink/af_netlink.c~hlist-drop-the-node-parameter-from-iterators net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netlink/af_netlink.c
@@ -248,11 +248,10 @@ static struct sock *netlink_lookup(struc
 	struct nl_portid_hash *hash = &nl_table[protocol].hash;
 	struct hlist_head *head;
 	struct sock *sk;
-	struct hlist_node *node;
 
 	read_lock(&nl_table_lock);
 	head = nl_portid_hashfn(hash, portid);
-	sk_for_each(sk, node, head) {
+	sk_for_each(sk, head) {
 		if (net_eq(sock_net(sk), net) && (nlk_sk(sk)->portid == portid)) {
 			sock_hold(sk);
 			goto found;
@@ -312,9 +311,9 @@ static int nl_portid_hash_rehash(struct 
 
 	for (i = 0; i <= omask; i++) {
 		struct sock *sk;
-		struct hlist_node *node, *tmp;
+		struct hlist_node *tmp;
 
-		sk_for_each_safe(sk, node, tmp, &otable[i])
+		sk_for_each_safe(sk, tmp, &otable[i])
 			__sk_add_node(sk, nl_portid_hashfn(hash, nlk_sk(sk)->portid));
 	}
 
@@ -344,7 +343,6 @@ static void
 netlink_update_listeners(struct sock *sk)
 {
 	struct netlink_table *tbl = &nl_table[sk->sk_protocol];
-	struct hlist_node *node;
 	unsigned long mask;
 	unsigned int i;
 	struct listeners *listeners;
@@ -355,7 +353,7 @@ netlink_update_listeners(struct sock *sk
 
 	for (i = 0; i < NLGRPLONGS(tbl->groups); i++) {
 		mask = 0;
-		sk_for_each_bound(sk, node, &tbl->mc_list) {
+		sk_for_each_bound(sk, &tbl->mc_list) {
 			if (i < NLGRPLONGS(nlk_sk(sk)->ngroups))
 				mask |= nlk_sk(sk)->groups[i];
 		}
@@ -371,18 +369,17 @@ static int netlink_insert(struct sock *s
 	struct hlist_head *head;
 	int err = -EADDRINUSE;
 	struct sock *osk;
-	struct hlist_node *node;
 	int len;
 
 	netlink_table_grab();
 	head = nl_portid_hashfn(hash, portid);
 	len = 0;
-	sk_for_each(osk, node, head) {
+	sk_for_each(osk, head) {
 		if (net_eq(sock_net(osk), net) && (nlk_sk(osk)->portid == portid))
 			break;
 		len++;
 	}
-	if (node)
+	if (osk)
 		goto err;
 
 	err = -EBUSY;
@@ -575,7 +572,6 @@ static int netlink_autobind(struct socke
 	struct nl_portid_hash *hash = &nl_table[sk->sk_protocol].hash;
 	struct hlist_head *head;
 	struct sock *osk;
-	struct hlist_node *node;
 	s32 portid = task_tgid_vnr(current);
 	int err;
 	static s32 rover = -4097;
@@ -584,7 +580,7 @@ retry:
 	cond_resched();
 	netlink_table_grab();
 	head = nl_portid_hashfn(hash, portid);
-	sk_for_each(osk, node, head) {
+	sk_for_each(osk, head) {
 		if (!net_eq(sock_net(osk), net))
 			continue;
 		if (nlk_sk(osk)->portid == portid) {
@@ -1101,7 +1097,6 @@ int netlink_broadcast_filtered(struct so
 {
 	struct net *net = sock_net(ssk);
 	struct netlink_broadcast_data info;
-	struct hlist_node *node;
 	struct sock *sk;
 
 	skb = netlink_trim(skb, allocation);
@@ -1124,7 +1119,7 @@ int netlink_broadcast_filtered(struct so
 
 	netlink_lock_table();
 
-	sk_for_each_bound(sk, node, &nl_table[ssk->sk_protocol].mc_list)
+	sk_for_each_bound(sk, &nl_table[ssk->sk_protocol].mc_list)
 		do_one_broadcast(sk, &info);
 
 	consume_skb(skb);
@@ -1200,7 +1195,6 @@ out:
 int netlink_set_err(struct sock *ssk, u32 portid, u32 group, int code)
 {
 	struct netlink_set_err_data info;
-	struct hlist_node *node;
 	struct sock *sk;
 	int ret = 0;
 
@@ -1212,7 +1206,7 @@ int netlink_set_err(struct sock *ssk, u3
 
 	read_lock(&nl_table_lock);
 
-	sk_for_each_bound(sk, node, &nl_table[ssk->sk_protocol].mc_list)
+	sk_for_each_bound(sk, &nl_table[ssk->sk_protocol].mc_list)
 		ret += do_one_set_err(sk, &info);
 
 	read_unlock(&nl_table_lock);
@@ -1676,10 +1670,9 @@ int netlink_change_ngroups(struct sock *
 void __netlink_clear_multicast_users(struct sock *ksk, unsigned int group)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 	struct netlink_table *tbl = &nl_table[ksk->sk_protocol];
 
-	sk_for_each_bound(sk, node, &tbl->mc_list)
+	sk_for_each_bound(sk, &tbl->mc_list)
 		netlink_update_socket_mc(nlk_sk(sk), group, 0);
 }
 
@@ -1974,14 +1967,13 @@ static struct sock *netlink_seq_socket_i
 	struct nl_seq_iter *iter = seq->private;
 	int i, j;
 	struct sock *s;
-	struct hlist_node *node;
 	loff_t off = 0;
 
 	for (i = 0; i < MAX_LINKS; i++) {
 		struct nl_portid_hash *hash = &nl_table[i].hash;
 
 		for (j = 0; j <= hash->mask; j++) {
-			sk_for_each(s, node, &hash->table[j]) {
+			sk_for_each(s, &hash->table[j]) {
 				if (sock_net(s) != seq_file_net(seq))
 					continue;
 				if (off == pos) {
diff -puN net/netrom/af_netrom.c~hlist-drop-the-node-parameter-from-iterators net/netrom/af_netrom.c
--- a/net/netrom/af_netrom.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netrom/af_netrom.c
@@ -104,10 +104,9 @@ static void nr_remove_socket(struct sock
 static void nr_kill_by_device(struct net_device *dev)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&nr_list_lock);
-	sk_for_each(s, node, &nr_list)
+	sk_for_each(s, &nr_list)
 		if (nr_sk(s)->device == dev)
 			nr_disconnect(s, ENETUNREACH);
 	spin_unlock_bh(&nr_list_lock);
@@ -149,10 +148,9 @@ static void nr_insert_socket(struct sock
 static struct sock *nr_find_listener(ax25_address *addr)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&nr_list_lock);
-	sk_for_each(s, node, &nr_list)
+	sk_for_each(s, &nr_list)
 		if (!ax25cmp(&nr_sk(s)->source_addr, addr) &&
 		    s->sk_state == TCP_LISTEN) {
 			bh_lock_sock(s);
@@ -170,10 +168,9 @@ found:
 static struct sock *nr_find_socket(unsigned char index, unsigned char id)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&nr_list_lock);
-	sk_for_each(s, node, &nr_list) {
+	sk_for_each(s, &nr_list) {
 		struct nr_sock *nr = nr_sk(s);
 
 		if (nr->my_index == index && nr->my_id == id) {
@@ -194,10 +191,9 @@ static struct sock *nr_find_peer(unsigne
 	ax25_address *dest)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&nr_list_lock);
-	sk_for_each(s, node, &nr_list) {
+	sk_for_each(s, &nr_list) {
 		struct nr_sock *nr = nr_sk(s);
 
 		if (nr->your_index == index && nr->your_id == id &&
diff -puN net/netrom/nr_route.c~hlist-drop-the-node-parameter-from-iterators net/netrom/nr_route.c
--- a/net/netrom/nr_route.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/netrom/nr_route.c
@@ -49,10 +49,9 @@ static struct nr_node *nr_node_get(ax25_
 {
 	struct nr_node *found = NULL;
 	struct nr_node *nr_node;
-	struct hlist_node *node;
 
 	spin_lock_bh(&nr_node_list_lock);
-	nr_node_for_each(nr_node, node, &nr_node_list)
+	nr_node_for_each(nr_node, &nr_node_list)
 		if (ax25cmp(callsign, &nr_node->callsign) == 0) {
 			nr_node_hold(nr_node);
 			found = nr_node;
@@ -67,10 +66,9 @@ static struct nr_neigh *nr_neigh_get_dev
 {
 	struct nr_neigh *found = NULL;
 	struct nr_neigh *nr_neigh;
-	struct hlist_node *node;
 
 	spin_lock_bh(&nr_neigh_list_lock);
-	nr_neigh_for_each(nr_neigh, node, &nr_neigh_list)
+	nr_neigh_for_each(nr_neigh, &nr_neigh_list)
 		if (ax25cmp(callsign, &nr_neigh->callsign) == 0 &&
 		    nr_neigh->dev == dev) {
 			nr_neigh_hold(nr_neigh);
@@ -114,10 +112,9 @@ static int __must_check nr_add_node(ax25
 	 */
 	if (nr_neigh != NULL && nr_neigh->failed != 0 && quality == 0) {
 		struct nr_node *nr_nodet;
-		struct hlist_node *node;
 
 		spin_lock_bh(&nr_node_list_lock);
-		nr_node_for_each(nr_nodet, node, &nr_node_list) {
+		nr_node_for_each(nr_nodet, &nr_node_list) {
 			nr_node_lock(nr_nodet);
 			for (i = 0; i < nr_nodet->count; i++)
 				if (nr_nodet->routes[i].neighbour == nr_neigh)
@@ -485,11 +482,11 @@ static int nr_dec_obs(void)
 {
 	struct nr_neigh *nr_neigh;
 	struct nr_node  *s;
-	struct hlist_node *node, *nodet;
+	struct hlist_node *nodet;
 	int i;
 
 	spin_lock_bh(&nr_node_list_lock);
-	nr_node_for_each_safe(s, node, nodet, &nr_node_list) {
+	nr_node_for_each_safe(s, nodet, &nr_node_list) {
 		nr_node_lock(s);
 		for (i = 0; i < s->count; i++) {
 			switch (s->routes[i].obs_count) {
@@ -540,15 +537,15 @@ static int nr_dec_obs(void)
 void nr_rt_device_down(struct net_device *dev)
 {
 	struct nr_neigh *s;
-	struct hlist_node *node, *nodet, *node2, *node2t;
+	struct hlist_node *nodet, *node2t;
 	struct nr_node  *t;
 	int i;
 
 	spin_lock_bh(&nr_neigh_list_lock);
-	nr_neigh_for_each_safe(s, node, nodet, &nr_neigh_list) {
+	nr_neigh_for_each_safe(s, nodet, &nr_neigh_list) {
 		if (s->dev == dev) {
 			spin_lock_bh(&nr_node_list_lock);
-			nr_node_for_each_safe(t, node2, node2t, &nr_node_list) {
+			nr_node_for_each_safe(t, node2t, &nr_node_list) {
 				nr_node_lock(t);
 				for (i = 0; i < t->count; i++) {
 					if (t->routes[i].neighbour == s) {
@@ -737,11 +734,10 @@ int nr_rt_ioctl(unsigned int cmd, void _
 void nr_link_failed(ax25_cb *ax25, int reason)
 {
 	struct nr_neigh *s, *nr_neigh = NULL;
-	struct hlist_node *node;
 	struct nr_node  *nr_node = NULL;
 
 	spin_lock_bh(&nr_neigh_list_lock);
-	nr_neigh_for_each(s, node, &nr_neigh_list) {
+	nr_neigh_for_each(s, &nr_neigh_list) {
 		if (s->ax25 == ax25) {
 			nr_neigh_hold(s);
 			nr_neigh = s;
@@ -761,7 +757,7 @@ void nr_link_failed(ax25_cb *ax25, int r
 		return;
 	}
 	spin_lock_bh(&nr_node_list_lock);
-	nr_node_for_each(nr_node, node, &nr_node_list) {
+	nr_node_for_each(nr_node, &nr_node_list) {
 		nr_node_lock(nr_node);
 		if (nr_node->which < nr_node->count &&
 		    nr_node->routes[nr_node->which].neighbour == nr_neigh)
@@ -1013,16 +1009,16 @@ void __exit nr_rt_free(void)
 {
 	struct nr_neigh *s = NULL;
 	struct nr_node  *t = NULL;
-	struct hlist_node *node, *nodet;
+	struct hlist_node *nodet;
 
 	spin_lock_bh(&nr_neigh_list_lock);
 	spin_lock_bh(&nr_node_list_lock);
-	nr_node_for_each_safe(t, node, nodet, &nr_node_list) {
+	nr_node_for_each_safe(t, nodet, &nr_node_list) {
 		nr_node_lock(t);
 		nr_remove_node_locked(t);
 		nr_node_unlock(t);
 	}
-	nr_neigh_for_each_safe(s, node, nodet, &nr_neigh_list) {
+	nr_neigh_for_each_safe(s, nodet, &nr_neigh_list) {
 		while(s->count) {
 			s->count--;
 			nr_neigh_put(s);
diff -puN net/nfc/llcp/llcp.c~hlist-drop-the-node-parameter-from-iterators net/nfc/llcp/llcp.c
--- a/net/nfc/llcp/llcp.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/nfc/llcp/llcp.c
@@ -71,14 +71,14 @@ static void nfc_llcp_socket_purge(struct
 static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool listen)
 {
 	struct sock *sk;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *tmp;
 	struct nfc_llcp_sock *llcp_sock;
 
 	skb_queue_purge(&local->tx_queue);
 
 	write_lock(&local->sockets.lock);
 
-	sk_for_each_safe(sk, node, tmp, &local->sockets.head) {
+	sk_for_each_safe(sk, tmp, &local->sockets.head) {
 		llcp_sock = nfc_llcp_sock(sk);
 
 		bh_lock_sock(sk);
@@ -171,7 +171,6 @@ static struct nfc_llcp_sock *nfc_llcp_so
 					       u8 ssap, u8 dsap)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 	struct nfc_llcp_sock *llcp_sock, *tmp_sock;
 
 	pr_debug("ssap dsap %d %d\n", ssap, dsap);
@@ -183,7 +182,7 @@ static struct nfc_llcp_sock *nfc_llcp_so
 
 	llcp_sock = NULL;
 
-	sk_for_each(sk, node, &local->sockets.head) {
+	sk_for_each(sk, &local->sockets.head) {
 		tmp_sock = nfc_llcp_sock(sk);
 
 		if (tmp_sock->ssap == ssap && tmp_sock->dsap == dsap) {
@@ -272,7 +271,6 @@ struct nfc_llcp_sock *nfc_llcp_sock_from
 					    u8 *sn, size_t sn_len)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 	struct nfc_llcp_sock *llcp_sock, *tmp_sock;
 
 	pr_debug("sn %zd %p\n", sn_len, sn);
@@ -284,7 +282,7 @@ struct nfc_llcp_sock *nfc_llcp_sock_from
 
 	llcp_sock = NULL;
 
-	sk_for_each(sk, node, &local->sockets.head) {
+	sk_for_each(sk, &local->sockets.head) {
 		tmp_sock = nfc_llcp_sock(sk);
 
 		pr_debug("llcp sock %p\n", tmp_sock);
@@ -601,14 +599,13 @@ static void nfc_llcp_set_nrns(struct nfc
 void nfc_llcp_send_to_raw_sock(struct nfc_llcp_local *local,
 			       struct sk_buff *skb, u8 direction)
 {
-	struct hlist_node *node;
 	struct sk_buff *skb_copy = NULL, *nskb;
 	struct sock *sk;
 	u8 *data;
 
 	read_lock(&local->raw_sockets.lock);
 
-	sk_for_each(sk, node, &local->raw_sockets.head) {
+	sk_for_each(sk, &local->raw_sockets.head) {
 		if (sk->sk_state != LLCP_BOUND)
 			continue;
 
@@ -697,11 +694,10 @@ static struct nfc_llcp_sock *nfc_llcp_co
 {
 	struct sock *sk;
 	struct nfc_llcp_sock *llcp_sock;
-	struct hlist_node *node;
 
 	read_lock(&local->connecting_sockets.lock);
 
-	sk_for_each(sk, node, &local->connecting_sockets.head) {
+	sk_for_each(sk, &local->connecting_sockets.head) {
 		llcp_sock = nfc_llcp_sock(sk);
 
 		if (llcp_sock->ssap == ssap) {
diff -puN net/openvswitch/datapath.c~hlist-drop-the-node-parameter-from-iterators net/openvswitch/datapath.c
--- a/net/openvswitch/datapath.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/openvswitch/datapath.c
@@ -158,11 +158,10 @@ static struct hlist_head *vport_hash_buc
 struct vport *ovs_lookup_vport(const struct datapath *dp, u16 port_no)
 {
 	struct vport *vport;
-	struct hlist_node *n;
 	struct hlist_head *head;
 
 	head = vport_hash_bucket(dp, port_no);
-	hlist_for_each_entry_rcu(vport, n, head, dp_hash_node) {
+	hlist_for_each_entry_rcu(vport, head, dp_hash_node) {
 		if (vport->port_no == port_no)
 			return vport;
 	}
@@ -1386,9 +1385,9 @@ static void __dp_destroy(struct datapath
 
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
 		struct vport *vport;
-		struct hlist_node *node, *n;
+		struct hlist_node *n;
 
-		hlist_for_each_entry_safe(vport, node, n, &dp->ports[i], dp_hash_node)
+		hlist_for_each_entry_safe(vport, n, &dp->ports[i], dp_hash_node)
 			if (vport->port_no != OVSP_LOCAL)
 				ovs_dp_detach_port(vport);
 	}
@@ -1825,10 +1824,9 @@ static int ovs_vport_cmd_dump(struct sk_
 	rcu_read_lock();
 	for (i = bucket; i < DP_VPORT_HASH_BUCKETS; i++) {
 		struct vport *vport;
-		struct hlist_node *n;
 
 		j = 0;
-		hlist_for_each_entry_rcu(vport, n, &dp->ports[i], dp_hash_node) {
+		hlist_for_each_entry_rcu(vport, &dp->ports[i], dp_hash_node) {
 			if (j >= skip &&
 			    ovs_vport_cmd_fill_info(vport, skb,
 						    NETLINK_CB(cb->skb).portid,
diff -puN net/openvswitch/flow.c~hlist-drop-the-node-parameter-from-iterators net/openvswitch/flow.c
--- a/net/openvswitch/flow.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/openvswitch/flow.c
@@ -299,10 +299,10 @@ void ovs_flow_tbl_destroy(struct flow_ta
 	for (i = 0; i < table->n_buckets; i++) {
 		struct sw_flow *flow;
 		struct hlist_head *head = flex_array_get(table->buckets, i);
-		struct hlist_node *node, *n;
+		struct hlist_node *n;
 		int ver = table->node_ver;
 
-		hlist_for_each_entry_safe(flow, node, n, head, hash_node[ver]) {
+		hlist_for_each_entry_safe(flow, n, head, hash_node[ver]) {
 			hlist_del_rcu(&flow->hash_node[ver]);
 			ovs_flow_free(flow);
 		}
@@ -332,7 +332,6 @@ struct sw_flow *ovs_flow_tbl_next(struct
 {
 	struct sw_flow *flow;
 	struct hlist_head *head;
-	struct hlist_node *n;
 	int ver;
 	int i;
 
@@ -340,7 +339,7 @@ struct sw_flow *ovs_flow_tbl_next(struct
 	while (*bucket < table->n_buckets) {
 		i = 0;
 		head = flex_array_get(table->buckets, *bucket);
-		hlist_for_each_entry_rcu(flow, n, head, hash_node[ver]) {
+		hlist_for_each_entry_rcu(flow, head, hash_node[ver]) {
 			if (i < *last) {
 				i++;
 				continue;
@@ -367,11 +366,10 @@ static void flow_table_copy_flows(struct
 	for (i = 0; i < old->n_buckets; i++) {
 		struct sw_flow *flow;
 		struct hlist_head *head;
-		struct hlist_node *n;
 
 		head = flex_array_get(old->buckets, i);
 
-		hlist_for_each_entry(flow, n, head, hash_node[old_ver])
+		hlist_for_each_entry(flow, head, hash_node[old_ver])
 			ovs_flow_tbl_insert(new, flow);
 	}
 	old->keep_flows = true;
@@ -766,14 +764,13 @@ struct sw_flow *ovs_flow_tbl_lookup(stru
 				struct sw_flow_key *key, int key_len)
 {
 	struct sw_flow *flow;
-	struct hlist_node *n;
 	struct hlist_head *head;
 	u32 hash;
 
 	hash = ovs_flow_hash(key, key_len);
 
 	head = find_bucket(table, hash);
-	hlist_for_each_entry_rcu(flow, n, head, hash_node[table->node_ver]) {
+	hlist_for_each_entry_rcu(flow, head, hash_node[table->node_ver]) {
 
 		if (flow->hash == hash &&
 		    !memcmp(&flow->key, key, key_len)) {
diff -puN net/openvswitch/vport.c~hlist-drop-the-node-parameter-from-iterators net/openvswitch/vport.c
--- a/net/openvswitch/vport.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/openvswitch/vport.c
@@ -86,9 +86,8 @@ struct vport *ovs_vport_locate(struct ne
 {
 	struct hlist_head *bucket = hash_bucket(net, name);
 	struct vport *vport;
-	struct hlist_node *node;
 
-	hlist_for_each_entry_rcu(vport, node, bucket, hash_node)
+	hlist_for_each_entry_rcu(vport, bucket, hash_node)
 		if (!strcmp(name, vport->ops->get_name(vport)) &&
 		    net_eq(ovs_dp_get_net(vport->dp), net))
 			return vport;
diff -puN net/packet/af_packet.c~hlist-drop-the-node-parameter-from-iterators net/packet/af_packet.c
--- a/net/packet/af_packet.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/packet/af_packet.c
@@ -3263,12 +3263,11 @@ static int packet_getsockopt(struct sock
 static int packet_notifier(struct notifier_block *this, unsigned long msg, void *data)
 {
 	struct sock *sk;
-	struct hlist_node *node;
 	struct net_device *dev = data;
 	struct net *net = dev_net(dev);
 
 	rcu_read_lock();
-	sk_for_each_rcu(sk, node, &net->packet.sklist) {
+	sk_for_each_rcu(sk, &net->packet.sklist) {
 		struct packet_sock *po = pkt_sk(sk);
 
 		switch (msg) {
diff -puN net/packet/diag.c~hlist-drop-the-node-parameter-from-iterators net/packet/diag.c
--- a/net/packet/diag.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/packet/diag.c
@@ -172,13 +172,12 @@ static int packet_diag_dump(struct sk_bu
 	struct packet_diag_req *req;
 	struct net *net;
 	struct sock *sk;
-	struct hlist_node *node;
 
 	net = sock_net(skb->sk);
 	req = nlmsg_data(cb->nlh);
 
 	mutex_lock(&net->packet.sklist_lock);
-	sk_for_each(sk, node, &net->packet.sklist) {
+	sk_for_each(sk, &net->packet.sklist) {
 		if (!net_eq(sock_net(sk), net))
 			continue;
 		if (num < s_num)
diff -puN net/phonet/pep.c~hlist-drop-the-node-parameter-from-iterators net/phonet/pep.c
--- a/net/phonet/pep.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/phonet/pep.c
@@ -640,11 +640,10 @@ static struct sock *pep_find_pipe(const 
 					const struct sockaddr_pn *dst,
 					u8 pipe_handle)
 {
-	struct hlist_node *node;
 	struct sock *sknode;
 	u16 dobj = pn_sockaddr_get_object(dst);
 
-	sk_for_each(sknode, node, hlist) {
+	sk_for_each(sknode, hlist) {
 		struct pep_sock *pnnode = pep_sk(sknode);
 
 		/* Ports match, but addresses might not: */
diff -puN net/phonet/socket.c~hlist-drop-the-node-parameter-from-iterators net/phonet/socket.c
--- a/net/phonet/socket.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/phonet/socket.c
@@ -76,7 +76,6 @@ static struct hlist_head *pn_hash_list(u
  */
 struct sock *pn_find_sock_by_sa(struct net *net, const struct sockaddr_pn *spn)
 {
-	struct hlist_node *node;
 	struct sock *sknode;
 	struct sock *rval = NULL;
 	u16 obj = pn_sockaddr_get_object(spn);
@@ -84,7 +83,7 @@ struct sock *pn_find_sock_by_sa(struct n
 	struct hlist_head *hlist = pn_hash_list(obj);
 
 	rcu_read_lock();
-	sk_for_each_rcu(sknode, node, hlist) {
+	sk_for_each_rcu(sknode, hlist) {
 		struct pn_sock *pn = pn_sk(sknode);
 		BUG_ON(!pn->sobject); /* unbound socket */
 
@@ -120,10 +119,9 @@ void pn_deliver_sock_broadcast(struct ne
 
 	rcu_read_lock();
 	for (h = 0; h < PN_HASHSIZE; h++) {
-		struct hlist_node *node;
 		struct sock *sknode;
 
-		sk_for_each(sknode, node, hlist) {
+		sk_for_each(sknode, hlist) {
 			struct sk_buff *clone;
 
 			if (!net_eq(sock_net(sknode), net))
@@ -543,12 +541,11 @@ static struct sock *pn_sock_get_idx(stru
 {
 	struct net *net = seq_file_net(seq);
 	struct hlist_head *hlist = pnsocks.hlist;
-	struct hlist_node *node;
 	struct sock *sknode;
 	unsigned int h;
 
 	for (h = 0; h < PN_HASHSIZE; h++) {
-		sk_for_each_rcu(sknode, node, hlist) {
+		sk_for_each_rcu(sknode, hlist) {
 			if (!net_eq(net, sock_net(sknode)))
 				continue;
 			if (!pos)
diff -puN net/rds/bind.c~hlist-drop-the-node-parameter-from-iterators net/rds/bind.c
--- a/net/rds/bind.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/rds/bind.c
@@ -52,13 +52,12 @@ static struct rds_sock *rds_bind_lookup(
 					struct rds_sock *insert)
 {
 	struct rds_sock *rs;
-	struct hlist_node *node;
 	struct hlist_head *head = hash_to_bucket(addr, port);
 	u64 cmp;
 	u64 needle = ((u64)be32_to_cpu(addr) << 32) | be16_to_cpu(port);
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(rs, node, head, rs_bound_node) {
+	hlist_for_each_entry_rcu(rs, head, rs_bound_node) {
 		cmp = ((u64)be32_to_cpu(rs->rs_bound_addr) << 32) |
 		      be16_to_cpu(rs->rs_bound_port);
 
diff -puN net/rds/connection.c~hlist-drop-the-node-parameter-from-iterators net/rds/connection.c
--- a/net/rds/connection.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/rds/connection.c
@@ -69,9 +69,8 @@ static struct rds_connection *rds_conn_l
 					      struct rds_transport *trans)
 {
 	struct rds_connection *conn, *ret = NULL;
-	struct hlist_node *pos;
 
-	hlist_for_each_entry_rcu(conn, pos, head, c_hash_node) {
+	hlist_for_each_entry_rcu(conn, head, c_hash_node) {
 		if (conn->c_faddr == faddr && conn->c_laddr == laddr &&
 				conn->c_trans == trans) {
 			ret = conn;
@@ -376,7 +375,6 @@ static void rds_conn_message_info(struct
 				  int want_send)
 {
 	struct hlist_head *head;
-	struct hlist_node *pos;
 	struct list_head *list;
 	struct rds_connection *conn;
 	struct rds_message *rm;
@@ -390,7 +388,7 @@ static void rds_conn_message_info(struct
 
 	for (i = 0, head = rds_conn_hash; i < ARRAY_SIZE(rds_conn_hash);
 	     i++, head++) {
-		hlist_for_each_entry_rcu(conn, pos, head, c_hash_node) {
+		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
 			if (want_send)
 				list = &conn->c_send_queue;
 			else
@@ -439,7 +437,6 @@ void rds_for_each_conn_info(struct socke
 {
 	uint64_t buffer[(item_len + 7) / 8];
 	struct hlist_head *head;
-	struct hlist_node *pos;
 	struct rds_connection *conn;
 	size_t i;
 
@@ -450,7 +447,7 @@ void rds_for_each_conn_info(struct socke
 
 	for (i = 0, head = rds_conn_hash; i < ARRAY_SIZE(rds_conn_hash);
 	     i++, head++) {
-		hlist_for_each_entry_rcu(conn, pos, head, c_hash_node) {
+		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
 
 			/* XXX no c_lock usage.. */
 			if (!visitor(conn, buffer))
diff -puN net/rose/af_rose.c~hlist-drop-the-node-parameter-from-iterators net/rose/af_rose.c
--- a/net/rose/af_rose.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/rose/af_rose.c
@@ -165,10 +165,9 @@ static void rose_remove_socket(struct so
 void rose_kill_by_neigh(struct rose_neigh *neigh)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&rose_list_lock);
-	sk_for_each(s, node, &rose_list) {
+	sk_for_each(s, &rose_list) {
 		struct rose_sock *rose = rose_sk(s);
 
 		if (rose->neighbour == neigh) {
@@ -186,10 +185,9 @@ void rose_kill_by_neigh(struct rose_neig
 static void rose_kill_by_device(struct net_device *dev)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&rose_list_lock);
-	sk_for_each(s, node, &rose_list) {
+	sk_for_each(s, &rose_list) {
 		struct rose_sock *rose = rose_sk(s);
 
 		if (rose->device == dev) {
@@ -246,10 +244,9 @@ static void rose_insert_socket(struct so
 static struct sock *rose_find_listener(rose_address *addr, ax25_address *call)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&rose_list_lock);
-	sk_for_each(s, node, &rose_list) {
+	sk_for_each(s, &rose_list) {
 		struct rose_sock *rose = rose_sk(s);
 
 		if (!rosecmp(&rose->source_addr, addr) &&
@@ -258,7 +255,7 @@ static struct sock *rose_find_listener(r
 			goto found;
 	}
 
-	sk_for_each(s, node, &rose_list) {
+	sk_for_each(s, &rose_list) {
 		struct rose_sock *rose = rose_sk(s);
 
 		if (!rosecmp(&rose->source_addr, addr) &&
@@ -278,10 +275,9 @@ found:
 struct sock *rose_find_socket(unsigned int lci, struct rose_neigh *neigh)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock_bh(&rose_list_lock);
-	sk_for_each(s, node, &rose_list) {
+	sk_for_each(s, &rose_list) {
 		struct rose_sock *rose = rose_sk(s);
 
 		if (rose->lci == lci && rose->neighbour == neigh)
diff -puN net/sched/sch_api.c~hlist-drop-the-node-parameter-from-iterators net/sched/sch_api.c
--- a/net/sched/sch_api.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sched/sch_api.c
@@ -545,7 +545,7 @@ static void qdisc_class_hash_free(struct
 void qdisc_class_hash_grow(struct Qdisc *sch, struct Qdisc_class_hash *clhash)
 {
 	struct Qdisc_class_common *cl;
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	struct hlist_head *nhash, *ohash;
 	unsigned int nsize, nmask, osize;
 	unsigned int i, h;
@@ -564,7 +564,7 @@ void qdisc_class_hash_grow(struct Qdisc 
 
 	sch_tree_lock(sch);
 	for (i = 0; i < osize; i++) {
-		hlist_for_each_entry_safe(cl, n, next, &ohash[i], hnode) {
+		hlist_for_each_entry_safe(cl, next, &ohash[i], hnode) {
 			h = qdisc_class_hash(cl->classid, nmask);
 			hlist_add_head(&cl->hnode, &nhash[h]);
 		}
diff -puN net/sched/sch_cbq.c~hlist-drop-the-node-parameter-from-iterators net/sched/sch_cbq.c
--- a/net/sched/sch_cbq.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sched/sch_cbq.c
@@ -1041,14 +1041,13 @@ static void cbq_adjust_levels(struct cbq
 static void cbq_normalize_quanta(struct cbq_sched_data *q, int prio)
 {
 	struct cbq_class *cl;
-	struct hlist_node *n;
 	unsigned int h;
 
 	if (q->quanta[prio] == 0)
 		return;
 
 	for (h = 0; h < q->clhash.hashsize; h++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[h], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[h], common.hnode) {
 			/* BUGGGG... Beware! This expression suffer of
 			 * arithmetic overflows!
 			 */
@@ -1087,10 +1086,9 @@ static void cbq_sync_defmap(struct cbq_c
 			continue;
 
 		for (h = 0; h < q->clhash.hashsize; h++) {
-			struct hlist_node *n;
 			struct cbq_class *c;
 
-			hlist_for_each_entry(c, n, &q->clhash.hash[h],
+			hlist_for_each_entry(c, &q->clhash.hash[h],
 					     common.hnode) {
 				if (c->split == split && c->level < level &&
 				    c->defmap & (1<<i)) {
@@ -1210,7 +1208,6 @@ cbq_reset(struct Qdisc *sch)
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
 	struct cbq_class *cl;
-	struct hlist_node *n;
 	int prio;
 	unsigned int h;
 
@@ -1228,7 +1225,7 @@ cbq_reset(struct Qdisc *sch)
 		q->active[prio] = NULL;
 
 	for (h = 0; h < q->clhash.hashsize; h++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[h], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[h], common.hnode) {
 			qdisc_reset(cl->q);
 
 			cl->next_alive = NULL;
@@ -1697,7 +1694,7 @@ static void cbq_destroy_class(struct Qdi
 static void cbq_destroy(struct Qdisc *sch)
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	struct cbq_class *cl;
 	unsigned int h;
 
@@ -1710,11 +1707,11 @@ static void cbq_destroy(struct Qdisc *sc
 	 * be bound to classes which have been destroyed already. --TGR '04
 	 */
 	for (h = 0; h < q->clhash.hashsize; h++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[h], common.hnode)
+		hlist_for_each_entry(cl, &q->clhash.hash[h], common.hnode)
 			tcf_destroy_chain(&cl->filter_list);
 	}
 	for (h = 0; h < q->clhash.hashsize; h++) {
-		hlist_for_each_entry_safe(cl, n, next, &q->clhash.hash[h],
+		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[h],
 					  common.hnode)
 			cbq_destroy_class(sch, cl);
 	}
@@ -2013,14 +2010,13 @@ static void cbq_walk(struct Qdisc *sch, 
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
 	struct cbq_class *cl;
-	struct hlist_node *n;
 	unsigned int h;
 
 	if (arg->stop)
 		return;
 
 	for (h = 0; h < q->clhash.hashsize; h++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[h], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[h], common.hnode) {
 			if (arg->count < arg->skip) {
 				arg->count++;
 				continue;
diff -puN net/sched/sch_drr.c~hlist-drop-the-node-parameter-from-iterators net/sched/sch_drr.c
--- a/net/sched/sch_drr.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sched/sch_drr.c
@@ -293,14 +293,13 @@ static void drr_walk(struct Qdisc *sch, 
 {
 	struct drr_sched *q = qdisc_priv(sch);
 	struct drr_class *cl;
-	struct hlist_node *n;
 	unsigned int i;
 
 	if (arg->stop)
 		return;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (arg->count < arg->skip) {
 				arg->count++;
 				continue;
@@ -451,11 +450,10 @@ static void drr_reset_qdisc(struct Qdisc
 {
 	struct drr_sched *q = qdisc_priv(sch);
 	struct drr_class *cl;
-	struct hlist_node *n;
 	unsigned int i;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (cl->qdisc->q.qlen)
 				list_del(&cl->alist);
 			qdisc_reset(cl->qdisc);
@@ -468,13 +466,13 @@ static void drr_destroy_qdisc(struct Qdi
 {
 	struct drr_sched *q = qdisc_priv(sch);
 	struct drr_class *cl;
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	unsigned int i;
 
 	tcf_destroy_chain(&q->filter_list);
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry_safe(cl, n, next, &q->clhash.hash[i],
+		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
 					  common.hnode)
 			drr_destroy_class(sch, cl);
 	}
diff -puN net/sched/sch_hfsc.c~hlist-drop-the-node-parameter-from-iterators net/sched/sch_hfsc.c
--- a/net/sched/sch_hfsc.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sched/sch_hfsc.c
@@ -1389,7 +1389,6 @@ static void
 hfsc_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 {
 	struct hfsc_sched *q = qdisc_priv(sch);
-	struct hlist_node *n;
 	struct hfsc_class *cl;
 	unsigned int i;
 
@@ -1397,7 +1396,7 @@ hfsc_walk(struct Qdisc *sch, struct qdis
 		return;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i],
+		hlist_for_each_entry(cl, &q->clhash.hash[i],
 				     cl_common.hnode) {
 			if (arg->count < arg->skip) {
 				arg->count++;
@@ -1523,11 +1522,10 @@ hfsc_reset_qdisc(struct Qdisc *sch)
 {
 	struct hfsc_sched *q = qdisc_priv(sch);
 	struct hfsc_class *cl;
-	struct hlist_node *n;
 	unsigned int i;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], cl_common.hnode)
+		hlist_for_each_entry(cl, &q->clhash.hash[i], cl_common.hnode)
 			hfsc_reset_class(cl);
 	}
 	q->eligible = RB_ROOT;
@@ -1540,16 +1538,16 @@ static void
 hfsc_destroy_qdisc(struct Qdisc *sch)
 {
 	struct hfsc_sched *q = qdisc_priv(sch);
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	struct hfsc_class *cl;
 	unsigned int i;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], cl_common.hnode)
+		hlist_for_each_entry(cl, &q->clhash.hash[i], cl_common.hnode)
 			tcf_destroy_chain(&cl->filter_list);
 	}
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry_safe(cl, n, next, &q->clhash.hash[i],
+		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
 					  cl_common.hnode)
 			hfsc_destroy_class(sch, cl);
 	}
@@ -1564,12 +1562,11 @@ hfsc_dump_qdisc(struct Qdisc *sch, struc
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tc_hfsc_qopt qopt;
 	struct hfsc_class *cl;
-	struct hlist_node *n;
 	unsigned int i;
 
 	sch->qstats.backlog = 0;
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], cl_common.hnode)
+		hlist_for_each_entry(cl, &q->clhash.hash[i], cl_common.hnode)
 			sch->qstats.backlog += cl->qdisc->qstats.backlog;
 	}
 
diff -puN net/sched/sch_htb.c~hlist-drop-the-node-parameter-from-iterators net/sched/sch_htb.c
--- a/net/sched/sch_htb.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sched/sch_htb.c
@@ -949,11 +949,10 @@ static void htb_reset(struct Qdisc *sch)
 {
 	struct htb_sched *q = qdisc_priv(sch);
 	struct htb_class *cl;
-	struct hlist_node *n;
 	unsigned int i;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (cl->level)
 				memset(&cl->un.inner, 0, sizeof(cl->un.inner));
 			else {
@@ -1218,7 +1217,7 @@ static void htb_destroy_class(struct Qdi
 static void htb_destroy(struct Qdisc *sch)
 {
 	struct htb_sched *q = qdisc_priv(sch);
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	struct htb_class *cl;
 	unsigned int i;
 
@@ -1232,11 +1231,11 @@ static void htb_destroy(struct Qdisc *sc
 	tcf_destroy_chain(&q->filter_list);
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], common.hnode)
+		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode)
 			tcf_destroy_chain(&cl->filter_list);
 	}
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry_safe(cl, n, next, &q->clhash.hash[i],
+		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
 					  common.hnode)
 			htb_destroy_class(sch, cl);
 	}
@@ -1516,14 +1515,13 @@ static void htb_walk(struct Qdisc *sch, 
 {
 	struct htb_sched *q = qdisc_priv(sch);
 	struct htb_class *cl;
-	struct hlist_node *n;
 	unsigned int i;
 
 	if (arg->stop)
 		return;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (arg->count < arg->skip) {
 				arg->count++;
 				continue;
diff -puN net/sched/sch_qfq.c~hlist-drop-the-node-parameter-from-iterators net/sched/sch_qfq.c
--- a/net/sched/sch_qfq.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sched/sch_qfq.c
@@ -276,9 +276,8 @@ static struct qfq_aggregate *qfq_find_ag
 					  u32 lmax, u32 weight)
 {
 	struct qfq_aggregate *agg;
-	struct hlist_node *n;
 
-	hlist_for_each_entry(agg, n, &q->nonfull_aggs, nonfull_next)
+	hlist_for_each_entry(agg, &q->nonfull_aggs, nonfull_next)
 		if (agg->lmax == lmax && agg->class_weight == weight)
 			return agg;
 
@@ -670,14 +669,13 @@ static void qfq_walk(struct Qdisc *sch, 
 {
 	struct qfq_sched *q = qdisc_priv(sch);
 	struct qfq_class *cl;
-	struct hlist_node *n;
 	unsigned int i;
 
 	if (arg->stop)
 		return;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (arg->count < arg->skip) {
 				arg->count++;
 				continue;
@@ -1376,11 +1374,10 @@ static unsigned int qfq_drop_from_slot(s
 				       struct hlist_head *slot)
 {
 	struct qfq_aggregate *agg;
-	struct hlist_node *n;
 	struct qfq_class *cl;
 	unsigned int len;
 
-	hlist_for_each_entry(agg, n, slot, next) {
+	hlist_for_each_entry(agg, slot, next) {
 		list_for_each_entry(cl, &agg->active, alist) {
 
 			if (!cl->qdisc->ops->drop)
@@ -1459,11 +1456,10 @@ static void qfq_reset_qdisc(struct Qdisc
 {
 	struct qfq_sched *q = qdisc_priv(sch);
 	struct qfq_class *cl;
-	struct hlist_node *n;
 	unsigned int i;
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, n, &q->clhash.hash[i], common.hnode) {
+		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (cl->qdisc->q.qlen > 0)
 				qfq_deactivate_class(q, cl);
 
@@ -1477,13 +1473,13 @@ static void qfq_destroy_qdisc(struct Qdi
 {
 	struct qfq_sched *q = qdisc_priv(sch);
 	struct qfq_class *cl;
-	struct hlist_node *n, *next;
+	struct hlist_node *next;
 	unsigned int i;
 
 	tcf_destroy_chain(&q->filter_list);
 
 	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry_safe(cl, n, next, &q->clhash.hash[i],
+		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
 					  common.hnode) {
 			qfq_destroy_class(sch, cl);
 		}
diff -puN net/sctp/endpointola.c~hlist-drop-the-node-parameter-from-iterators net/sctp/endpointola.c
--- a/net/sctp/endpointola.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sctp/endpointola.c
@@ -332,7 +332,6 @@ static struct sctp_association *__sctp_e
 	struct sctp_transport *t = NULL;
 	struct sctp_hashbucket *head;
 	struct sctp_ep_common *epb;
-	struct hlist_node *node;
 	int hash;
 	int rport;
 
@@ -350,7 +349,7 @@ static struct sctp_association *__sctp_e
 				 rport);
 	head = &sctp_assoc_hashtable[hash];
 	read_lock(&head->lock);
-	sctp_for_each_hentry(epb, node, &head->chain) {
+	sctp_for_each_hentry(epb, &head->chain) {
 		tmp = sctp_assoc(epb);
 		if (tmp->ep != ep || rport != tmp->peer.port)
 			continue;
diff -puN net/sctp/input.c~hlist-drop-the-node-parameter-from-iterators net/sctp/input.c
--- a/net/sctp/input.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sctp/input.c
@@ -784,13 +784,12 @@ static struct sctp_endpoint *__sctp_rcv_
 	struct sctp_hashbucket *head;
 	struct sctp_ep_common *epb;
 	struct sctp_endpoint *ep;
-	struct hlist_node *node;
 	int hash;
 
 	hash = sctp_ep_hashfn(net, ntohs(laddr->v4.sin_port));
 	head = &sctp_ep_hashtable[hash];
 	read_lock(&head->lock);
-	sctp_for_each_hentry(epb, node, &head->chain) {
+	sctp_for_each_hentry(epb, &head->chain) {
 		ep = sctp_ep(epb);
 		if (sctp_endpoint_is_match(ep, net, laddr))
 			goto hit;
@@ -876,7 +875,6 @@ static struct sctp_association *__sctp_l
 	struct sctp_ep_common *epb;
 	struct sctp_association *asoc;
 	struct sctp_transport *transport;
-	struct hlist_node *node;
 	int hash;
 
 	/* Optimize here for direct hit, only listening connections can
@@ -886,7 +884,7 @@ static struct sctp_association *__sctp_l
 				 ntohs(peer->v4.sin_port));
 	head = &sctp_assoc_hashtable[hash];
 	read_lock(&head->lock);
-	sctp_for_each_hentry(epb, node, &head->chain) {
+	sctp_for_each_hentry(epb, &head->chain) {
 		asoc = sctp_assoc(epb);
 		transport = sctp_assoc_is_match(asoc, net, local, peer);
 		if (transport)
diff -puN net/sctp/proc.c~hlist-drop-the-node-parameter-from-iterators net/sctp/proc.c
--- a/net/sctp/proc.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sctp/proc.c
@@ -213,7 +213,6 @@ static int sctp_eps_seq_show(struct seq_
 	struct sctp_ep_common *epb;
 	struct sctp_endpoint *ep;
 	struct sock *sk;
-	struct hlist_node *node;
 	int    hash = *(loff_t *)v;
 
 	if (hash >= sctp_ep_hashsize)
@@ -222,7 +221,7 @@ static int sctp_eps_seq_show(struct seq_
 	head = &sctp_ep_hashtable[hash];
 	sctp_local_bh_disable();
 	read_lock(&head->lock);
-	sctp_for_each_hentry(epb, node, &head->chain) {
+	sctp_for_each_hentry(epb, &head->chain) {
 		ep = sctp_ep(epb);
 		sk = epb->sk;
 		if (!net_eq(sock_net(sk), seq_file_net(seq)))
@@ -321,7 +320,6 @@ static int sctp_assocs_seq_show(struct s
 	struct sctp_ep_common *epb;
 	struct sctp_association *assoc;
 	struct sock *sk;
-	struct hlist_node *node;
 	int    hash = *(loff_t *)v;
 
 	if (hash >= sctp_assoc_hashsize)
@@ -330,7 +328,7 @@ static int sctp_assocs_seq_show(struct s
 	head = &sctp_assoc_hashtable[hash];
 	sctp_local_bh_disable();
 	read_lock(&head->lock);
-	sctp_for_each_hentry(epb, node, &head->chain) {
+	sctp_for_each_hentry(epb, &head->chain) {
 		assoc = sctp_assoc(epb);
 		sk = epb->sk;
 		if (!net_eq(sock_net(sk), seq_file_net(seq)))
@@ -436,7 +434,6 @@ static int sctp_remaddr_seq_show(struct 
 	struct sctp_hashbucket *head;
 	struct sctp_ep_common *epb;
 	struct sctp_association *assoc;
-	struct hlist_node *node;
 	struct sctp_transport *tsp;
 	int    hash = *(loff_t *)v;
 
@@ -447,7 +444,7 @@ static int sctp_remaddr_seq_show(struct 
 	sctp_local_bh_disable();
 	read_lock(&head->lock);
 	rcu_read_lock();
-	sctp_for_each_hentry(epb, node, &head->chain) {
+	sctp_for_each_hentry(epb, &head->chain) {
 		if (!net_eq(sock_net(epb->sk), seq_file_net(seq)))
 			continue;
 		assoc = sctp_assoc(epb);
diff -puN net/sctp/socket.c~hlist-drop-the-node-parameter-from-iterators net/sctp/socket.c
--- a/net/sctp/socket.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sctp/socket.c
@@ -5882,8 +5882,7 @@ static struct sctp_bind_bucket *sctp_buc
 static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 {
 	struct sctp_bind_hashbucket *head; /* hash list */
-	struct sctp_bind_bucket *pp; /* hash list port iterator */
-	struct hlist_node *node;
+	struct sctp_bind_bucket *pp;
 	unsigned short snum;
 	int ret;
 
@@ -5910,7 +5909,7 @@ static long sctp_get_port_local(struct s
 			index = sctp_phashfn(sock_net(sk), rover);
 			head = &sctp_port_hashtable[index];
 			sctp_spin_lock(&head->lock);
-			sctp_for_each_hentry(pp, node, &head->chain)
+			sctp_for_each_hentry(pp, &head->chain)
 				if ((pp->port == rover) &&
 				    net_eq(sock_net(sk), pp->net))
 					goto next;
@@ -5938,7 +5937,7 @@ static long sctp_get_port_local(struct s
 		 */
 		head = &sctp_port_hashtable[sctp_phashfn(sock_net(sk), snum)];
 		sctp_spin_lock(&head->lock);
-		sctp_for_each_hentry(pp, node, &head->chain) {
+		sctp_for_each_hentry(pp, &head->chain) {
 			if ((pp->port == snum) && net_eq(pp->net, sock_net(sk)))
 				goto pp_found;
 		}
@@ -5970,7 +5969,7 @@ pp_found:
 		 * that this port/socket (sk) combination are already
 		 * in an endpoint.
 		 */
-		sk_for_each_bound(sk2, node, &pp->owner) {
+		sk_for_each_bound(sk2, &pp->owner) {
 			struct sctp_endpoint *ep2;
 			ep2 = sctp_sk(sk2)->ep;
 
diff -puN net/sunrpc/auth.c~hlist-drop-the-node-parameter-from-iterators net/sunrpc/auth.c
--- a/net/sunrpc/auth.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sunrpc/auth.c
@@ -407,7 +407,6 @@ rpcauth_lookup_credcache(struct rpc_auth
 {
 	LIST_HEAD(free);
 	struct rpc_cred_cache *cache = auth->au_credcache;
-	struct hlist_node *pos;
 	struct rpc_cred	*cred = NULL,
 			*entry, *new;
 	unsigned int nr;
@@ -415,7 +414,7 @@ rpcauth_lookup_credcache(struct rpc_auth
 	nr = hash_long(from_kuid(&init_user_ns, acred->uid), cache->hashbits);
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(entry, pos, &cache->hashtable[nr], cr_hash) {
+	hlist_for_each_entry_rcu(entry, &cache->hashtable[nr], cr_hash) {
 		if (!entry->cr_ops->crmatch(acred, entry, flags))
 			continue;
 		spin_lock(&cache->lock);
@@ -439,7 +438,7 @@ rpcauth_lookup_credcache(struct rpc_auth
 	}
 
 	spin_lock(&cache->lock);
-	hlist_for_each_entry(entry, pos, &cache->hashtable[nr], cr_hash) {
+	hlist_for_each_entry(entry, &cache->hashtable[nr], cr_hash) {
 		if (!entry->cr_ops->crmatch(acred, entry, flags))
 			continue;
 		cred = get_rpccred(entry);
diff -puN net/sunrpc/cache.c~hlist-drop-the-node-parameter-from-iterators net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sunrpc/cache.c
@@ -670,13 +670,13 @@ static void cache_revisit_request(struct
 {
 	struct cache_deferred_req *dreq;
 	struct list_head pending;
-	struct hlist_node *lp, *tmp;
+	struct hlist_node *tmp;
 	int hash = DFR_HASH(item);
 
 	INIT_LIST_HEAD(&pending);
 	spin_lock(&cache_defer_lock);
 
-	hlist_for_each_entry_safe(dreq, lp, tmp, &cache_defer_hash[hash], hash)
+	hlist_for_each_entry_safe(dreq, tmp, &cache_defer_hash[hash], hash)
 		if (dreq->item == item) {
 			__unhash_deferred_req(dreq);
 			list_add(&dreq->recent, &pending);
diff -puN net/sunrpc/svcauth.c~hlist-drop-the-node-parameter-from-iterators net/sunrpc/svcauth.c
--- a/net/sunrpc/svcauth.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/sunrpc/svcauth.c
@@ -138,13 +138,12 @@ auth_domain_lookup(char *name, struct au
 {
 	struct auth_domain *hp;
 	struct hlist_head *head;
-	struct hlist_node *np;
 
 	head = &auth_domain_table[hash_str(name, DN_HASHBITS)];
 
 	spin_lock(&auth_domain_lock);
 
-	hlist_for_each_entry(hp, np, head, hash) {
+	hlist_for_each_entry(hp, head, hash) {
 		if (strcmp(hp->name, name)==0) {
 			kref_get(&hp->ref);
 			spin_unlock(&auth_domain_lock);
diff -puN net/tipc/name_table.c~hlist-drop-the-node-parameter-from-iterators net/tipc/name_table.c
--- a/net/tipc/name_table.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/tipc/name_table.c
@@ -473,11 +473,10 @@ static void tipc_nameseq_subscribe(struc
 static struct name_seq *nametbl_find_seq(u32 type)
 {
 	struct hlist_head *seq_head;
-	struct hlist_node *seq_node;
 	struct name_seq *ns;
 
 	seq_head = &table.types[hash(type)];
-	hlist_for_each_entry(ns, seq_node, seq_head, ns_list) {
+	hlist_for_each_entry(ns, seq_head, ns_list) {
 		if (ns->type == type)
 			return ns;
 	}
@@ -853,7 +852,6 @@ static int nametbl_list(char *buf, int l
 			 u32 type, u32 lowbound, u32 upbound)
 {
 	struct hlist_head *seq_head;
-	struct hlist_node *seq_node;
 	struct name_seq *seq;
 	int all_types;
 	int ret = 0;
@@ -873,7 +871,7 @@ static int nametbl_list(char *buf, int l
 		upbound = ~0;
 		for (i = 0; i < TIPC_NAMETBL_SIZE; i++) {
 			seq_head = &table.types[i];
-			hlist_for_each_entry(seq, seq_node, seq_head, ns_list) {
+			hlist_for_each_entry(seq, seq_head, ns_list) {
 				ret += nameseq_list(seq, buf + ret, len - ret,
 						   depth, seq->type,
 						   lowbound, upbound, i);
@@ -889,7 +887,7 @@ static int nametbl_list(char *buf, int l
 		ret += nametbl_header(buf + ret, len - ret, depth);
 		i = hash(type);
 		seq_head = &table.types[i];
-		hlist_for_each_entry(seq, seq_node, seq_head, ns_list) {
+		hlist_for_each_entry(seq, seq_head, ns_list) {
 			if (seq->type == type) {
 				ret += nameseq_list(seq, buf + ret, len - ret,
 						   depth, type,
diff -puN net/tipc/node.c~hlist-drop-the-node-parameter-from-iterators net/tipc/node.c
--- a/net/tipc/node.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/tipc/node.c
@@ -69,12 +69,11 @@ static unsigned int tipc_hashfn(u32 addr
 struct tipc_node *tipc_node_find(u32 addr)
 {
 	struct tipc_node *node;
-	struct hlist_node *pos;
 
 	if (unlikely(!in_own_cluster_exact(addr)))
 		return NULL;
 
-	hlist_for_each_entry(node, pos, &node_htable[tipc_hashfn(addr)], hash) {
+	hlist_for_each_entry(node, &node_htable[tipc_hashfn(addr)], hash) {
 		if (node->addr == addr)
 			return node;
 	}
diff -puN net/unix/af_unix.c~hlist-drop-the-node-parameter-from-iterators net/unix/af_unix.c
--- a/net/unix/af_unix.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/unix/af_unix.c
@@ -263,9 +263,8 @@ static struct sock *__unix_find_socket_b
 					      int len, int type, unsigned int hash)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
-	sk_for_each(s, node, &unix_socket_table[hash ^ type]) {
+	sk_for_each(s, &unix_socket_table[hash ^ type]) {
 		struct unix_sock *u = unix_sk(s);
 
 		if (!net_eq(sock_net(s), net))
@@ -298,10 +297,9 @@ static inline struct sock *unix_find_soc
 static struct sock *unix_find_socket_byinode(struct inode *i)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	spin_lock(&unix_table_lock);
-	sk_for_each(s, node,
+	sk_for_each(s,
 		    &unix_socket_table[i->i_ino & (UNIX_HASH_SIZE - 1)]) {
 		struct dentry *dentry = unix_sk(s)->path.dentry;
 
diff -puN net/unix/diag.c~hlist-drop-the-node-parameter-from-iterators net/unix/diag.c
--- a/net/unix/diag.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/unix/diag.c
@@ -192,10 +192,9 @@ static int unix_diag_dump(struct sk_buff
 	     slot < ARRAY_SIZE(unix_socket_table);
 	     s_num = 0, slot++) {
 		struct sock *sk;
-		struct hlist_node *node;
 
 		num = 0;
-		sk_for_each(sk, node, &unix_socket_table[slot]) {
+		sk_for_each(sk, &unix_socket_table[slot]) {
 			if (!net_eq(sock_net(sk), net))
 				continue;
 			if (num < s_num)
@@ -226,9 +225,7 @@ static struct sock *unix_lookup_by_ino(i
 
 	spin_lock(&unix_table_lock);
 	for (i = 0; i < ARRAY_SIZE(unix_socket_table); i++) {
-		struct hlist_node *node;
-
-		sk_for_each(sk, node, &unix_socket_table[i])
+		sk_for_each(sk, &unix_socket_table[i])
 			if (ino == sock_i_ino(sk)) {
 				sock_hold(sk);
 				spin_unlock(&unix_table_lock);
diff -puN net/x25/af_x25.c~hlist-drop-the-node-parameter-from-iterators net/x25/af_x25.c
--- a/net/x25/af_x25.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/x25/af_x25.c
@@ -208,11 +208,10 @@ static void x25_remove_socket(struct soc
 static void x25_kill_by_device(struct net_device *dev)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	write_lock_bh(&x25_list_lock);
 
-	sk_for_each(s, node, &x25_list)
+	sk_for_each(s, &x25_list)
 		if (x25_sk(s)->neighbour && x25_sk(s)->neighbour->dev == dev)
 			x25_disconnect(s, ENETUNREACH, 0, 0);
 
@@ -280,12 +279,11 @@ static struct sock *x25_find_listener(st
 {
 	struct sock *s;
 	struct sock *next_best;
-	struct hlist_node *node;
 
 	read_lock_bh(&x25_list_lock);
 	next_best = NULL;
 
-	sk_for_each(s, node, &x25_list)
+	sk_for_each(s, &x25_list)
 		if ((!strcmp(addr->x25_addr,
 			x25_sk(s)->source_addr.x25_addr) ||
 				!strcmp(addr->x25_addr,
@@ -323,9 +321,8 @@ found:
 static struct sock *__x25_find_socket(unsigned int lci, struct x25_neigh *nb)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
-	sk_for_each(s, node, &x25_list)
+	sk_for_each(s, &x25_list)
 		if (x25_sk(s)->lci == lci && x25_sk(s)->neighbour == nb) {
 			sock_hold(s);
 			goto found;
@@ -1782,11 +1779,10 @@ static struct notifier_block x25_dev_not
 void x25_kill_by_neigh(struct x25_neigh *nb)
 {
 	struct sock *s;
-	struct hlist_node *node;
 
 	write_lock_bh(&x25_list_lock);
 
-	sk_for_each(s, node, &x25_list)
+	sk_for_each(s, &x25_list)
 		if (x25_sk(s)->neighbour == nb)
 			x25_disconnect(s, ENETUNREACH, 0, 0);
 
diff -puN net/xfrm/xfrm_policy.c~hlist-drop-the-node-parameter-from-iterators net/xfrm/xfrm_policy.c
--- a/net/xfrm/xfrm_policy.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/xfrm/xfrm_policy.c
@@ -379,27 +379,27 @@ static void xfrm_dst_hash_transfer(struc
 				   struct hlist_head *ndsttable,
 				   unsigned int nhashmask)
 {
-	struct hlist_node *entry, *tmp, *entry0 = NULL;
+	struct hlist_node *tmp, *entry0 = NULL;
 	struct xfrm_policy *pol;
 	unsigned int h0 = 0;
 
 redo:
-	hlist_for_each_entry_safe(pol, entry, tmp, list, bydst) {
+	hlist_for_each_entry_safe(pol, tmp, list, bydst) {
 		unsigned int h;
 
 		h = __addr_hash(&pol->selector.daddr, &pol->selector.saddr,
 				pol->family, nhashmask);
 		if (!entry0) {
-			hlist_del(entry);
+			hlist_del(&pol->bydst);
 			hlist_add_head(&pol->bydst, ndsttable+h);
 			h0 = h;
 		} else {
 			if (h != h0)
 				continue;
-			hlist_del(entry);
+			hlist_del(&pol->bydst);
 			hlist_add_after(entry0, &pol->bydst);
 		}
-		entry0 = entry;
+		entry0 = &pol->bydst;
 	}
 	if (!hlist_empty(list)) {
 		entry0 = NULL;
@@ -411,10 +411,10 @@ static void xfrm_idx_hash_transfer(struc
 				   struct hlist_head *nidxtable,
 				   unsigned int nhashmask)
 {
-	struct hlist_node *entry, *tmp;
+	struct hlist_node *tmp;
 	struct xfrm_policy *pol;
 
-	hlist_for_each_entry_safe(pol, entry, tmp, list, byidx) {
+	hlist_for_each_entry_safe(pol, tmp, list, byidx) {
 		unsigned int h;
 
 		h = __idx_hash(pol->index, nhashmask);
@@ -544,7 +544,6 @@ static u32 xfrm_gen_index(struct net *ne
 	static u32 idx_generator;
 
 	for (;;) {
-		struct hlist_node *entry;
 		struct hlist_head *list;
 		struct xfrm_policy *p;
 		u32 idx;
@@ -556,7 +555,7 @@ static u32 xfrm_gen_index(struct net *ne
 			idx = 8;
 		list = net->xfrm.policy_byidx + idx_hash(net, idx);
 		found = 0;
-		hlist_for_each_entry(p, entry, list, byidx) {
+		hlist_for_each_entry(p, list, byidx) {
 			if (p->index == idx) {
 				found = 1;
 				break;
@@ -628,13 +627,13 @@ int xfrm_policy_insert(int dir, struct x
 	struct xfrm_policy *pol;
 	struct xfrm_policy *delpol;
 	struct hlist_head *chain;
-	struct hlist_node *entry, *newpos;
+	struct hlist_node *newpos;
 
 	write_lock_bh(&xfrm_policy_lock);
 	chain = policy_hash_bysel(net, &policy->selector, policy->family, dir);
 	delpol = NULL;
 	newpos = NULL;
-	hlist_for_each_entry(pol, entry, chain, bydst) {
+	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == policy->type &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
 		    xfrm_policy_mark_match(policy, pol) &&
@@ -691,13 +690,12 @@ struct xfrm_policy *xfrm_policy_bysel_ct
 {
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
-	struct hlist_node *entry;
 
 	*err = 0;
 	write_lock_bh(&xfrm_policy_lock);
 	chain = policy_hash_bysel(net, sel, sel->family, dir);
 	ret = NULL;
-	hlist_for_each_entry(pol, entry, chain, bydst) {
+	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == type &&
 		    (mark & pol->mark.m) == pol->mark.v &&
 		    !selector_cmp(sel, &pol->selector) &&
@@ -729,7 +727,6 @@ struct xfrm_policy *xfrm_policy_byid(str
 {
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
-	struct hlist_node *entry;
 
 	*err = -ENOENT;
 	if (xfrm_policy_id2dir(id) != dir)
@@ -739,7 +736,7 @@ struct xfrm_policy *xfrm_policy_byid(str
 	write_lock_bh(&xfrm_policy_lock);
 	chain = net->xfrm.policy_byidx + idx_hash(net, id);
 	ret = NULL;
-	hlist_for_each_entry(pol, entry, chain, byidx) {
+	hlist_for_each_entry(pol, chain, byidx) {
 		if (pol->type == type && pol->index == id &&
 		    (mark & pol->mark.m) == pol->mark.v) {
 			xfrm_pol_hold(pol);
@@ -772,10 +769,9 @@ xfrm_policy_flush_secctx_check(struct ne
 
 	for (dir = 0; dir < XFRM_POLICY_MAX; dir++) {
 		struct xfrm_policy *pol;
-		struct hlist_node *entry;
 		int i;
 
-		hlist_for_each_entry(pol, entry,
+		hlist_for_each_entry(pol,
 				     &net->xfrm.policy_inexact[dir], bydst) {
 			if (pol->type != type)
 				continue;
@@ -789,7 +785,7 @@ xfrm_policy_flush_secctx_check(struct ne
 			}
 		}
 		for (i = net->xfrm.policy_bydst[dir].hmask; i >= 0; i--) {
-			hlist_for_each_entry(pol, entry,
+			hlist_for_each_entry(pol,
 					     net->xfrm.policy_bydst[dir].table + i,
 					     bydst) {
 				if (pol->type != type)
@@ -828,11 +824,10 @@ int xfrm_policy_flush(struct net *net, u
 
 	for (dir = 0; dir < XFRM_POLICY_MAX; dir++) {
 		struct xfrm_policy *pol;
-		struct hlist_node *entry;
 		int i;
 
 	again1:
-		hlist_for_each_entry(pol, entry,
+		hlist_for_each_entry(pol,
 				     &net->xfrm.policy_inexact[dir], bydst) {
 			if (pol->type != type)
 				continue;
@@ -852,7 +847,7 @@ int xfrm_policy_flush(struct net *net, u
 
 		for (i = net->xfrm.policy_bydst[dir].hmask; i >= 0; i--) {
 	again2:
-			hlist_for_each_entry(pol, entry,
+			hlist_for_each_entry(pol,
 					     net->xfrm.policy_bydst[dir].table + i,
 					     bydst) {
 				if (pol->type != type)
@@ -980,7 +975,6 @@ static struct xfrm_policy *xfrm_policy_l
 	int err;
 	struct xfrm_policy *pol, *ret;
 	const xfrm_address_t *daddr, *saddr;
-	struct hlist_node *entry;
 	struct hlist_head *chain;
 	u32 priority = ~0U;
 
@@ -992,7 +986,7 @@ static struct xfrm_policy *xfrm_policy_l
 	read_lock_bh(&xfrm_policy_lock);
 	chain = policy_hash_direct(net, daddr, saddr, family, dir);
 	ret = NULL;
-	hlist_for_each_entry(pol, entry, chain, bydst) {
+	hlist_for_each_entry(pol, chain, bydst) {
 		err = xfrm_policy_match(pol, fl, type, family, dir);
 		if (err) {
 			if (err == -ESRCH)
@@ -1008,7 +1002,7 @@ static struct xfrm_policy *xfrm_policy_l
 		}
 	}
 	chain = &net->xfrm.policy_inexact[dir];
-	hlist_for_each_entry(pol, entry, chain, bydst) {
+	hlist_for_each_entry(pol, chain, bydst) {
 		err = xfrm_policy_match(pol, fl, type, family, dir);
 		if (err) {
 			if (err == -ESRCH)
@@ -3041,13 +3035,12 @@ static struct xfrm_policy * xfrm_migrate
 						     u8 dir, u8 type)
 {
 	struct xfrm_policy *pol, *ret = NULL;
-	struct hlist_node *entry;
 	struct hlist_head *chain;
 	u32 priority = ~0U;
 
 	read_lock_bh(&xfrm_policy_lock);
 	chain = policy_hash_direct(&init_net, &sel->daddr, &sel->saddr, sel->family, dir);
-	hlist_for_each_entry(pol, entry, chain, bydst) {
+	hlist_for_each_entry(pol, chain, bydst) {
 		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
@@ -3056,7 +3049,7 @@ static struct xfrm_policy * xfrm_migrate
 		}
 	}
 	chain = &init_net.xfrm.policy_inexact[dir];
-	hlist_for_each_entry(pol, entry, chain, bydst) {
+	hlist_for_each_entry(pol, chain, bydst) {
 		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type &&
 		    pol->priority < priority) {
diff -puN net/xfrm/xfrm_state.c~hlist-drop-the-node-parameter-from-iterators net/xfrm/xfrm_state.c
--- a/net/xfrm/xfrm_state.c~hlist-drop-the-node-parameter-from-iterators
+++ a/net/xfrm/xfrm_state.c
@@ -72,10 +72,10 @@ static void xfrm_hash_transfer(struct hl
 			       struct hlist_head *nspitable,
 			       unsigned int nhashmask)
 {
-	struct hlist_node *entry, *tmp;
+	struct hlist_node *tmp;
 	struct xfrm_state *x;
 
-	hlist_for_each_entry_safe(x, entry, tmp, list, bydst) {
+	hlist_for_each_entry_safe(x, tmp, list, bydst) {
 		unsigned int h;
 
 		h = __xfrm_dst_hash(&x->id.daddr, &x->props.saddr,
@@ -368,14 +368,14 @@ static void xfrm_state_gc_task(struct wo
 {
 	struct net *net = container_of(work, struct net, xfrm.state_gc_work);
 	struct xfrm_state *x;
-	struct hlist_node *entry, *tmp;
+	struct hlist_node *tmp;
 	struct hlist_head gc_list;
 
 	spin_lock_bh(&xfrm_state_gc_lock);
 	hlist_move_list(&net->xfrm.state_gc_list, &gc_list);
 	spin_unlock_bh(&xfrm_state_gc_lock);
 
-	hlist_for_each_entry_safe(x, entry, tmp, &gc_list, gclist)
+	hlist_for_each_entry_safe(x, tmp, &gc_list, gclist)
 		xfrm_state_gc_destroy(x);
 
 	wake_up(&net->xfrm.km_waitq);
@@ -577,10 +577,9 @@ xfrm_state_flush_secctx_check(struct net
 	int i, err = 0;
 
 	for (i = 0; i <= net->xfrm.state_hmask; i++) {
-		struct hlist_node *entry;
 		struct xfrm_state *x;
 
-		hlist_for_each_entry(x, entry, net->xfrm.state_bydst+i, bydst) {
+		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			if (xfrm_id_proto_match(x->id.proto, proto) &&
 			   (err = security_xfrm_state_delete(x)) != 0) {
 				xfrm_audit_state_delete(x, 0,
@@ -613,10 +612,9 @@ int xfrm_state_flush(struct net *net, u8
 
 	err = -ESRCH;
 	for (i = 0; i <= net->xfrm.state_hmask; i++) {
-		struct hlist_node *entry;
 		struct xfrm_state *x;
 restart:
-		hlist_for_each_entry(x, entry, net->xfrm.state_bydst+i, bydst) {
+		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			if (!xfrm_state_kern(x) &&
 			    xfrm_id_proto_match(x->id.proto, proto)) {
 				xfrm_state_hold(x);
@@ -685,9 +683,8 @@ static struct xfrm_state *__xfrm_state_l
 {
 	unsigned int h = xfrm_spi_hash(net, daddr, spi, proto, family);
 	struct xfrm_state *x;
-	struct hlist_node *entry;
 
-	hlist_for_each_entry(x, entry, net->xfrm.state_byspi+h, byspi) {
+	hlist_for_each_entry(x, net->xfrm.state_byspi+h, byspi) {
 		if (x->props.family != family ||
 		    x->id.spi       != spi ||
 		    x->id.proto     != proto ||
@@ -710,9 +707,8 @@ static struct xfrm_state *__xfrm_state_l
 {
 	unsigned int h = xfrm_src_hash(net, daddr, saddr, family);
 	struct xfrm_state *x;
-	struct hlist_node *entry;
 
-	hlist_for_each_entry(x, entry, net->xfrm.state_bysrc+h, bysrc) {
+	hlist_for_each_entry(x, net->xfrm.state_bysrc+h, bysrc) {
 		if (x->props.family != family ||
 		    x->id.proto     != proto ||
 		    !xfrm_addr_equal(&x->id.daddr, daddr, family) ||
@@ -798,7 +794,6 @@ xfrm_state_find(const xfrm_address_t *da
 	static xfrm_address_t saddr_wildcard = { };
 	struct net *net = xp_net(pol);
 	unsigned int h, h_wildcard;
-	struct hlist_node *entry;
 	struct xfrm_state *x, *x0, *to_put;
 	int acquire_in_progress = 0;
 	int error = 0;
@@ -810,7 +805,7 @@ xfrm_state_find(const xfrm_address_t *da
 
 	spin_lock_bh(&xfrm_state_lock);
 	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
-	hlist_for_each_entry(x, entry, net->xfrm.state_bydst+h, bydst) {
+	hlist_for_each_entry(x, net->xfrm.state_bydst+h, bydst) {
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -826,7 +821,7 @@ xfrm_state_find(const xfrm_address_t *da
 		goto found;
 
 	h_wildcard = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, encap_family);
-	hlist_for_each_entry(x, entry, net->xfrm.state_bydst+h_wildcard, bydst) {
+	hlist_for_each_entry(x, net->xfrm.state_bydst+h_wildcard, bydst) {
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -906,11 +901,10 @@ xfrm_stateonly_find(struct net *net, u32
 {
 	unsigned int h;
 	struct xfrm_state *rx = NULL, *x = NULL;
-	struct hlist_node *entry;
 
 	spin_lock(&xfrm_state_lock);
 	h = xfrm_dst_hash(net, daddr, saddr, reqid, family);
-	hlist_for_each_entry(x, entry, net->xfrm.state_bydst+h, bydst) {
+	hlist_for_each_entry(x, net->xfrm.state_bydst+h, bydst) {
 		if (x->props.family == family &&
 		    x->props.reqid == reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -972,12 +966,11 @@ static void __xfrm_state_bump_genids(str
 	unsigned short family = xnew->props.family;
 	u32 reqid = xnew->props.reqid;
 	struct xfrm_state *x;
-	struct hlist_node *entry;
 	unsigned int h;
 	u32 mark = xnew->mark.v & xnew->mark.m;
 
 	h = xfrm_dst_hash(net, &xnew->id.daddr, &xnew->props.saddr, reqid, family);
-	hlist_for_each_entry(x, entry, net->xfrm.state_bydst+h, bydst) {
+	hlist_for_each_entry(x, net->xfrm.state_bydst+h, bydst) {
 		if (x->props.family	== family &&
 		    x->props.reqid	== reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -1004,11 +997,10 @@ static struct xfrm_state *__find_acq_cor
 					  const xfrm_address_t *saddr, int create)
 {
 	unsigned int h = xfrm_dst_hash(net, daddr, saddr, reqid, family);
-	struct hlist_node *entry;
 	struct xfrm_state *x;
 	u32 mark = m->v & m->m;
 
-	hlist_for_each_entry(x, entry, net->xfrm.state_bydst+h, bydst) {
+	hlist_for_each_entry(x, net->xfrm.state_bydst+h, bydst) {
 		if (x->props.reqid  != reqid ||
 		    x->props.mode   != mode ||
 		    x->props.family != family ||
@@ -1215,12 +1207,11 @@ struct xfrm_state * xfrm_migrate_state_f
 {
 	unsigned int h;
 	struct xfrm_state *x;
-	struct hlist_node *entry;
 
 	if (m->reqid) {
 		h = xfrm_dst_hash(&init_net, &m->old_daddr, &m->old_saddr,
 				  m->reqid, m->old_family);
-		hlist_for_each_entry(x, entry, init_net.xfrm.state_bydst+h, bydst) {
+		hlist_for_each_entry(x, init_net.xfrm.state_bydst+h, bydst) {
 			if (x->props.mode != m->mode ||
 			    x->id.proto != m->proto)
 				continue;
@@ -1237,7 +1228,7 @@ struct xfrm_state * xfrm_migrate_state_f
 	} else {
 		h = xfrm_src_hash(&init_net, &m->old_daddr, &m->old_saddr,
 				  m->old_family);
-		hlist_for_each_entry(x, entry, init_net.xfrm.state_bysrc+h, bysrc) {
+		hlist_for_each_entry(x, init_net.xfrm.state_bysrc+h, bysrc) {
 			if (x->props.mode != m->mode ||
 			    x->id.proto != m->proto)
 				continue;
@@ -1466,10 +1457,9 @@ static struct xfrm_state *__xfrm_find_ac
 	int i;
 
 	for (i = 0; i <= net->xfrm.state_hmask; i++) {
-		struct hlist_node *entry;
 		struct xfrm_state *x;
 
-		hlist_for_each_entry(x, entry, net->xfrm.state_bydst+i, bydst) {
+		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			if (x->km.seq == seq &&
 			    (mark & x->mark.m) == x->mark.v &&
 			    x->km.state == XFRM_STATE_ACQ) {
diff -puN security/integrity/ima/ima_queue.c~hlist-drop-the-node-parameter-from-iterators security/integrity/ima/ima_queue.c
--- a/security/integrity/ima/ima_queue.c~hlist-drop-the-node-parameter-from-iterators
+++ a/security/integrity/ima/ima_queue.c
@@ -45,12 +45,11 @@ static struct ima_queue_entry *ima_looku
 {
 	struct ima_queue_entry *qe, *ret = NULL;
 	unsigned int key;
-	struct hlist_node *pos;
 	int rc;
 
 	key = ima_hash_key(digest_value);
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(qe, pos, &ima_htable.queue[key], hnext) {
+	hlist_for_each_entry_rcu(qe, &ima_htable.queue[key], hnext) {
 		rc = memcmp(qe->entry->digest, digest_value, IMA_DIGEST_SIZE);
 		if (rc == 0) {
 			ret = qe;
diff -puN security/selinux/avc.c~hlist-drop-the-node-parameter-from-iterators security/selinux/avc.c
--- a/security/selinux/avc.c~hlist-drop-the-node-parameter-from-iterators
+++ a/security/selinux/avc.c
@@ -188,11 +188,9 @@ int avc_get_hash_stats(char *page)
 	for (i = 0; i < AVC_CACHE_SLOTS; i++) {
 		head = &avc_cache.slots[i];
 		if (!hlist_empty(head)) {
-			struct hlist_node *next;
-
 			slots_used++;
 			chain_len = 0;
-			hlist_for_each_entry_rcu(node, next, head, list)
+			hlist_for_each_entry_rcu(node, head, list)
 				chain_len++;
 			if (chain_len > max_chain_len)
 				max_chain_len = chain_len;
@@ -241,7 +239,6 @@ static inline int avc_reclaim_node(void)
 	int hvalue, try, ecx;
 	unsigned long flags;
 	struct hlist_head *head;
-	struct hlist_node *next;
 	spinlock_t *lock;
 
 	for (try = 0, ecx = 0; try < AVC_CACHE_SLOTS; try++) {
@@ -253,7 +250,7 @@ static inline int avc_reclaim_node(void)
 			continue;
 
 		rcu_read_lock();
-		hlist_for_each_entry(node, next, head, list) {
+		hlist_for_each_entry(node, head, list) {
 			avc_node_delete(node);
 			avc_cache_stats_incr(reclaims);
 			ecx++;
@@ -301,11 +298,10 @@ static inline struct avc_node *avc_searc
 	struct avc_node *node, *ret = NULL;
 	int hvalue;
 	struct hlist_head *head;
-	struct hlist_node *next;
 
 	hvalue = avc_hash(ssid, tsid, tclass);
 	head = &avc_cache.slots[hvalue];
-	hlist_for_each_entry_rcu(node, next, head, list) {
+	hlist_for_each_entry_rcu(node, head, list) {
 		if (ssid == node->ae.ssid &&
 		    tclass == node->ae.tclass &&
 		    tsid == node->ae.tsid) {
@@ -394,7 +390,6 @@ static struct avc_node *avc_insert(u32 s
 	node = avc_alloc_node();
 	if (node) {
 		struct hlist_head *head;
-		struct hlist_node *next;
 		spinlock_t *lock;
 
 		hvalue = avc_hash(ssid, tsid, tclass);
@@ -404,7 +399,7 @@ static struct avc_node *avc_insert(u32 s
 		lock = &avc_cache.slots_lock[hvalue];
 
 		spin_lock_irqsave(lock, flag);
-		hlist_for_each_entry(pos, next, head, list) {
+		hlist_for_each_entry(pos, head, list) {
 			if (pos->ae.ssid == ssid &&
 			    pos->ae.tsid == tsid &&
 			    pos->ae.tclass == tclass) {
@@ -541,7 +536,6 @@ static int avc_update_node(u32 event, u3
 	unsigned long flag;
 	struct avc_node *pos, *node, *orig = NULL;
 	struct hlist_head *head;
-	struct hlist_node *next;
 	spinlock_t *lock;
 
 	node = avc_alloc_node();
@@ -558,7 +552,7 @@ static int avc_update_node(u32 event, u3
 
 	spin_lock_irqsave(lock, flag);
 
-	hlist_for_each_entry(pos, next, head, list) {
+	hlist_for_each_entry(pos, head, list) {
 		if (ssid == pos->ae.ssid &&
 		    tsid == pos->ae.tsid &&
 		    tclass == pos->ae.tclass &&
@@ -614,7 +608,6 @@ out:
 static void avc_flush(void)
 {
 	struct hlist_head *head;
-	struct hlist_node *next;
 	struct avc_node *node;
 	spinlock_t *lock;
 	unsigned long flag;
@@ -630,7 +623,7 @@ static void avc_flush(void)
 		 * prevent RCU grace periods from ending.
 		 */
 		rcu_read_lock();
-		hlist_for_each_entry(node, next, head, list)
+		hlist_for_each_entry(node, head, list)
 			avc_node_delete(node);
 		rcu_read_unlock();
 		spin_unlock_irqrestore(lock, flag);
diff -puN tools/perf/util/evlist.c~hlist-drop-the-node-parameter-from-iterators tools/perf/util/evlist.c
--- a/tools/perf/util/evlist.c~hlist-drop-the-node-parameter-from-iterators
+++ a/tools/perf/util/evlist.c
@@ -314,7 +314,6 @@ static int perf_evlist__id_add_fd(struct
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 {
 	struct hlist_head *head;
-	struct hlist_node *pos;
 	struct perf_sample_id *sid;
 	int hash;
 
@@ -324,7 +323,7 @@ struct perf_evsel *perf_evlist__id2evsel
 	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
 	head = &evlist->heads[hash];
 
-	hlist_for_each_entry(sid, pos, head, node)
+	hlist_for_each_entry(sid, head, node)
 		if (sid->id == id)
 			return sid->evsel;
 
diff -puN virt/kvm/eventfd.c~hlist-drop-the-node-parameter-from-iterators virt/kvm/eventfd.c
--- a/virt/kvm/eventfd.c~hlist-drop-the-node-parameter-from-iterators
+++ a/virt/kvm/eventfd.c
@@ -268,14 +268,13 @@ static void irqfd_update(struct kvm *kvm
 			 struct kvm_irq_routing_table *irq_rt)
 {
 	struct kvm_kernel_irq_routing_entry *e;
-	struct hlist_node *n;
 
 	if (irqfd->gsi >= irq_rt->nr_rt_entries) {
 		rcu_assign_pointer(irqfd->irq_entry, NULL);
 		return;
 	}
 
-	hlist_for_each_entry(e, n, &irq_rt->map[irqfd->gsi], link) {
+	hlist_for_each_entry(e, &irq_rt->map[irqfd->gsi], link) {
 		/* Only fast-path MSI. */
 		if (e->type == KVM_IRQ_ROUTING_MSI)
 			rcu_assign_pointer(irqfd->irq_entry, e);
diff -puN virt/kvm/irq_comm.c~hlist-drop-the-node-parameter-from-iterators virt/kvm/irq_comm.c
--- a/virt/kvm/irq_comm.c~hlist-drop-the-node-parameter-from-iterators
+++ a/virt/kvm/irq_comm.c
@@ -173,7 +173,6 @@ int kvm_set_irq(struct kvm *kvm, int irq
 	struct kvm_kernel_irq_routing_entry *e, irq_set[KVM_NR_IRQCHIPS];
 	int ret = -1, i = 0;
 	struct kvm_irq_routing_table *irq_rt;
-	struct hlist_node *n;
 
 	trace_kvm_set_irq(irq, level, irq_source_id);
 
@@ -184,7 +183,7 @@ int kvm_set_irq(struct kvm *kvm, int irq
 	rcu_read_lock();
 	irq_rt = rcu_dereference(kvm->irq_routing);
 	if (irq < irq_rt->nr_rt_entries)
-		hlist_for_each_entry(e, n, &irq_rt->map[irq], link)
+		hlist_for_each_entry(e, &irq_rt->map[irq], link)
 			irq_set[i++] = *e;
 	rcu_read_unlock();
 
@@ -212,7 +211,6 @@ int kvm_set_irq_inatomic(struct kvm *kvm
 	struct kvm_kernel_irq_routing_entry *e;
 	int ret = -EINVAL;
 	struct kvm_irq_routing_table *irq_rt;
-	struct hlist_node *n;
 
 	trace_kvm_set_irq(irq, level, irq_source_id);
 
@@ -227,7 +225,7 @@ int kvm_set_irq_inatomic(struct kvm *kvm
 	rcu_read_lock();
 	irq_rt = rcu_dereference(kvm->irq_routing);
 	if (irq < irq_rt->nr_rt_entries)
-		hlist_for_each_entry(e, n, &irq_rt->map[irq], link) {
+		hlist_for_each_entry(e, &irq_rt->map[irq], link) {
 			if (likely(e->type == KVM_IRQ_ROUTING_MSI))
 				ret = kvm_set_msi_inatomic(e, kvm);
 			else
@@ -241,13 +239,12 @@ int kvm_set_irq_inatomic(struct kvm *kvm
 bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 {
 	struct kvm_irq_ack_notifier *kian;
-	struct hlist_node *n;
 	int gsi;
 
 	rcu_read_lock();
 	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kian, n, &kvm->irq_ack_notifier_list,
+		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
 					 link)
 			if (kian->gsi == gsi) {
 				rcu_read_unlock();
@@ -263,7 +260,6 @@ EXPORT_SYMBOL_GPL(kvm_irq_has_notifier);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 {
 	struct kvm_irq_ack_notifier *kian;
-	struct hlist_node *n;
 	int gsi;
 
 	trace_kvm_ack_irq(irqchip, pin);
@@ -271,7 +267,7 @@ void kvm_notify_acked_irq(struct kvm *kv
 	rcu_read_lock();
 	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kian, n, &kvm->irq_ack_notifier_list,
+		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
 					 link)
 			if (kian->gsi == gsi)
 				kian->irq_acked(kian);
@@ -369,13 +365,12 @@ void kvm_fire_mask_notifiers(struct kvm 
 			     bool mask)
 {
 	struct kvm_irq_mask_notifier *kimn;
-	struct hlist_node *n;
 	int gsi;
 
 	rcu_read_lock();
 	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kimn, n, &kvm->mask_notifier_list, link)
+		hlist_for_each_entry_rcu(kimn, &kvm->mask_notifier_list, link)
 			if (kimn->irq == gsi)
 				kimn->func(kimn, mask);
 	rcu_read_unlock();
@@ -396,13 +391,12 @@ static int setup_routing_entry(struct kv
 	int delta;
 	unsigned max_pin;
 	struct kvm_kernel_irq_routing_entry *ei;
-	struct hlist_node *n;
 
 	/*
 	 * Do not allow GSI to be mapped to the same irqchip more than once.
 	 * Allow only one to one mapping between GSI and MSI.
 	 */
-	hlist_for_each_entry(ei, n, &rt->map[ue->gsi], link)
+	hlist_for_each_entry(ei, &rt->map[ue->gsi], link)
 		if (ei->type == KVM_IRQ_ROUTING_MSI ||
 		    ue->type == KVM_IRQ_ROUTING_MSI ||
 		    ue->u.irqchip.irqchip == ei->irqchip.irqchip)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
linux-next.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
epoll-support-for-disabling-items-and-a-self-test-app-fix.patch

