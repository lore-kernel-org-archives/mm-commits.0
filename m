From: akpm@linux-foundation.org
Subject: - nv-drop-useless-module-ifdefs.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:11 -0700
Message-ID: <200804282159.m3SLxBDa018559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965451AbYD1V7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: nv: drop useless MODULE ifdefs
has been removed from the -mm tree.  Its filename was
     nv-drop-useless-module-ifdefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: nv: drop useless MODULE ifdefs
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    3 ---
 drivers/video/riva/fbdev.c    |    2 --
 2 files changed, 5 deletions(-)

diff -puN drivers/video/nvidia/nvidia.c~nv-drop-useless-module-ifdefs drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nv-drop-useless-module-ifdefs
+++ a/drivers/video/nvidia/nvidia.c
@@ -1559,7 +1559,6 @@ static int __devinit nvidiafb_init(void)
 
 module_init(nvidiafb_init);
 
-#ifdef MODULE
 static void __exit nvidiafb_exit(void)
 {
 	pci_unregister_driver(&nvidiafb_driver);
@@ -1615,5 +1614,3 @@ MODULE_PARM_DESC(nomtrr, "Disables MTRR 
 MODULE_AUTHOR("Antonino Daplas");
 MODULE_DESCRIPTION("Framebuffer driver for nVidia graphics chipset");
 MODULE_LICENSE("GPL");
-#endif				/* MODULE */
-
diff -puN drivers/video/riva/fbdev.c~nv-drop-useless-module-ifdefs drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~nv-drop-useless-module-ifdefs
+++ a/drivers/video/riva/fbdev.c
@@ -2213,14 +2213,12 @@ static int __devinit rivafb_init(void)
 
 module_init(rivafb_init);
 
-#ifdef MODULE
 static void __exit rivafb_exit(void)
 {
 	pci_unregister_driver(&rivafb_driver);
 }
 
 module_exit(rivafb_exit);
-#endif /* MODULE */
 
 module_param(noaccel, bool, 0);
 MODULE_PARM_DESC(noaccel, "bool: disable acceleration");
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
remove-the-macro-get_personality.patch
ipmi-remove-write_proc-code.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

