From: akpm@linux-foundation.org
Subject: + fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch added to -mm tree
Date: Fri, 05 Jun 2009 18:51:45 -0700
Message-ID: <200906060151.n561pjXV002530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbZFFBwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 21:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@redhat.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm, pjones@redhat.com


The patch titled
     fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#86: FILE: drivers/video/fbmem.c:1471:
+	if (gen->aperture_base > hw->aperture_base && gen->aperture_base <= hw->aperture_base + hw->aperture_size)

WARNING: line over 80 characters
#103: FILE: drivers/video/fbmem.c:1504:
+			if (fb_do_apertures_overlap(registered_fb[i], fb_info)) {

WARNING: printk() should include KERN_ facility level
#104: FILE: drivers/video/fbmem.c:1505:
+				printk("fb: conflicting fb hw usage %s vs %s - removing generic driver\n",

WARNING: line over 80 characters
#105: FILE: drivers/video/fbmem.c:1506:
+				       fb_info->fix.id, registered_fb[i]->fix.id);

total: 0 errors, 4 warnings, 143 lines checked

./patches/fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Airlie <airlied@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes
+++ a/drivers/video/fbmem.c
@@ -1502,8 +1502,10 @@ register_framebuffer(struct fb_info *fb_
 
 		if (registered_fb[i]->flags & FBINFO_MISC_FIRMWARE) {
 			if (fb_do_apertures_overlap(registered_fb[i], fb_info)) {
-				printk("fb: conflicting fb hw usage %s vs %s - removing generic driver\n",
-				       fb_info->fix.id, registered_fb[i]->fix.id);
+				printk(KERN_ERR "fb: conflicting fb hw usage "
+				       "%s vs %s - removing generic driver\n",
+				       fb_info->fix.id,
+				       registered_fb[i]->fix.id);
 				unregister_framebuffer(registered_fb[i]);
 				break;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
ds_selftest-is-borked.patch
eeepc-laptop-enable-camera-by-default-fix.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data-cleanup.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device-cleanup.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool-fix.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
gpio-driver-for-primecell-pl061-gpio-controller-fix.patch
gpio-driver-for-primecell-pl061-gpio-controller-fix-fix.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
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
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-fix.patch

