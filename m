From: akpm@linux-foundation.org
Subject: + nv-fix-sparse-noise.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:10:39 -0700
Message-ID: <200803242210.m2OMAdAo027907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbYCXWKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, adaplas@gmail.com


The patch titled
     fbdev: nv: fix sparse noise
has been added to the -mm tree.  Its filename is
     nv-fix-sparse-noise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

tags-add-menuconfig-symbols-as-well.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
likely_prof-changed-to-use-proc_create.patch

