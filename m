From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 15 Jun 2017 10:16:56 -0700
Message-ID: <20170615171656.mT2l8ynAe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdFORQ5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 13:16:57 -0400
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


diff -puN drivers/hid/hid-core.c~linux-next-git-rejects drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~linux-next-git-rejects
+++ a/drivers/hid/hid-core.c
@@ -2068,15 +2068,10 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2) },
-<<<<<<< HEAD
-#endif
-#if IS_ENABLED(CONFIG_HID_ICADE)
-=======
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HUION, USB_DEVICE_ID_HUION_TABLET) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_ASUS_MD_5112) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD) },
->>>>>>> linux-next/akpm-base
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ION, USB_DEVICE_ID_ICADE) },
 #endif
 #if IS_ENABLED(CONFIG_HID_KENSINGTON)
@@ -2344,14 +2339,7 @@ static const struct hid_device_id hid_ha
 #endif
 #if IS_ENABLED(CONFIG_HID_TWINHAN)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TWINHAN, USB_DEVICE_ID_TWINHAN_IR_REMOTE) },
-<<<<<<< HEAD
-#endif
-#if IS_ENABLED(CONFIG_HID_UCLOGIC)
-	{ HID_USB_DEVICE(USB_VENDOR_ID_HUION, USB_DEVICE_ID_HUION_TABLET) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_HUION_TABLET) },
-=======
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_ASUS_MD_5110) },
->>>>>>> linux-next/akpm-base
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_PF1209) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP4030U) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_WP5540U) },
diff -puN drivers/net/ethernet/qlogic/qed/qed_debug.c~linux-next-git-rejects drivers/net/ethernet/qlogic/qed/qed_debug.c
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -3253,26 +3253,12 @@ static u32 qed_grc_dump_ctx_data(struct
 		return offset + total_size;
 
 	/* Dump context data */
-<<<<<<< HEAD
-	if (dump) {
-		for (lid = 0; lid < num_lids; lid++) {
-			for (i = 0; i < lid_size; i++, offset++) {
-				qed_wr(p_hwfn,
-				       p_ptt,
-				       s_storm_defs[storm_id].cm_ctx_wr_addr,
-				       (i << 9) | lid);
-				*(dump_buf + offset) = qed_rd(p_hwfn,
-							      p_ptt,
-							      rd_reg_addr);
-			}
-=======
 	for (lid = 0; lid < num_lids; lid++) {
 		for (i = 0; i < lid_size; i++, offset++) {
 			qed_wr(p_hwfn,
 			       p_ptt, storm->cm_ctx_wr_addr, (i << 9) | lid);
 			*(dump_buf + offset) = qed_rd(p_hwfn,
 						      p_ptt, rd_reg_addr);
->>>>>>> linux-next/akpm-base
 		}
 	}
 
diff -puN net/batman-adv/routing.c~linux-next-git-rejects net/batman-adv/routing.c
--- a/net/batman-adv/routing.c~linux-next-git-rejects
+++ a/net/batman-adv/routing.c
@@ -985,13 +985,8 @@ int batadv_recv_unicast_packet(struct sk
 			batadv_orig_node_put(orig_node_gw);
 			if (is_gw) {
 				batadv_dbg(BATADV_DBG_BLA, bat_priv,
-<<<<<<< HEAD
-					   "recv_unicast_packet(): Dropped unicast pkt received from another backbone gw %pM.\n",
-					   orig_addr_gw);
-=======
 					   "%s(): Dropped unicast pkt received from another backbone gw %pM.\n",
 					   __func__, orig_addr_gw);
->>>>>>> linux-next/akpm-base
 				goto free_skb;
 			}
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

