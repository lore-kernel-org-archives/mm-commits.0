From: akpm@linux-foundation.org
Subject: + regulator-minor-cleanup-of-virtual-consumer-fix.patch added to -mm tree
Date: Thu, 15 Jan 2009 16:13:17 -0800
Message-ID: <200901160013.n0G0DHQP007410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593AbZAPANb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 19:13:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, dbrownell@users.sourceforge.net, lrg@slimlogic.co.uk


The patch titled
     regulator-minor-cleanup-of-virtual-consumer-fix
has been added to the -mm tree.  Its filename is
     regulator-minor-cleanup-of-virtual-consumer-fix.patch

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
Subject: regulator-minor-cleanup-of-virtual-consumer-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/virtual.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/regulator/virtual.c~regulator-minor-cleanup-of-virtual-consumer-fix drivers/regulator/virtual.c
--- a/drivers/regulator/virtual.c~regulator-minor-cleanup-of-virtual-consumer-fix
+++ a/drivers/regulator/virtual.c
@@ -226,6 +226,10 @@ static ssize_t set_mode(struct device *d
 	unsigned int mode;
 	int ret;
 
+	/*
+	 * sysfs_streq() doesn't need the \n's, but we add them so the strings
+	 * will be shared with show_mode(), above.
+	 */
 	if (sysfs_streq(buf, "fast\n") == 0)
 		mode = REGULATOR_MODE_FAST;
 	else if (sysfs_streq(buf, "normal\n") == 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-fix-vmalloc-breakage.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
serial-add-supraexpress-336i-pnp-voice-modem-fix.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
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
w1-build-fix.patch

