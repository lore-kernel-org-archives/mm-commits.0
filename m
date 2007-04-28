From: akpm@linux-foundation.org
Subject: - git-net-fixup.patch removed from -mm tree
Date: Sat, 28 Apr 2007 02:47:08 -0700
Message-ID: <200704280947.l3S9l8fB019146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbXD1JrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 05:47:11 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l3S9l9XG009415
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sat, 28 Apr 2007 02:47:10 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-net-fixup
has been removed from the -mm tree.  Its filename was
     git-net-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-net-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/eth1394.c     |    2 -
 drivers/net/e1000/e1000_main.c |   39 +++++++++++++-----------------
 drivers/net/ehea/ehea_main.c   |    4 +--
 drivers/net/sis900.c           |    3 --
 include/linux/ipv6.h           |    9 ------
 include/linux/sysctl.h         |    4 ---
 net/ipv4/fib_frontend.c        |    4 ---
 net/ipv6/addrconf.c            |    4 ---
 net/ipv6/exthdrs.c             |   40 -------------------------------
 9 files changed, 21 insertions(+), 88 deletions(-)

diff -puN include/linux/ipv6.h~git-net-fixup include/linux/ipv6.h
--- a/include/linux/ipv6.h~git-net-fixup
+++ a/include/linux/ipv6.h
@@ -177,14 +177,10 @@ struct ipv6_devconf {
 #endif
 #endif
 	__s32		proxy_ndp;
-<<<<<<< HEAD/include/linux/ipv6.h
-	__s32		accept_source_route;
-=======
 #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
 	__s32		optimistic_dad;
 #endif
 	__s32		accept_source_route;
->>>>>>> /include/linux/ipv6.h
 	void		*sysctl;
 };
 
@@ -213,13 +209,8 @@ enum {
 	DEVCONF_RTR_PROBE_INTERVAL,
 	DEVCONF_ACCEPT_RA_RT_INFO_MAX_PLEN,
 	DEVCONF_PROXY_NDP,
-<<<<<<< HEAD/include/linux/ipv6.h
-	__DEVCONF_OPTIMISTIC_DAD,
-	DEVCONF_ACCEPT_SOURCE_ROUTE,
-=======
 	DEVCONF_OPTIMISTIC_DAD,
 	DEVCONF_ACCEPT_SOURCE_ROUTE,
->>>>>>> /include/linux/ipv6.h
 	DEVCONF_MAX
 };
 
diff -puN include/linux/sysctl.h~git-net-fixup include/linux/sysctl.h
--- a/include/linux/sysctl.h~git-net-fixup
+++ a/include/linux/sysctl.h
@@ -583,12 +583,8 @@ enum {
 	NET_IPV6_RTR_PROBE_INTERVAL=21,
 	NET_IPV6_ACCEPT_RA_RT_INFO_MAX_PLEN=22,
 	NET_IPV6_PROXY_NDP=23,
-<<<<<<< HEAD/include/linux/sysctl.h
-	NET_IPV6_ACCEPT_SOURCE_ROUTE=25,
-=======
 	NET_IPV6_OPTIMISTIC_DAD=24,
 	NET_IPV6_ACCEPT_SOURCE_ROUTE=25,
->>>>>>> /include/linux/sysctl.h
 	__NET_IPV6_MAX
 };
 
diff -puN net/ipv6/addrconf.c~git-net-fixup net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~git-net-fixup
+++ a/net/ipv6/addrconf.c
@@ -3446,14 +3446,10 @@ static inline void ipv6_store_devconf(st
 #endif
 #endif
 	array[DEVCONF_PROXY_NDP] = cnf->proxy_ndp;
-<<<<<<< HEAD/net/ipv6/addrconf.c
-	array[DEVCONF_ACCEPT_SOURCE_ROUTE] = cnf->accept_source_route;
-=======
 #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
 	array[DEVCONF_OPTIMISTIC_DAD] = cnf->optimistic_dad;
 #endif
 	array[DEVCONF_ACCEPT_SOURCE_ROUTE] = cnf->accept_source_route;
->>>>>>> /net/ipv6/addrconf.c
 }
 
 static inline size_t inet6_if_nlmsg_size(void)
diff -puN net/ipv6/exthdrs.c~git-net-fixup net/ipv6/exthdrs.c
--- a/net/ipv6/exthdrs.c~git-net-fixup
+++ a/net/ipv6/exthdrs.c
@@ -369,7 +369,6 @@ static int ipv6_rthdr_rcv(struct sk_buff
 	int n, i;
 	struct ipv6_rt_hdr *hdr;
 	struct rt0_hdr *rthdr;
-<<<<<<< HEAD/net/ipv6/exthdrs.c
 	int accept_source_route = ipv6_devconf.accept_source_route;
 
 	if (accept_source_route < 0 ||
@@ -387,25 +386,6 @@ static int ipv6_rthdr_rcv(struct sk_buff
 		accept_source_route = idev->cnf.accept_source_route;
 
 	in6_dev_put(idev);
-=======
-	int accept_source_route = ipv6_devconf.accept_source_route;
-
-	if (accept_source_route < 0 ||
-	    ((idev = in6_dev_get(skb->dev)) == NULL)) {
-		kfree_skb(skb);
-		return -1;
-	}
-	if (idev->cnf.accept_source_route < 0) {
-		in6_dev_put(idev);
-		kfree_skb(skb);
-		return -1;
-	}
-
-	if (accept_source_route > idev->cnf.accept_source_route)
-		accept_source_route = idev->cnf.accept_source_route;
->>>>>>> /net/ipv6/exthdrs.c
-
-	in6_dev_put(idev);
 
 	if (!pskb_may_pull(skb, skb_transport_offset(skb) + 8) ||
 	    !pskb_may_pull(skb, (skb_transport_offset(skb) +
@@ -418,25 +398,6 @@ static int ipv6_rthdr_rcv(struct sk_buff
 
 	hdr = (struct ipv6_rt_hdr *)skb_transport_header(skb);
 
-<<<<<<< HEAD/net/ipv6/exthdrs.c
-	switch (hdr->type) {
-#ifdef CONFIG_IPV6_MIP6
-		break;
-#endif
-	case IPV6_SRCRT_TYPE_0:
-		if (accept_source_route > 0)
-			break;
-		kfree_skb(skb);
-		return -1;
-	default:
-		IP6_INC_STATS_BH(ip6_dst_idev(skb->dst),
-				 IPSTATS_MIB_INHDRERRORS);
-		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, (&hdr->type) - skb->nh.raw);
-		return -1;
-	}
-
-	if (ipv6_addr_is_multicast(&skb->nh.ipv6h->daddr) ||
-=======
 	switch (hdr->type) {
 #ifdef CONFIG_IPV6_MIP6
 	case IPV6_SRCRT_TYPE_2:
@@ -456,7 +417,6 @@ static int ipv6_rthdr_rcv(struct sk_buff
 	}
 
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) ||
->>>>>>> /net/ipv6/exthdrs.c
 	    skb->pkt_type != PACKET_HOST) {
 		IP6_INC_STATS_BH(ip6_dst_idev(skb->dst),
 				 IPSTATS_MIB_INADDRERRORS);
diff -puN MAINTAINERS~git-net-fixup MAINTAINERS
diff -puN drivers/ieee1394/eth1394.c~git-net-fixup drivers/ieee1394/eth1394.c
--- a/drivers/ieee1394/eth1394.c~git-net-fixup
+++ a/drivers/ieee1394/eth1394.c
@@ -752,7 +752,7 @@ static u16 ether1394_type_trans(struct s
 	struct eth1394hdr *eth;
 	unsigned char *rawp;
 
-	skb->mac.raw = skb->data;
+	skb_reset_mac_header(skb);
 	skb_pull(skb, ETH1394_HLEN);
 	eth = eth1394_hdr(skb);
 
diff -puN drivers/net/e1000/e1000_main.c~git-net-fixup drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~git-net-fixup
+++ a/drivers/net/e1000/e1000_main.c
@@ -2967,33 +2967,30 @@ e1000_tso(struct e1000_adapter *adapter,
 				return err;
 		}
 
-		hdr_len = ((skb->h.raw - skb->data) + (skb->h.th->doff << 2));
+		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
 		mss = skb_shinfo(skb)->gso_size;
 		if (skb->protocol == htons(ETH_P_IP)) {
-			skb->nh.iph->tot_len = 0;
-			skb->nh.iph->check = 0;
-			skb->h.th->check =
-				~csum_tcpudp_magic(skb->nh.iph->saddr,
-						   skb->nh.iph->daddr,
-						   0,
-						   IPPROTO_TCP,
-						   0);
+			struct iphdr *iph = ip_hdr(skb);
+			iph->tot_len = 0;
+			iph->check = 0;
+			tcp_hdr(skb)->check = ~csum_tcpudp_magic(iph->saddr,
+								 iph->daddr, 0,
+								 IPPROTO_TCP,
+								 0);
 			cmd_length = E1000_TXD_CMD_IP;
-			ipcse = skb->h.raw - skb->data - 1;
+			ipcse = skb_transport_offset(skb) - 1;
 		} else if (skb_shinfo(skb)->gso_type == SKB_GSO_TCPV6) {
-			skb->nh.ipv6h->payload_len = 0;
-			skb->h.th->check =
-				~csum_ipv6_magic(&skb->nh.ipv6h->saddr,
-						 &skb->nh.ipv6h->daddr,
-						 0,
-						 IPPROTO_TCP,
-						 0);
+			ipv6_hdr(skb)->payload_len = 0;
+			tcp_hdr(skb)->check =
+				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+						 &ipv6_hdr(skb)->daddr,
+						 0, IPPROTO_TCP, 0);
 			ipcse = 0;
 		}
-		ipcss = skb->nh.raw - skb->data;
-		ipcso = (void *)&(skb->nh.iph->check) - (void *)skb->data;
-		tucss = skb->h.raw - skb->data;
-		tucso = (void *)&(skb->h.th->check) - (void *)skb->data;
+		ipcss = skb_network_offset(skb);
+		ipcso = (void *)&(ip_hdr(skb)->check) - (void *)skb->data;
+		tucss = skb_transport_offset(skb);
+		tucso = (void *)&(tcp_hdr(skb)->check) - (void *)skb->data;
 		tucse = 0;
 
 		cmd_length |= (E1000_TXD_CMD_DEXT | E1000_TXD_CMD_TSE |
diff -puN drivers/net/ehea/ehea_main.c~git-net-fixup drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~git-net-fixup
+++ a/drivers/net/ehea/ehea_main.c
@@ -426,8 +426,8 @@ static struct ehea_cqe *ehea_proc_rwqes(
 					if (!skb)
 						break;
 				}
-				memcpy(skb->data, ((char*)cqe) + 64,
-				       cqe->num_bytes_transfered - 4);
+				skb_copy_to_linear_data(skb, ((char*)cqe) + 64,
+					       cqe->num_bytes_transfered - 4);
 				ehea_fill_skb(port->netdev, skb, cqe);
 			} else if (rq == 2) {  /* RQ2 */
 				skb = get_skb_by_index(skb_arr_rq2,
diff -puN drivers/net/sis900.c~git-net-fixup drivers/net/sis900.c
--- a/drivers/net/sis900.c~git-net-fixup
+++ a/drivers/net/sis900.c
@@ -1797,11 +1797,9 @@ static int sis900_rx(struct net_device *
 			net_dev->last_rx = jiffies;
 			sis_priv->stats.rx_bytes += rx_size;
 			sis_priv->stats.rx_packets++;
-<<<<<<< HEAD/drivers/net/sis900.c
 			sis_priv->dirty_rx++;
 refill_rx_ring:
 			skb->dev = net_dev;
-=======
 
 			/* refill the Rx buffer, what if there is not enought
 			 * memory for new socket buffer ?? */
@@ -1822,7 +1820,6 @@ refill_rx_ring:
 				sis_priv->cur_rx++;
 				break;
 			}
->>>>>>> /drivers/net/sis900.c
 			sis_priv->rx_skbuff[entry] = skb;
 			sis_priv->rx_ring[entry].cmdsts = RX_BUF_SIZE;
                 	sis_priv->rx_ring[entry].bufptr =
diff -puN net/ipv4/fib_frontend.c~git-net-fixup net/ipv4/fib_frontend.c
--- a/net/ipv4/fib_frontend.c~git-net-fixup
+++ a/net/ipv4/fib_frontend.c
@@ -804,14 +804,10 @@ static void nl_fib_input(struct sock *sk
 	struct fib_table *tb;
 
 	skb = skb_dequeue(&sk->sk_receive_queue);
-<<<<<<< HEAD/net/ipv4/fib_frontend.c
 	if (skb == NULL)
 		return;
 
-	nlh = (struct nlmsghdr *)skb->data;
-=======
 	nlh = nlmsg_hdr(skb);
->>>>>>> /net/ipv4/fib_frontend.c
 	if (skb->len < NLMSG_SPACE(0) || skb->len < nlh->nlmsg_len ||
 	    nlh->nlmsg_len < NLMSG_LENGTH(sizeof(*frn))) {
 		kfree_skb(skb);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
extend-print_symbol-capability.patch
add-kvasprintf.patch
add-kvasprintf-fix.patch
slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-agpgart.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
ida-implement-idr-based-id-allocator-fix.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-gfs2-nmw.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-input-fixup.patch
git-jfs.patch
git-kvm.patch
git-libata-all.patch
ata-printk-warning-fixes.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-netdev-all.patch
ne-add-platform_driver-fix.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage.patch
git-net-fix-yamc.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
git-r8169.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-fixup.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
git-wireless.patch
fix-x86_64-mm-nmi-watchdog-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
x86_64-unexport-cpu_llc_id.patch
xfs-clean-up-shrinker-games.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
smaps-add-clear_refs-file-to-clear-reference.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-kconfig-update.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
utimensat-implementation-fix.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
