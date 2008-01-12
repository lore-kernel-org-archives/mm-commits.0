From: akpm@linux-foundation.org
Subject: + tdfxfb-fix-section-mismatch-warnings.patch added to -mm tree
Date: Sat, 12 Jan 2008 03:54:11 -0800
Message-ID: <200801121153.m0CBrph1028267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760975AbYALLyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jan 2008 06:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@pol.net, krzysztof.h1@poczta.fm


The patch titled
     tdfxfb: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     tdfxfb-fix-section-mismatch-warnings.patch

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
Subject: tdfxfb: fix section mismatch warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

tdfxfb_setup() can be __init.  This fixes the modpost section mismatch
warnings:

WARNING: vmlinux.o(.text+0x4cff9b): Section mismatch: reference to .init.data:mode_option (between 'tdfxfb_setup' and 'getclkMHz')
WARNING: vmlinux.o(.text+0x4cffa8): Section mismatch: reference to .init.data: (between 'tdfxfb_setup' and 'getclkMHz')

[krzysztof.h1@poczta.fm: use __init, not __devinit]
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-fix-section-mismatch-warnings drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-fix-section-mismatch-warnings
+++ a/drivers/video/tdfxfb.c
@@ -1342,7 +1342,7 @@ out_err:
 }
 
 #ifndef MODULE
-static void tdfxfb_setup(char *options)
+static void __init tdfxfb_setup(char *options)
 {
 	char *this_opt;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

scsi-qla2xxx-qla_osc-section-fix.patch
cciss-section-mismatch.patch
advansys-fix-section-mismatch-warning.patch
uvesafb-fix-section-mismatch-warnings.patch
driver-core-build-with-sysfs=n.patch
sysfs-make-sysfs_deprecated-depend-on-sysfs.patch
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
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
