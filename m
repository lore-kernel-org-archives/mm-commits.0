From: akpm@linux-foundation.org
Subject: + smph-move-smp-version-of-on_each_cpu-out-of-line.patch added to -mm tree
Date: Mon, 05 Aug 2013 15:47:29 -0700
Message-ID: <52002b81.bokS5CKd97Ql+DQJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3HEWra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 18:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david.daney@cavium.com

Subject: + smph-move-smp-version-of-on_each_cpu-out-of-line.patch added to -mm tree
To: david.daney@cavium.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 15:47:29 -0700


The patch titled
     Subject: smp.h: move !SMP version of on_each_cpu() out-of-line
has been added to the -mm tree.  Its filename is
     smph-move-smp-version-of-on_each_cpu-out-of-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smph-move-smp-version-of-on_each_cpu-out-of-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smph-move-smp-version-of-on_each_cpu-out-of-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: smp.h: move !SMP version of on_each_cpu() out-of-line

All of the other non-trivial !SMP versions of functions in smp.h are
out-of-line in up.c.  Move on_each_cpu() there as well.

This allows us to get rid of the #include <linux/irqflags.h>.  The
drawback is that this makes both the x86_64 and i386 defconfig !SMP
kernels about 200 bytes larger each.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   21 +++++----------------
 kernel/up.c         |   11 +++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

diff -puN include/linux/smp.h~smph-move-smp-version-of-on_each_cpu-out-of-line include/linux/smp.h
--- a/include/linux/smp.h~smph-move-smp-version-of-on_each_cpu-out-of-line
+++ a/include/linux/smp.h
@@ -11,7 +11,6 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
-#include <linux/irqflags.h>
 
 extern void cpu_idle(void);
 
@@ -30,6 +29,11 @@ int smp_call_function_single(int cpuid,
 			     int wait);
 
 /*
+ * Call a function on all processors
+ */
+int on_each_cpu(smp_call_func_t func, void *info, int wait);
+
+/*
  * Call a function on processors specified by mask, which might include
  * the local one.
  */
@@ -112,11 +116,6 @@ static inline void call_function_init(vo
 #endif
 
 /*
- * Call a function on all processors
- */
-int on_each_cpu(smp_call_func_t func, void *info, int wait);
-
-/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -141,16 +140,6 @@ static inline int up_smp_call_function(s
 #define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
 
-static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	func(info);
-	local_irq_restore(flags);
-	return 0;
-}
-
 static inline void __smp_call_function_single(int cpuid,
 		struct call_single_data *data, int wait)
 {
diff -puN kernel/up.c~smph-move-smp-version-of-on_each_cpu-out-of-line kernel/up.c
--- a/kernel/up.c~smph-move-smp-version-of-on_each_cpu-out-of-line
+++ a/kernel/up.c
@@ -22,6 +22,17 @@ int smp_call_function_single(int cpu, vo
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+int on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	func(info);
+	local_irq_restore(flags);
+	return 0;
+}
+EXPORT_SYMBOL(on_each_cpu);
+
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
_

Patches currently in -mm which might be from david.daney@cavium.com are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch
upc-use-local_irq_saverestore-in-smp_call_function_single.patch
smph-move-smp-version-of-on_each_cpu-out-of-line.patch
linux-next.patch

