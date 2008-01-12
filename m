From: akpm@linux-foundation.org
Subject: + uvesafb-fix-section-mismatch-warnings.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:12:08 -0800
Message-ID: <200801120112.m0C1C8UE007223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095AbYALBMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:12:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@pol.net


The patch titled
     uvesafb: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     uvesafb-fix-section-mismatch-warnings.patch

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
Subject: uvesafb: fix section mismatch warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Mark uvesafb_init_mtrr() as __devinit since its caller is __devinit
and since it accesses __devinitdata.

WARNING: vmlinux.o(.text+0x4df80e): Section mismatch: reference to .init.data: (between 'uvesafb_init_mtrr' and 'uvesafb_show_vbe_ver')

Variable 'blank' cannot be __devinitdata since it is referenced in an
fb_ops method that could be called at any time.

WARNING: vmlinux.o(.text+0x4dfc1e): Section mismatch: reference to .init.data:blank (between 'param_set_scroll' and 'vesa_setpalette')
WARNING: vmlinux.o(.text+0x4dfc24): Section mismatch: reference to .init.data:blank (between 'param_set_scroll' and 'vesa_setpalette')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-fix-section-mismatch-warnings drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-fix-section-mismatch-warnings
+++ a/drivers/video/uvesafb.c
@@ -43,7 +43,7 @@ static struct fb_fix_screeninfo uvesafb_
 };
 
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */
-static int blank	__devinitdata = 1; /* enable blanking by default */
+static int blank	= 1;		   /* enable blanking by default */
 static int ypan		__devinitdata = 1; /* 0: scroll, 1: ypan, 2: ywrap */
 static int pmi_setpal	__devinitdata = 1; /* use PMI for palette changes */
 static int nocrtc	__devinitdata; /* ignore CRTC settings */
@@ -1549,7 +1549,7 @@ static void __devinit uvesafb_init_info(
 		info->fbops->fb_pan_display = NULL;
 }
 
-static void uvesafb_init_mtrr(struct fb_info *info)
+static void __devinit uvesafb_init_mtrr(struct fb_info *info)
 {
 #ifdef CONFIG_MTRR
 	if (mtrr && !(info->fix.smem_start & (PAGE_SIZE - 1))) {
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
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
tdfxfb-fix-section-mismatch-warnings.patch
pm3fb-fix-section-mismatch-warnings.patch
