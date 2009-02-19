From: akpm@linux-foundation.org
Subject: + kgdb-switch-master-cpu-after-gdb-thread-command-for-smp.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:50:42 -0800
Message-ID: <200902192050.n1JKogYv022134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbZBSUvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:51:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.adi@gmail.com, cooloney@kernel.org, jason.wessel@windriver.com


The patch titled
     kgdb: switch master cpu after gdb thread command for SMP
has been added to the -mm tree.  Its filename is
     kgdb-switch-master-cpu-after-gdb-thread-command-for-smp.patch

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
Subject: kgdb: switch master cpu after gdb thread command for SMP
From: sonic zhang <sonic.adi@gmail.com>

The kgdb SMP patch, which is tested on blackfin bf561 dual core system.  

   In blackfin SMP architecture, different core has its own L1 SRAM and
   MMR memory, which code running on the other core can't access.  In
   current kgdb implementation, cpus are represented by thread with minus
   prefix.

If user run thread command in gdb to switch to the thread of the other
cpu, kgdb should:

1. send IPI signal to master cpu
2. release the specific passive cpu waiting in IPI handler
3. exit kgdb exception loop on master cpu and trap into kgdb wait in IPI handler
4. trap the released passive cpu into kgdb exception in IPI handler

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kgdb.h |   13 ++++++
 kernel/kgdb.c        |   85 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 89 insertions(+), 9 deletions(-)

diff -puN include/linux/kgdb.h~kgdb-switch-master-cpu-after-gdb-thread-command-for-smp include/linux/kgdb.h
--- a/include/linux/kgdb.h~kgdb-switch-master-cpu-after-gdb-thread-command-for-smp
+++ a/include/linux/kgdb.h
@@ -202,6 +202,19 @@ kgdb_arch_handle_exception(int vector, i
  */
 extern void kgdb_roundup_cpus(unsigned long flags);
 
+/**
+ *	kgdb_roundup_cpu - Get spcific CPU into a holding pattern
+ *	@cpu: Specific cpu id
+ *	@flags: Current IRQ state
+ *
+ *	On SMP systems, we need to switch cpu from current active one to
+ *	the other passive one. This get current active CPU into a known state
+ *	in kgdb_wait().
+ *
+ *	On non-SMP systems, this is not called.
+ */
+extern void kgdb_roundup_cpu(int cpu, unsigned long flags);
+
 /* Optional functions. */
 extern int kgdb_validate_break_address(unsigned long addr);
 extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
diff -puN kernel/kgdb.c~kgdb-switch-master-cpu-after-gdb-thread-command-for-smp kernel/kgdb.c
--- a/kernel/kgdb.c~kgdb-switch-master-cpu-after-gdb-thread-command-for-smp
+++ a/kernel/kgdb.c
@@ -565,6 +565,7 @@ static void kgdb_wait(struct pt_regs *re
 {
 	unsigned long flags;
 	int cpu;
+	struct task_struct *thread;
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
@@ -577,10 +578,26 @@ static void kgdb_wait(struct pt_regs *re
 	smp_wmb();
 	atomic_set(&cpu_in_kgdb[cpu], 1);
 
+	kgdb_disable_hw_debug(regs);
+
 	/* Wait till primary CPU is done with debugging */
 	while (atomic_read(&passive_cpu_wait[cpu]))
 		cpu_relax();
 
+	/* Trap into kgdb as the active CPU if gdb asks to switch. */
+	thread = getthread(regs, -raw_smp_processor_id() - 2);
+	if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) &&
+		kgdb_contthread && kgdb_contthread == current) {
+		kgdb_breakpoint();
+
+		kgdb_info[cpu].debuggerinfo = NULL;
+		kgdb_info[cpu].task = NULL;
+
+		clocksource_touch_watchdog();
+		local_irq_restore(flags);
+		return;
+	}
+
 	kgdb_info[cpu].debuggerinfo = NULL;
 	kgdb_info[cpu].task = NULL;
 
@@ -1066,13 +1083,16 @@ static void gdb_cmd_query(struct kgdb_st
 			sprintf(tmpstr, "shadowCPU%d",
 					(int)(-ks->threadid - 2));
 			kgdb_mem2hex(tmpstr, remcom_out_buffer, strlen(tmpstr));
+
+			if (arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP)
+				ks->thr_query = 1;
 		}
 		break;
 	}
 }
 
 /* Handle the 'H' task query packets */
-static void gdb_cmd_task(struct kgdb_state *ks)
+static int gdb_cmd_task(struct kgdb_state *ks)
 {
 	struct task_struct *thread;
 	char *ptr;
@@ -1089,6 +1109,15 @@ static void gdb_cmd_task(struct kgdb_sta
 		kgdb_usethread = thread;
 		ks->kgdb_usethreadid = ks->threadid;
 		strcpy(remcom_out_buffer, "OK");
+#ifdef CONFIG_SMP
+		if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) &&
+			!ks->thr_query && ks->kgdb_usethreadid < -1 &&
+			- ks->kgdb_usethreadid - 2 != raw_smp_processor_id()) {
+			kgdb_roundup_cpu(raw_smp_processor_id(), 0);
+			kgdb_contthread = kgdb_usethread;
+			return 1;
+		}
+#endif
 		break;
 	case 'c':
 		ptr = &remcom_in_buffer[2];
@@ -1102,10 +1131,27 @@ static void gdb_cmd_task(struct kgdb_sta
 				break;
 			}
 			kgdb_contthread = thread;
+#ifdef CONFIG_SMP
+			if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) &&
+				thread != current) {
+				int cpu;
+				for_each_online_cpu(cpu) {
+					if (thread == kgdb_info[cpu].task) {
+						kgdb_roundup_cpu(
+							raw_smp_processor_id(),
+							0);
+						ks->kgdb_usethreadid = -cpu-2;
+						return 1;
+					}
+				}
+			}
+#endif
 		}
 		strcpy(remcom_out_buffer, "OK");
 		break;
 	}
+
+	return 0;
 }
 
 /* Handle the 'T' thread query packets */
@@ -1114,6 +1160,9 @@ static void gdb_cmd_thread(struct kgdb_s
 	char *ptr = &remcom_in_buffer[1];
 	struct task_struct *thread;
 
+	if (arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP)
+		ks->thr_query = 0;
+
 	kgdb_hex2long(&ptr, &ks->threadid);
 	thread = getthread(ks->linux_regs, ks->threadid);
 	if (thread)
@@ -1223,7 +1272,12 @@ static int gdb_serial_stub(struct kgdb_s
 	/* Clear the out buffer. */
 	memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
 
-	if (kgdb_connected) {
+	if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) && kgdb_contthread) {
+		remcom_out_buffer[0] = 'O';
+		remcom_out_buffer[1] = 'K';
+		remcom_out_buffer[2] = 0;
+		put_packet(remcom_out_buffer);
+	} else if (kgdb_connected) {
 		unsigned char thref[8];
 		char *ptr;
 
@@ -1238,6 +1292,7 @@ static int gdb_serial_stub(struct kgdb_s
 		put_packet(remcom_out_buffer);
 	}
 
+	kgdb_contthread = current;
 	kgdb_usethread = kgdb_info[ks->cpu].task;
 	ks->kgdb_usethreadid = shadow_pid(kgdb_info[ks->cpu].task->pid);
 	ks->pass_exception = 0;
@@ -1284,7 +1339,8 @@ static int gdb_serial_stub(struct kgdb_s
 			gdb_cmd_query(ks);
 			break;
 		case 'H': /* task related */
-			gdb_cmd_task(ks);
+			if (gdb_cmd_task(ks))
+				goto kgdb_exit;
 			break;
 		case 'T': /* Query thread status */
 			gdb_cmd_thread(ks);
@@ -1324,6 +1380,7 @@ default_handle:
 			if (error >= 0 || remcom_in_buffer[0] == 'D' ||
 			    remcom_in_buffer[0] == 'k') {
 				error = 0;
+				kgdb_contthread = NULL;
 				goto kgdb_exit;
 			}
 
@@ -1464,11 +1521,15 @@ acquirelock:
 	 * Get the passive CPU lock which will hold all the non-primary
 	 * CPU in a spin state while the debugger is active
 	 */
-	if (!kgdb_single_step) {
+	if (!kgdb_single_step && !kgdb_contthread) {
 		for (i = 0; i < NR_CPUS; i++)
 			atomic_set(&passive_cpu_wait[i], 1);
 	}
 
+	if (kgdb_contthread)
+		atomic_set(&passive_cpu_wait[raw_smp_processor_id()], 1);
+
+
 	/*
 	 * spin_lock code is good enough as a barrier so we don't
 	 * need one here:
@@ -1477,7 +1538,7 @@ acquirelock:
 
 #ifdef CONFIG_SMP
 	/* Signal the other CPUs to enter kgdb_wait() */
-	if ((!kgdb_single_step) && kgdb_do_roundup)
+	if ((!kgdb_single_step && !kgdb_contthread) && kgdb_do_roundup)
 		kgdb_roundup_cpus(flags);
 #endif
 
@@ -1496,7 +1557,6 @@ acquirelock:
 	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
 	kgdb_deactivate_sw_breakpoints();
 	kgdb_single_step = 0;
-	kgdb_contthread = current;
 	exception_level = 0;
 
 	/* Talk to debugger with gdbserial protocol */
@@ -1510,7 +1570,14 @@ acquirelock:
 	kgdb_info[ks->cpu].task = NULL;
 	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
 
-	if (!kgdb_single_step) {
+#ifdef CONFIG_SMP
+	i = -(ks->kgdb_usethreadid + 2);
+	if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) &&
+		kgdb_contthread && i != cpu) {
+		atomic_set(&passive_cpu_wait[i], 0);
+	}
+#endif
+	if (!kgdb_single_step && !kgdb_contthread) {
 		for (i = NR_CPUS-1; i >= 0; i--)
 			atomic_set(&passive_cpu_wait[i], 0);
 		/*
@@ -1536,9 +1603,9 @@ kgdb_restore:
 int kgdb_nmicallback(int cpu, void *regs)
 {
 #ifdef CONFIG_SMP
-	if (!atomic_read(&cpu_in_kgdb[cpu]) &&
+	if (!atomic_read(&cpu_in_kgdb[cpu]) && (kgdb_contthread ||
 			atomic_read(&kgdb_active) != cpu &&
-			atomic_read(&cpu_in_kgdb[atomic_read(&kgdb_active)])) {
+			atomic_read(&cpu_in_kgdb[atomic_read(&kgdb_active)]))) {
 		kgdb_wait((struct pt_regs *)regs);
 		return 0;
 	}
_

Patches currently in -mm which might be from sonic.adi@gmail.com are

linux-next.patch
kgdb-switch-master-cpu-after-gdb-thread-command-for-smp.patch

