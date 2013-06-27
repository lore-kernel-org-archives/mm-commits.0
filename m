From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 27 Jun 2013 13:05:40 -0700
Message-ID: <51cc9b14.eaicqG7x7zVwfbCz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3F0UFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jun 2013 16:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Thu, 27 Jun 2013 13:05:40 -0700


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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

 arch/mips/mm/tlbex.c                      |    3 -
 drivers/net/ethernet/freescale/fec_main.c |    7 ---
 drivers/net/ethernet/renesas/sh_eth.c     |   18 ---------
 net/bluetooth/hci_core.c                  |    4 --
 net/wireless/nl80211.c                    |   38 --------------------
 5 files changed, 70 deletions(-)

diff -puN arch/mips/mm/tlbex.c~linux-next-git-rejects arch/mips/mm/tlbex.c
--- a/arch/mips/mm/tlbex.c~linux-next-git-rejects
+++ a/arch/mips/mm/tlbex.c
@@ -2259,7 +2259,6 @@ void __cpuinit build_tlb_refill_handler(
 			build_r4000_tlb_refill_handler();
 	}
 }
-<<<<<<< HEAD
 
 void __cpuinit flush_tlb_handlers(void)
 {
@@ -2272,5 +2271,3 @@ void __cpuinit flush_tlb_handlers(void)
 	local_flush_icache_range((unsigned long)tlbmiss_handler_setup_pgd,
 			   (unsigned long)tlbmiss_handler_setup_pgd_end);
 }
-=======
->>>>>>> 3f90b82df110ef9cb33761b56ca85ae0d0372d4a
diff -puN drivers/net/ethernet/freescale/fec_main.c~linux-next-git-rejects drivers/net/ethernet/freescale/fec_main.c
--- a/drivers/net/ethernet/freescale/fec_main.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/freescale/fec_main.c
@@ -1451,9 +1451,6 @@ static int fec_enet_set_pauseparam(struc
 	return 0;
 }
 
-<<<<<<< HEAD
-#endif /* !defined(CONFIG_M5272) */
-=======
 static const struct fec_stat {
 	char name[ETH_GSTRING_LEN];
 	u16 offset;
@@ -1564,7 +1561,6 @@ static int fec_enet_nway_reset(struct ne
 
 	return genphy_restart_aneg(phydev);
 }
->>>>>>> linux-next/akpm-base
 
 static const struct ethtool_ops fec_enet_ethtool_ops = {
 #if !defined(CONFIG_M5272)
@@ -2016,15 +2012,12 @@ fec_probe(struct platform_device *pdev)
 	    (pdev->id_entry->driver_data & FEC_QUIRK_HAS_GBIT))
 		fep->pause_flag |= FEC_PAUSE_FLAG_AUTONEG;
 #endif
-<<<<<<< HEAD
-=======
 
 	fep->hwp = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(fep->hwp)) {
 		ret = PTR_ERR(fep->hwp);
 		goto failed_ioremap;
 	}
->>>>>>> linux-next/akpm-base
 
 	fep->pdev = pdev;
 	fep->dev_id = dev_id++;
diff -puN drivers/net/ethernet/renesas/sh_eth.c~linux-next-git-rejects drivers/net/ethernet/renesas/sh_eth.c
--- a/drivers/net/ethernet/renesas/sh_eth.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/renesas/sh_eth.c
@@ -385,10 +385,7 @@ static struct sh_eth_cpu_data r8a777x_da
 	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE |
 			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE |
 			  EESR_ECI,
-<<<<<<< HEAD
 	.tx_error_check	= EESR_TWB | EESR_TABT | EESR_TDE | EESR_TFE,
-=======
->>>>>>> linux-next/akpm-base
 
 	.apr		= 1,
 	.mpr		= 1,
@@ -425,10 +422,7 @@ static struct sh_eth_cpu_data sh7724_dat
 	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE |
 			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE |
 			  EESR_ECI,
-<<<<<<< HEAD
 	.tx_error_check	= EESR_TWB | EESR_TABT | EESR_TDE | EESR_TFE,
-=======
->>>>>>> linux-next/akpm-base
 
 	.apr		= 1,
 	.mpr		= 1,
@@ -466,10 +460,7 @@ static struct sh_eth_cpu_data sh7757_dat
 	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE |
 			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE |
 			  EESR_ECI,
-<<<<<<< HEAD
 	.tx_error_check	= EESR_TWB | EESR_TABT | EESR_TDE | EESR_TFE,
-=======
->>>>>>> linux-next/akpm-base
 
 	.irq_flags	= IRQF_SHARED,
 	.apr		= 1,
@@ -539,11 +530,8 @@ static struct sh_eth_cpu_data sh7757_dat
 	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT |
 			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
 			  EESR_TDE | EESR_ECI,
-<<<<<<< HEAD
 	.tx_error_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_TDE | \
 			  EESR_TFE,
-=======
->>>>>>> linux-next/akpm-base
 	.fdr_value	= 0x0000072f,
 	.rmcr_value	= 0x00000001,
 
@@ -602,11 +590,8 @@ static struct sh_eth_cpu_data sh7734_dat
 	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT |
 			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
 			  EESR_TDE | EESR_ECI,
-<<<<<<< HEAD
 	.tx_error_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_TDE | \
 			  EESR_TFE,
-=======
->>>>>>> linux-next/akpm-base
 
 	.apr		= 1,
 	.mpr		= 1,
@@ -671,11 +656,8 @@ static struct sh_eth_cpu_data r8a7740_da
 	.eesr_err_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_RABT |
 			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
 			  EESR_TDE | EESR_ECI,
-<<<<<<< HEAD
 	.tx_error_check	= EESR_TWB1 | EESR_TWB | EESR_TABT | EESR_TDE | \
 			  EESR_TFE,
-=======
->>>>>>> linux-next/akpm-base
 
 	.apr		= 1,
 	.mpr		= 1,
diff -puN net/bluetooth/hci_core.c~linux-next-git-rejects net/bluetooth/hci_core.c
--- a/net/bluetooth/hci_core.c~linux-next-git-rejects
+++ a/net/bluetooth/hci_core.c
@@ -597,9 +597,6 @@ static void hci_init3_req(struct hci_req
 	struct hci_dev *hdev = req->hdev;
 	u8 p;
 
-<<<<<<< HEAD
-	/* Only send HCI_Delete_Stored_Link_Key if it is supported */
-=======
 	/* Some Broadcom based Bluetooth controllers do not support the
 	 * Delete Stored Link Key command. They are clearly indicating its
 	 * absence in the bit mask of supported commands.
@@ -609,7 +606,6 @@ static void hci_init3_req(struct hci_req
 	 * does not have actual support for stored link keys which makes this
 	 * command redundant anyway.
          */
->>>>>>> linux-next/akpm-base
 	if (hdev->commands[6] & 0x80) {
 		struct hci_cp_delete_stored_link_key cp;
 
diff -puN net/wireless/nl80211.c~linux-next-git-rejects net/wireless/nl80211.c
--- a/net/wireless/nl80211.c~linux-next-git-rejects
+++ a/net/wireless/nl80211.c
@@ -1564,43 +1564,6 @@ static int nl80211_dump_wiphy(struct sk_
 	int idx = 0, ret;
 	struct nl80211_dump_wiphy_state *state = (void *)cb->args[0];
 	struct cfg80211_registered_device *dev;
-<<<<<<< HEAD
-	s64 filter_wiphy = -1;
-	bool split = false;
-	struct nlattr **tb;
-	int res;
-
-	/* will be zeroed in nlmsg_parse() */
-	tb = kmalloc(sizeof(*tb) * (NL80211_ATTR_MAX + 1), GFP_KERNEL);
-	if (!tb)
-		return -ENOMEM;
-
-	mutex_lock(&cfg80211_mutex);
-	res = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-			  tb, NL80211_ATTR_MAX, nl80211_policy);
-	if (res == 0) {
-		split = tb[NL80211_ATTR_SPLIT_WIPHY_DUMP];
-		if (tb[NL80211_ATTR_WIPHY])
-			filter_wiphy = nla_get_u32(tb[NL80211_ATTR_WIPHY]);
-		if (tb[NL80211_ATTR_WDEV])
-			filter_wiphy = nla_get_u64(tb[NL80211_ATTR_WDEV]) >> 32;
-		if (tb[NL80211_ATTR_IFINDEX]) {
-			struct net_device *netdev;
-			int ifidx = nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
-
-			netdev = dev_get_by_index(sock_net(skb->sk), ifidx);
-			if (!netdev) {
-				mutex_unlock(&cfg80211_mutex);
-				kfree(tb);
-				return -ENODEV;
-			}
-			if (netdev->ieee80211_ptr) {
-				dev = wiphy_to_dev(
-					netdev->ieee80211_ptr->wiphy);
-				filter_wiphy = dev->wiphy_idx;
-			}
-			dev_put(netdev);
-=======
 
 	rtnl_lock();
 	if (!state) {
@@ -1615,7 +1578,6 @@ static int nl80211_dump_wiphy(struct sk_
 			kfree(state);
 			rtnl_unlock();
 			return ret;
->>>>>>> linux-next/akpm-base
 		}
 		cb->args[0] = (long)state;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix-fix-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

