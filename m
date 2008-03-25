From: akpm@linux-foundation.org
Subject: - the-scheduled-rc80211-simplec-removal.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:51 -0700
Message-ID: <200803250019.m2P0Jp1u032717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbYCYAVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:21:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     ] the scheduled rc80211-simple.c removal
has been removed from the -mm tree.  Its filename was
     the-scheduled-rc80211-simplec-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ] the scheduled rc80211-simple.c removal
From: Adrian Bunk <bunk@kernel.org>

The scheduled rc80211-simple.c removal.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   10 
 net/mac80211/Kconfig                       |   19 
 net/mac80211/Makefile                      |    2 
 net/mac80211/ieee80211.c                   |    9 
 net/mac80211/ieee80211_rate.h              |   15 
 net/mac80211/rc80211_simple.c              |  400 -------------------
 6 files changed, 1 insertion(+), 454 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~the-scheduled-rc80211-simplec-removal Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~the-scheduled-rc80211-simplec-removal
+++ a/Documentation/feature-removal-schedule.txt
@@ -223,16 +223,6 @@ Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
 
-What:	rc80211-simple rate control algorithm for mac80211
-When:	2.6.26
-Files:	net/mac80211/rc80211-simple.c
-Why:	This algorithm was provided for reference but always exhibited bad
-	responsiveness and performance and has some serious flaws. It has been
-	replaced by rc80211-pid.
-Who:	Stefano Brivio <stefano.brivio@polimi.it>
-
----------------------------
-
 What (Why):
 	- include/linux/netfilter_ipv4/ipt_TOS.h ipt_tos.h header files
 	  (superseded by xt_TOS/xt_tos target & match)
diff -puN net/mac80211/Kconfig~the-scheduled-rc80211-simplec-removal net/mac80211/Kconfig
--- a/net/mac80211/Kconfig~the-scheduled-rc80211-simplec-removal
+++ a/net/mac80211/Kconfig
@@ -32,15 +32,6 @@ config MAC80211_RC_DEFAULT_PID
 	  default rate control algorithm. You should choose
 	  this unless you know what you are doing.
 
-config MAC80211_RC_DEFAULT_SIMPLE
-	bool "Simple rate control algorithm"
-	select MAC80211_RC_SIMPLE
-	---help---
-	  Select the simple rate control as the default rate
-	  control algorithm. Note that this is a non-responsive,
-	  dumb algorithm. You should choose the PID rate control
-	  instead.
-
 config MAC80211_RC_DEFAULT_NONE
 	bool "No default algorithm"
 	depends on EMBEDDED
@@ -57,7 +48,6 @@ comment "build the algorithm into mac802
 config MAC80211_RC_DEFAULT
 	string
 	default "pid" if MAC80211_RC_DEFAULT_PID
-	default "simple" if MAC80211_RC_DEFAULT_SIMPLE
 	default ""
 
 config MAC80211_RC_PID
@@ -70,15 +60,6 @@ config MAC80211_RC_PID
 	  Say Y or M unless you're sure you want to use a
 	  different rate control algorithm.
 
-config MAC80211_RC_SIMPLE
-	tristate "Simple rate control algorithm (DEPRECATED)"
-	---help---
-	  This option enables a very simple, non-responsive TX
-	  rate control algorithm. This algorithm is deprecated
-	  and will be removed from the kernel in the near future.
-	  It has been replaced by the PID algorithm.
-
-	  Say N unless you know what you are doing.
 endmenu
 
 config MAC80211_LEDS
diff -puN net/mac80211/Makefile~the-scheduled-rc80211-simplec-removal net/mac80211/Makefile
--- a/net/mac80211/Makefile~the-scheduled-rc80211-simplec-removal
+++ a/net/mac80211/Makefile
@@ -39,9 +39,7 @@ mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
 
 
 # Build rate control algorithm(s)
-CFLAGS_rc80211_simple.o += -DRC80211_SIMPLE_COMPILE
 CFLAGS_rc80211_pid_algo.o += -DRC80211_PID_COMPILE
-mac80211-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
 mac80211-$(CONFIG_MAC80211_RC_PID) += $(rc-pid-$(CONFIG_MAC80211_RC_PID))
 
 # Modular rate algorithms are assigned to mac80211-m - make separate modules
diff -puN net/mac80211/ieee80211.c~the-scheduled-rc80211-simplec-removal net/mac80211/ieee80211.c
--- a/net/mac80211/ieee80211.c~the-scheduled-rc80211-simplec-removal
+++ a/net/mac80211/ieee80211.c
@@ -1345,13 +1345,9 @@ static int __init ieee80211_init(void)
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) > sizeof(skb->cb));
 
-	ret = rc80211_simple_init();
-	if (ret)
-		goto out;
-
 	ret = rc80211_pid_init();
 	if (ret)
-		goto out_cleanup_simple;
+		goto out;
 
 	ret = ieee80211_wme_register();
 	if (ret) {
@@ -1367,15 +1363,12 @@ static int __init ieee80211_init(void)
 
  out_cleanup_pid:
 	rc80211_pid_exit();
- out_cleanup_simple:
-	rc80211_simple_exit();
  out:
 	return ret;
 }
 
 static void __exit ieee80211_exit(void)
 {
-	rc80211_simple_exit();
 	rc80211_pid_exit();
 
 	ieee80211_wme_unregister();
diff -puN net/mac80211/ieee80211_rate.h~the-scheduled-rc80211-simplec-removal net/mac80211/ieee80211_rate.h
--- a/net/mac80211/ieee80211_rate.h~the-scheduled-rc80211-simplec-removal
+++ a/net/mac80211/ieee80211_rate.h
@@ -166,21 +166,6 @@ void rate_control_deinitialize(struct ie
 
 
 /* Rate control algorithms */
-#if defined(RC80211_SIMPLE_COMPILE) || \
-	(defined(CONFIG_MAC80211_RC_SIMPLE) && \
-	 !defined(CONFIG_MAC80211_RC_SIMPLE_MODULE))
-extern int rc80211_simple_init(void);
-extern void rc80211_simple_exit(void);
-#else
-static inline int rc80211_simple_init(void)
-{
-	return 0;
-}
-static inline void rc80211_simple_exit(void)
-{
-}
-#endif
-
 #if defined(RC80211_PID_COMPILE) || \
 	(defined(CONFIG_MAC80211_RC_PID) && \
 	 !defined(CONFIG_MAC80211_RC_PID_MODULE))
diff -puN net/mac80211/rc80211_simple.c~the-scheduled-rc80211-simplec-removal /dev/null
--- a/net/mac80211/rc80211_simple.c
+++ /dev/null
@@ -1,400 +0,0 @@
-/*
- * Copyright 2002-2005, Instant802 Networks, Inc.
- * Copyright 2005, Devicescape Software, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/init.h>
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/compiler.h>
-#include <linux/module.h>
-
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-#include "ieee80211_rate.h"
-#include "debugfs.h"
-
-
-/* This is a minimal implementation of TX rate controlling that can be used
- * as the default when no improved mechanisms are available. */
-
-#define RATE_CONTROL_NUM_DOWN 20
-#define RATE_CONTROL_NUM_UP   15
-
-#define RATE_CONTROL_EMERG_DEC 2
-#define RATE_CONTROL_INTERVAL (HZ / 20)
-#define RATE_CONTROL_MIN_TX 10
-
-static void rate_control_rate_inc(struct ieee80211_local *local,
-				  struct sta_info *sta)
-{
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
-	int i = sta->txrate;
-	int maxrate;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
-		/* forced unicast rate - do not change STA rate */
-		return;
-	}
-
-	mode = local->oper_hw_mode;
-	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
-
-	if (i > mode->num_rates)
-		i = mode->num_rates - 2;
-
-	while (i + 1 < mode->num_rates) {
-		i++;
-		if (sta->supp_rates & BIT(i) &&
-		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED &&
-		    (maxrate < 0 || i <= maxrate)) {
-			sta->txrate = i;
-			break;
-		}
-	}
-}
-
-
-static void rate_control_rate_dec(struct ieee80211_local *local,
-				  struct sta_info *sta)
-{
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
-	int i = sta->txrate;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
-		/* forced unicast rate - do not change STA rate */
-		return;
-	}
-
-	mode = local->oper_hw_mode;
-	if (i > mode->num_rates)
-		i = mode->num_rates;
-
-	while (i > 0) {
-		i--;
-		if (sta->supp_rates & BIT(i) &&
-		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED) {
-			sta->txrate = i;
-			break;
-		}
-	}
-}
-
-struct global_rate_control {
-	int dummy;
-};
-
-struct sta_rate_control {
-	unsigned long last_rate_change;
-	u32 tx_num_failures;
-	u32 tx_num_xmit;
-
-	unsigned long avg_rate_update;
-	u32 tx_avg_rate_sum;
-	u32 tx_avg_rate_num;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *tx_avg_rate_sum_dentry;
-	struct dentry *tx_avg_rate_num_dentry;
-#endif
-};
-
-
-static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
-					  struct sk_buff *skb,
-					  struct ieee80211_tx_status *status)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct sta_info *sta;
-	struct sta_rate_control *srctrl;
-
-	sta = sta_info_get(local, hdr->addr1);
-
-	if (!sta)
-	    return;
-
-	srctrl = sta->rate_ctrl_priv;
-	srctrl->tx_num_xmit++;
-	if (status->excessive_retries) {
-		srctrl->tx_num_failures++;
-		sta->tx_retry_failed++;
-		sta->tx_num_consecutive_failures++;
-		sta->tx_num_mpdu_fail++;
-	} else {
-		sta->last_ack_rssi[0] = sta->last_ack_rssi[1];
-		sta->last_ack_rssi[1] = sta->last_ack_rssi[2];
-		sta->last_ack_rssi[2] = status->ack_signal;
-		sta->tx_num_consecutive_failures = 0;
-		sta->tx_num_mpdu_ok++;
-	}
-	sta->tx_retry_count += status->retry_count;
-	sta->tx_num_mpdu_fail += status->retry_count;
-
-	if (time_after(jiffies,
-		       srctrl->last_rate_change + RATE_CONTROL_INTERVAL) &&
-		srctrl->tx_num_xmit > RATE_CONTROL_MIN_TX) {
-		u32 per_failed;
-		srctrl->last_rate_change = jiffies;
-
-		per_failed = (100 * sta->tx_num_mpdu_fail) /
-			(sta->tx_num_mpdu_fail + sta->tx_num_mpdu_ok);
-		/* TODO: calculate average per_failed to make adjusting
-		 * parameters easier */
-#if 0
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "MPDU fail=%d ok=%d per_failed=%d\n",
-			       sta->tx_num_mpdu_fail, sta->tx_num_mpdu_ok,
-			       per_failed);
-		}
-#endif
-
-		/*
-		 * XXX: Make these configurable once we have an
-		 * interface to the rate control algorithms
-		 */
-		if (per_failed > RATE_CONTROL_NUM_DOWN) {
-			rate_control_rate_dec(local, sta);
-		} else if (per_failed < RATE_CONTROL_NUM_UP) {
-			rate_control_rate_inc(local, sta);
-		}
-		srctrl->tx_avg_rate_sum += status->control.rate->rate;
-		srctrl->tx_avg_rate_num++;
-		srctrl->tx_num_failures = 0;
-		srctrl->tx_num_xmit = 0;
-	} else if (sta->tx_num_consecutive_failures >=
-		   RATE_CONTROL_EMERG_DEC) {
-		rate_control_rate_dec(local, sta);
-	}
-
-	if (srctrl->avg_rate_update + 60 * HZ < jiffies) {
-		srctrl->avg_rate_update = jiffies;
-		if (srctrl->tx_avg_rate_num > 0) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			DECLARE_MAC_BUF(mac);
-			printk(KERN_DEBUG "%s: STA %s Average rate: "
-			       "%d (%d/%d)\n",
-			       dev->name, print_mac(mac, sta->addr),
-			       srctrl->tx_avg_rate_sum /
-			       srctrl->tx_avg_rate_num,
-			       srctrl->tx_avg_rate_sum,
-			       srctrl->tx_avg_rate_num);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-			srctrl->tx_avg_rate_sum = 0;
-			srctrl->tx_avg_rate_num = 0;
-		}
-	}
-
-	sta_info_put(sta);
-}
-
-
-static void
-rate_control_simple_get_rate(void *priv, struct net_device *dev,
-			     struct ieee80211_hw_mode *mode,
-			     struct sk_buff *skb,
-			     struct rate_selection *sel)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_sub_if_data *sdata;
-	struct sta_info *sta;
-	int rateidx;
-	u16 fc;
-
-	sta = sta_info_get(local, hdr->addr1);
-
-	/* Send management frames and broadcast/multicast data using lowest
-	 * rate. */
-	fc = le16_to_cpu(hdr->frame_control);
-	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
-	    is_multicast_ether_addr(hdr->addr1) || !sta) {
-		sel->rate = rate_lowest(local, mode, sta);
-		if (sta)
-			sta_info_put(sta);
-		return;
-	}
-
-	/* If a forced rate is in effect, select it. */
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
-		sta->txrate = sdata->bss->force_unicast_rateidx;
-
-	rateidx = sta->txrate;
-
-	if (rateidx >= mode->num_rates)
-		rateidx = mode->num_rates - 1;
-
-	sta->last_txrate = rateidx;
-
-	sta_info_put(sta);
-
-	sel->rate = &mode->rates[rateidx];
-}
-
-
-static void rate_control_simple_rate_init(void *priv, void *priv_sta,
-					  struct ieee80211_local *local,
-					  struct sta_info *sta)
-{
-	struct ieee80211_hw_mode *mode;
-	int i;
-	sta->txrate = 0;
-	mode = local->oper_hw_mode;
-	/* TODO: This routine should consider using RSSI from previous packets
-	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
-	 * Until that method is implemented, we will use the lowest supported rate
-	 * as a workaround, */
-	for (i = 0; i < mode->num_rates; i++) {
-		if ((sta->supp_rates & BIT(i)) &&
-		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED)) {
-			sta->txrate = i;
-			break;
-		}
-	}
-}
-
-
-static void * rate_control_simple_alloc(struct ieee80211_local *local)
-{
-	struct global_rate_control *rctrl;
-
-	rctrl = kzalloc(sizeof(*rctrl), GFP_ATOMIC);
-
-	return rctrl;
-}
-
-
-static void rate_control_simple_free(void *priv)
-{
-	struct global_rate_control *rctrl = priv;
-	kfree(rctrl);
-}
-
-
-static void rate_control_simple_clear(void *priv)
-{
-}
-
-
-static void * rate_control_simple_alloc_sta(void *priv, gfp_t gfp)
-{
-	struct sta_rate_control *rctrl;
-
-	rctrl = kzalloc(sizeof(*rctrl), gfp);
-
-	return rctrl;
-}
-
-
-static void rate_control_simple_free_sta(void *priv, void *priv_sta)
-{
-	struct sta_rate_control *rctrl = priv_sta;
-	kfree(rctrl);
-}
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-
-static int open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
-static ssize_t sta_tx_avg_rate_sum_read(struct file *file,
-					char __user *userbuf,
-					size_t count, loff_t *ppos)
-{
-	struct sta_rate_control *srctrl = file->private_data;
-	char buf[20];
-
-	sprintf(buf, "%d\n", srctrl->tx_avg_rate_sum);
-	return simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
-}
-
-static const struct file_operations sta_tx_avg_rate_sum_ops = {
-	.read = sta_tx_avg_rate_sum_read,
-	.open = open_file_generic,
-};
-
-static ssize_t sta_tx_avg_rate_num_read(struct file *file,
-					char __user *userbuf,
-					size_t count, loff_t *ppos)
-{
-	struct sta_rate_control *srctrl = file->private_data;
-	char buf[20];
-
-	sprintf(buf, "%d\n", srctrl->tx_avg_rate_num);
-	return simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
-}
-
-static const struct file_operations sta_tx_avg_rate_num_ops = {
-	.read = sta_tx_avg_rate_num_read,
-	.open = open_file_generic,
-};
-
-static void rate_control_simple_add_sta_debugfs(void *priv, void *priv_sta,
-						struct dentry *dir)
-{
-	struct sta_rate_control *srctrl = priv_sta;
-
-	srctrl->tx_avg_rate_num_dentry =
-		debugfs_create_file("rc_simple_sta_tx_avg_rate_num", 0400,
-				    dir, srctrl, &sta_tx_avg_rate_num_ops);
-	srctrl->tx_avg_rate_sum_dentry =
-		debugfs_create_file("rc_simple_sta_tx_avg_rate_sum", 0400,
-				    dir, srctrl, &sta_tx_avg_rate_sum_ops);
-}
-
-static void rate_control_simple_remove_sta_debugfs(void *priv, void *priv_sta)
-{
-	struct sta_rate_control *srctrl = priv_sta;
-
-	debugfs_remove(srctrl->tx_avg_rate_sum_dentry);
-	debugfs_remove(srctrl->tx_avg_rate_num_dentry);
-}
-#endif
-
-static struct rate_control_ops mac80211_rcsimple = {
-	.name = "simple",
-	.tx_status = rate_control_simple_tx_status,
-	.get_rate = rate_control_simple_get_rate,
-	.rate_init = rate_control_simple_rate_init,
-	.clear = rate_control_simple_clear,
-	.alloc = rate_control_simple_alloc,
-	.free = rate_control_simple_free,
-	.alloc_sta = rate_control_simple_alloc_sta,
-	.free_sta = rate_control_simple_free_sta,
-#ifdef CONFIG_MAC80211_DEBUGFS
-	.add_sta_debugfs = rate_control_simple_add_sta_debugfs,
-	.remove_sta_debugfs = rate_control_simple_remove_sta_debugfs,
-#endif
-};
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Simple rate control algorithm");
-
-int __init rc80211_simple_init(void)
-{
-	return ieee80211_rate_control_register(&mac80211_rcsimple);
-}
-
-void rc80211_simple_exit(void)
-{
-	ieee80211_rate_control_unregister(&mac80211_rcsimple);
-}
-
-#ifdef CONFIG_MAC80211_RC_SIMPLE_MODULE
-module_init(rc80211_simple_init);
-module_exit(rc80211_simple_exit);
-#endif
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-udf.patch
git-net.patch
git-nfsd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch

