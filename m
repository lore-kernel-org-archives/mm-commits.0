From: akpm@linux-foundation.org
Subject: [folded] fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:10:35 -0700
Message-ID: <200903312210.n2VMAaaT018478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757616AbZCaWMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kristoffer.ericson@gmail.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch

This patch was dropped because it was folded into fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#64: FILE: drivers/video/s1d13xxxfb.c:559:
+	u8 revision,prod_id;
 	           ^

WARNING: line over 80 characters
#97: FILE: drivers/video/s1d13xxxfb.c:648:
+		printk(KERN_INFO PFX "chip production id %i = %s\n", prod_id, s1d13xxxfb_prod_names[i]);

WARNING: line over 80 characters
#102: FILE: drivers/video/s1d13xxxfb.c:651:
+		printk(KERN_INFO PFX "unknown chip production id %i, revision %i\n", prod_id, revision);

total: 1 errors, 2 warnings, 78 lines checked

./patches/fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s1d13xxxfb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/video/s1d13xxxfb.c~fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes drivers/video/s1d13xxxfb.c
--- a/drivers/video/s1d13xxxfb.c~fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes
+++ a/drivers/video/s1d13xxxfb.c
@@ -556,7 +556,7 @@ s1d13xxxfb_probe(struct platform_device 
 	struct s1d13xxxfb_pdata *pdata = NULL;
 	int ret = 0;
 	int i;
-	u8 revision,prod_id;
+	u8 revision, prod_id;
 
 	dbg("probe called: device is %p\n", pdev);
 
@@ -645,10 +645,13 @@ s1d13xxxfb_probe(struct platform_device 
 	}
 
 	if (!ret) {
-		printk(KERN_INFO PFX "chip production id %i = %s\n", prod_id, s1d13xxxfb_prod_names[i]);
+		printk(KERN_INFO PFX "chip production id %i = %s\n",
+			prod_id, s1d13xxxfb_prod_names[i]);
 		printk(KERN_INFO PFX "chip revision %i\n", revision);
 	} else {
-		printk(KERN_INFO PFX "unknown chip production id %i, revision %i\n", prod_id, revision);
+		printk(KERN_INFO PFX
+			"unknown chip production id %i, revision %i\n",
+			prod_id, revision);
 		printk(KERN_INFO PFX "please contant maintainer\n");
 		goto bail;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page_fault-retry-with-nopage_retry.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage.patch
alpha-convert-u64-to-unsigned-long-long.patch
ubd-stop-defintining-major_nr.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi.patch
rtc-test-before-subtraction-on-unsigned.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo.patch
cirrusfb-fix-clock-doubling.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
simplify-copy_thread-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

