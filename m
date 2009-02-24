From: akpm@linux-foundation.org
Subject: [failures] pm-rework-includes-remove-arch-ifdefs.patch removed from -mm tree
Date: Tue, 24 Feb 2009 15:28:36 -0800
Message-ID: <200902242346.n1ONk5va021515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757569AbZBXXqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 18:46:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, lethal@linux-sh.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: rework includes, remove arch ifdefs
has been removed from the -mm tree.  Its filename was
     pm-rework-includes-remove-arch-ifdefs.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: rework includes, remove arch ifdefs
From: Magnus Damm <damm@igel.co.jp>

Make the following header file changes:

 - remove arch ifdefs and asm/suspend.h from linux/suspend.h
 - add asm/suspend.h to disk.c (for arch_prepare_suspend())
 - add linux/io.h to swsusp.c (for ioremap())

These are the only generic changes needed to get CONFIG_HIBERNATION
working on SuperH.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    3 ---
 kernel/power/disk.c     |    1 +
 kernel/power/swsusp.c   |    1 +
 3 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/suspend.h~pm-rework-includes-remove-arch-ifdefs include/linux/suspend.h
--- a/include/linux/suspend.h~pm-rework-includes-remove-arch-ifdefs
+++ a/include/linux/suspend.h
@@ -1,9 +1,6 @@
 #ifndef _LINUX_SUSPEND_H
 #define _LINUX_SUSPEND_H
 
-#if defined(CONFIG_X86) || defined(CONFIG_FRV) || defined(CONFIG_PPC32) || defined(CONFIG_PPC64)
-#include <asm/suspend.h>
-#endif
 #include <linux/swap.h>
 #include <linux/notifier.h>
 #include <linux/init.h>
diff -puN kernel/power/disk.c~pm-rework-includes-remove-arch-ifdefs kernel/power/disk.c
--- a/kernel/power/disk.c~pm-rework-includes-remove-arch-ifdefs
+++ a/kernel/power/disk.c
@@ -22,6 +22,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <asm/suspend.h>
 
 #include "power.h"
 
diff -puN kernel/power/swsusp.c~pm-rework-includes-remove-arch-ifdefs kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~pm-rework-includes-remove-arch-ifdefs
+++ a/kernel/power/swsusp.c
@@ -51,6 +51,7 @@
 #include <linux/highmem.h>
 #include <linux/time.h>
 #include <linux/rbtree.h>
+#include <linux/io.h>
 
 #include "power.h"
 
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
pm-rework-includes-remove-arch-ifdefs.patch

