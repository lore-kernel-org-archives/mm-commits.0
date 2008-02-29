From: akpm@linux-foundation.org
Subject: - ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch removed from -mm tree
Date: Fri, 29 Feb 2008 00:38:00 -0800
Message-ID: <200802290838.m1T8c0UX013781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbYB2IjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 03:39:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, jarkao2@gmail.com, linville@tuxdriver.com, tomas.winkler@intel.com, mm-commits@vger.kernel.org


The patch titled
     ieee80211: fix broken error handling in ieee80211_sta_process_addba_request()
has been removed from the -mm tree.  Its filename was
     ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ieee80211: fix broken error handling in ieee80211_sta_process_addba_request()
From: Adrian Bunk <bunk@kernel.org>

The Coverity checker spotted this buggy error handling added by
commit 07db218396650933abff3c5c1ad1e2a6e0cfedeb.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: "Tomas Winkler" <tomas.winkler@intel.com>
Cc: "Jarek Poplawski" <jarkao2@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/ieee80211_sta.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN net/mac80211/ieee80211_sta.c~ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request net/mac80211/ieee80211_sta.c
--- a/net/mac80211/ieee80211_sta.c~ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request
+++ a/net/mac80211/ieee80211_sta.c
@@ -1116,9 +1116,10 @@ static void ieee80211_sta_process_addba_
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
 		kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
-	if ((!tid_agg_rx->reorder_buf) && net_ratelimit()) {
-		printk(KERN_ERR "can not allocate reordering buffer "
-						"to tid %d\n", tid);
+	if (!tid_agg_rx->reorder_buf) {
+		if (net_ratelimit())
+			printk(KERN_ERR "cannot allocate reordering buffer "
+							"to tid %d\n", tid);
 		goto end;
 	}
 	memset(tid_agg_rx->reorder_buf, 0,
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
ipwireless-fix-potential-tty-==-null-dereference.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
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
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch

