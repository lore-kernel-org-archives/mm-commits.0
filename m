From: akpm@linux-foundation.org
Subject: - hp_accel-do-not-call-acpi-from-invalid-context-fix.patch removed from -mm tree
Date: Thu, 15 Jan 2009 12:08:50 -0800
Message-ID: <200901152008.n0FK8pF5017372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932710AbZAOUJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 15:09:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eric.piel@tremplin-utc.net, lenb@kernel.org, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hp_accel-do-not-call-acpi-from-invalid-context-fix
has been removed from the -mm tree.  Its filename was
     hp_accel-do-not-call-acpi-from-invalid-context-fix.patch

This patch was dropped because it was folded into hp_accel-do-not-call-=
acpi-from-invalid-context.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hp_accel-do-not-call-acpi-from-invalid-context-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

use flush_work() rather than sort-of reimplementing it.

Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~hp_accel-do-not-call-acpi-from-inval=
id-context-fix drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp_accel-do-not-call-acpi-from-invalid-c=
ontext-fix
+++ a/drivers/hwmon/hp_accel.c
@@ -244,9 +244,7 @@ static int lis3lv02d_add(struct acpi_dev
=20
 	ret =3D lis3lv02d_init_device(&adev);
 	if (ret) {
-		while (work_pending(&hpled_led.work))
-			schedule();
-
+		flush_work(&hpled_led.work);
 		led_classdev_unregister(&hpled_led.led_classdev);
 		return ret;
 	}
@@ -262,8 +260,7 @@ static int lis3lv02d_remove(struct acpi_
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(device->handle);
=20
-	while (work_pending(&hpled_led.work))
-		schedule();
+	flush_work(&hpled_led.work);
 	led_classdev_unregister(&hpled_led.led_classdev);
=20
 	return lis3lv02d_remove_fs();
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
alpha-fix-vmalloc-breakage.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context.patch
hp_accel-do-not-call-acpi-from-invalid-context-fix.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.p=
atch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-f=
ixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build.pa=
tch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkp=
atch-fixes.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patc=
h
w1-build-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
