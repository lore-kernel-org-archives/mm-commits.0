From: akpm@linux-foundation.org
Subject: [to-be-updated]
 printk-nmi-generic-solution-for-safe-printk-in-nmi-fix.patch removed from
 -mm tree
Date: Fri, 26 Feb 2016 15:29:01 -0800
Message-ID: <56d0dfbd.T+7RFTKy7WlOXRkN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbcBZX3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 18:29:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, pmladek@suse.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/nmi: restore printk_func in nmi_panic
has been removed from the -mm tree.  Its filename was
     printk-nmi-generic-solution-for-safe-printk-in-nmi-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: printk/nmi: restore printk_func in nmi_panic

When watchdog detects a hardlockup and calls nmi_panic() `printk_func'
must be restored via printk_nmi_exit() call, so panic() will be able
to flush nmi buf and show backtrace and panic message. We also better
explicitly ask nmi to printk_nmi_flush() in console_flush_on_panic(),
because it may be too late to rely on irq work.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++--
 kernel/printk/printk.c |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~printk-nmi-generic-solution-for-safe-printk-in-nmi-fix include/linux/kernel.h
--- a/include/linux/kernel.h~printk-nmi-generic-solution-for-safe-printk-in-nmi-fix
+++ a/include/linux/kernel.h
@@ -467,10 +467,12 @@ do {									\
 	cpu = raw_smp_processor_id();					\
 	old_cpu = atomic_cmpxchg(&panic_cpu, PANIC_CPU_INVALID, cpu);	\
 									\
-	if (old_cpu == PANIC_CPU_INVALID)				\
+	if (old_cpu == PANIC_CPU_INVALID) {				\
+		printk_nmi_exit();					\
 		panic(fmt, ##__VA_ARGS__);				\
-	else if (old_cpu != cpu)					\
+	} else if (old_cpu != cpu) {					\
 		nmi_panic_self_stop(regs);				\
+	}								\
 } while (0)
 
 /*
diff -puN kernel/printk/printk.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-fix kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-fix
+++ a/kernel/printk/printk.c
@@ -2392,6 +2392,7 @@ void console_flush_on_panic(void)
 	 */
 	console_trylock();
 	console_may_schedule = 0;
+	printk_nmi_flush();
 	console_unlock();
 }
 
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are


