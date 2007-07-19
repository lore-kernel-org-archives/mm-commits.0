From: akpm@linux-foundation.org
Subject: - dev_vdbg-available-with-dverbose_debug-docs.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:11:13 -0700
Message-ID: <200707192011.l6JKBD9G020749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbXGSUQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     dev_vdbg(), available with -DVERBOSE_DEBUG (docs)
has been removed from the -mm tree.  Its filename was
     dev_vdbg-available-with-dverbose_debug-docs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dev_vdbg(), available with -DVERBOSE_DEBUG (docs)
From: David Brownell <david-b@pacbell.net>

Update CodingStyle to talk about "-DDEBUG" message conventions and the
new "-DVERBOSE_DEBUG" convention.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff -puN Documentation/CodingStyle~dev_vdbg-available-with-dverbose_debug-docs Documentation/CodingStyle
--- a/Documentation/CodingStyle~dev_vdbg-available-with-dverbose_debug-docs
+++ a/Documentation/CodingStyle
@@ -633,12 +633,27 @@ covers RTL which is used frequently with
 
 Kernel developers like to be seen as literate. Do mind the spelling
 of kernel messages to make a good impression. Do not use crippled
-words like "dont" and use "do not" or "don't" instead.
+words like "dont"; use "do not" or "don't" instead.  Make the messages
+concise, clear, and unambiguous.
 
 Kernel messages do not have to be terminated with a period.
 
 Printing numbers in parentheses (%d) adds no value and should be avoided.
 
+There are a number of driver model diagnostic macros in <linux/device.h>
+which you should use to make sure messages are matched to the right device
+and driver, and are tagged with the right level:  dev_err(), dev_warn(),
+dev_info(), and so forth.  For messages that aren't associated with a
+particular device, <linux/kernel.h> defines pr_debug() and pr_info().
+
+Coming up with good debugging messages can be quite a challenge; and once
+you have them, they can be a huge help for remote troubleshooting.  Such
+messages should be compiled out when the DEBUG symbol is not defined (that
+is, by default they are not included).  When you use dev_dbg() or pr_debug(),
+that's automatic.  Many subsystems have Kconfig options to turn on -DDEBUG.
+A related convention uses VERBOSE_DEBUG to add dev_vdbg() messages to the
+ones already enabled by DEBUG.
+
 
 		Chapter 14: Allocating memory
 
@@ -790,4 +805,5 @@ Kernel CodingStyle, by greg@kroah.com at
 http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
 
 --
-Last updated on 2006-December-06.
+Last updated on 2007-July-13.
+
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
