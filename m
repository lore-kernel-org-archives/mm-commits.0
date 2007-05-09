From: akpm@linux-foundation.org
Subject: + frame-buffer-geforce-7300-gt.patch added to -mm tree
Date: Tue, 08 May 2007 20:07:35 -0700
Message-ID: <200705090307.l4937ZjQ011202@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbXEIDHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, adaplas@pol.net


The patch titled
     frame buffer: geforce 7300 gt
has been added to the -mm tree.  Its filename is
     frame-buffer-geforce-7300-gt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: frame buffer: geforce 7300 gt
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

My geforce isn't supported by nvidia frame buffer.

/sbin/lspci
01:00.0 VGA compatible controller: nVidia Corporation Unknown device 02e2 (rev a2)

/usr/sbin/fbset -i

mode "1024x768-60"
    # D: 65.003 MHz, H: 48.365 kHz, V: 60.006 Hz
    geometry 1024 768 1024 32767 8
    timings 15384 160 24 29 3 136 6
    accel true
    rgba 8/0,8/0,8/0,0/0
endmode

Frame buffer device information:
    Name        : NV2e
    Address     : 0xe0000000
    Size        : 134217728
    Type        : PACKED PIXELS
    Visual      : PSEUDOCOLOR
    XPanStep    : 8
    YPanStep    : 1
    YWrapStep   : 0
    LineLength  : 1024
    MMIO Address: 0xf6000000
    MMIO Size   : 16777216
    Accelerator : Unknown (46)

Here is a patch for this problem.

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_hw.c  |    7 +++++--
 drivers/video/nvidia/nvidia.c |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/video/nvidia/nv_hw.c~frame-buffer-geforce-7300-gt drivers/video/nvidia/nv_hw.c
--- a/drivers/video/nvidia/nv_hw.c~frame-buffer-geforce-7300-gt
+++ a/drivers/video/nvidia/nv_hw.c
@@ -149,8 +149,7 @@ static void nvGetClocks(struct nvidia_pa
 		pll = NV_RD32(par->PMC, 0x4024);
 		M = pll & 0xFF;
 		N = (pll >> 8) & 0xFF;
-		if (((par->Chipset & 0xfff0) == 0x0290) ||
-				((par->Chipset & 0xfff0) == 0x0390)) {
+		if (((par->Chipset & 0xfff0) == 0x0290) || ((par->Chipset & 0xfff0) == 0x0390) || ((par->Chipset & 0xfff0) == 0x02E0)) {
 			MB = 1;
 			NB = 1;
 		} else {
@@ -963,6 +962,7 @@ void NVLoadStateExt(struct nvidia_par *p
 
 		if (((par->Chipset & 0xfff0) == 0x0090) ||
 		    ((par->Chipset & 0xfff0) == 0x01D0) ||
+		    ((par->Chipset & 0xfff0) == 0x02E0) ||
 		    ((par->Chipset & 0xfff0) == 0x0290))
 			regions = 15;
 		for(i = 0; i < regions; i++) {
@@ -1275,6 +1275,7 @@ void NVLoadStateExt(struct nvidia_par *p
 						0x00100000);
 					break;
 				case 0x0090:
+				case 0x02E0:
 				case 0x0290:
 					NV_WR32(par->PRAMDAC, 0x0608,
 						NV_RD32(par->PRAMDAC, 0x0608) |
@@ -1352,6 +1353,7 @@ void NVLoadStateExt(struct nvidia_par *p
 			} else {
 				if (((par->Chipset & 0xfff0) == 0x0090) ||
 				    ((par->Chipset & 0xfff0) == 0x01D0) ||
+				    ((par->Chipset & 0xfff0) == 0x02E0) ||
 				    ((par->Chipset & 0xfff0) == 0x0290)) {
 					for (i = 0; i < 60; i++) {
 						NV_WR32(par->PGRAPH,
@@ -1403,6 +1405,7 @@ void NVLoadStateExt(struct nvidia_par *p
 				} else {
 					if ((par->Chipset & 0xfff0) == 0x0090 ||
 					    (par->Chipset & 0xfff0) == 0x01D0 ||
+					    (par->Chipset & 0xfff0) == 0x02E0 ||
 					    (par->Chipset & 0xfff0) == 0x0290) {
 						NV_WR32(par->PGRAPH, 0x0DF0,
 							NV_RD32(par->PFB, 0x0200));
diff -puN drivers/video/nvidia/nvidia.c~frame-buffer-geforce-7300-gt drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~frame-buffer-geforce-7300-gt
+++ a/drivers/video/nvidia/nvidia.c
@@ -1243,6 +1243,7 @@ static u32 __devinit nvidia_get_arch(str
 	case 0x0140:		/* GeForce 6600 */
 	case 0x0160:		/* GeForce 6200 */
 	case 0x01D0:		/* GeForce 7200, 7300, 7400 */
+	case 0x02E0:		/* GeForce 7300 GT */
 	case 0x0090:		/* GeForce 7800 */
 	case 0x0210:		/* GeForce 6800 */
 	case 0x0220:		/* GeForce 6200 */
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-ia64.patch
git-kvm.patch
i386-irq-kill-irq-compression.patch
xfs-fix-unmount-race.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
frame-buffer-geforce-7300-gt.patch
