From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 18 Dec 2012 15:19:14 -0800
Message-ID: <20121218231915.188CC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52504 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2LRXTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:19:16 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so153184ggn.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:19:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe.jin@oracle.com, khali@linux-fr.org, zhenzhong.duan@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes

WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
#56: FILE: drivers/firmware/dmi_scan.c:426:
+				printk(KERN_INFO "SMBIOS %d.%d present.\n",

WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
#61: FILE: drivers/firmware/dmi_scan.c:431:
+				printk(KERN_INFO "Legacy DMI %d.%d present.\n",

WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
#85: FILE: drivers/firmware/dmi_scan.c:455:
+			printk(KERN_DEBUG "SMBIOS version fixup(2.%d->2.%d)\n",

WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
#90: FILE: drivers/firmware/dmi_scan.c:460:
+			printk(KERN_DEBUG "SMBIOS version fixup(2.%d->2.%d)\n",

total: 0 errors, 4 warnings, 104 lines checked

./patches/drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Feng Jin <joe.jin@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes
+++ a/drivers/firmware/dmi_scan.c
@@ -423,12 +423,12 @@ static int __init dmi_present(const char
 
 		if (dmi_walk_early(dmi_decode) == 0) {
 			if (dmi_ver)
-				printk(KERN_INFO "SMBIOS %d.%d present.\n",
+				pr_info("SMBIOS %d.%d present.\n",
 				       dmi_ver >> 8, dmi_ver & 0xFF);
 			else {
 				dmi_ver = (buf[14] & 0xF0) << 4 |
 					   (buf[14] & 0x0F);
-				printk(KERN_INFO "Legacy DMI %d.%d present.\n",
+				pr_info("Legacy DMI %d.%d present.\n",
 				       dmi_ver >> 8, dmi_ver & 0xFF);
 			}
 			dmi_dump_ids();
@@ -452,13 +452,12 @@ static int __init smbios_present(const c
 		switch (dmi_ver) {
 		case 0x021F:
 		case 0x0221:
-			printk(KERN_DEBUG "SMBIOS version fixup(2.%d->2.%d)\n",
+			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n",
 			       dmi_ver & 0xFF, 3);
 			dmi_ver = 0x0203;
 			break;
 		case 0x0233:
-			printk(KERN_DEBUG "SMBIOS version fixup(2.%d->2.%d)\n",
-			       51, 6);
+			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n", 51, 6);
 			dmi_ver = 0x0206;
 			break;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sendfile-allows-bypassing-of-notifier-events.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

