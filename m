From: akpm@linux-foundation.org
Subject: - kernel-taskstatsc-fix-bogus-nlmsg_free.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:10 -0800
Message-ID: <200711152111.lAFLBAnl015738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44725 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761954AbXKOVRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, balbir@linux.vnet.ibm, mm-commits@vger.kernel.org


The patch titled
     kernel/taskstats.c: fix bogus nlmsg_free()
has been removed from the -mm tree.  Its filename was
     kernel-taskstatsc-fix-bogus-nlmsg_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/taskstats.c: fix bogus nlmsg_free()
From: Adrian Bunk <bunk@kernel.org>

We'd better not nlmsg_free on a pointer containing an undefined value
(and without having anything allocated).

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN kernel/taskstats.c~kernel-taskstatsc-fix-bogus-nlmsg_free kernel/taskstats.c
--- a/kernel/taskstats.c~kernel-taskstatsc-fix-bogus-nlmsg_free
+++ a/kernel/taskstats.c
@@ -398,31 +398,31 @@ static int cgroupstats_user_cmd(struct s
 
 	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
 	file = fget_light(fd, &fput_needed);
-	if (file) {
-		size = nla_total_size(sizeof(struct cgroupstats));
+	if (!file)
+		return 0;
 
-		rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
-					size);
-		if (rc < 0)
-			goto err;
-
-		na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
-					sizeof(struct cgroupstats));
-		stats = nla_data(na);
-		memset(stats, 0, sizeof(*stats));
+	size = nla_total_size(sizeof(struct cgroupstats));
 
-		rc = cgroupstats_build(stats, file->f_dentry);
-		if (rc < 0)
-			goto err;
+	rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
+				size);
+	if (rc < 0)
+		goto err;
 
-		fput_light(file, fput_needed);
-		return send_reply(rep_skb, info->snd_pid);
+	na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
+				sizeof(struct cgroupstats));
+	stats = nla_data(na);
+	memset(stats, 0, sizeof(*stats));
+
+	rc = cgroupstats_build(stats, file->f_dentry);
+	if (rc < 0) {
+		nlmsg_free(rep_skb);
+		goto err;
 	}
 
+	rc = send_reply(rep_skb, info->snd_pid);
+
 err:
-	if (file)
-		fput_light(file, fput_needed);
-	nlmsg_free(rep_skb);
+	fput_light(file, fput_needed);
 	return rc;
 }
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-avr32.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-libata-all.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
always-export-pci_scan_single_device.patch
remove-additional-pci_scan_child_bus-prototype.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
git-x86.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
