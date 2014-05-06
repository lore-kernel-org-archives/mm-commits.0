From: akpm@linux-foundation.org
Subject: + documentation-expand-clarify-debug-documentation.patch added to -mm tree
Date: Tue, 06 May 2014 14:51:26 -0700
Message-ID: <5369595e.ocT59G6jkEKcA7Z3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEFVv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 17:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fabf@skynet.be, ddstreet@ieee.org

Subject: + documentation-expand-clarify-debug-documentation.patch added to -mm tree
To: ddstreet@ieee.org,fabf@skynet.be,joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 14:51:26 -0700


The patch titled
     Subject: Documentation: expand/clarify debug documentation
has been added to the -mm tree.  Its filename is
     documentation-expand-clarify-debug-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-expand-clarify-debug-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-expand-clarify-debug-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: Documentation: expand/clarify debug documentation

The pr_debug() and related debug print macros all differ from the normal
pr_XXX() macros, in that the normal ones print unconditionally, while the
debug macros are compiled out unless DEBUG is defined or
CONFIG_DYNAMIC_DEBUG is set.  This isn't obvious, and the only way to find
this out is either to review the actual printk.h code or to read
CodingStyle, and the message there doesn't highlight the fact.

Change Documentation/CodingStyle to clearly indicate that pr_debug() and
related debug printing macros behave differently than all other pr_XXX()
macros, and attempt to clarify when and where the different debug printing
methods might be used.

Add short comment to printk.h above the pr_XXX() macros indicating that
while these macros print unconditionally, pr_debug() does not.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   22 +++++++++++++++-------
 include/linux/printk.h    |    6 ++++++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff -puN Documentation/CodingStyle~documentation-expand-clarify-debug-documentation Documentation/CodingStyle
--- a/Documentation/CodingStyle~documentation-expand-clarify-debug-documentation
+++ a/Documentation/CodingStyle
@@ -660,15 +660,23 @@ There are a number of driver model diagn
 which you should use to make sure messages are matched to the right device
 and driver, and are tagged with the right level:  dev_err(), dev_warn(),
 dev_info(), and so forth.  For messages that aren't associated with a
-particular device, <linux/printk.h> defines pr_debug() and pr_info().
+particular device, <linux/printk.h> defines pr_notice(), pr_info(),
+pr_warn(), pr_err(), etc.
 
 Coming up with good debugging messages can be quite a challenge; and once
-you have them, they can be a huge help for remote troubleshooting.  Such
-messages should be compiled out when the DEBUG symbol is not defined (that
-is, by default they are not included).  When you use dev_dbg() or pr_debug(),
-that's automatic.  Many subsystems have Kconfig options to turn on -DDEBUG.
-A related convention uses VERBOSE_DEBUG to add dev_vdbg() messages to the
-ones already enabled by DEBUG.
+you have them, they can be a huge help for remote troubleshooting.  However
+debug message printing is handled differently than printing other non-debug
+messages.  While the other pr_XXX() functions print unconditionally,
+pr_debug() does not; it is compiled out by default, unless either DEBUG is
+defined or CONFIG_DYNAMIC_DEBUG is set.  That is true for dev_dbg() also,
+and a related convention uses VERBOSE_DEBUG to add dev_vdbg() messages to
+the ones already enabled by DEBUG.
+
+Many subsystems have Kconfig debug options to turn on -DDEBUG in the
+corresponding Makefile; in other cases specific files #define DEBUG.  And
+when a debug message should be unconditionally printed, such as if it is
+already inside a debug-related #ifdef secton, printk(KERN_DEBUG ...) can be
+used.
 
 
 		Chapter 14: Allocating memory
diff -puN include/linux/printk.h~documentation-expand-clarify-debug-documentation include/linux/printk.h
--- a/include/linux/printk.h~documentation-expand-clarify-debug-documentation
+++ a/include/linux/printk.h
@@ -210,6 +210,12 @@ extern asmlinkage void dump_stack(void)
 #define pr_fmt(fmt) fmt
 #endif
 
+/*
+ * These can be used to print at the various log levels.
+ * All of these will print unconditionally, although note that pr_debug()
+ * and other debug macros are compiled out unless either DEBUG is defined
+ * or CONFIG_DYNAMIC_DEBUG is set.
+ */
 #define pr_emerg(fmt, ...) \
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_alert(fmt, ...) \
_

Patches currently in -mm which might be from ddstreet@ieee.org are

documentation-expand-clarify-debug-documentation.patch
lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch

