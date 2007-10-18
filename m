From: akpm@linux-foundation.org
Subject: - lp_console-cleanups.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:59 -0700
Message-ID: <200710180701.l9I71xV8031221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbXJRHXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:23:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     lp_console: cleanups
has been removed from the -mm tree.  Its filename was
     lp_console-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lp_console: cleanups
From: Pavel Machek <pavel@ucw.cz>

Remove NULL initializers and clean whitespace a bit.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/lp.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/char/lp.c~lp_console-cleanups drivers/char/lp.c
--- a/drivers/char/lp.c~lp_console-cleanups
+++ a/drivers/char/lp.c
@@ -144,7 +144,7 @@ static unsigned int lp_count = 0;
 static struct class *lp_class;
 
 #ifdef CONFIG_LP_CONSOLE
-static struct parport *console_registered; // initially NULL
+static struct parport *console_registered;
 #endif /* CONFIG_LP_CONSOLE */
 
 #undef LP_DEBUG
@@ -749,8 +749,8 @@ static struct console lpcons = {
 /* --- initialisation code ------------------------------------- */
 
 static int parport_nr[LP_NO] = { [0 ... LP_NO-1] = LP_PARPORT_UNSPEC };
-static char *parport[LP_NO] = { NULL,  };
-static int reset = 0;
+static char *parport[LP_NO];
+static int reset;
 
 module_param_array(parport, charp, NULL, 0);
 module_param(reset, bool, 0);
@@ -758,10 +758,10 @@ module_param(reset, bool, 0);
 #ifndef MODULE
 static int __init lp_setup (char *str)
 {
-	static int parport_ptr; // initially zero
+	static int parport_ptr;
 	int x;
 
-	if (get_option (&str, &x)) {
+	if (get_option(&str, &x)) {
 		if (x == 0) {
 			/* disable driver on "lp=" or "lp=0" */
 			parport_nr[0] = LP_PARPORT_OFF;
@@ -807,7 +807,7 @@ static int lp_register(int nr, struct pa
 #ifdef CONFIG_LP_CONSOLE
 	if (!nr) {
 		if (port->modes & PARPORT_MODE_SAFEININT) {
-			register_console (&lpcons);
+			register_console(&lpcons);
 			console_registered = port;
 			printk (KERN_INFO "lp%d: console ready\n", CONSOLE_LP);
 		} else
@@ -823,8 +823,7 @@ static void lp_attach (struct parport *p
 {
 	unsigned int i;
 
-	switch (parport_nr[0])
-	{
+	switch (parport_nr[0]) {
 	case LP_PARPORT_UNSPEC:
 	case LP_PARPORT_AUTO:
 		if (parport_nr[0] == LP_PARPORT_AUTO &&
@@ -855,7 +854,7 @@ static void lp_detach (struct parport *p
 	/* Write this some day. */
 #ifdef CONFIG_LP_CONSOLE
 	if (console_registered == port) {
-		unregister_console (&lpcons);
+		unregister_console(&lpcons);
 		console_registered = NULL;
 	}
 #endif /* CONFIG_LP_CONSOLE */
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-x86.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-rework-struct-platform_suspend_ops-fixup.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
freezer-be-more-verbose.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch
