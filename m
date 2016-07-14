From: akpm@linux-foundation.org
Subject: [withdrawn]
 x86-panic-replace-smp_send_stop-with-kdump-friendly-version.patch removed
 from -mm tree
Date: Thu, 14 Jul 2016 12:38:28 -0700
Message-ID: <5787ea34.3hPcVQmzbAL/PaGx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbcGNTi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:38:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, bhe@redhat.com, bp@suse.de, dwalker@fifo99.com, dyoung@redhat.com, ebiederm@xmission.com, mhiramat@kernel.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/panic: Replace smp_send_stop() with kdump friendly version
has been removed from the -mm tree.  Its filename was
     x86-panic-replace-smp_send_stop-with-kdump-friendly-version.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: x86/panic: Replace smp_send_stop() with kdump friendly version

This patch fixes one of the problems reported by Daniel Walker
(https://lkml.org/lkml/2015/6/24/44).

If crash_kexec_post_notifiers boot option is specified, other CPUs
are stopped by smp_send_stop() instead of machine_crash_shutdown()
in crash_kexec() path.  This behavior change leads two problems.

 Problem 1:
 octeon_generic_shutdown() for MIPS OCTEON assumes that other CPUs are
 still online and try to stop their watchdog timer.  If
 smp_send_stop() is called before octeon_generic_shutdown(), stopping
 watchdog timer will fail because other CPUs have been offlined by
 smp_send_stop().

   panic()
     if crash_kexec_post_notifiers == 1
       smp_send_stop()
       atomic_notifier_call_chain()
       kmsg_dump()
     crash_kexec()
       machine_crash_shutdown()
         octeon_generic_shutdown() // shutdown watchdog for ONLINE CPUs

 Problem 2:
 Most of architectures stop other CPUs in machine_crash_shutdown()
 path, and they also do something needed for kdump.  For example,
 they save registers, disable virtualization extensions, and so on.
 However, if smp_send_stop() stops other CPUs before
 machine_crash_shutdown(), we miss those operations.

How do we fix these problems?  In the first place, we should stop
other CPUs as soon as possible when panic() was called, otherwise
other CPUs may wipe out a clue to the cause of the failure.  So, we
replace smp_send_stop() with more suitable one for kdump.

This patch solves Problem 2 by replacing smp_send_stop() in panic()
with panic_smp_send_stop().  This is a weak function which calls
smp_send_stop(), and architecture dependent code may override this
with appropriate one.  This patch only provides x86-specific version.

Link: http://lkml.kernel.org/r/20160705113325.5864.74840.stgit@softrs
Reported-by: Daniel Walker <dwalker@fifo99.com>
Fixes: f06e5153f4ae (kernel/panic.c: add "crash_kexec_post_notifiers" option)
Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |   14 ++++++++----
 kernel/panic.c          |   43 ++++++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 15 deletions(-)

diff -puN arch/x86/kernel/crash.c~x86-panic-replace-smp_send_stop-with-kdump-friendly-version arch/x86/kernel/crash.c
--- a/arch/x86/kernel/crash.c~x86-panic-replace-smp_send_stop-with-kdump-friendly-version
+++ a/arch/x86/kernel/crash.c
@@ -133,15 +133,21 @@ static void kdump_nmi_callback(int cpu,
 	disable_local_APIC();
 }
 
-static void kdump_nmi_shootdown_cpus(void)
+/* Override the weak function in kernel/panic.c */
+void panic_smp_send_stop(void)
 {
-	nmi_shootdown_cpus(kdump_nmi_callback);
+	static int cpus_stopped;
+
+	if (cpus_stopped)
+		return;
 
+	nmi_shootdown_cpus(kdump_nmi_callback);
 	disable_local_APIC();
+	cpus_stopped = 1;
 }
 
 #else
-static void kdump_nmi_shootdown_cpus(void)
+void panic_smp_send_stop(void)
 {
 	/* There are no cpus to shootdown */
 }
@@ -160,7 +166,7 @@ void native_machine_crash_shutdown(struc
 	/* The kernel is broken so disable interrupts */
 	local_irq_disable();
 
-	kdump_nmi_shootdown_cpus();
+	panic_smp_send_stop();
 
 	/*
 	 * VMCLEAR VMCSs loaded on this cpu if needed.
diff -puN kernel/panic.c~x86-panic-replace-smp_send_stop-with-kdump-friendly-version kernel/panic.c
--- a/kernel/panic.c~x86-panic-replace-smp_send_stop-with-kdump-friendly-version
+++ a/kernel/panic.c
@@ -71,6 +71,32 @@ void __weak nmi_panic_self_stop(struct p
 	panic_smp_self_stop();
 }
 
+/*
+ * Stop other CPUs in panic.  Architecture dependent code may override this
+ * with more suitable version.  For example, if the architecture supports
+ * crash dump, it should save registers of each stopped CPU and disable
+ * per-CPU features such as virtualization extensions.
+ */
+void __weak panic_smp_send_stop(void)
+{
+	static int cpus_stopped;
+
+	/*
+	 * This function can be called twice in panic path, but obviously
+	 * we execute this only once.
+	 */
+	if (cpus_stopped)
+		return;
+
+	/*
+	 * Note smp_send_stop is the usual smp shutdown function, which
+	 * unfortunately means it may not be hardened to work in a panic
+	 * situation.
+	 */
+	smp_send_stop();
+	cpus_stopped = 1;
+}
+
 atomic_t panic_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 
 /*
@@ -125,7 +151,7 @@ void panic(const char *fmt, ...)
 	 * Only one CPU is allowed to execute the panic code from here. For
 	 * multiple parallel invocations of panic, all other CPUs either
 	 * stop themself or will wait until they are stopped by the 1st CPU
-	 * with smp_send_stop().
+	 * with panic_smp_send_stop().
 	 *
 	 * `old_cpu == PANIC_CPU_INVALID' means this is the 1st CPU which
 	 * comes here, so go ahead.
@@ -165,12 +191,7 @@ void panic(const char *fmt, ...)
 		__crash_kexec(NULL);
 	}
 
-	/*
-	 * Note smp_send_stop is the usual smp shutdown function, which
-	 * unfortunately means it may not be hardened to work in a panic
-	 * situation.
-	 */
-	smp_send_stop();
+	panic_smp_send_stop();
 
 	/*
 	 * Run any panic handlers, including those that might need to
@@ -198,10 +219,10 @@ void panic(const char *fmt, ...)
 
 	/*
 	 * We may have ended up stopping the CPU holding the lock (in
-	 * smp_send_stop()) while still having some valuable data in the console
-	 * buffer.  Try to acquire the lock then release it regardless of the
-	 * result.  The release will also print the buffers out.  Locks debug
-	 * should be disabled to avoid reporting bad unlock balance when
+	 * panic_smp_send_stop()) while still having some valuable data in the
+	 * console buffer.  Try to acquire the lock then release it regardless
+	 * of the result.  The release will also print the buffers out.  Locks
+	 * debug should be disabled to avoid reporting bad unlock balance when
 	 * panic() is not being callled from OOPS.
 	 */
 	debug_locks_off();
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

kexec-use-core_param-for-crash_kexec_post_notifiers-boot-option.patch

