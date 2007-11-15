From: akpm@linux-foundation.org
Subject: - x86_64-efi-boot-support-efi-frame-buffer-v3.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:43:16 -0800
Message-ID: <200711150043.lAF0hGki001982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756709AbXKOAoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, adaplas@pol.net, ak@suse.de, mingo@elte.hu, mouli@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64-efi-boot-support-efi-frame-buffer v3
has been removed from the -mm tree.  Its filename was
     x86_64-efi-boot-support-efi-frame-buffer-v3.patch

This patch was dropped because it was folded into x86_64-efi-boot-support-efi-frame-buffer.patch

------------------------------------------------------
Subject: x86_64-efi-boot-support-efi-frame-buffer v3
From: "Huang, Ying" <ying.huang@intel.com>

This patch adds Graphics Output Protocol support to the kernel.
UEFI2.0 spec deprecates Universal Graphics Adapter (UGA) protocol and
only Graphics Output Protocol (GOP) is produced. Therefore, the boot
loader needs to query the UEFI firmware with appropriate Output
Protocol and pass the video information to the kernel. As a result of
GOP protocol, an EFI framebuffer driver is needed for displaying
console messages. The patch adds a EFI framebuffer driver. The EFI
frame buffer driver in this patch is based on the Intel Mac
framebuffer driver.

The ELILO bootloader takes care of passing the video information as
appropriate for EFI firmware.

The framebuffer driver has been tested in i386 kernel and x86_64
kernel on EFI platform.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/efifb.c       |    2 +-
 include/linux/screen_info.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/efifb.c~x86_64-efi-boot-support-efi-frame-buffer-v3 drivers/video/efifb.c
--- a/drivers/video/efifb.c~x86_64-efi-boot-support-efi-frame-buffer-v3
+++ a/drivers/video/efifb.c
@@ -1,5 +1,5 @@
 /*
- * framebuffer driver for EFI/UEFI based system
+ * Framebuffer driver for EFI/UEFI based system
  *
  * (c) 2006 Edgar Hucek <gimli@dark-green.com>
  * Original efi driver written by Gerd Knorr <kraxel@goldbach.in-berlin.de>
diff -puN include/linux/screen_info.h~x86_64-efi-boot-support-efi-frame-buffer-v3 include/linux/screen_info.h
--- a/include/linux/screen_info.h~x86_64-efi-boot-support-efi-frame-buffer-v3
+++ a/include/linux/screen_info.h
@@ -51,7 +51,6 @@ struct screen_info {
 #define VIDEO_TYPE_EGAC		0x21	/* EGA in Color Mode		*/
 #define VIDEO_TYPE_VGAC		0x22	/* VGA+ in Color Mode		*/
 #define VIDEO_TYPE_VLFB		0x23	/* VESA VGA in graphic mode	*/
-#define VIDEO_TYPE_EFI		0x24	/* EFI graphic mode		*/
 
 #define VIDEO_TYPE_PICA_S3	0x30	/* ACER PICA-61 local S3 video	*/
 #define VIDEO_TYPE_MIPS_G364	0x31    /* MIPS Magnum 4000 G364 video  */
@@ -64,6 +63,8 @@ struct screen_info {
 
 #define VIDEO_TYPE_PMAC		0x60	/* PowerMacintosh frame buffer. */
 
+#define VIDEO_TYPE_EFI		0x70	/* EFI graphic mode		*/
+
 #ifdef __KERNEL__
 extern struct screen_info screen_info;
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-frame-buffer-v3.patch
x86_64-efi-boot-support-efi-boot-document.patch
