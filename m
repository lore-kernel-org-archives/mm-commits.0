From: akpm@linux-foundation.org
Subject: + revert-7f8be19f5a5737ce6ad670756183235c71b560bb.patch added to -mm tree
Date: Mon, 23 Apr 2007 16:33:30 -0700
Message-ID: <200704232336.l3NNa99J028030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932231AbXDWXgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Apr 2007 19:36:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au


The patch titled
     revert 7f8be19f5a5737ce6ad670756183235c71b560bb
has been added to the -mm tree.  Its filename is
     revert-7f8be19f5a5737ce6ad670756183235c71b560bb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert 7f8be19f5a5737ce6ad670756183235c71b560bb
From: Andrew Morton <akpm@linux-foundation.org>

make udp work again.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/skbuff.h |    9 ++-------
 net/core/dev.c         |   25 ++++++++++---------------
 net/core/skbuff.c      |    2 +-
 net/ipv4/tcp_ipv4.c    |    2 --
 net/ipv4/udp.c         |    1 -
 net/ipv6/tcp_ipv6.c    |    2 --
 6 files changed, 13 insertions(+), 28 deletions(-)

diff -puN include/linux/skbuff.h~revert-7f8be19f5a5737ce6ad670756183235c71b560bb include/linux/skbuff.h
--- a/include/linux/skbuff.h~revert-7f8be19f5a5737ce6ad670756183235c71b560bb
+++ a/include/linux/skbuff.h
@@ -206,9 +206,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@len: Length of actual data
  *	@data_len: Data length
  *	@mac_len: Length of link layer header
- *	@csum: Checksum (must include start/offset pair)
- *	@csum_start: Offset from skb->head where checksumming should start
- *	@csum_offset: Offset from csum_start where checksum should be stored
+ *	@csum: Checksum
  *	@local_df: allow local fragmentation
  *	@cloned: Head may be cloned (check refcnt to be sure)
  *	@nohdr: Payload reference only, must not modify header
@@ -264,10 +262,7 @@ struct sk_buff {
 				mac_len;
 	union {
 		__wsum		csum;
-		struct {
-			__u16	csum_start;
-			__u16	csum_offset;
-		};
+		__u32		csum_offset;
 	};
 	__u32			priority;
 	__u8			local_df:1,
diff -puN net/core/dev.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb net/core/dev.c
--- a/net/core/dev.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb
+++ a/net/core/dev.c
@@ -1147,7 +1147,7 @@ EXPORT_SYMBOL(netif_device_attach);
 int skb_checksum_help(struct sk_buff *skb)
 {
 	__wsum csum;
-	int ret = 0, offset;
+	int ret = 0, offset = skb_transport_offset(skb);
 
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
 		goto out_set_summed;
@@ -1163,16 +1163,15 @@ int skb_checksum_help(struct sk_buff *sk
 			goto out;
 	}
 
-	offset = skb->csum_start - skb_headroom(skb);
 	BUG_ON(offset > (int)skb->len);
 	csum = skb_checksum(skb, offset, skb->len-offset, 0);
 
-	offset = skb_headlen(skb) - offset;
+	offset = skb->tail - skb->transport_header;
 	BUG_ON(offset <= 0);
 	BUG_ON(skb->csum_offset + 2 > offset);
 
-	*(__sum16 *)(skb->head + skb->csum_start + skb->csum_offset) =
-		csum_fold(csum);
+	*(__sum16 *)(skb_transport_header(skb) +
+		     skb->csum_offset) = csum_fold(csum);
 out_set_summed:
 	skb->ip_summed = CHECKSUM_NONE;
 out:
@@ -1424,16 +1423,12 @@ int dev_queue_xmit(struct sk_buff *skb)
 	/* If packet is not checksummed and device does not support
 	 * checksumming for this protocol, complete checksumming here.
 	 */
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		skb_set_transport_header(skb, skb->csum_start -
-					      skb_headroom(skb));
-
-		if (!(dev->features & NETIF_F_GEN_CSUM) &&
-		    (!(dev->features & NETIF_F_IP_CSUM) ||
-		     skb->protocol != htons(ETH_P_IP)))
-			if (skb_checksum_help(skb))
-				goto out_kfree_skb;
-	}
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    (!(dev->features & NETIF_F_GEN_CSUM) &&
+	     (!(dev->features & NETIF_F_IP_CSUM) ||
+	      skb->protocol != htons(ETH_P_IP))))
+		if (skb_checksum_help(skb))
+			goto out_kfree_skb;
 
 gso:
 	spin_lock_prefetch(&dev->queue_lock);
diff -puN net/core/skbuff.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb net/core/skbuff.c
--- a/net/core/skbuff.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb
+++ a/net/core/skbuff.c
@@ -1367,7 +1367,7 @@ void skb_copy_and_csum_dev(const struct 
 	long csstart;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		csstart = skb->csum_start - skb_headroom(skb);
+		csstart = skb_transport_offset(skb);
 	else
 		csstart = skb_headlen(skb);
 
diff -puN net/ipv4/tcp_ipv4.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb
+++ a/net/ipv4/tcp_ipv4.c
@@ -504,7 +504,6 @@ void tcp_v4_send_check(struct sock *sk, 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		th->check = ~tcp_v4_check(len, inet->saddr,
 					  inet->daddr, 0);
-		skb->csum_start = skb_transport_header(skb) - skb->head;
 		skb->csum_offset = offsetof(struct tcphdr, check);
 	} else {
 		th->check = tcp_v4_check(len, inet->saddr, inet->daddr,
@@ -527,7 +526,6 @@ int tcp_v4_gso_send_check(struct sk_buff
 
 	th->check = 0;
 	th->check = ~tcp_v4_check(skb->len, iph->saddr, iph->daddr, 0);
-	skb->csum_start = skb_transport_header(skb) - skb->head;
 	skb->csum_offset = offsetof(struct tcphdr, check);
 	skb->ip_summed = CHECKSUM_PARTIAL;
 	return 0;
diff -puN net/ipv4/udp.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb net/ipv4/udp.c
--- a/net/ipv4/udp.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb
+++ a/net/ipv4/udp.c
@@ -427,7 +427,6 @@ static void udp4_hwcsum_outgoing(struct 
 		/*
 		 * Only one fragment on the socket.
 		 */
-		skb->csum_start = skb_transport_header(skb) - skb->head;
 		skb->csum_offset = offsetof(struct udphdr, check);
 		uh->check = ~csum_tcpudp_magic(src, dst, len, IPPROTO_UDP, 0);
 	} else {
diff -puN net/ipv6/tcp_ipv6.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb net/ipv6/tcp_ipv6.c
--- a/net/ipv6/tcp_ipv6.c~revert-7f8be19f5a5737ce6ad670756183235c71b560bb
+++ a/net/ipv6/tcp_ipv6.c
@@ -950,7 +950,6 @@ static void tcp_v6_send_check(struct soc
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		th->check = ~csum_ipv6_magic(&np->saddr, &np->daddr, len, IPPROTO_TCP,  0);
-		skb->csum_start = skb_transport_header(skb) - skb->head;
 		skb->csum_offset = offsetof(struct tcphdr, check);
 	} else {
 		th->check = csum_ipv6_magic(&np->saddr, &np->daddr, len, IPPROTO_TCP,
@@ -973,7 +972,6 @@ static int tcp_v6_gso_send_check(struct 
 	th->check = 0;
 	th->check = ~csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr, skb->len,
 				     IPPROTO_TCP, 0);
-	skb->csum_start = skb_transport_header(skb) - skb->head;
 	skb->csum_offset = offsetof(struct tcphdr, check);
 	skb->ip_summed = CHECKSUM_PARTIAL;
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-thermal-fix-mod_timer-interval.patch
fix-x86-fix-potential-overflow-in-perfctr-reservation.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-fix.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
device_schedule_callback-needs-a-module-reference-fix.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-fix.patch
dev_dbg-check-dev_dbg-arguments-fix.patch
dev_dbg-check-dev_dbg-arguments-fix-2.patch
sysfs-binc-printk-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
sbp2-include-fixes.patch
git-infiniband-make-it-build-hack.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-ubi-fixup.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
git-netdev-all-fixup.patch
reapply-gitpowerpc-ehea-changes.patch
git-netdev-all-baycom_ser_fdx-fix.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-fix-yamc.patch
revert-8952d6c988ec31070732117f353666a4b9a09fea.patch
revert-7f8be19f5a5737ce6ad670756183235c71b560bb.patch
git-net-vs-git-netdev-all.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-3.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-s390-fixup.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
pci-error-recovery-symbios-scsi-base-support-fixes.patch
pci-error-recovery-symbios-scsi-first-failure-fix.patch
cxacru-add-documentation-file-fix.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
git-wireless-vs-git-net-3.patch
fix-x86_64-mm-fam10-mwait-idle.patch
more-fix-x86_64-mm-fam10-mwait-idle.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
extend-print_symbol-capability-fix-fix.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-more-statics.patch
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
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
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
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
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
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
unprivileged-mounts-account-user-mounts-fix.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt-fix.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
undo-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
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
