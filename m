From: akpm@linux-foundation.org
Subject: + pm-do-not-require-dev-spew-to-get-pm_debug.patch added to -mm tree
Date: Thu, 24 May 2007 13:46:24 -0700
Message-ID: <200705242046.l4OKkO9L002207@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbXEXUqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 16:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bcollins@ubuntu.com, greg@kroah.com, pavel@ucw.cz, rjw@sisk.pl, torvalds@linux-foundation.org


The patch titled
     PM: Do not require dev spew to get PM_DEBUG
has been added to the -mm tree.  Its filename is
     pm-do-not-require-dev-spew-to-get-pm_debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: Do not require dev spew to get PM_DEBUG
From: Ben Collins <bcollins@ubuntu.com>

In order to enable things like PM_TRACE, you're required to enable
PM_DEBUG, which sends a large spew of messages on boot, and often times can
overflow dmesg buffer.

Create new PM_VERBOSE and shift that to be the option that enables
drivers/base/power's messages.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/Makefile |    2 +-
 kernel/power/Kconfig        |   17 ++++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/base/power/Makefile~pm-do-not-require-dev-spew-to-get-pm_debug drivers/base/power/Makefile
--- a/drivers/base/power/Makefile~pm-do-not-require-dev-spew-to-get-pm_debug
+++ a/drivers/base/power/Makefile
@@ -5,6 +5,6 @@ obj-$(CONFIG_PM_TRACE)	+= trace.o
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
-ifeq ($(CONFIG_PM_DEBUG),y)
+ifeq ($(CONFIG_PM_VERBOSE),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
diff -puN kernel/power/Kconfig~pm-do-not-require-dev-spew-to-get-pm_debug kernel/power/Kconfig
--- a/kernel/power/Kconfig~pm-do-not-require-dev-spew-to-get-pm_debug
+++ a/kernel/power/Kconfig
@@ -33,13 +33,20 @@ config PM_DEBUG
 	bool "Power Management Debug Support"
 	depends on PM
 	---help---
-	This option enables verbose debugging support in the Power Management
-	code. This is helpful when debugging and reporting various PM bugs, 
-	like suspend support.
+	This option enables various debugging support in the Power Management
+	code. This is helpful when debugging and reporting PM bugs, like
+	suspend support.
+
+config PM_VERBOSE
+	bool "Verbose Power Management debugging"
+	depends on PM_DEBUG
+	default n
+	---help---
+	This option enables verbose messages from the Power Management code.
 
 config DISABLE_CONSOLE_SUSPEND
 	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
-	depends on PM && PM_DEBUG
+	depends on PM_DEBUG
 	default n
 	---help---
 	This option turns off the console suspend mechanism that prevents
@@ -50,7 +57,7 @@ config DISABLE_CONSOLE_SUSPEND
 
 config PM_TRACE
 	bool "Suspend/resume event tracing"
-	depends on PM && PM_DEBUG && X86_32 && EXPERIMENTAL
+	depends on PM_DEBUG && X86_32 && EXPERIMENTAL
 	default n
 	---help---
 	This enables some cheesy code to save the last PM event point in the
_

Patches currently in -mm which might be from bcollins@ubuntu.com are

origin.patch
avoid-zero-size-allocation-in-cache_k8_northbridges.patch
cleanup-libata-hpa-support.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
