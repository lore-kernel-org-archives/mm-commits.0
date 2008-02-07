From: akpm@linux-foundation.org
Subject: - drivers-video-pm3fbc-section-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:27 -0800
Message-ID: <200802070028.m170S8UQ007120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933243AbYBGAph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, adaplas@gmail.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/video/pm3fb.c section fix
has been removed from the -mm tree.  Its filename was
     drivers-video-pm3fbc-section-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/pm3fb.c section fix
From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0x46e456): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e45c): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e49b): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4a0): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4bc): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4c2): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e5c1): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e5c7): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/pm3fb.c~drivers-video-pm3fbc-section-fix drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~drivers-video-pm3fbc-section-fix
+++ a/drivers/video/pm3fb.c
@@ -1227,7 +1227,7 @@ static struct fb_ops pm3fb_ops = {
 
 /* mmio register are already mapped when this function is called */
 /* the pm3fb_fix.smem_start is also set */
-static unsigned long pm3fb_size_memory(struct pm3_par *par)
+static unsigned long __devinit pm3fb_size_memory(struct pm3_par *par)
 {
 	unsigned long	memsize = 0;
 	unsigned long	tempBypass, i, temp1, temp2;
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
