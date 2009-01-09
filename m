From: akpm@linux-foundation.org
Subject: - video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch removed from -mm tree
Date: Fri, 09 Jan 2009 11:57:14 -0800
Message-ID: <200901091957.n09JvEMe030391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbZAIT6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 14:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mjg59@srcf.ucam.org, rpurdie@rpsys.net, schwalbe@inf.tu-dresden.de, mm-commits@vger.kernel.org


The patch titled
     video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix
has been removed from the -mm tree.  Its filename was
     video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch

This patch was dropped because it was folded into video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/video/backlight/mbp_nvidia_bl.c:135: error: conflicting types for 'dmi_match'
include/linux/dmi.h:50: error: previous declaration of 'dmi_match' was here

Cc: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -102,7 +102,7 @@ static const struct dmi_match_data nvidi
  */
 static /* const */ struct dmi_match_data *driver_data;
 
-static int dmi_match(const struct dmi_system_id *id)
+static int mbp_dmi_match(const struct dmi_system_id *id)
 {
 	driver_data = id->driver_data;
 
@@ -112,7 +112,7 @@ static int dmi_match(const struct dmi_sy
 
 static const struct dmi_system_id __initdata mbp_device_table[] = {
 	{
-		.callback	= dmi_match,
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookPro 3,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
@@ -121,7 +121,7 @@ static const struct dmi_system_id __init
 		.driver_data	= (void *)&intel_chipset_data,
 	},
 	{
-		.callback	= dmi_match,
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookPro 3,2",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
@@ -130,7 +130,7 @@ static const struct dmi_system_id __init
 		.driver_data	= (void *)&intel_chipset_data,
 	},
 	{
-		.callback	= dmi_match,
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookPro 4,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
@@ -139,7 +139,7 @@ static const struct dmi_system_id __init
 		.driver_data	= (void *)&intel_chipset_data,
 	},
 	{
-		.callback	= dmi_match,
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBook 5,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
@@ -148,7 +148,7 @@ static const struct dmi_system_id __init
 		.driver_data	= (void *)&nvidia_chipset_data,
 	},
 	{
-		.callback	= dmi_match,
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookAir 2,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
@@ -157,7 +157,7 @@ static const struct dmi_system_id __init
 		.driver_data	= (void *)&nvidia_chipset_data,
 	},
 	{
-		.callback	= dmi_match,
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookPro 5,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
kernel-trace-ring_bufferc-use-div_round_up-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

