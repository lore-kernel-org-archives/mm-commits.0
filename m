From: akpm@linux-foundation.org
Subject: - container-freezer-implement-freezer-cgroup-subsystem.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:21 -0700
Message-ID: <200810202034.m9KKYLUp010827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbYJTUfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, clg@fr.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     container freezer: implement freezer cgroup subsystem
has been removed from the -mm tree.  Its filename was
     container-freezer-implement-freezer-cgroup-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container freezer: implement freezer cgroup subsystem
From: Matt Helsley <matthltc@us.ibm.com>

This patch implements a new freezer subsystem in the control groups
framework.  It provides a way to stop and resume execution of all tasks in
a cgroup by writing in the cgroup filesystem.

The freezer subsystem in the container filesystem defines a file named
freezer.state.  Writing "FROZEN" to the state file will freeze all tasks
in the cgroup.  Subsequently writing "RUNNING" will unfreeze the tasks in
the cgroup.  Reading will return the current state.

* Examples of usage :

   # mkdir /containers/freezer
   # mount -t cgroup -ofreezer freezer  /containers
   # mkdir /containers/0
   # echo $some_pid > /containers/0/tasks

to get status of the freezer subsystem :

   # cat /containers/0/freezer.state
   RUNNING

to freeze all tasks in the container :

   # echo FROZEN > /containers/0/freezer.state
   # cat /containers/0/freezer.state
   FREEZING
   # cat /containers/0/freezer.state
   FROZEN

to unfreeze all tasks in the container :

   # echo RUNNING > /containers/0/freezer.state
   # cat /containers/0/freezer.state
   RUNNING

This is the basic mechanism which should do the right thing for user space
task in a simple scenario.

It's important to note that freezing can be incomplete.  In that case we
return EBUSY.  This means that some tasks in the cgroup are busy doing
something that prevents us from completely freezing the cgroup at this
time.  After EBUSY, the cgroup will remain partially frozen -- reflected
by freezer.state reporting "FREEZING" when read.  The state will remain
"FREEZING" until one of these things happens:

	1) Userspace cancels the freezing operation by writing "RUNNING" to
		the freezer.state file
	2) Userspace retries the freezing operation by writing "FROZEN" to
		the freezer.state file (writing "FREEZING" is not legal
		and returns EIO)
	3) The tasks that blocked the cgroup from entering the "FROZEN"
		state disappear from the cgroup's set of tasks.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: export thaw_process]
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig            |    1 
 arch/arm/Kconfig              |    2 
 arch/avr32/Kconfig            |    2 
 arch/blackfin/Kconfig         |    3 
 arch/cris/Kconfig             |    2 
 arch/frv/Kconfig              |    2 
 arch/h8300/Kconfig            |    2 
 arch/ia64/Kconfig             |    2 
 arch/m32r/Kconfig             |    2 
 arch/m68k/Kconfig             |    2 
 arch/m68knommu/Kconfig        |    2 
 arch/mips/Kconfig             |    2 
 arch/mn10300/Kconfig          |    2 
 arch/parisc/Kconfig           |    2 
 arch/powerpc/Kconfig          |    2 
 arch/s390/Kconfig             |    2 
 arch/sh/Kconfig               |    2 
 arch/sparc/Kconfig            |    2 
 arch/sparc64/Kconfig          |    1 
 arch/um/Kconfig               |    2 
 arch/x86/Kconfig              |    1 
 arch/xtensa/Kconfig           |    1 
 include/linux/cgroup_subsys.h |    6 
 include/linux/freezer.h       |   31 --
 init/Kconfig                  |    7 
 kernel/Kconfig.freezer        |    2 
 kernel/Makefile               |    1 
 kernel/cgroup_freezer.c       |  366 ++++++++++++++++++++++++++++++++
 kernel/freezer.c              |   32 ++
 kernel/power/Kconfig          |    3 
 30 files changed, 466 insertions(+), 23 deletions(-)

diff -puN arch/alpha/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/alpha/Kconfig
@@ -70,6 +70,7 @@ config AUTO_IRQ_AFFINITY
 	default y
 
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 
 
 menu "System setup"
diff -puN arch/arm/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/arm/Kconfig
--- a/arch/arm/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/arm/Kconfig
@@ -192,6 +192,8 @@ config VECTORS_BASE
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "System Type"
 
 choice
diff -puN arch/avr32/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/avr32/Kconfig
@@ -72,6 +72,8 @@ config GENERIC_BUG
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "System Type and features"
 
 source "kernel/time/Kconfig"
diff -puN arch/blackfin/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/blackfin/Kconfig
@@ -64,8 +64,11 @@ config HARDWARE_PM
 	depends on OPROFILE
 
 source "init/Kconfig"
+
 source "kernel/Kconfig.preempt"
 
+source "kernel/Kconfig.freezer"
+
 menu "Blackfin Processor Options"
 
 comment "Processor and Board Settings"
diff -puN arch/cris/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/cris/Kconfig
--- a/arch/cris/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/cris/Kconfig
@@ -62,6 +62,8 @@ config HZ
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "General setup"
 
 source "fs/Kconfig.binfmt"
diff -puN arch/frv/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/frv/Kconfig
--- a/arch/frv/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/frv/Kconfig
@@ -66,6 +66,8 @@ mainmenu "Fujitsu FR-V Kernel Configurat
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 
 menu "Fujitsu FR-V system setup"
 
diff -puN arch/h8300/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/h8300/Kconfig
@@ -90,6 +90,8 @@ config HZ
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 source "arch/h8300/Kconfig.cpu"
 
 menu "Executable file formats"
diff -puN arch/ia64/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/ia64/Kconfig
@@ -7,6 +7,8 @@ mainmenu "IA-64 Linux Kernel Configurati
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Processor type and features"
 
 config IA64
diff -puN arch/m32r/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/m32r/Kconfig
@@ -42,6 +42,8 @@ config HZ
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 
 menu "Processor type and features"
 
diff -puN arch/m68k/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/m68k/Kconfig
@@ -62,6 +62,8 @@ mainmenu "Linux/68k Kernel Configuration
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Platform dependent setup"
 
 config EISA
diff -puN arch/m68knommu/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/m68knommu/Kconfig
@@ -75,6 +75,8 @@ config NO_IOPORT
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Processor type and features"
 
 choice
diff -puN arch/mips/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/mips/Kconfig
--- a/arch/mips/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/mips/Kconfig
@@ -1885,6 +1885,8 @@ config PROBE_INITRD_HEADER
 	  add initrd or initramfs image to the kernel image.
 	  Otherwise, say N.
 
+source "kernel/Kconfig.freezer"
+
 menu "Bus options (PCI, PCMCIA, EISA, ISA, TC)"
 
 config HW_HAS_EISA
diff -puN arch/mn10300/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/mn10300/Kconfig
@@ -68,6 +68,8 @@ mainmenu "Matsushita MN10300/AM33 Kernel
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 
 menu "Matsushita MN10300 system setup"
 
diff -puN arch/parisc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/parisc/Kconfig
@@ -90,6 +90,8 @@ config ARCH_MAY_HAVE_PC_FDC
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 
 menu "Processor type and features"
 
diff -puN arch/powerpc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/powerpc/Kconfig
@@ -230,6 +230,8 @@ config PPC_OF_PLATFORM_PCI
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 source "arch/powerpc/sysdev/Kconfig"
 source "arch/powerpc/platforms/Kconfig"
 
diff -puN arch/s390/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/s390/Kconfig
--- a/arch/s390/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/s390/Kconfig
@@ -78,6 +78,8 @@ config S390
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Base setup"
 
 comment "Processor type and features"
diff -puN arch/sh/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/sh/Kconfig
--- a/arch/sh/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/sh/Kconfig
@@ -106,6 +106,8 @@ config IO_TRAPPED
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "System type"
 
 #
diff -puN arch/sparc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/sparc/Kconfig
@@ -37,6 +37,8 @@ config HZ
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "General machine setup"
 
 config SMP
diff -puN arch/sparc64/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/sparc64/Kconfig
@@ -96,6 +96,7 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	def_bool y
 
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
diff -puN arch/um/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/um/Kconfig
--- a/arch/um/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/um/Kconfig
@@ -229,6 +229,8 @@ endmenu
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 source "drivers/block/Kconfig"
 
 source "arch/um/Kconfig.char"
diff -puN arch/x86/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/x86/Kconfig
--- a/arch/x86/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/x86/Kconfig
@@ -193,6 +193,7 @@ config X86_TRAMPOLINE
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
diff -puN arch/xtensa/Kconfig~container-freezer-implement-freezer-cgroup-subsystem arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/arch/xtensa/Kconfig
@@ -55,6 +55,7 @@ config HZ
 	default 100
 
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
diff -puN include/linux/cgroup_subsys.h~container-freezer-implement-freezer-cgroup-subsystem include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~container-freezer-implement-freezer-cgroup-subsystem
+++ a/include/linux/cgroup_subsys.h
@@ -48,3 +48,9 @@ SUBSYS(devices)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_FREEZER
+SUBSYS(freezer)
+#endif
+
+/* */
diff -puN include/linux/freezer.h~container-freezer-implement-freezer-cgroup-subsystem include/linux/freezer.h
--- a/include/linux/freezer.h~container-freezer-implement-freezer-cgroup-subsystem
+++ a/include/linux/freezer.h
@@ -46,26 +46,11 @@ static inline bool should_send_signal(st
 
 /*
  * Wake up a frozen process
- *
- * task_lock() is taken to prevent the race with refrigerator() which may
- * occur if the freezing of tasks fails.  Namely, without the lock, if the
- * freezing of tasks failed, thaw_tasks() might have run before a task in
- * refrigerator() could call frozen_process(), in which case the task would be
- * frozen and no one would thaw it.
- */
-static inline int thaw_process(struct task_struct *p)
-{
-	task_lock(p);
-	if (frozen(p)) {
-		p->flags &= ~PF_FROZEN;
-		task_unlock(p);
-		wake_up_process(p);
-		return 1;
-	}
-	clear_freeze_flag(p);
-	task_unlock(p);
-	return 0;
-}
+ */
+extern int __thaw_process(struct task_struct *p);
+
+/* Takes and releases task alloc lock using task_lock() */
+extern int thaw_process(struct task_struct *p);
 
 extern void refrigerator(void);
 extern int freeze_processes(void);
@@ -83,6 +68,12 @@ static inline int try_to_freeze(void)
 extern bool freeze_task(struct task_struct *p, bool sig_only);
 extern void cancel_freezing(struct task_struct *p);
 
+#ifdef CONFIG_CGROUP_FREEZER
+extern int cgroup_frozen(struct task_struct *task);
+#else /* !CONFIG_CGROUP_FREEZER */
+static inline int cgroup_frozen(struct task_struct *task) { return 0; }
+#endif /* !CONFIG_CGROUP_FREEZER */
+
 /*
  * The PF_FREEZER_SKIP flag should be set by a vfork parent right before it
  * calls wait_for_completion(&vfork) and reset right after it returns from this
diff -puN init/Kconfig~container-freezer-implement-freezer-cgroup-subsystem init/Kconfig
--- a/init/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/init/Kconfig
@@ -299,6 +299,13 @@ config CGROUP_NS
           for instance virtual servers and checkpoint/restart
           jobs.
 
+config CGROUP_FREEZER
+        bool "control group freezer subsystem"
+        depends on CGROUPS
+        help
+          Provides a way to freeze and unfreeze all tasks in a
+	  cgroup.
+
 config CGROUP_DEVICE
 	bool "Device controller for cgroups"
 	depends on CGROUPS && EXPERIMENTAL
diff -puN /dev/null kernel/Kconfig.freezer
--- /dev/null
+++ a/kernel/Kconfig.freezer
@@ -0,0 +1,2 @@
+config FREEZER
+	def_bool PM_SLEEP || CGROUP_FREEZER
diff -puN kernel/Makefile~container-freezer-implement-freezer-cgroup-subsystem kernel/Makefile
--- a/kernel/Makefile~container-freezer-implement-freezer-cgroup-subsystem
+++ a/kernel/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += bac
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
+obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
 obj-$(CONFIG_UTS_NS) += utsname.o
diff -puN /dev/null kernel/cgroup_freezer.c
--- /dev/null
+++ a/kernel/cgroup_freezer.c
@@ -0,0 +1,366 @@
+/*
+ * cgroup_freezer.c -  control group freezer subsystem
+ *
+ * Copyright IBM Corporation, 2007
+ *
+ * Author : Cedric Le Goater <clg@fr.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/module.h>
+#include <linux/cgroup.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/freezer.h>
+#include <linux/seq_file.h>
+
+enum freezer_state {
+	STATE_RUNNING = 0,
+	STATE_FREEZING,
+	STATE_FROZEN,
+};
+
+struct freezer {
+	struct cgroup_subsys_state css;
+	enum freezer_state state;
+	spinlock_t lock; /* protects _writes_ to state */
+};
+
+static inline struct freezer *cgroup_freezer(
+		struct cgroup *cgroup)
+{
+	return container_of(
+		cgroup_subsys_state(cgroup, freezer_subsys_id),
+		struct freezer, css);
+}
+
+static inline struct freezer *task_freezer(struct task_struct *task)
+{
+	return container_of(task_subsys_state(task, freezer_subsys_id),
+			    struct freezer, css);
+}
+
+int cgroup_frozen(struct task_struct *task)
+{
+	struct freezer *freezer;
+	enum freezer_state state;
+
+	task_lock(task);
+	freezer = task_freezer(task);
+	state = freezer->state;
+	task_unlock(task);
+
+	return state == STATE_FROZEN;
+}
+
+/*
+ * cgroups_write_string() limits the size of freezer state strings to
+ * CGROUP_LOCAL_BUFFER_SIZE
+ */
+static const char *freezer_state_strs[] = {
+	"RUNNING",
+	"FREEZING",
+	"FROZEN",
+};
+
+/*
+ * State diagram
+ * Transitions are caused by userspace writes to the freezer.state file.
+ * The values in parenthesis are state labels. The rest are edge labels.
+ *
+ * (RUNNING) --FROZEN--> (FREEZING) --FROZEN--> (FROZEN)
+ *    ^ ^                     |                       |
+ *    | \_______RUNNING_______/                       |
+ *    \_____________________________RUNNING___________/
+ */
+
+struct cgroup_subsys freezer_subsys;
+
+/* Locks taken and their ordering
+ * ------------------------------
+ * css_set_lock
+ * cgroup_mutex (AKA cgroup_lock)
+ * task->alloc_lock (AKA task_lock)
+ * freezer->lock
+ * task->sighand->siglock
+ *
+ * cgroup code forces css_set_lock to be taken before task->alloc_lock
+ *
+ * freezer_create(), freezer_destroy():
+ * cgroup_mutex [ by cgroup core ]
+ *
+ * can_attach():
+ * cgroup_mutex
+ *
+ * cgroup_frozen():
+ * task->alloc_lock (to get task's cgroup)
+ *
+ * freezer_fork() (preserving fork() performance means can't take cgroup_mutex):
+ * task->alloc_lock (to get task's cgroup)
+ * freezer->lock
+ *  sighand->siglock (if the cgroup is freezing)
+ *
+ * freezer_read():
+ * cgroup_mutex
+ *  freezer->lock
+ *   read_lock css_set_lock (cgroup iterator start)
+ *
+ * freezer_write() (freeze):
+ * cgroup_mutex
+ *  freezer->lock
+ *   read_lock css_set_lock (cgroup iterator start)
+ *    sighand->siglock
+ *
+ * freezer_write() (unfreeze):
+ * cgroup_mutex
+ *  freezer->lock
+ *   read_lock css_set_lock (cgroup iterator start)
+ *    task->alloc_lock (to prevent races with freeze_task())
+ *     sighand->siglock
+ */
+static struct cgroup_subsys_state *freezer_create(struct cgroup_subsys *ss,
+						  struct cgroup *cgroup)
+{
+	struct freezer *freezer;
+
+	freezer = kzalloc(sizeof(struct freezer), GFP_KERNEL);
+	if (!freezer)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&freezer->lock);
+	freezer->state = STATE_RUNNING;
+	return &freezer->css;
+}
+
+static void freezer_destroy(struct cgroup_subsys *ss,
+			    struct cgroup *cgroup)
+{
+	kfree(cgroup_freezer(cgroup));
+}
+
+
+static int freezer_can_attach(struct cgroup_subsys *ss,
+			      struct cgroup *new_cgroup,
+			      struct task_struct *task)
+{
+	struct freezer *freezer;
+	int retval = 0;
+
+	/*
+	 * The call to cgroup_lock() in the freezer.state write method prevents
+	 * a write to that file racing against an attach, and hence the
+	 * can_attach() result will remain valid until the attach completes.
+	 */
+	freezer = cgroup_freezer(new_cgroup);
+	if (freezer->state == STATE_FROZEN)
+		retval = -EBUSY;
+	return retval;
+}
+
+static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
+{
+	struct freezer *freezer;
+
+	task_lock(task);
+	freezer = task_freezer(task);
+	task_unlock(task);
+
+	BUG_ON(freezer->state == STATE_FROZEN);
+	spin_lock_irq(&freezer->lock);
+	/* Locking avoids race with FREEZING -> RUNNING transitions. */
+	if (freezer->state == STATE_FREEZING)
+		freeze_task(task, true);
+	spin_unlock_irq(&freezer->lock);
+}
+
+/*
+ * caller must hold freezer->lock
+ */
+static void check_if_frozen(struct cgroup *cgroup,
+			     struct freezer *freezer)
+{
+	struct cgroup_iter it;
+	struct task_struct *task;
+	unsigned int nfrozen = 0, ntotal = 0;
+
+	cgroup_iter_start(cgroup, &it);
+	while ((task = cgroup_iter_next(cgroup, &it))) {
+		ntotal++;
+		/*
+		 * Task is frozen or will freeze immediately when next it gets
+		 * woken
+		 */
+		if (frozen(task) ||
+		    (task_is_stopped_or_traced(task) && freezing(task)))
+			nfrozen++;
+	}
+
+	/*
+	 * Transition to FROZEN when no new tasks can be added ensures
+	 * that we never exist in the FROZEN state while there are unfrozen
+	 * tasks.
+	 */
+	if (nfrozen == ntotal)
+		freezer->state = STATE_FROZEN;
+	cgroup_iter_end(cgroup, &it);
+}
+
+static int freezer_read(struct cgroup *cgroup, struct cftype *cft,
+			struct seq_file *m)
+{
+	struct freezer *freezer;
+	enum freezer_state state;
+
+	if (!cgroup_lock_live_group(cgroup))
+		return -ENODEV;
+
+	freezer = cgroup_freezer(cgroup);
+	spin_lock_irq(&freezer->lock);
+	state = freezer->state;
+	if (state == STATE_FREEZING) {
+		/* We change from FREEZING to FROZEN lazily if the cgroup was
+		 * only partially frozen when we exitted write. */
+		check_if_frozen(cgroup, freezer);
+		state = freezer->state;
+	}
+	spin_unlock_irq(&freezer->lock);
+	cgroup_unlock();
+
+	seq_puts(m, freezer_state_strs[state]);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
+{
+	struct cgroup_iter it;
+	struct task_struct *task;
+	unsigned int num_cant_freeze_now = 0;
+
+	freezer->state = STATE_FREEZING;
+	cgroup_iter_start(cgroup, &it);
+	while ((task = cgroup_iter_next(cgroup, &it))) {
+		if (!freeze_task(task, true))
+			continue;
+		if (task_is_stopped_or_traced(task) && freezing(task))
+			/*
+			 * The freeze flag is set so these tasks will
+			 * immediately go into the fridge upon waking.
+			 */
+			continue;
+		if (!freezing(task) && !freezer_should_skip(task))
+			num_cant_freeze_now++;
+	}
+	cgroup_iter_end(cgroup, &it);
+
+	return num_cant_freeze_now ? -EBUSY : 0;
+}
+
+static int unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
+{
+	struct cgroup_iter it;
+	struct task_struct *task;
+
+	cgroup_iter_start(cgroup, &it);
+	while ((task = cgroup_iter_next(cgroup, &it))) {
+		int do_wake;
+
+		task_lock(task);
+		do_wake = __thaw_process(task);
+		task_unlock(task);
+		if (do_wake)
+			wake_up_process(task);
+	}
+	cgroup_iter_end(cgroup, &it);
+	freezer->state = STATE_RUNNING;
+
+	return 0;
+}
+
+static int freezer_change_state(struct cgroup *cgroup,
+				enum freezer_state goal_state)
+{
+	struct freezer *freezer;
+	int retval = 0;
+
+	freezer = cgroup_freezer(cgroup);
+	spin_lock_irq(&freezer->lock);
+	check_if_frozen(cgroup, freezer); /* may update freezer->state */
+	if (goal_state == freezer->state)
+		goto out;
+	switch (freezer->state) {
+	case STATE_RUNNING:
+		retval = try_to_freeze_cgroup(cgroup, freezer);
+		break;
+	case STATE_FREEZING:
+		if (goal_state == STATE_FROZEN) {
+			/* Userspace is retrying after
+			 * "/bin/echo FROZEN > freezer.state" returned -EBUSY */
+			retval = try_to_freeze_cgroup(cgroup, freezer);
+			break;
+		}
+		/* state == FREEZING and goal_state == RUNNING, so unfreeze */
+	case STATE_FROZEN:
+		retval = unfreeze_cgroup(cgroup, freezer);
+		break;
+	default:
+		break;
+	}
+out:
+	spin_unlock_irq(&freezer->lock);
+
+	return retval;
+}
+
+static int freezer_write(struct cgroup *cgroup,
+			 struct cftype *cft,
+			 const char *buffer)
+{
+	int retval;
+	enum freezer_state goal_state;
+
+	if (strcmp(buffer, freezer_state_strs[STATE_RUNNING]) == 0)
+		goal_state = STATE_RUNNING;
+	else if (strcmp(buffer, freezer_state_strs[STATE_FROZEN]) == 0)
+		goal_state = STATE_FROZEN;
+	else
+		return -EIO;
+
+	if (!cgroup_lock_live_group(cgroup))
+		return -ENODEV;
+	retval = freezer_change_state(cgroup, goal_state);
+	cgroup_unlock();
+	return retval;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "state",
+		.read_seq_string = freezer_read,
+		.write_string = freezer_write,
+	},
+};
+
+static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
+{
+	return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
+}
+
+struct cgroup_subsys freezer_subsys = {
+	.name		= "freezer",
+	.create		= freezer_create,
+	.destroy	= freezer_destroy,
+	.populate	= freezer_populate,
+	.subsys_id	= freezer_subsys_id,
+	.can_attach	= freezer_can_attach,
+	.attach		= NULL,
+	.fork		= freezer_fork,
+	.exit		= NULL,
+};
diff -puN kernel/freezer.c~container-freezer-implement-freezer-cgroup-subsystem kernel/freezer.c
--- a/kernel/freezer.c~container-freezer-implement-freezer-cgroup-subsystem
+++ a/kernel/freezer.c
@@ -120,3 +120,35 @@ void cancel_freezing(struct task_struct 
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
+
+/*
+ * Wake up a frozen process
+ *
+ * task_lock() is needed to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
+ */
+int __thaw_process(struct task_struct *p)
+{
+	if (frozen(p)) {
+		p->flags &= ~PF_FROZEN;
+		return 1;
+	}
+	clear_freeze_flag(p);
+	return 0;
+}
+
+int thaw_process(struct task_struct *p)
+{
+	task_lock(p);
+	if (__thaw_process(p) == 1) {
+		task_unlock(p);
+		wake_up_process(p);
+		return 1;
+	}
+	task_unlock(p);
+	return 0;
+}
+EXPORT_SYMBOL(thaw_process);
diff -puN kernel/power/Kconfig~container-freezer-implement-freezer-cgroup-subsystem kernel/power/Kconfig
--- a/kernel/power/Kconfig~container-freezer-implement-freezer-cgroup-subsystem
+++ a/kernel/power/Kconfig
@@ -85,9 +85,6 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
 	default y
 
-config FREEZER
-	def_bool PM_SLEEP
