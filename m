From: akpm@linux-foundation.org
Subject: [patch 070/102] mips/panic: replace smp_send_stop() with kdump
 friendly version in panic path
Date: Tue, 11 Oct 2016 13:54:26 -0700
Message-ID: <57fd5182.ty3RW1q95EPLW3JP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38179 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcJKUy2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hidehiro.kawai.ez@hitachi.com, aaro.koskinen@iki.fi, bhe@redhat.com, bp@suse.de, cminyard@mvista.com, david.daney@cavium.com, david.vrabel@citrix.com, dwalker@fifo99.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mhiramat@kernel.org, mingo@redhat.com, ralf@linux-mips.org, steven.hill@cavium.com, tglx@linutronix.de, toshi.kani@hpe.com, vgoyal@redhat.com, xpang@redhat.com

From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: mips/panic: replace smp_send_stop() with kdump friendly version in panic path

Daniel Walker reported problems which happens when
crash_kexec_post_notifiers kernel option is enabled
(https://lkml.org/lkml/2015/6/24/44).

In that case, smp_send_stop() is called before entering kdump routines
which assume other CPUs are still online.  As the result, kdump
routines fail to save other CPUs' registers.  Additionally for MIPS
OCTEON, it misses to stop the watchdog timer.

To fix this problem, call a new kdump friendly function,
crash_smp_send_stop(), instead of the smp_send_stop() when
crash_kexec_post_notifiers is enabled.  crash_smp_send_stop() is a
weak function, and it just call smp_send_stop().  Architecture
codes should override it so that kdump can work appropriately.
This patch provides MIPS version.

Fixes: f06e5153f4ae (kernel/panic.c: add "crash_kexec_post_notifiers" option)
Link: http://lkml.kernel.org/r/20160810080950.11028.28000.stgit@sysi4-13.yrl.intra.hitachi.co.jp
Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Reported-by: Daniel Walker <dwalker@fifo99.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Xunlei Pang <xpang@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: "Steven J. Hill" <steven.hill@cavium.com>
Cc: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/setup.c  |   14 ++++++++++++++
 arch/mips/include/asm/kexec.h    |    1 +
 arch/mips/kernel/crash.c         |   18 +++++++++++++++++-
 arch/mips/kernel/machine_kexec.c |    1 +
 4 files changed, 33 insertions(+), 1 deletion(-)

diff -puN arch/mips/cavium-octeon/setup.c~mips-panic-replace-smp_send_stop-with-kdump-friendly-version-in-panic-path arch/mips/cavium-octeon/setup.c
--- a/arch/mips/cavium-octeon/setup.c~mips-panic-replace-smp_send_stop-with-kdump-friendly-version-in-panic-path
+++ a/arch/mips/cavium-octeon/setup.c
@@ -267,6 +267,17 @@ static void octeon_crash_shutdown(struct
 	default_machine_crash_shutdown(regs);
 }
 
+#ifdef CONFIG_SMP
+void octeon_crash_smp_send_stop(void)
+{
+	int cpu;
+
+	/* disable watchdogs */
+	for_each_online_cpu(cpu)
+		cvmx_write_csr(CVMX_CIU_WDOGX(cpu_logical_map(cpu)), 0);
+}
+#endif
+
 #endif /* CONFIG_KEXEC */
 
 #ifdef CONFIG_CAVIUM_RESERVE32
@@ -911,6 +922,9 @@ void __init prom_init(void)
 	_machine_kexec_shutdown = octeon_shutdown;
 	_machine_crash_shutdown = octeon_crash_shutdown;
 	_machine_kexec_prepare = octeon_kexec_prepare;
+#ifdef CONFIG_SMP
+	_crash_smp_send_stop = octeon_crash_smp_send_stop;
+#endif
 #endif
 
 	octeon_user_io_init();
diff -puN arch/mips/include/asm/kexec.h~mips-panic-replace-smp_send_stop-with-kdump-friendly-version-in-panic-path arch/mips/include/asm/kexec.h
--- a/arch/mips/include/asm/kexec.h~mips-panic-replace-smp_send_stop-with-kdump-friendly-version-in-panic-path
+++ a/arch/mips/include/asm/kexec.h
@@ -45,6 +45,7 @@ extern const unsigned char kexec_smp_wai
 extern unsigned long secondary_kexec_args[4];
 extern void (*relocated_kexec_smp_wait) (void *);
 extern atomic_t kexec_ready_to_reboot;
+extern void (*_crash_smp_send_stop)(void);
 #endif
 #endif
 
diff -puN arch/mips/kernel/crash.c~mips-panic-replace-smp_send_stop-with-kdump-friendly-version-in-panic-path arch/mips/kernel/crash.c
--- a/arch/mips/kernel/crash.c~mips-panic-replace-smp_send_stop-with-kdump-friendly-version-in-panic-path
+++ a/arch/mips/kernel/crash.c
@@ -47,9 +47,14 @@ static void crash_shutdown_secondary(voi
 
 static void crash_kexec_prepare_cpus(void)
 {
+	static int cpus_stopped;
 	unsigned int msecs;
+	unsigned int ncpus;
 
-	unsigned int ncpus = num_online_cpus() - 1;/* Excluding the panic cpu */
+	if (cpus_stopped)
+		return;
+
+	ncpus = num_online_cpus() - 1;/* Excluding the panic cpu */
 
 	dump_send_ipi(crash_shutdown_secondary);
 	smp_wmb();
@@ -64,6 +69,17 @@ static void crash_kexec_prepare_cpus(voi
 		cpu_relax();
 		mdelay(1);
 	}
+
+	cpus_stopped = 1;
+}
+
+/* Override the weak function in kernel/panic.c */
+void crash_smp_send_stop(void)
+{
+	if (_crash_smp_send_stop)
+		_crash_smp_send_stop();
+
+	crash_kexec_prepare_cpus();
 }
 
 #else /* !defined(CONFIG_SMP)  */
diff -puN arch/mips/kernel/machine_kexec.c~mips-panic-replace-smp_send_stop-with-kdump-friendly-version-in-panic-path arch/mips/kernel/machine_kexec.c
--- a/arch/mips/kernel/machine_kexec.c~mips-panic-replace-smp_send_stop-with-kdump-friendly-version-in-panic-path
+++ a/arch/mips/kernel/machine_kexec.c
@@ -25,6 +25,7 @@ void (*_machine_crash_shutdown)(struct p
 #ifdef CONFIG_SMP
 void (*relocated_kexec_smp_wait) (void *);
 atomic_t kexec_ready_to_reboot = ATOMIC_INIT(0);
+void (*_crash_smp_send_stop)(void) = NULL;
 #endif
 
 int
_
