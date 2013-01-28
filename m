From: akpm@linux-foundation.org
Subject: + linux-next-fit-rejects.patch added to -mm tree
Date: Mon, 28 Jan 2013 13:24:29 -0800
Message-ID: <20130128212430.531B15A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:46891 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3A1VYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 16:24:34 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so322342yhr.2
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 13:24:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-fit-rejects
has been added to the -mm tree.  Its filename is
     linux-next-fit-rejects.patch

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
Subject: linux-next-fit-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/realtek/r8169.c    |    3 --
 drivers/net/usb/cdc_ncm.c               |    7 ----
 drivers/net/virtio_net.c                |   31 ----------------------
 drivers/net/wireless/ath/ath9k/main.c   |   12 --------
 include/linux/mfd/abx500/ab8500-bm.h    |    4 --
 net/netfilter/nf_conntrack_core.c       |   24 -----------------
 net/netfilter/nf_conntrack_standalone.c |    3 --
 7 files changed, 84 deletions(-)

diff -puN drivers/net/ethernet/realtek/r8169.c~linux-next-fit-rejects drivers/net/ethernet/realtek/r8169.c
--- a/drivers/net/ethernet/realtek/r8169.c~linux-next-fit-rejects
+++ a/drivers/net/ethernet/realtek/r8169.c
@@ -6102,13 +6102,10 @@ process_pkt:
 			tp->rx_stats.bytes += pkt_size;
 			u64_stats_update_end(&tp->rx_stats.syncp);
 		}
-<<<<<<< HEAD
 release_descriptor:
 		desc->opts2 = 0;
 		wmb();
 		rtl8169_mark_to_asic(desc, rx_buf_sz);
-=======
->>>>>>> linux-next/akpm-base
 	}
 
 	count = cur_rx - tp->cur_rx;
diff -puN drivers/net/usb/cdc_ncm.c~linux-next-fit-rejects drivers/net/usb/cdc_ncm.c
--- a/drivers/net/usb/cdc_ncm.c~linux-next-fit-rejects
+++ a/drivers/net/usb/cdc_ncm.c
@@ -453,12 +453,6 @@ advance:
 	}
 
 	/* some buggy devices have an IAD but no CDC Union */
-<<<<<<< HEAD
-	if (!ctx->union_desc && intf->intf_assoc && intf->intf_assoc->bInterfaceCount == 2) {
-		ctx->control = intf;
-		ctx->data = usb_ifnum_to_if(dev->udev, intf->cur_altsetting->desc.bInterfaceNumber + 1);
-		dev_dbg(&intf->dev, "CDC Union missing - got slave from IAD\n");
-=======
 	if (!ctx->union_desc) {
 		dev_dbg(&intf->dev, "missing CDC Union descriptor\n");
 		ctx->data = get_iad_slave(dev->udev, intf);
@@ -466,7 +460,6 @@ advance:
 			ctx->control = intf;
 			dev_dbg(&intf->dev, "got slave from IAD\n");
 		}
->>>>>>> linux-next/akpm-base
 	}
 
 	/* check if we got everything */
diff -puN drivers/net/virtio_net.c~linux-next-fit-rejects drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c~linux-next-fit-rejects
+++ a/drivers/net/virtio_net.c
@@ -1034,7 +1034,6 @@ static int virtnet_vlan_rx_kill_vid(stru
 }
 
 static void virtnet_clean_affinity(struct virtnet_info *vi, long hcpu)
-<<<<<<< HEAD
 {
 	int i;
 	int cpu;
@@ -1063,36 +1062,6 @@ static void virtnet_set_affinity(struct 
 {
 	int i;
 	int cpu;
-=======
-{
-	int i;
-	int cpu;
-
-	if (vi->affinity_hint_set) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtqueue_set_affinity(vi->rq[i].vq, -1);
-			virtqueue_set_affinity(vi->sq[i].vq, -1);
-		}
-
-		vi->affinity_hint_set = false;
-	}
-
-	i = 0;
-	for_each_online_cpu(cpu) {
-		if (cpu == hcpu) {
-			*per_cpu_ptr(vi->vq_index, cpu) = -1;
-		} else {
-			*per_cpu_ptr(vi->vq_index, cpu) =
-				++i % vi->curr_queue_pairs;
-		}
-	}
-}
-
-static void virtnet_set_affinity(struct virtnet_info *vi)
-{
-	int i;
-	int cpu;
->>>>>>> linux-next/akpm-base
 
 	/* In multiqueue mode, when the number of cpu is equal to the number of
 	 * queue pairs, we let the queue pairs to be private to one cpu by
diff -puN drivers/net/wireless/ath/ath9k/main.c~linux-next-fit-rejects drivers/net/wireless/ath/ath9k/main.c
--- a/drivers/net/wireless/ath/ath9k/main.c~linux-next-fit-rejects
+++ a/drivers/net/wireless/ath/ath9k/main.c
@@ -182,11 +182,7 @@ static void ath_restart_work(struct ath_
 	ath_start_ani(sc);
 }
 
-<<<<<<< HEAD
-static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
-=======
 static bool ath_prepare_reset(struct ath_softc *sc)
->>>>>>> linux-next/akpm-base
 {
 	struct ath_hw *ah = sc->sc_ah;
 	bool ret = true;
@@ -274,11 +270,7 @@ static int ath_reset_internal(struct ath
 		hchan = ah->curchan;
 	}
 
-<<<<<<< HEAD
-	if (!ath_prepare_reset(sc, retry_tx))
-=======
 	if (!ath_prepare_reset(sc))
->>>>>>> linux-next/akpm-base
 		fastcc = false;
 
 	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
@@ -802,11 +794,7 @@ static void ath9k_stop(struct ieee80211_
 		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
 	}
 
-<<<<<<< HEAD
-	ath_prepare_reset(sc, false);
-=======
 	ath_prepare_reset(sc);
->>>>>>> linux-next/akpm-base
 
 	if (sc->rx.frag) {
 		dev_kfree_skb_any(sc->rx.frag);
diff -puN include/linux/mfd/abx500/ab8500-bm.h~linux-next-fit-rejects include/linux/mfd/abx500/ab8500-bm.h
--- a/include/linux/mfd/abx500/ab8500-bm.h~linux-next-fit-rejects
+++ a/include/linux/mfd/abx500/ab8500-bm.h
@@ -441,9 +441,6 @@ int ab8500_fg_inst_curr_started(struct a
 int ab8500_fg_inst_curr_done(struct ab8500_fg *di);
 
 #else
-<<<<<<< HEAD
-static struct abx500_bm_data ab8500_bm_data;
-=======
 int ab8500_fg_inst_curr_started(struct ab8500_fg *di)
 {
 	return 0;
@@ -475,7 +472,6 @@ static int ab8500_fg_inst_curr_blocking(
 {
 	return -ENODEV;
 }
->>>>>>> linux-next/akpm-base
 
 static inline int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
 {
diff -puN net/netfilter/nf_conntrack_core.c~linux-next-fit-rejects net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c~linux-next-fit-rejects
+++ a/net/netfilter/nf_conntrack_core.c
@@ -1390,30 +1390,6 @@ void nf_conntrack_cleanup_net(struct net
 	free_percpu(net->ct.stat);
 }
 
-<<<<<<< HEAD
-/* Mishearing the voices in his head, our hero wonders how he's
-   supposed to kill the mall. */
-void nf_conntrack_cleanup(struct net *net)
-{
-	if (net_eq(net, &init_net))
-		RCU_INIT_POINTER(ip_ct_attach, NULL);
-
-	/* This makes sure all current packets have passed through
-	   netfilter framework.  Roll on, two-stage module
-	   delete... */
-	synchronize_net();
-	nf_conntrack_proto_fini(net);
-	nf_conntrack_cleanup_net(net);
-}
-
-void nf_conntrack_cleanup_end(void)
-{
-	RCU_INIT_POINTER(nf_ct_destroy, NULL);
-	nf_conntrack_cleanup_init_net();
-}
-
-=======
->>>>>>> linux-next/akpm-base
 void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 {
 	struct hlist_nulls_head *hash;
diff -puN net/netfilter/nf_conntrack_standalone.c~linux-next-fit-rejects net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c~linux-next-fit-rejects
+++ a/net/netfilter/nf_conntrack_standalone.c
@@ -593,12 +593,9 @@ static void __exit nf_conntrack_standalo
 {
 	nf_conntrack_cleanup_start();
 	unregister_pernet_subsys(&nf_conntrack_net_ops);
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_SYSCTL
 	unregister_net_sysctl_table(nf_ct_netfilter_header);
 #endif
->>>>>>> linux-next/akpm-base
 	nf_conntrack_cleanup_end();
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
linux-next-fit-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
userns-improve-uid-gid-map-collision-detection-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

