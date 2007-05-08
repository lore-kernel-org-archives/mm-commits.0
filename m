From: akpm@linux-foundation.org
Subject: + sm501fb-printk-warning-fixes.patch added to -mm tree
Date: Mon, 07 May 2007 23:06:30 -0700
Message-ID: <200705080606.l4866Upq015067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbXEHGGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 02:06:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adaplas@pol.net


The patch titled
     sm501fb-printk-warning-fixes
has been added to the -mm tree.  Its filename is
     sm501fb-printk-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sm501fb-printk-warning-fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/video/sm501fb.c: In function 'sm501fb_cursor':
drivers/video/sm501fb.c:992: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
drivers/video/sm501fb.c:992: warning: format '%08x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/sm501fb.c~sm501fb-printk-warning-fixes drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-printk-warning-fixes
+++ a/drivers/video/sm501fb.c
@@ -989,7 +989,7 @@ static int sm501fb_cursor(struct fb_info
 			((info->cmap.green[fg_col] & 0xFC) << 3) |
 			((info->cmap.blue[fg_col] & 0xF8) >> 3);
 
-		dev_dbg(fbi->dev, "fgcol %08x, bgcol %08x\n", fg, bg);
+		dev_dbg(fbi->dev, "fgcol %08lx, bgcol %08lx\n", fg, bg);
 
 		writel(bg, base + SM501_OFF_HWC_COLOR_1_2);
 		writel(fg, base + SM501_OFF_HWC_COLOR_3);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others.patch
rtc-add-rtc-rs5c313-driver.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
parport-dev-driver-model-support.patch
add-support-for-deferrable-timers-respun.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
fix-kevents-childs-priority-greediness.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
enhance-initcall_debug-measure-latency.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
consolidate-asm-consth-to-linux-consth.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
speedup-divides-by-cpu_power-in-scheduler.patch
utimensat-implementation.patch
revert-rtc-add-rtc_merge_alarm.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-probe-cleanup.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
cirrusfb-convert-to-generic-boolean.patch
sm501fb-printk-warning-fixes.patch
