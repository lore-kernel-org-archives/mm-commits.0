From: akpm@linux-foundation.org
Subject: + uvesafb-small-cleanups.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:22:59 -0800
Message-ID: <200801120122.m0C1MxYD007574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756962AbYALBXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:23:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adaplas@pol.net, spock@gentoo.org


The patch titled
     uvesafb: small cleanups
has been added to the -mm tree.  Its filename is
     uvesafb-small-cleanups.patch

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
Subject: uvesafb: small cleanups
From: Randy Dunlap <randy.dunlap@oracle.com>

Some cleanups in uvesafb:
- The custom module_param() get/set functions don't need to be inlined
  since it is referred to via a pointer in a struct.
- don't end a #define with a ';'
- remove one of the single quote marks in "''ypan'"

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-small-cleanups drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-small-cleanups
+++ a/drivers/video/uvesafb.c
@@ -2003,12 +2003,12 @@ static void __devexit uvesafb_exit(void)
 
 module_exit(uvesafb_exit);
 
-static inline int param_get_scroll(char *buffer, struct kernel_param *kp)
+static int param_get_scroll(char *buffer, struct kernel_param *kp)
 {
 	return 0;
 }
 
-static inline int param_set_scroll(const char *val, struct kernel_param *kp)
+static int param_set_scroll(const char *val, struct kernel_param *kp)
 {
 	ypan = 0;
 
@@ -2022,11 +2022,11 @@ static inline int param_set_scroll(const
 	return 0;
 }
 
-#define param_check_scroll(name, p) __param_check(name, p, void);
+#define param_check_scroll(name, p) __param_check(name, p, void)
 
 module_param_named(scroll, ypan, scroll, 0);
 MODULE_PARM_DESC(scroll,
-	"Scrolling mode, set to 'redraw', ''ypan' or 'ywrap'");
+	"Scrolling mode, set to 'redraw', 'ypan', or 'ywrap'");
 module_param_named(vgapal, pmi_setpal, invbool, 0);
 MODULE_PARM_DESC(vgapal, "Set palette using VGA registers");
 module_param_named(pmipal, pmi_setpal, bool, 0);
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
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
