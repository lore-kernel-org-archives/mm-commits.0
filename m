From: akpm@linux-foundation.org
Subject: - vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch removed from -mm tree
Date: Sat, 19 May 2007 23:42:17 -0700
Message-ID: <200705200642.l4K6gJCx017457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42206 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756888AbXETGop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 02:44:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, arjan@infradead.org, mm-commits@vger.kernel.org


The patch titled
     vdso: improve print_fatal_signals support by adding memory maps
has been removed from the -mm tree.  Its filename was
     vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: vdso: improve print_fatal_signals support by adding memory maps
From: Ingo Molnar <mingo@elte.hu>

improved the print-fatal-signals debug output:

hotplug/825: potentially unexpected fatal signal 11.
code at ffffe400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
vDSO at b7f41000

Pid: 825, comm:              hotplug
EIP: 0073:[<ffffe400>] CPU: 0
EIP is at 0xffffe400
 ESP: 007b:bff52910 EFLAGS: 00010246    Not tainted  (2.6.17-rc4 #91)
EAX: 000000af EBX: 00000000 ECX: 00000000 EDX: 080f341c
ESI: 00000008 EDI: 41c9eff4 EBP: bff529ac DS: 007b ES: 007b
CR0: 8005003b CR2: ffffe40f CR3: 372a3000 CR4: 00000680
 [<c0103fad>] show_trace+0xd/0x10
 [<c0101637>] show_regs+0x177/0x180
 [<c0123d13>] get_signal_to_deliver+0x3f3/0x7d0
 [<c010278c>] do_notify_resume+0x1bc/0x750
 [<c0102ebe>] work_notifysig+0x13/0x19

08047000-080e9000 r-xp 00000000 03:01 3547392    /bin/bash
080e9000-080ef000 rw-p 000a1000 03:01 3547392    /bin/bash
080ef000-080f4000 rw-p 080ef000 00:00 0          [heap]
41b5a000-41b73000 r-xp 00000000 03:01 846154     /lib/ld-2.3.90.so
41b73000-41b74000 r--p 00018000 03:01 846154     /lib/ld-2.3.90.so
41b74000-41b75000 rw-p 00019000 03:01 846154     /lib/ld-2.3.90.so
41b77000-41c9d000 r-xp 00000000 03:01 846155     /lib/libc-2.3.90.so
41c9d000-41c9f000 r--p 00125000 03:01 846155     /lib/libc-2.3.90.so
41c9f000-41ca1000 rw-p 00127000 03:01 846155     /lib/libc-2.3.90.so
41ca1000-41ca3000 rw-p 41ca1000 00:00 0
41ccc000-41cce000 r-xp 00000000 03:01 846157     /lib/libdl-2.3.90.so
41cce000-41ccf000 r--p 00001000 03:01 846157     /lib/libdl-2.3.90.so
41ccf000-41cd0000 rw-p 00002000 03:01 846157     /lib/libdl-2.3.90.so
41dce000-41dd1000 r-xp 00000000 03:01 846175     /lib/libtermcap.so.2.0.8
41dd1000-41dd2000 rw-p 00002000 03:01 846175     /lib/libtermcap.so.2.0.8
b7f29000-b7f2a000 rw-p b7f29000 00:00 0
b7f40000-b7f41000 rw-p b7f40000 00:00 0
b7f41000-b7f42000 r-xp b7f41000 00:00 0          [vdso]
bff3e000-bff53000 rw-p bff3e000 00:00 0          [stack]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   97 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~vdso-improve-print_fatal_signals-support-by-adding-memory-maps kernel/signal.c
--- a/kernel/signal.c~vdso-improve-print_fatal_signals-support-by-adding-memory-maps
+++ a/kernel/signal.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
@@ -693,7 +694,95 @@ out_set:
 #define LEGACY_QUEUE(sigptr, sig) \
 	(((sig) < SIGRTMIN) && sigismember(&(sigptr)->signal, (sig)))
 
-int print_fatal_signals = 0;
+int print_fatal_signals;
+
+static void pad_len_spaces(int len)
+{
+	len = 25 + sizeof(void*) * 6 - len;
+
+	if (len < 1)
+		len = 1;
+
+	printk("%*c", len, ' ');
+}
+
+static int print_vma(struct vm_area_struct *vma)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct file *file = vma->vm_file;
+	int flags = vma->vm_flags;
+	unsigned long ino = 0;
+	dev_t dev = 0;
+	int len = 0;
+
+	if (file) {
+		struct inode *inode = vma->vm_file->f_dentry->d_inode;
+		dev = inode->i_sb->s_dev;
+		ino = inode->i_ino;
+	}
+
+	printk("%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
+			vma->vm_start,
+			vma->vm_end,
+			flags & VM_READ ? 'r' : '-',
+			flags & VM_WRITE ? 'w' : '-',
+			flags & VM_EXEC ? 'x' : '-',
+			flags & VM_MAYSHARE ? 's' : 'p',
+			vma->vm_pgoff << PAGE_SHIFT,
+			MAJOR(dev), MINOR(dev), ino, &len);
+
+	/*
+	 * Print the dentry name for named mappings, and a
+	 * special [heap] marker for the heap:
+	 */
+	if (file) {
+#define SIZE 128
+		char tmp[SIZE], *str;
+
+		str = d_path(file->f_dentry, file->f_vfsmnt, tmp, SIZE);
+		while (str[0] && (str[0] == ' '))
+			str++;
+
+		pad_len_spaces(len);
+		printk("%s", str);
+	} else {
+		const char *name = arch_vma_name(vma);
+		if (!name) {
+			if (mm) {
+				if (vma->vm_start <= mm->start_brk &&
+						vma->vm_end >= mm->brk) {
+					name = "[heap]";
+				} else if (vma->vm_start <= mm->start_stack &&
+					   vma->vm_end >= mm->start_stack) {
+					name = "[stack]";
+				}
+			} else {
+				name = "[vdso]";
+			}
+		}
+		if (name) {
+			pad_len_spaces(len);
+			printk(name);
+		}
+	}
+	printk("\n");
+
+	return 0;
+}
+
+static void print_vmas(void)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
+
+	if (!mm)
+		return;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		print_vma(vma);
+	up_read(&mm->mmap_sem);
+}
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
@@ -711,9 +800,13 @@ static void print_fatal_signal(struct pt
 			printk("%02x ", insn);
 		}
 	}
-#endif
 	printk("\n");
+	if (current->mm)
+		printk("vDSO at %p\n", current->mm->context.vdso);
+#endif
 	show_regs(regs);
+	printk("\n");
+	print_vmas();
 }
 
 static int __init setup_print_fatal_signals(char *str)
_

Patches currently in -mm which might be from mingo@elte.hu are

git-kvm.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
pie-randomization.patch
pie-randomization-fix.patch
cfs-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
