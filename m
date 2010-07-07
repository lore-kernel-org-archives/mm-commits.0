From: akpm@linux-foundation.org
Subject: + compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0.patch added to -mm tree
Date: Wed, 07 Jul 2010 14:41:33 -0700
Message-ID: <201007072141.o67LfXdb028193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659Ab0GGVlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 17:41:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, jwoithe@physics.adelaide.edu.au, mjg@redhat.com


The patch titled
     compal-laptop/fujitsu-laptop/msi-laptop: make dmi_check_cb to return 1 instead of 0
has been added to the -mm tree.  Its filename is
     compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compal-laptop/fujitsu-laptop/msi-laptop: make dmi_check_cb to return 1 instead of 0
From: Axel Lin <axel.lin@gmail.com>

dmi_check_system() walks the table running matching functions until
someone returns non zero or we hit the end.

This patch makes dmi_check_cb to return 1 so dmi_check_system() return
immediately when a match is found.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Matthew Garrett <mjg@redhat.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/compal-laptop.c  |    2 +-
 drivers/platform/x86/fujitsu-laptop.c |    6 +++---
 drivers/platform/x86/msi-laptop.c     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/platform/x86/compal-laptop.c~compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0 drivers/platform/x86/compal-laptop.c
--- a/drivers/platform/x86/compal-laptop.c~compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0
+++ a/drivers/platform/x86/compal-laptop.c
@@ -190,7 +190,7 @@ static int dmi_check_cb(const struct dmi
 	printk(KERN_INFO "compal-laptop: Identified laptop model '%s'.\n",
 		id->ident);
 
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id __initdata compal_dmi_table[] = {
diff -puN drivers/platform/x86/fujitsu-laptop.c~compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0 drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -603,7 +603,7 @@ static int dmi_check_cb_s6410(const stru
 	dmi_check_cb_common(id);
 	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
 	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
-	return 0;
+	return 1;
 }
 
 static int dmi_check_cb_s6420(const struct dmi_system_id *id)
@@ -611,7 +611,7 @@ static int dmi_check_cb_s6420(const stru
 	dmi_check_cb_common(id);
 	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
 	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
-	return 0;
+	return 1;
 }
 
 static int dmi_check_cb_p8010(const struct dmi_system_id *id)
@@ -620,7 +620,7 @@ static int dmi_check_cb_p8010(const stru
 	fujitsu->keycode1 = KEY_HELP;	/* "Support" */
 	fujitsu->keycode3 = KEY_SWITCHVIDEOMODE;	/* "Presentation" */
 	fujitsu->keycode4 = KEY_WWW;	/* "Internet" */
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id fujitsu_dmi_table[] = {
diff -puN drivers/platform/x86/msi-laptop.c~compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0 drivers/platform/x86/msi-laptop.c
--- a/drivers/platform/x86/msi-laptop.c~compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0
+++ a/drivers/platform/x86/msi-laptop.c
@@ -434,7 +434,7 @@ static int dmi_check_cb(const struct dmi
 {
 	printk(KERN_INFO "msi-laptop: Identified laptop model '%s'.\n",
 	       id->ident);
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id __initdata msi_dmi_table[] = {
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch
compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

