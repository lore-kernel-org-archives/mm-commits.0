From: akpm@linux-foundation.org
Subject: + pm-rework-includes-remove-arch-ifdefs-v2.patch added to -mm tree
Date: Thu, 26 Feb 2009 12:48:33 -0800
Message-ID: <200902262048.n1QKmYTH020848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbZBZUtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 15:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, lethal@linux-sh.org, rjw@sisk.pl


The patch titled
     pm: rework includes, remove arch ifdefs
has been added to the -mm tree.  Its filename is
     pm-rework-includes-remove-arch-ifdefs-v2.patch

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
Subject: pm: rework includes, remove arch ifdefs
From: Magnus Damm <damm@igel.co.jp>

Make the following header file changes:

 - remove arch ifdefs and asm/suspend.h from linux/suspend.h
 - add asm/suspend.h to disk.c (for arch_prepare_suspend())
 - add linux/io.h to swsusp.c (for ioremap())
 - x86 32/64 bit compile fixes

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/asm-offsets_32.c |    1 +
 arch/x86/kernel/asm-offsets_64.c |    1 +
 arch/x86/power/cpu_32.c          |    1 +
 arch/x86/power/cpu_64.c          |    1 +
 arch/x86/power/hibernate_64.c    |    1 +
 include/linux/suspend.h          |    3 ---
 kernel/power/disk.c              |    1 +
 kernel/power/swsusp.c            |    1 +
 8 files changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/asm-offsets_32.c~pm-rework-includes-remove-arch-ifdefs-v2 arch/x86/kernel/asm-offsets_32.c
--- a/arch/x86/kernel/asm-offsets_32.c~pm-rework-includes-remove-arch-ifdefs-v2
+++ a/arch/x86/kernel/asm-offsets_32.c
@@ -18,6 +18,7 @@
 #include <asm/thread_info.h>
 #include <asm/bootparam.h>
 #include <asm/elf.h>
+#include <asm/suspend.h>
 
 #include <xen/interface/xen.h>
 
diff -puN arch/x86/kernel/asm-offsets_64.c~pm-rework-includes-remove-arch-ifdefs-v2 arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c~pm-rework-includes-remove-arch-ifdefs-v2
+++ a/arch/x86/kernel/asm-offsets_64.c
@@ -16,6 +16,7 @@
 #include <asm/thread_info.h>
 #include <asm/ia32.h>
 #include <asm/bootparam.h>
+#include <asm/suspend.h>
 
 #include <xen/interface/xen.h>
 
diff -puN arch/x86/power/cpu_32.c~pm-rework-includes-remove-arch-ifdefs-v2 arch/x86/power/cpu_32.c
--- a/arch/x86/power/cpu_32.c~pm-rework-includes-remove-arch-ifdefs-v2
+++ a/arch/x86/power/cpu_32.c
@@ -12,6 +12,7 @@
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/xcr.h>
+#include <asm/suspend.h>
 
 static struct saved_context saved_context;
 
diff -puN arch/x86/power/cpu_64.c~pm-rework-includes-remove-arch-ifdefs-v2 arch/x86/power/cpu_64.c
--- a/arch/x86/power/cpu_64.c~pm-rework-includes-remove-arch-ifdefs-v2
+++ a/arch/x86/power/cpu_64.c
@@ -15,6 +15,7 @@
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
 #include <asm/xcr.h>
+#include <asm/suspend.h>
 
 static void fix_processor_context(void);
 
diff -puN arch/x86/power/hibernate_64.c~pm-rework-includes-remove-arch-ifdefs-v2 arch/x86/power/hibernate_64.c
--- a/arch/x86/power/hibernate_64.c~pm-rework-includes-remove-arch-ifdefs-v2
+++ a/arch/x86/power/hibernate_64.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/suspend.h>
 
 /* References to section boundaries */
 extern const void __nosave_begin, __nosave_end;
diff -puN include/linux/suspend.h~pm-rework-includes-remove-arch-ifdefs-v2 include/linux/suspend.h
--- a/include/linux/suspend.h~pm-rework-includes-remove-arch-ifdefs-v2
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
diff -puN kernel/power/disk.c~pm-rework-includes-remove-arch-ifdefs-v2 kernel/power/disk.c
--- a/kernel/power/disk.c~pm-rework-includes-remove-arch-ifdefs-v2
+++ a/kernel/power/disk.c
@@ -22,6 +22,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <asm/suspend.h>
 
 #include "power.h"
 
diff -puN kernel/power/swsusp.c~pm-rework-includes-remove-arch-ifdefs-v2 kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~pm-rework-includes-remove-arch-ifdefs-v2
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
pm-rework-includes-remove-arch-ifdefs-v2.patch
pm-cleanup-includes.patch

