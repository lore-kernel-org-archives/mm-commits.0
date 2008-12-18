From: akpm@linux-foundation.org
Subject: + video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch added to -mm tree
Date: Wed, 17 Dec 2008 16:26:06 -0800
Message-ID: <200812180042.mBI0g3K6002967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbYLRAme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 19:42:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mjg59@srcf.ucam.org, rpurdie@rpsys.net, schwalbe@inf.tu-dresden.de


The patch titled
     video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix
has been added to the -mm tree.  Its filename is
     video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch

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
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-hrtimerc-kill-warning.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

