From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-rtc-rtc-pcf2127c-hack.patch removed
 from -mm tree
Date: Thu, 22 Oct 2015 12:24:49 -0700
Message-ID: <56293801.zv8e0JRw0TUa0Lk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbbJVTYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Oct 2015 15:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.belloni@free-electrons.com, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf2127.c hack
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf2127c-hack.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rtc/rtc-pcf2127.c hack

Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2127.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf2127.c~drivers-rtc-rtc-pcf2127c-hack drivers/rtc/rtc-pcf2127.c
--- a/drivers/rtc/rtc-pcf2127.c~drivers-rtc-rtc-pcf2127c-hack
+++ a/drivers/rtc/rtc-pcf2127.c
@@ -145,6 +145,7 @@ static int pcf2127_rtc_ioctl(struct devi
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char buf = PCF2127_REG_CTRL3;
 	int ret;
+	int foo;
 
 	switch (cmd) {
 	case RTC_VL_READ:
@@ -162,7 +163,8 @@ static int pcf2127_rtc_ioctl(struct devi
 
 		buf = buf & PCF2127_REG_CTRL3_BLF ? 1 : 0;
 
-		if (copy_to_user((void __user *)arg, &buf, sizeof(int)))
+		foo = buf;	// ytf is an unsigned char called "buf"?
+		if (copy_to_user((void __user *)arg, &foo, sizeof(int)))
 			return -EFAULT;
 		return 0;
 	default:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-support-madvisemadv_free-vs-thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

