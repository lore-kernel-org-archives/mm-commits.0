From: akpm@linux-foundation.org
Subject: - isdn-rename-config_avmb1_compat-to-not-look-like-a-kconfig-variable.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:55 -0700
Message-ID: <200804282156.m3SLutvE018282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965098AbYD1V5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: rename CONFIG_AVMB1_COMPAT to not look like a Kconfig variable
has been removed from the -mm tree.  Its filename was
     isdn-rename-config_avmb1_compat-to-not-look-like-a-kconfig-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: rename CONFIG_AVMB1_COMPAT to not look like a Kconfig variable
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since CONFIG_AVMB1_COMPAT is not a Kconfig variable, move it out of the
Kconfig namespace.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/capi/kcapi.c~isdn-rename-config_avmb1_compat-to-not-look-like-a-kconfig-variable drivers/isdn/capi/kcapi.c
--- a/drivers/isdn/capi/kcapi.c~isdn-rename-config_avmb1_compat-to-not-look-like-a-kconfig-variable
+++ a/drivers/isdn/capi/kcapi.c
@@ -10,7 +10,7 @@
  *
  */
 
-#define CONFIG_AVMB1_COMPAT
+#define AVMB1_COMPAT
 
 #include "kcapi.h"
 #include <linux/module.h>
@@ -29,7 +29,7 @@
 #include <asm/uaccess.h>
 #include <linux/isdn/capicmd.h>
 #include <linux/isdn/capiutil.h>
-#ifdef CONFIG_AVMB1_COMPAT
+#ifdef AVMB1_COMPAT
 #include <linux/b1lli.h>
 #endif
 #include <linux/mutex.h>
@@ -740,7 +740,7 @@ u16 capi20_get_profile(u32 contr, struct
 
 EXPORT_SYMBOL(capi20_get_profile);
 
-#ifdef CONFIG_AVMB1_COMPAT
+#ifdef AVMB1_COMPAT
 static int old_capi_manufacturer(unsigned int cmd, void __user *data)
 {
 	avmb1_loadandconfigdef ldef;
@@ -904,7 +904,7 @@ int capi20_manufacturer(unsigned int cmd
         struct capi_ctr *card;
 
 	switch (cmd) {
-#ifdef CONFIG_AVMB1_COMPAT
+#ifdef AVMB1_COMPAT
 	case AVMB1_LOAD:
 	case AVMB1_LOAD_AND_CONFIG:
 	case AVMB1_RESETCARD:
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-mtd.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch
ipmi-make-comment-match-actual-preprocessor-check.patch
keys-explicitly-include-required-slabh-header-file.patch
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

