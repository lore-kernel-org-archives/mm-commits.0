From: akpm@linux-foundation.org
Subject: - nv-drop-useless-config_pci-checks.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:13 -0700
Message-ID: <200804282159.m3SLxDoG018562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965441AbYD1V7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: nv: drop useless CONFIG_PCI checks
has been removed from the -mm tree.  Its filename was
     nv-drop-useless-config_pci-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: nv: drop useless CONFIG_PCI checks
From: Alexey Dobriyan <adobriyan@gmail.com>

Both FB_RIVA and FB_NVIDIA depends on PCI, so CONFIG_PCI always defined for
them.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c     |    4 ----
 drivers/video/riva/nv_driver.c |    5 -----
 2 files changed, 9 deletions(-)

diff -puN drivers/video/riva/fbdev.c~nv-drop-useless-config_pci-checks drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~nv-drop-useless-config_pci-checks
+++ a/drivers/video/riva/fbdev.c
@@ -56,10 +56,6 @@
 #include "rivafb.h"
 #include "nvreg.h"
 
-#ifndef CONFIG_PCI		/* sanity check */
-#error This driver requires PCI support.
-#endif
-
 /* version number of this driver */
 #define RIVAFB_VERSION "0.9.5b"
 
diff -puN drivers/video/riva/nv_driver.c~nv-drop-useless-config_pci-checks drivers/video/riva/nv_driver.c
--- a/drivers/video/riva/nv_driver.c~nv-drop-useless-config_pci-checks
+++ a/drivers/video/riva/nv_driver.c
@@ -41,11 +41,6 @@
 #include "rivafb.h"
 #include "nvreg.h"
 
-
-#ifndef CONFIG_PCI		/* sanity check */
-#error This driver requires PCI support.
-#endif
-
 #define PFX "rivafb: "
 
 static inline unsigned char MISCin(struct riva_par *par)
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

