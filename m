From: akpm@linux-foundation.org
Subject: + pm3fb-fix-section-mismatch-warnings.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:12:54 -0800
Message-ID: <200801120112.m0C1CsOK007235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756962AbYALBNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:13:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@pol.net


The patch titled
     pm3fb: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     pm3fb-fix-section-mismatch-warnings.patch

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
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
