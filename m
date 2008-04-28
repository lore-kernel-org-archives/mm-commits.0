From: akpm@linux-foundation.org
Subject: - nv-fix-sparse-noise.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:15 -0700
Message-ID: <200804282159.m3SLxFnX018566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965444AbYD1V7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: nv: fix sparse noise
has been removed from the -mm tree.  Its filename was
     nv-fix-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: nv: fix sparse noise
From: Alexey Dobriyan <adobriyan@gmail.com>

Mostly signedness fixes.  nv10_sim_state existence in both drivers suggests
that one of them should be removed, but that's for later.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_hw.c    |    4 ++--
 drivers/video/nvidia/nv_setup.c |    4 ++--
 drivers/video/riva/nv_driver.c  |    2 +-
 drivers/video/riva/riva_hw.c    |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/video/nvidia/nv_hw.c~nv-fix-sparse-noise drivers/video/nvidia/nv_hw.c
--- a/drivers/video/nvidia/nv_hw.c~nv-fix-sparse-noise
+++ a/drivers/video/nvidia/nv_hw.c
@@ -129,7 +129,7 @@ typedef struct {
 	int nvclk_khz;
 	char mem_page_miss;
 	char mem_latency;
-	int memory_type;
+	u32 memory_type;
 	int memory_width;
 	char enable_video;
 	char gr_during_vid;
@@ -719,7 +719,7 @@ static void nForceUpdateArbitrationSetti
 	memctrl >>= 16;
 
 	if ((memctrl == 0x1A9) || (memctrl == 0x1AB) || (memctrl == 0x1ED)) {
-		int dimm[3];
+		u32 dimm[3];
 
 		dev = pci_get_bus_and_slot(0, 2);
 		pci_read_config_dword(dev, 0x40, &dimm[0]);
diff -puN drivers/video/nvidia/nv_setup.c~nv-fix-sparse-noise drivers/video/nvidia/nv_setup.c
--- a/drivers/video/nvidia/nv_setup.c~nv-fix-sparse-noise
+++ a/drivers/video/nvidia/nv_setup.c
@@ -265,12 +265,12 @@ static void nv10GetConfig(struct nvidia_
 
 	dev = pci_get_bus_and_slot(0, 1);
 	if ((par->Chipset & 0xffff) == 0x01a0) {
-		int amt = 0;
+		u32 amt;
 
 		pci_read_config_dword(dev, 0x7c, &amt);
 		par->RamAmountKBytes = (((amt >> 6) & 31) + 1) * 1024;
 	} else if ((par->Chipset & 0xffff) == 0x01f0) {
-		int amt = 0;
+		u32 amt;
 
 		pci_read_config_dword(dev, 0x84, &amt);
 		par->RamAmountKBytes = (((amt >> 4) & 127) + 1) * 1024;
diff -puN drivers/video/riva/nv_driver.c~nv-fix-sparse-noise drivers/video/riva/nv_driver.c
--- a/drivers/video/riva/nv_driver.c~nv-fix-sparse-noise
+++ a/drivers/video/riva/nv_driver.c
@@ -158,7 +158,7 @@ unsigned long riva_get_memlen(struct riv
 	unsigned long memlen = 0;
 	unsigned int chipset = par->Chipset;
 	struct pci_dev* dev;
-	int amt;
+	u32 amt;
 
 	switch (chip->Architecture) {
 	case NV_ARCH_03:
diff -puN drivers/video/riva/riva_hw.c~nv-fix-sparse-noise drivers/video/riva/riva_hw.c
--- a/drivers/video/riva/riva_hw.c~nv-fix-sparse-noise
+++ a/drivers/video/riva/riva_hw.c
@@ -231,7 +231,7 @@ typedef struct {
   int nvclk_khz;
   char mem_page_miss;
   char mem_latency;
-  int memory_type;
+  u32 memory_type;
   int memory_width;
   char enable_video;
   char gr_during_vid;
@@ -2107,7 +2107,7 @@ static void nv10GetConfig
 )
 {
     struct pci_dev* dev;
-    int amt;
+    u32 amt;
 
 #ifdef __BIG_ENDIAN
     /* turn on big endian register access */
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

