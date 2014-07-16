From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 16 Jul 2014 13:31:43 -0700
Message-ID: <53c6e12f.VcKbw3QyhhPs0Z3l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:58977 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaGPUbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 16:31:44 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so102199pdj.2
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 13:31:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


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

 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    3 -
 drivers/net/wireless/iwlwifi/mvm/scan.c     |   38 ------------------
 net/bluetooth/smp.c                         |   27 ------------
 sound/pci/hda/hda_intel.c                   |   20 ---------
 4 files changed, 88 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/mvm/mac80211.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/mvm/mac80211.c
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -328,12 +328,9 @@ int iwl_mvm_mac_setup_register(struct iw
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 	}
 
-<<<<<<< HEAD
-=======
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
 		hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
 
->>>>>>> linux-next/akpm-base
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
 	hw->chanctx_data_size = sizeof(u16);
diff -puN net/bluetooth/smp.c~linux-next-git-rejects net/bluetooth/smp.c
--- a/net/bluetooth/smp.c~linux-next-git-rejects
+++ a/net/bluetooth/smp.c
@@ -391,19 +391,12 @@ static const u8 gen_method[5][5] = {
 
 static u8 get_auth_method(struct smp_chan *smp, u8 local_io, u8 remote_io)
 {
-<<<<<<< HEAD
-	/* If either side has unknown io_caps, use JUST WORKS */
-	if (local_io > SMP_IO_KEYBOARD_DISPLAY ||
-	    remote_io > SMP_IO_KEYBOARD_DISPLAY)
-		return JUST_WORKS;
-=======
 	/* If either side has unknown io_caps, use JUST_CFM (which gets
 	 * converted later to JUST_WORKS if we're initiators.
 	 */
 	if (local_io > SMP_IO_KEYBOARD_DISPLAY ||
 	    remote_io > SMP_IO_KEYBOARD_DISPLAY)
 		return JUST_CFM;
->>>>>>> linux-next/akpm-base
 
 	return gen_method[remote_io][local_io];
 }
@@ -423,18 +416,6 @@ static int tk_request(struct l2cap_conn
 
 	BT_DBG("tk_request: auth:%d lcl:%d rem:%d", auth, local_io, remote_io);
 
-<<<<<<< HEAD
-	/* If neither side wants MITM, use JUST WORKS */
-	/* Otherwise, look up method from the table */
-	if (!(auth & SMP_AUTH_MITM))
-		method = JUST_WORKS;
-	else
-		method = get_auth_method(smp, local_io, remote_io);
-
-	/* If not bonding, don't ask user to confirm a Zero TK */
-	if (!(auth & SMP_AUTH_BONDING) && method == JUST_CFM)
-		method = JUST_WORKS;
-=======
 	/* If neither side wants MITM, either "just" confirm an incoming
 	 * request or use just-works for outgoing ones. The JUST_CFM
 	 * will be converted to JUST_WORKS if necessary later in this
@@ -445,7 +426,6 @@ static int tk_request(struct l2cap_conn
 		method = JUST_CFM;
 	else
 		method = get_auth_method(smp, local_io, remote_io);
->>>>>>> linux-next/akpm-base
 
 	/* Don't confirm locally initiated pairing attempts */
 	if (method == JUST_CFM && test_bit(SMP_FLAG_INITIATOR, &smp->flags))
@@ -927,12 +907,9 @@ static u8 smp_cmd_security_req(struct l2
 		return SMP_CMD_NOTSUPP;
 
 	sec_level = authreq_to_seclevel(rp->auth_req);
-<<<<<<< HEAD
-=======
 	if (smp_sufficient_security(hcon, sec_level))
 		return 0;
 
->>>>>>> linux-next/akpm-base
 	if (sec_level > hcon->pending_sec_level)
 		hcon->pending_sec_level = sec_level;
 
@@ -984,11 +961,7 @@ int smp_conn_security(struct hci_conn *h
 	if (sec_level > hcon->pending_sec_level)
 		hcon->pending_sec_level = sec_level;
 
-<<<<<<< HEAD
-	if (hcon->link_mode & HCI_LM_MASTER)
-=======
 	if (test_bit(HCI_CONN_MASTER, &hcon->flags))
->>>>>>> linux-next/akpm-base
 		if (smp_ltk_encrypt(conn, hcon->pending_sec_level))
 			return 0;
 
diff -puN sound/pci/hda/hda_intel.c~linux-next-git-rejects sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~linux-next-git-rejects
+++ a/sound/pci/hda/hda_intel.c
@@ -776,11 +776,7 @@ static int azx_suspend(struct device *de
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 	struct azx_pcm *p;
 
-<<<<<<< HEAD
-	if (chip->disabled || chip->init_failed)
-=======
 	if (chip->disabled || hda->init_failed)
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
@@ -813,11 +809,7 @@ static int azx_resume(struct device *dev
 	struct azx *chip = card->private_data;
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 
-<<<<<<< HEAD
-	if (chip->disabled || chip->init_failed)
-=======
 	if (chip->disabled || hda->init_failed)
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
@@ -855,11 +847,7 @@ static int azx_runtime_suspend(struct de
 	struct azx *chip = card->private_data;
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 
-<<<<<<< HEAD
-	if (chip->disabled || chip->init_failed)
-=======
 	if (chip->disabled || hda->init_failed)
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
@@ -887,11 +875,7 @@ static int azx_runtime_resume(struct dev
 	struct hda_codec *codec;
 	int status;
 
-<<<<<<< HEAD
-	if (chip->disabled || chip->init_failed)
-=======
 	if (chip->disabled || hda->init_failed)
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
@@ -929,11 +913,7 @@ static int azx_runtime_idle(struct devic
 	struct azx *chip = card->private_data;
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 
-<<<<<<< HEAD
-	if (chip->disabled || chip->init_failed)
-=======
 	if (chip->disabled || hda->init_failed)
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	if (!power_save_controller ||
diff -puN drivers/net/wireless/iwlwifi/mvm/scan.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/mvm/scan.c
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -711,22 +711,6 @@ static void iwl_build_channel_cfg(struct
 				  u32 ssid_bitmap,
 				  struct iwl_mvm_scan_params *params)
 {
-<<<<<<< HEAD
-	int i, index = 0;
-
-	for (i = 0; i < req->n_channels; i++) {
-		struct ieee80211_channel *chan = req->channels[i];
-
-		if (chan->band != band)
-			continue;
-
-		index = *head;
-		(*head)++;
-
-		channels->channel_number[index] = cpu_to_le16(chan->hw_value);
-		channels->dwell_time[index][0] = params->dwell[band].active;
-		channels->dwell_time[index][1] = params->dwell[band].passive;
-=======
 	u32 n_channels = mvm->fw->ucode_capa.n_scan_channels;
 	__le32 *type = (__le32 *)channels_buffer;
 	__le16 *channel_number = (__le16 *)(type + n_channels);
@@ -748,23 +732,11 @@ static void iwl_build_channel_cfg(struct
 		channel_number[index] = cpu_to_le16(chan->hw_value);
 		active_dwell[index] = params->dwell[band].active;
 		passive_dwell[index] = params->dwell[band].passive;
->>>>>>> linux-next/akpm-base
 
 		iter_count[index] = cpu_to_le16(1);
 		iter_interval[index] = 0;
 
 		if (!(chan->flags & IEEE80211_CHAN_NO_IR))
-<<<<<<< HEAD
-			channels->type[index] |=
-				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_ACTIVE);
-
-		channels->type[index] |=
-				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_FULL |
-					    IWL_SCAN_OFFLOAD_CHANNEL_PARTIAL);
-
-		if (chan->flags & IEEE80211_CHAN_NO_HT40)
-			channels->type[index] |=
-=======
 			type[index] |=
 				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_ACTIVE);
 
@@ -773,7 +745,6 @@ static void iwl_build_channel_cfg(struct
 
 		if (chan->flags & IEEE80211_CHAN_NO_HT40)
 			type[index] |=
->>>>>>> linux-next/akpm-base
 				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_NARROW);
 
 		/* scan for all SSIDs from req->ssids */
@@ -826,13 +797,8 @@ int iwl_mvm_config_sched_scan(struct iwl
 		iwl_scan_offload_build_tx_cmd(mvm, vif, ies,
 					      IEEE80211_BAND_2GHZ,
 					      &scan_cfg->scan_cmd.tx_cmd[0],
-<<<<<<< HEAD
-					      scan_cfg->data);
-		iwl_build_channel_cfg(mvm, req, &scan_cfg->channel_cfg,
-=======
 					      probes);
 		iwl_build_channel_cfg(mvm, req, scan_cfg->data,
->>>>>>> linux-next/akpm-base
 				      IEEE80211_BAND_2GHZ, &head,
 				      ssid_bitmap, &params);
 	}
@@ -842,11 +808,7 @@ int iwl_mvm_config_sched_scan(struct iwl
 					      &scan_cfg->scan_cmd.tx_cmd[1],
 					      probes +
 						SCAN_OFFLOAD_PROBE_REQ_SIZE);
-<<<<<<< HEAD
-		iwl_build_channel_cfg(mvm, req, &scan_cfg->channel_cfg,
-=======
 		iwl_build_channel_cfg(mvm, req, scan_cfg->data,
->>>>>>> linux-next/akpm-base
 				      IEEE80211_BAND_5GHZ, &head,
 				      ssid_bitmap, &params);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

