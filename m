From: akpm@linux-foundation.org
Subject: - memory-controller-resource-counters-v7.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:57 -0800
Message-ID: <200802080802.m1882cU2014052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000AbYBHIXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:23:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@googl


The patch titled
     Memory controller: resource counters
has been removed from the -mm tree.  Its filename was
     memory-controller-resource-counters-v7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory controller: resource counters
From: Pavel Emelianov <xemul@openvz.org>

Introduce generic structures and routines for resource accounting.

Each resource accounting cgroup is supposed to aggregate it,
cgroup_subsystem_state and its resource-specific members within.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
DESC
memory-controller-resource-counters-v7 fix
EDESC

There's a gotcha in res_counter_charge_locked() because of C99 6.3.1.8(1)
since both counter->limit and 'val' are of unsigned long type, the result
of the subtraction will be the same; no promotion is required.  So if
'val' is greater than counter->limit, it will always be larger than
counter->usage and the conditional will fail.  Simply casting this to
signed doesn't work since counter->usage is also unsigned and thus the
result of the subtraction will be promoted to unsigned since the ranks are
the same.

Even though the only (current) use of res_counter_charge() is with a 'val'
actual of 1, this still fails if you set counter->limit to 0.  No chance
of overflow unless you're running on a machine with 4KB pages and 16TB of
memory.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |  102 ++++++++++++++++++++++++++++
 init/Kconfig                |    7 +
 kernel/Makefile             |    1 
 kernel/res_counter.c        |  120 ++++++++++++++++++++++++++++++++++
 4 files changed, 230 insertions(+)

diff -puN /dev/null include/linux/res_counter.h
--- /dev/null
+++ a/include/linux/res_counter.h
@@ -0,0 +1,102 @@
+#ifndef __RES_COUNTER_H__
+#define __RES_COUNTER_H__
+
+/*
+ * Resource Counters
+ * Contain common data types and routines for resource accounting
+ *
+ * Copyright 2007 OpenVZ SWsoft Inc
+ *
+ * Author: Pavel Emelianov <xemul@openvz.org>
+ *
+ */
+
+#include <linux/cgroup.h>
+
+/*
+ * The core object. the cgroup that wishes to account for some
+ * resource may include this counter into its structures and use
+ * the helpers described beyond
+ */
+
+struct res_counter {
+	/*
+	 * the current resource consumption level
+	 */
+	unsigned long usage;
+	/*
+	 * the limit that usage cannot exceed
+	 */
+	unsigned long limit;
+	/*
+	 * the number of unsuccessful attempts to consume the resource
+	 */
+	unsigned long failcnt;
+	/*
+	 * the lock to protect all of the above.
+	 * the routines below consider this to be IRQ-safe
+	 */
+	spinlock_t lock;
+};
+
+/*
+ * Helpers to interact with userspace
+ * res_counter_read/_write - put/get the specified fields from the
+ * res_counter struct to/from the user
+ *
+ * @counter:     the counter in question
+ * @member:  the field to work with (see RES_xxx below)
+ * @buf:     the buffer to opeate on,...
+ * @nbytes:  its size...
+ * @pos:     and the offset.
+ */
+
+ssize_t res_counter_read(struct res_counter *counter, int member,
+		const char __user *buf, size_t nbytes, loff_t *pos);
+ssize_t res_counter_write(struct res_counter *counter, int member,
+		const char __user *buf, size_t nbytes, loff_t *pos);
+
+/*
+ * the field descriptors. one for each member of res_counter
+ */
+
+enum {
+	RES_USAGE,
+	RES_LIMIT,
+	RES_FAILCNT,
+};
+
+/*
+ * helpers for accounting
+ */
+
+void res_counter_init(struct res_counter *counter);
+
+/*
+ * charge - try to consume more resource.
+ *
+ * @counter: the counter
+ * @val: the amount of the resource. each controller defines its own
+ *       units, e.g. numbers, bytes, Kbytes, etc
+ *
+ * returns 0 on success and <0 if the counter->usage will exceed the
+ * counter->limit _locked call expects the counter->lock to be taken
+ */
+
+int res_counter_charge_locked(struct res_counter *counter, unsigned long val);
+int res_counter_charge(struct res_counter *counter, unsigned long val);
+
+/*
+ * uncharge - tell that some portion of the resource is released
+ *
+ * @counter: the counter
+ * @val: the amount of the resource
+ *
+ * these calls check for usage underflow and show a warning on the console
+ * _locked call expects the counter->lock to be taken
+ */
+
+void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
+void res_counter_uncharge(struct res_counter *counter, unsigned long val);
+
+#endif
diff -puN init/Kconfig~memory-controller-resource-counters-v7 init/Kconfig
--- a/init/Kconfig~memory-controller-resource-counters-v7
+++ a/init/Kconfig
@@ -369,6 +369,13 @@ config CGROUP_CPUACCT
 	  Provides a simple Resource Controller for monitoring the
 	  total CPU consumed by the tasks in a cgroup
 
+config RESOURCE_COUNTERS
+	bool "Resource counters"
+	help
+	  This option enables controller independent resource accounting
+          infrastructure that works with cgroups
+	depends on CGROUPS
+
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
 	depends on SYSFS
diff -puN kernel/Makefile~memory-controller-resource-counters-v7 kernel/Makefile
--- a/kernel/Makefile~memory-controller-resource-counters-v7
+++ a/kernel/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_CGROUP_DEBUG) += cgroup_deb
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
 obj-$(CONFIG_IKCONFIG) += configs.o
+obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
diff -puN /dev/null kernel/res_counter.c
--- /dev/null
+++ a/kernel/res_counter.c
@@ -0,0 +1,120 @@
+/*
+ * resource cgroups
+ *
+ * Copyright 2007 OpenVZ SWsoft Inc
+ *
+ * Author: Pavel Emelianov <xemul@openvz.org>
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/parser.h>
+#include <linux/fs.h>
+#include <linux/res_counter.h>
+#include <linux/uaccess.h>
+
+void res_counter_init(struct res_counter *counter)
+{
+	spin_lock_init(&counter->lock);
+	counter->limit = (unsigned long)LONG_MAX;
+}
+
+int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
+{
+	if (counter->usage + val > counter->limit) {
+		counter->failcnt++;
+		return -ENOMEM;
+	}
+
+	counter->usage += val;
+	return 0;
+}
+
+int res_counter_charge(struct res_counter *counter, unsigned long val)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	ret = res_counter_charge_locked(counter, val);
+	spin_unlock_irqrestore(&counter->lock, flags);
+	return ret;
+}
+
+void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
+{
+	if (WARN_ON(counter->usage < val))
+		val = counter->usage;
+
+	counter->usage -= val;
+}
+
+void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	res_counter_uncharge_locked(counter, val);
+	spin_unlock_irqrestore(&counter->lock, flags);
+}
+
+
+static inline unsigned long *res_counter_member(struct res_counter *counter,
+						int member)
+{
+	switch (member) {
+	case RES_USAGE:
+		return &counter->usage;
+	case RES_LIMIT:
+		return &counter->limit;
+	case RES_FAILCNT:
+		return &counter->failcnt;
+	};
+
+	BUG();
+	return NULL;
+}
+
+ssize_t res_counter_read(struct res_counter *counter, int member,
+		const char __user *userbuf, size_t nbytes, loff_t *pos)
+{
+	unsigned long *val;
+	char buf[64], *s;
+
+	s = buf;
+	val = res_counter_member(counter, member);
+	s += sprintf(s, "%lu\n", *val);
+	return simple_read_from_buffer((void __user *)userbuf, nbytes,
+			pos, buf, s - buf);
+}
+
+ssize_t res_counter_write(struct res_counter *counter, int member,
+		const char __user *userbuf, size_t nbytes, loff_t *pos)
+{
+	int ret;
+	char *buf, *end;
+	unsigned long tmp, *val;
+
+	buf = kmalloc(nbytes + 1, GFP_KERNEL);
+	ret = -ENOMEM;
+	if (buf == NULL)
+		goto out;
+
+	buf[nbytes] = '\0';
+	ret = -EFAULT;
+	if (copy_from_user(buf, userbuf, nbytes))
+		goto out_free;
+
+	ret = -EINVAL;
+	tmp = simple_strtoul(buf, &end, 10);
+	if (*end != '\0')
+		goto out_free;
+
+	val = res_counter_member(counter, member);
+	*val = tmp;
+	ret = nbytes;
+out_free:
+	kfree(buf);
+out:
+	return ret;
+}
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
ipc-uninline-some-code-from-utilh.patch
ipc-make-struct-ipc_ids-static-in-ipc_namespace.patch
ipc-consolidate-sem_exit_ns-msg_exit_ns-and-shm_exit_ns.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
pidns-make-full-use-of-xxx_vnr-calls.patch
pidns-fix-badly-converted-mqueues-pid-handling.patch
clean-up-the-kill_something_info.patch
get-rid-of-the-kill_pgrp_info-function.patch
use-find_task_by_vpid-in-posix-timers.patch
use-find_task_by_vpid-in-taskstats.patch
dont-operate-with-pid_t-in-rtmutex-tester.patch
deprecate-find_task_by_pid.patch
reiser4.patch
