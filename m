From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 17 Jul 2012 12:49:03 -0700
Message-ID: <20120717194904.ED3FC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43208 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab2GQTtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 15:49:08 -0400
Received: by eaao13 with SMTP id o13so47644eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 12:49:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


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

 drivers/net/usb/qmi_wwan.c              |    4 ----
 drivers/net/wireless/rt2x00/rt2x00usb.c |    7 -------
 net/batman-adv/bridge_loop_avoidance.c  |    5 -----
 net/batman-adv/bridge_loop_avoidance.h  |   22 ----------------------
 net/batman-adv/soft-interface.c         |   12 ------------
 5 files changed, 50 deletions(-)

diff -puN drivers/net/usb/qmi_wwan.c~linux-next-git-rejects drivers/net/usb/qmi_wwan.c
--- a/drivers/net/usb/qmi_wwan.c~linux-next-git-rejects
+++ a/drivers/net/usb/qmi_wwan.c
@@ -378,11 +378,7 @@ static const struct driver_info qmi_wwan
 	.description	= "Qualcomm WWAN/QMI device",
 	.flags		= FLAG_WWAN,
 	.bind		= qmi_wwan_bind_shared,
-<<<<<<< HEAD
-	.unbind		= qmi_wwan_unbind_shared,
-=======
 	.unbind		= qmi_wwan_unbind,
->>>>>>> linux-next/akpm-base
 	.manage_power	= qmi_wwan_manage_power,
 	.data		= BIT(2), /* interface whitelist bitmap */
 };
diff -puN drivers/net/wireless/rt2x00/rt2x00usb.c~linux-next-git-rejects drivers/net/wireless/rt2x00/rt2x00usb.c
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c~linux-next-git-rejects
+++ a/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -432,14 +432,7 @@ void rt2x00usb_kick_queue(struct data_qu
 		break;
 	case QID_RX:
 		if (!rt2x00queue_full(queue))
-<<<<<<< HEAD
-			rt2x00queue_for_each_entry(queue,
-						   Q_INDEX,
-						   Q_INDEX_DONE,
-						   NULL,
-=======
 			rt2x00queue_for_each_entry(queue, Q_INDEX, Q_INDEX_DONE,
->>>>>>> linux-next/akpm-base
 						   rt2x00usb_kick_rx_entry);
 		break;
 	default:
diff -puN net/batman-adv/bridge_loop_avoidance.c~linux-next-git-rejects net/batman-adv/bridge_loop_avoidance.c
--- a/net/batman-adv/bridge_loop_avoidance.c~linux-next-git-rejects
+++ a/net/batman-adv/bridge_loop_avoidance.c
@@ -1391,13 +1391,8 @@ void batadv_bla_free(struct batadv_priv 
  * returns 1, otherwise it returns 0 and the caller shall further
  * process the skb.
  */
-<<<<<<< HEAD
-int bla_rx(struct bat_priv *bat_priv, struct sk_buff *skb, short vid,
-	   bool is_bcast)
-=======
 int batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb, short vid,
 		  bool is_bcast)
->>>>>>> linux-next/akpm-base
 {
 	struct ethhdr *ethhdr;
 	struct batadv_claim search_claim, *claim = NULL;
diff -puN net/batman-adv/bridge_loop_avoidance.h~linux-next-git-rejects net/batman-adv/bridge_loop_avoidance.h
--- a/net/batman-adv/bridge_loop_avoidance.h~linux-next-git-rejects
+++ a/net/batman-adv/bridge_loop_avoidance.h
@@ -21,22 +21,6 @@
 #define _NET_BATMAN_ADV_BLA_H_
 
 #ifdef CONFIG_BATMAN_ADV_BLA
-<<<<<<< HEAD
-int bla_rx(struct bat_priv *bat_priv, struct sk_buff *skb, short vid,
-	   bool is_bcast);
-int bla_tx(struct bat_priv *bat_priv, struct sk_buff *skb, short vid);
-int bla_is_backbone_gw(struct sk_buff *skb,
-		       struct orig_node *orig_node, int hdr_size);
-int bla_claim_table_seq_print_text(struct seq_file *seq, void *offset);
-int bla_is_backbone_gw_orig(struct bat_priv *bat_priv, uint8_t *orig);
-int bla_check_bcast_duplist(struct bat_priv *bat_priv,
-			    struct bcast_packet *bcast_packet, int hdr_size);
-void bla_update_orig_address(struct bat_priv *bat_priv,
-			     struct hard_iface *primary_if,
-			     struct hard_iface *oldif);
-int bla_init(struct bat_priv *bat_priv);
-void bla_free(struct bat_priv *bat_priv);
-=======
 int batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb, short vid,
 		  bool is_bcast);
 int batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb, short vid);
@@ -52,19 +36,13 @@ void batadv_bla_update_orig_address(stru
 				    struct batadv_hard_iface *oldif);
 int batadv_bla_init(struct batadv_priv *bat_priv);
 void batadv_bla_free(struct batadv_priv *bat_priv);
->>>>>>> linux-next/akpm-base
 
 #define BATADV_BLA_CRC_INIT	0
 #else /* ifdef CONFIG_BATMAN_ADV_BLA */
 
-<<<<<<< HEAD
-static inline int bla_rx(struct bat_priv *bat_priv, struct sk_buff *skb,
-			 short vid, bool is_bcast)
-=======
 static inline int batadv_bla_rx(struct batadv_priv *bat_priv,
 				struct sk_buff *skb, short vid,
 				bool is_bcast)
->>>>>>> linux-next/akpm-base
 {
 	return 0;
 }
diff -puN net/batman-adv/soft-interface.c~linux-next-git-rejects net/batman-adv/soft-interface.c
--- a/net/batman-adv/soft-interface.c~linux-next-git-rejects
+++ a/net/batman-adv/soft-interface.c
@@ -267,20 +267,12 @@ void batadv_interface_rx(struct net_devi
 	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
 	struct ethhdr *ethhdr;
 	struct vlan_ethhdr *vhdr;
-<<<<<<< HEAD
-	struct batman_header *batadv_header = (struct batman_header *)skb->data;
-	short vid __maybe_unused = -1;
-	bool is_bcast;
-
-	is_bcast = (batadv_header->packet_type == BAT_BCAST);
-=======
 	struct batadv_header *batadv_header = (struct batadv_header *)skb->data;
 	short vid __maybe_unused = -1;
 	__be16 ethertype = __constant_htons(BATADV_ETH_P_BATMAN);
 	bool is_bcast;
 
 	is_bcast = (batadv_header->packet_type == BATADV_BCAST);
->>>>>>> linux-next/akpm-base
 
 	/* check if enough space is available for pulling, and pull */
 	if (!pskb_may_pull(skb, hdr_size))
@@ -327,11 +319,7 @@ void batadv_interface_rx(struct net_devi
 	/* Let the bridge loop avoidance check the packet. If will
 	 * not handle it, we can safely push it up.
 	 */
-<<<<<<< HEAD
-	if (bla_rx(bat_priv, skb, vid, is_bcast))
-=======
 	if (batadv_bla_rx(bat_priv, skb, vid, is_bcast))
->>>>>>> linux-next/akpm-base
 		goto out;
 
 	netif_rx(skb);
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fixes.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

