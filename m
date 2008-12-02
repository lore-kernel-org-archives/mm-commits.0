From: akpm@linux-foundation.org
Subject: + misc-add-dell-laptop-driver-fix.patch added to -mm tree
Date: Tue, 02 Dec 2008 11:52:20 -0800
Message-ID: <200812021952.mB2JqKwR015766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbYLBTyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 14:54:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Matt_Domsch@dell.com, greg@kroah.com, ivdoorn@gmail.com, lenb@kernel.org, mjg59@srcf.ucam.org, mjg@redhat.com, rpurdie@rpsys.net


The patch titled
     misc-add-dell-laptop-driver-fix
has been added to the -mm tree.  Its filename is
     misc-add-dell-laptop-driver-fix.patch

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
Subject: misc-add-dell-laptop-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

- use __packed

- make dell_device_table[] const

- fix error return in dell_init()

Cc: Greg KH <greg@kroah.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/dell-laptop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/misc/dell-laptop.c~misc-add-dell-laptop-driver-fix drivers/misc/dell-laptop.c
--- a/drivers/misc/dell-laptop.c~misc-add-dell-laptop-driver-fix
+++ a/drivers/misc/dell-laptop.c
@@ -34,7 +34,7 @@ struct calling_interface_buffer {
 	u16 select;
 	volatile u32 input[4];
 	volatile u32 output[4];
-} __attribute__ ((packed));
+} __packed;
 
 struct calling_interface_token {
 	u16 tokenID;
@@ -51,7 +51,7 @@ struct calling_interface_structure {
 	u8 cmdIOCode;
 	u32 supportedCmds;
 	struct calling_interface_token tokens[];
-} __attribute__ ((packed));
+} __packed;
 
 static int da_command_address;
 static int da_command_code;
@@ -63,7 +63,7 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
-static struct dmi_system_id __initdata dell_device_table[] = {
+static const struct dmi_system_id __initdata dell_device_table[] = {
 	{
 		.ident = "Dell laptop",
 		.matches = {
@@ -388,8 +388,8 @@ static int __init dell_init(void)
 			&dell_ops);
 
 		if (IS_ERR(dell_backlight_device)) {
-			dell_backlight_device = NULL;
 			ret = PTR_ERR(dell_backlight_device);
+			dell_backlight_device = NULL;
 			goto out;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bdi-register-sysfs-bdi-device-only-once-per-queue.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
pci-uninline-pci_ioremap_bar.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
misc-add-dell-laptop-driver-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
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

