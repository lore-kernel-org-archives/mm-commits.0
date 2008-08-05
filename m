From: akpm@linux-foundation.org
Subject: + mm_initc-avoid-ifdef-inside-macro-expansion.patch added to -mm tree
Date: Tue, 05 Aug 2008 02:11:45 -0700
Message-ID: <200808050911.m759BjDO027069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755603AbYHEJL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 05:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bunk@kernel.org, mel@csn.ul.ie


The patch titled
     mm_init.c: avoid ifdef-inside-macro-expansion
has been added to the -mm tree.  Its filename is
     mm_initc-avoid-ifdef-inside-macro-expansion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm_init.c: avoid ifdef-inside-macro-expansion
From: Andrew Morton <akpm@linux-foundation.org>

gcc-3.2:

/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:77:1: directives may not be used inside a macro argument
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:76:47: unterminated argument list invoking macro "mminit_dprintk"
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c: In function `mminit_verify_pageflags_layout':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: `mminit_dprintk' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/mm_init.c:80: syntax error before numeric constant

Also fix a typo in a comment.

Reported-by: Adrian Bunk <bunk@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/mmzone.h~mm_initc-avoid-ifdef-inside-macro-expansion include/linux/mmzone.h
diff -puN mm/mm_init.c~mm_initc-avoid-ifdef-inside-macro-expansion mm/mm_init.c
--- a/mm/mm_init.c~mm_initc-avoid-ifdef-inside-macro-expansion
+++ a/mm/mm_init.c
@@ -14,6 +14,10 @@
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
 
+#ifndef SECTIONS_SHIFT
+#define SECTIONS_SHIFT	0
+#endif
+
 /* The zonelists are simply reported, validation is manual. */
 void mminit_verify_zonelist(void)
 {
@@ -74,11 +78,7 @@ void __init mminit_verify_pageflags_layo
 		NR_PAGEFLAGS);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
 		"Section %d Node %d Zone %d\n",
-#ifdef SECTIONS_SHIFT
 		SECTIONS_SHIFT,
-#else
-		0,
-#endif
 		NODES_SHIFT,
 		ZONES_SHIFT);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_offsets",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm_initc-avoid-ifdef-inside-macro-expansion.patch
pm_qos-spelling-fixes-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-hubc-fix-build-with-config_pm=n.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
h8300-generic_bug-support-checkpatch-fixes.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

