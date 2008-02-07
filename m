From: akpm@linux-foundation.org
Subject: - video-hpfbc-section-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:07 -0800
Message-ID: <200802070027.m170RmlU007084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933901AbYBGAo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     video/hpfb.c section fix
has been removed from the -mm tree.  Its filename was
     video-hpfbc-section-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video/hpfb.c section fix
From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0xb851a): Section mismatch: reference to .init.text:hpfb_init_one (between 'hpfb_dio_probe' and 'read_null')

hpfb_init_one() must be __devinit since it's called by the __devinit
hpfb_dio_probe().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hpfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/hpfb.c~video-hpfbc-section-fix drivers/video/hpfb.c
--- a/drivers/video/hpfb.c~video-hpfbc-section-fix
+++ a/drivers/video/hpfb.c
@@ -207,7 +207,8 @@ static struct fb_ops hpfb_ops = {
 #define HPFB_FBOMSB	0x5d	/* Frame buffer offset		*/
 #define HPFB_FBOLSB	0x5f
 
-static int __init hpfb_init_one(unsigned long phys_base, unsigned long virt_base)
+static int __devinit hpfb_init_one(unsigned long phys_base,
+				   unsigned long virt_base)
 {
 	unsigned long fboff, fb_width, fb_height, fb_start;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
