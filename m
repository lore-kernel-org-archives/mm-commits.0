From: akpm@linux-foundation.org
Subject: - remove-unnecessary-includes-of-spinlockh-under-include-linux.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:58 -0700
Message-ID: <200707162053.l6GKrwp1001697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760496AbXGPVVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:21:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Remove unnecessary includes of spinlock.h under include/linux
has been removed from the -mm tree.  Its filename was
     remove-unnecessary-includes-of-spinlockh-under-include-linux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unnecessary includes of spinlock.h under include/linux
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the obviously unnecessary includes of <linux/spinlock.h> under the
include/linux/ directory, and fix the couple errors that are introduced as
a result of that.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/attribute_container.h |    1 -
 include/linux/capability.h          |    1 -
 include/linux/console.h             |    1 -
 include/linux/ds17287rtc.h          |    1 -
 include/linux/ipc.h                 |    1 +
 include/linux/leds.h                |    1 -
 include/linux/module.h              |    1 -
 include/linux/percpu.h              |    2 +-
 include/linux/scx200_gpio.h         |    2 --
 include/linux/signal.h              |    1 -
 include/linux/smp_lock.h            |    1 -
 include/linux/timer.h               |    1 -
 12 files changed, 2 insertions(+), 12 deletions(-)

diff -puN include/linux/attribute_container.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/attribute_container.h
--- a/include/linux/attribute_container.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/attribute_container.h
@@ -12,7 +12,6 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/klist.h>
-#include <linux/spinlock.h>
 
 struct attribute_container {
 	struct list_head	node;
diff -puN include/linux/capability.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/capability.h
--- a/include/linux/capability.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/capability.h
@@ -44,7 +44,6 @@ typedef struct __user_cap_data_struct {
   
 #ifdef __KERNEL__
 
-#include <linux/spinlock.h>
 #include <asm/current.h>
 
 /* #define STRICT_CAP_T_TYPECHECKS */
diff -puN include/linux/console.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/console.h
--- a/include/linux/console.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/console.h
@@ -15,7 +15,6 @@
 #define _LINUX_CONSOLE_H_ 1
 
 #include <linux/types.h>
-#include <linux/spinlock.h>
 
 struct vc_data;
 struct console_font_op;
diff -puN include/linux/ds17287rtc.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/ds17287rtc.h
--- a/include/linux/ds17287rtc.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/ds17287rtc.h
@@ -11,7 +11,6 @@
 #define __LINUX_DS17287RTC_H
 
 #include <linux/rtc.h>			/* get the user-level API */
-#include <linux/spinlock.h>		/* spinlock_t */
 #include <linux/mc146818rtc.h>
 
 /* Register A */
diff -puN include/linux/ipc.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/ipc.h
--- a/include/linux/ipc.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/ipc.h
@@ -52,6 +52,7 @@ struct ipc_perm
 #ifdef __KERNEL__
 
 #include <linux/kref.h>
+#include <linux/spinlock.h>
 
 #define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
 
diff -puN include/linux/leds.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/leds.h
--- a/include/linux/leds.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/leds.h
@@ -13,7 +13,6 @@
 #define __LINUX_LEDS_H_INCLUDED
 
 #include <linux/list.h>
-#include <linux/spinlock.h>
 
 struct device;
 struct class_device;
diff -puN include/linux/module.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/module.h
--- a/include/linux/module.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/module.h
@@ -6,7 +6,6 @@
  * Rewritten by Richard Henderson <rth@tamu.edu> Dec 1996
  * Rewritten again by Rusty Russell, 2002
  */
-#include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/stat.h>
 #include <linux/compiler.h>
diff -puN include/linux/percpu.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/percpu.h
--- a/include/linux/percpu.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/percpu.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_PERCPU_H
 #define __LINUX_PERCPU_H
 
-#include <linux/spinlock.h> /* For preempt_disable() */
+#include <linux/preempt.h>
 #include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>
 #include <linux/string.h> /* For memset() */
diff -puN include/linux/scx200_gpio.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/scx200_gpio.h
--- a/include/linux/scx200_gpio.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/scx200_gpio.h
@@ -1,5 +1,3 @@
-#include <linux/spinlock.h>
-
 u32 scx200_gpio_configure(unsigned index, u32 set, u32 clear);
 
 extern unsigned scx200_gpio_base;
diff -puN include/linux/signal.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/signal.h
--- a/include/linux/signal.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/signal.h
@@ -6,7 +6,6 @@
 
 #ifdef __KERNEL__
 #include <linux/list.h>
-#include <linux/spinlock.h>
 
 /*
  * Real Time signals may be queued.
diff -puN include/linux/smp_lock.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/smp_lock.h
--- a/include/linux/smp_lock.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/smp_lock.h
@@ -3,7 +3,6 @@
 
 #ifdef CONFIG_LOCK_KERNEL
 #include <linux/sched.h>
-#include <linux/spinlock.h>
 
 #define kernel_locked()		(current->lock_depth >= 0)
 
diff -puN include/linux/timer.h~remove-unnecessary-includes-of-spinlockh-under-include-linux include/linux/timer.h
--- a/include/linux/timer.h~remove-unnecessary-includes-of-spinlockh-under-include-linux
+++ a/include/linux/timer.h
@@ -3,7 +3,6 @@
 
 #include <linux/list.h>
 #include <linux/ktime.h>
-#include <linux/spinlock.h>
 #include <linux/stddef.h>
 
 struct tvec_t_base_s;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
