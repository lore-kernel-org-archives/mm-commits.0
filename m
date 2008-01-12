From: akpm@linux-foundation.org
Subject: - pm3fb-fix-section-mismatch-warnings.patch removed from -mm tree
Date: Fri, 11 Jan 2008 17:22:20 -0800
Message-ID: <200801120122.m0C1MK5c007565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756709AbYALBWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:22:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     pm3fb: fix section mismatch warnings
has been removed from the -mm tree.  Its filename was
     pm3fb-fix-section-mismatch-warnings.patch

This patch was dropped because I already had it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm3fb: fix section mismatch warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Add __devinit to one function to clean up section mismatch warnings:

WARNING: vmlinux.o(.text+0x47c176): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47c188): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47c1ba): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47c1c1): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47c1e2): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47c1e9): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47c2f0): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47c2f7): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/pm3fb.c~pm3fb-fix-section-mismatch-warnings drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-fix-section-mismatch-warnings
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

Patches currently in -mm which might be from randy.dunlap@oracle.com are

scsi-qla2xxx-qla_osc-section-fix.patch
cciss-section-mismatch.patch
advansys-fix-section-mismatch-warning.patch
uvesafb-fix-section-mismatch-warnings.patch
git-dvb.patch
dvb-av7110-fix-section-mismatch.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
megaraid-fix-section-mismatch.patch
git-unionfs.patch
hostap-section-mismatch-warning.patch
git-ipwireless_cs.patch
git-x86.patch
x86-discover_ebda-section-mismatch.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
pm3fb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
