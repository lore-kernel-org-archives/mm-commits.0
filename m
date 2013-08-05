From: akpm@linux-foundation.org
Subject: [merged] printk-add-console_cmdlineh.patch removed from -mm tree
Date: Mon, 05 Aug 2013 12:06:00 -0700
Message-ID: <51fff798.+LbOHKL6SBo7Ns8H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3HETGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ming.lei@canonical.com, joe@perches.com

Subject: [merged] printk-add-console_cmdlineh.patch removed from -mm tree
To: joe@perches.com,ming.lei@canonical.com,samuel.thibault@ens-lyon.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:06:00 -0700


The patch titled
     Subject: printk: add console_cmdline.h
has been removed from the -mm tree.  Its filename was
     printk-add-console_cmdlineh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: add console_cmdline.h

Add an include file for the console_cmdline struct so that the braille
console driver can be separated.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/console_cmdline.h |   14 ++++++++++++++
 kernel/printk/printk.c          |   12 +++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff -puN /dev/null kernel/printk/console_cmdline.h
--- /dev/null
+++ a/kernel/printk/console_cmdline.h
@@ -0,0 +1,14 @@
+#ifndef _CONSOLE_CMDLINE_H
+#define _CONSOLE_CMDLINE_H
+
+struct console_cmdline
+{
+	char	name[8];			/* Name of the driver	    */
+	int	index;				/* Minor dev. to use	    */
+	char	*options;			/* Options for the driver   */
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	char	*brl_options;			/* Options for braille driver */
+#endif
+};
+
+#endif
diff -puN kernel/printk/printk.c~printk-add-console_cmdlineh kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-console_cmdlineh
+++ a/kernel/printk/printk.c
@@ -51,6 +51,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#include "console_cmdline.h"
+
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
@@ -105,19 +107,11 @@ static struct console *exclusive_console
 /*
  *	Array of consoles built from command line options (console=)
  */
-struct console_cmdline
-{
-	char	name[8];			/* Name of the driver	    */
-	int	index;				/* Minor dev. to use	    */
-	char	*options;			/* Options for the driver   */
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	char	*brl_options;			/* Options for braille driver */
-#endif
-};
 
 #define MAX_CMDLINECONSOLES 8
 
 static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
+
 static int selected_console = -1;
 static int preferred_console = -1;
 int console_set_on_cmdline;
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

