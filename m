From: akpm@linux-foundation.org
Subject: - make-ds1511_rtc_readset_time-static.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:16 -0700
Message-ID: <200804282150.m3SLoGQP017459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934590AbYD1Vuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     make ds1511_rtc_{read,set}_time() static
has been removed from the -mm tree.  Its filename was
     make-ds1511_rtc_readset_time-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make ds1511_rtc_{read,set}_time() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global ds1511_rtc_{read,set}_time() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1511.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1511.c~make-ds1511_rtc_readset_time-static drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~make-ds1511_rtc_readset_time-static
+++ a/drivers/rtc/rtc-ds1511.c
@@ -181,8 +181,7 @@ ds1511_wdog_disable(void)
  * stupidly, some callers call with year unmolested;
  * and some call with  year = year - 1900.  thanks.
  */
- int
-ds1511_rtc_set_time(struct device *dev, struct rtc_time *rtc_tm)
+static int ds1511_rtc_set_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	u8 mon, day, dow, hrs, min, sec, yrs, cen;
 	unsigned int flags;
@@ -245,8 +244,7 @@ ds1511_rtc_set_time(struct device *dev, 
 	return 0;
 }
 
- int
-ds1511_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
+static int ds1511_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	unsigned int century;
 	unsigned int flags;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
arch-x86-video-fbdevc-add-module_license.patch
git-m32r.patch
git-nfsd.patch
git-ocfs2.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-pci.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
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
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
ipmi-make-alloc_recv_msg-static.patch
ipmi-fix-return-from-atca_oem_poweroff_hook.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
reiser4.patch

