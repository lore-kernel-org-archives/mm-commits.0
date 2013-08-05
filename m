From: akpm@linux-foundation.org
Subject: [merged] printk-use-pointer-for-console_cmdline-indexing.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 12:06:02 -0700
Message-ID: <51fff79a.VaEKooGKMYyLNHBG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3HETGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ming.lei@canonical.com, joe@perches.com

Subject: [merged] printk-use-pointer-for-console_cmdline-indexing.patch removed from -mm tree
To: joe@perches.com,ming.lei@canonical.com,samuel.thibault@ens-lyon.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:06:02 -0700


The patch titled
     Subject: printk: use pointer for console_cmdline indexing
has been removed from the -mm tree.  Its filename was
     printk-use-pointer-for-console_cmdline-indexing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: use pointer for console_cmdline indexing

Make the code a bit more compact by always using a pointer for the active
console_cmdline.

Move overly indented code to correct indent level.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   49 ++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff -puN kernel/printk/printk.c~printk-use-pointer-for-console_cmdline-indexing kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-use-pointer-for-console_cmdline-indexing
+++ a/kernel/printk/printk.c
@@ -1756,18 +1756,19 @@ static int __add_preferred_console(char
 	 *	See if this tty is not yet registered, and
 	 *	if we have a slot free.
 	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				if (!brl_options)
-					selected_console = i;
-				return 0;
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++) {
+		if (strcmp(c->name, name) == 0 && c->index == idx) {
+			if (!brl_options)
+				selected_console = i;
+			return 0;
 		}
+	}
 	if (i == MAX_CMDLINECONSOLES)
 		return -E2BIG;
 	if (!brl_options)
 		selected_console = i;
-	c = &console_cmdline[i];
 	strlcpy(c->name, name, sizeof(c->name));
 	c->options = options;
 	braille_set_options(c, brl_options);
@@ -1840,15 +1841,15 @@ int update_console_cmdline(char *name, i
 	struct console_cmdline *c;
 	int i;
 
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				c = &console_cmdline[i];
-				strlcpy(c->name, name_new, sizeof(c->name));
-				c->name[sizeof(c->name) - 1] = 0;
-				c->options = options;
-				c->index = idx_new;
-				return i;
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++)
+		if (strcmp(c->name, name) == 0 && c->index == idx) {
+			strlcpy(c->name, name_new, sizeof(c->name));
+			c->name[sizeof(c->name) - 1] = 0;
+			c->options = options;
+			c->index = idx_new;
+			return i;
 		}
 	/* not found */
 	return -1;
@@ -2223,6 +2224,7 @@ void register_console(struct console *ne
 	int i;
 	unsigned long flags;
 	struct console *bcon = NULL;
+	struct console_cmdline *c;
 
 	/*
 	 * before we register a new CON_BOOT console, make sure we don't
@@ -2270,24 +2272,25 @@ void register_console(struct console *ne
 	 *	See if this console matches one we selected on
 	 *	the command line.
 	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0];
-			i++) {
-		if (strcmp(console_cmdline[i].name, newcon->name) != 0)
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++) {
+		if (strcmp(c->name, newcon->name) != 0)
 			continue;
 		if (newcon->index >= 0 &&
-		    newcon->index != console_cmdline[i].index)
+		    newcon->index != c->index)
 			continue;
 		if (newcon->index < 0)
-			newcon->index = console_cmdline[i].index;
+			newcon->index = c->index;
 
-		if (_braille_register_console(newcon, &console_cmdline[i]))
+		if (_braille_register_console(newcon, c))
 			return;
 
 		if (newcon->setup &&
 		    newcon->setup(newcon, console_cmdline[i].options) != 0)
 			break;
 		newcon->flags |= CON_ENABLED;
-		newcon->index = console_cmdline[i].index;
+		newcon->index = c->index;
 		if (i == selected_console) {
 			newcon->flags |= CON_CONSDEV;
 			preferred_console = selected_console;
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch
linux-next.patch

