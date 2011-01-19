From: akpm@linux-foundation.org
Subject: + smp-move-smp-setup-functions-to-kernel-smpc.patch added to -mm tree
Date: Wed, 19 Jan 2011 12:09:05 -0800
Message-ID: <201101192009.p0JK95he032760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab1ASUKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 15:10:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, a.p.zijlstra@chello.nl, akinobu.mita@gmail.com, arnd@arndb.de, dhowells@redhat.com, mingo@elte.hu, rakib.mullick@gmail.com, tj@kernel.org


The patch titled
     smp: move smp setup functions to kernel/smp.c
has been added to the -mm tree.  Its filename is
     smp-move-smp-setup-functions-to-kernel-smpc.patch

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
Subject: smp: move smp setup functions to kernel/smp.c
From: Amerigo Wang <amwang@redhat.com>

Move setup_nr_cpu_ids(), smp_init() and some other SMP boot parameter
setup functions from init/main.c to kenrel/smp.c, saves some #ifdef
CONFIG_SMP.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    2 
 init/main.c         |   90 ------------------------------------------
 kernel/smp.c        |   81 +++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 89 deletions(-)

diff -puN include/linux/smp.h~smp-move-smp-setup-functions-to-kernel-smpc include/linux/smp.h
--- a/include/linux/smp.h~smp-move-smp-setup-functions-to-kernel-smpc
+++ a/include/linux/smp.h
@@ -114,6 +114,8 @@ int on_each_cpu(smp_call_func_t func, vo
 void smp_prepare_boot_cpu(void);
 
 extern unsigned int setup_max_cpus;
+extern void __init setup_nr_cpu_ids(void);
+extern void __init smp_init(void);
 
 #else /* !SMP */
 
diff -puN init/main.c~smp-move-smp-setup-functions-to-kernel-smpc init/main.c
--- a/init/main.c~smp-move-smp-setup-functions-to-kernel-smpc
+++ a/init/main.c
@@ -120,63 +120,6 @@ static char *static_command_line;
 static char *execute_command;
 static char *ramdisk_execute_command;
 
-#ifdef CONFIG_SMP
-/* Setup configured maximum number of CPUs to activate */
-unsigned int setup_max_cpus = NR_CPUS;
-EXPORT_SYMBOL(setup_max_cpus);
-
-
-/*
- * Setup routine for controlling SMP activation
- *
- * Command-line option of "nosmp" or "maxcpus=0" will disable SMP
- * activation entirely (the MPS table probe still happens, though).
- *
- * Command-line option of "maxcpus=<NUM>", where <NUM> is an integer
- * greater than 0, limits the maximum number of CPUs activated in
- * SMP mode to <NUM>.
- */
-
-void __weak arch_disable_smp_support(void) { }
-
-static int __init nosmp(char *str)
-{
-	setup_max_cpus = 0;
-	arch_disable_smp_support();
-
-	return 0;
-}
-
-early_param("nosmp", nosmp);
-
-/* this is hard limit */
-static int __init nrcpus(char *str)
-{
-	int nr_cpus;
-
-	get_option(&str, &nr_cpus);
-	if (nr_cpus > 0 && nr_cpus < nr_cpu_ids)
-		nr_cpu_ids = nr_cpus;
-
-	return 0;
-}
-
-early_param("nr_cpus", nrcpus);
-
-static int __init maxcpus(char *str)
-{
-	get_option(&str, &setup_max_cpus);
-	if (setup_max_cpus == 0)
-		arch_disable_smp_support();
-
-	return 0;
-}
-
-early_param("maxcpus", maxcpus);
-#else
-static const unsigned int setup_max_cpus = NR_CPUS;
-#endif
-
 /*
  * If set, this is an indication to the drivers that reset the underlying
  * device before going ahead with the initialization otherwise driver might
@@ -353,7 +296,7 @@ static int __init rdinit_setup(char *str
 __setup("rdinit=", rdinit_setup);
 
 #ifndef CONFIG_SMP
-
+static const unsigned int setup_max_cpus = NR_CPUS;
 #ifdef CONFIG_X86_LOCAL_APIC
 static void __init smp_init(void)
 {
@@ -365,37 +308,6 @@ static void __init smp_init(void)
 
 static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
-
-#else
-
-/* Setup number of possible processor ids */
-int nr_cpu_ids __read_mostly = NR_CPUS;
-EXPORT_SYMBOL(nr_cpu_ids);
-
-/* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
-static void __init setup_nr_cpu_ids(void)
-{
-	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
-}
-
-/* Called by boot processor to activate the rest. */
-static void __init smp_init(void)
-{
-	unsigned int cpu;
-
-	/* FIXME: This should be done in userspace --RR */
-	for_each_present_cpu(cpu) {
-		if (num_online_cpus() >= setup_max_cpus)
-			break;
-		if (!cpu_online(cpu))
-			cpu_up(cpu);
-	}
-
-	/* Any cleanup work */
-	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
-	smp_cpus_done(setup_max_cpus);
-}
-
 #endif
 
 /*
diff -puN kernel/smp.c~smp-move-smp-setup-functions-to-kernel-smpc kernel/smp.c
--- a/kernel/smp.c~smp-move-smp-setup-functions-to-kernel-smpc
+++ a/kernel/smp.c
@@ -532,6 +532,87 @@ void ipi_call_unlock_irq(void)
 }
 #endif /* USE_GENERIC_SMP_HELPERS */
 
+/* Setup configured maximum number of CPUs to activate */
+unsigned int setup_max_cpus = NR_CPUS;
+EXPORT_SYMBOL(setup_max_cpus);
+
+
+/*
+ * Setup routine for controlling SMP activation
+ *
+ * Command-line option of "nosmp" or "maxcpus=0" will disable SMP
+ * activation entirely (the MPS table probe still happens, though).
+ *
+ * Command-line option of "maxcpus=<NUM>", where <NUM> is an integer
+ * greater than 0, limits the maximum number of CPUs activated in
+ * SMP mode to <NUM>.
+ */
+
+void __weak arch_disable_smp_support(void) { }
+
+static int __init nosmp(char *str)
+{
+	setup_max_cpus = 0;
+	arch_disable_smp_support();
+
+	return 0;
+}
+
+early_param("nosmp", nosmp);
+
+/* this is hard limit */
+static int __init nrcpus(char *str)
+{
+	int nr_cpus;
+
+	get_option(&str, &nr_cpus);
+	if (nr_cpus > 0 && nr_cpus < nr_cpu_ids)
+		nr_cpu_ids = nr_cpus;
+
+	return 0;
+}
+
+early_param("nr_cpus", nrcpus);
+
+static int __init maxcpus(char *str)
+{
+	get_option(&str, &setup_max_cpus);
+	if (setup_max_cpus == 0)
+		arch_disable_smp_support();
+
+	return 0;
+}
+
+early_param("maxcpus", maxcpus);
+
+/* Setup number of possible processor ids */
+int nr_cpu_ids __read_mostly = NR_CPUS;
+EXPORT_SYMBOL(nr_cpu_ids);
+
+/* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
+void __init setup_nr_cpu_ids(void)
+{
+	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
+}
+
+/* Called by boot processor to activate the rest. */
+void __init smp_init(void)
+{
+	unsigned int cpu;
+
+	/* FIXME: This should be done in userspace --RR */
+	for_each_present_cpu(cpu) {
+		if (num_online_cpus() >= setup_max_cpus)
+			break;
+		if (!cpu_online(cpu))
+			cpu_up(cpu);
+	}
+
+	/* Any cleanup work */
+	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
+	smp_cpus_done(setup_max_cpus);
+}
+
 /*
  * Call a function on all processors
  */
_

Patches currently in -mm which might be from amwang@redhat.com are

debugfs-remove-module_exit.patch
smp-move-smp-setup-functions-to-kernel-smpc.patch

