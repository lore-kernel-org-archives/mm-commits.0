From: akpm@linux-foundation.org
Subject: - vmi-pit-override.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:55:22 -0800
Message-ID: <200703052355.l25NtMeu005182@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41943 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932688AbXCEXzY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:55:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     vmi: pit override
has been removed from the -mm tree.  Its filename was
     vmi-pit-override.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vmi: pit override
From: Zachary Amsden <zach@vmware.com>

The time_init_hook in paravirt-ops no longer functions in the correct manner
after the integration of the hrtimers code.  The problem is that now the call
path for time initialization is:

  time_init :
       late_time_init = hpet_time_init;

  late_time_init -> hpet_time_init:
       setup_pit_timer (BAD)
       do_time_init --> (via paravirt.h)
          time_init_hook --> (via arch_hooks.h)
              time_init_hook (in SUBARCH/setup.c)

If this isn't confusing enough, the paravirt case goes through an indirect
function pointer in the paravirt-ops table.  The problem is, by the time the
paravirt hook is called, the pit timer is already enabled.

But paravirt guests have their own timer, and don't want to use the PIT. 
Rather than intensify the struggle for power going on here, just make it all
nice and simple and just unconditionally do all timer setup in the
late_time_init hook.  This also has the advantage of enabling timers in the
same place in all code paths, so everyone has the same bugs and we don't have
outliers who break other code because they turn on timer too early or too
late.

So the paravirt-ops time init function is now by default hpet_time_init, which
is the time init function used for native hardware.  Paravirt guests have the
chance to override this when they setup the paravirt-ops table, and should
need no change.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    2 +-
 arch/i386/kernel/time.c     |   14 +++++++++++---
 include/asm-i386/paravirt.h |    4 ++--
 include/asm-i386/time.h     |    5 ++++-
 4 files changed, 18 insertions(+), 7 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~vmi-pit-override arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~vmi-pit-override
+++ a/arch/i386/kernel/paravirt.c
@@ -494,7 +494,7 @@ struct paravirt_ops paravirt_ops = {
 	.memory_setup = machine_specific_memory_setup,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
-	.time_init = time_init_hook,
+	.time_init = hpet_time_init,
 	.init_IRQ = native_init_IRQ,
 
 	.cpuid = native_cpuid,
diff -puN arch/i386/kernel/time.c~vmi-pit-override arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c~vmi-pit-override
+++ a/arch/i386/kernel/time.c
@@ -262,14 +262,22 @@ void notify_arch_cmos_timer(void)
 
 extern void (*late_time_init)(void);
 /* Duplicate of time_init() below, with hpet_enable part added */
-static void __init hpet_time_init(void)
+void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
-	do_time_init();
+	time_init_hook();
 }
 
+/*
+ * This is called directly from init code; we must delay timer setup in the
+ * HPET case as we can't make the decision to turn on HPET this early in the
+ * boot process.
+ *
+ * The chosen time_init function will usually be hpet_time_init, above, but
+ * in the case of virtual hardware, an alternative function may be substituted.
+ */
 void __init time_init(void)
 {
-	late_time_init = hpet_time_init;
+	late_time_init = choose_time_init();
 }
diff -puN include/asm-i386/paravirt.h~vmi-pit-override include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~vmi-pit-override
+++ a/include/asm-i386/paravirt.h
@@ -186,9 +186,9 @@ static inline int set_wallclock(unsigned
 	return paravirt_ops.set_wallclock(nowtime);
 }
 
-static inline void do_time_init(void)
+static inline void (*choose_time_init(void))(void)
 {
-	return paravirt_ops.time_init();
+	return paravirt_ops.time_init;
 }
 
 /* The paravirtualized CPUID instruction. */
diff -puN include/asm-i386/time.h~vmi-pit-override include/asm-i386/time.h
--- a/include/asm-i386/time.h~vmi-pit-override
+++ a/include/asm-i386/time.h
@@ -28,13 +28,16 @@ static inline int native_set_wallclock(u
 	return retval;
 }
 
+extern void (*late_time_init)(void);
+extern void hpet_time_init(void);
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else /* !CONFIG_PARAVIRT */
 
 #define get_wallclock() native_get_wallclock()
 #define set_wallclock(x) native_set_wallclock(x)
-#define do_time_init() time_init_hook()
+#define choose_time_init() hpet_time_init
 
 #endif /* CONFIG_PARAVIRT */
 
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
make-struct-vmi_ops-static.patch
