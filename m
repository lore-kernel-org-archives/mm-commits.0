From: akpm@linux-foundation.org
Subject: - uvesafb-small-cleanups.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:41 -0800
Message-ID: <200802070028.m170SMaX007141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50338 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763508AbYBGAp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@pol.net, spock@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     uvesafb: small cleanups
has been removed from the -mm tree.  Its filename was
     uvesafb-small-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
