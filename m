From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:29:45 -0800
Message-ID: <201003102029.o2AKTjRQ001915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005Ab0CJUaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: add proc_rcu_string to manage sysctls using rcu strings
has been removed from the -mm tree.  Its filename was
     sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: add proc_rcu_string to manage sysctls using rcu strings
From: Andi Kleen <andi@firstfloor.org>

Add a helper to use the new rcu strings for managing access to text
sysctls.  Conversions will be in follow-on patches.

An alternative would be to use seqlocks here, but RCU seemed cleaner.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 +
 kernel/sysctl.c        |   66 +++++++++++++++++++++++++++++++++++++++
 kernel/sysctl_check.c  |    1 
 3 files changed, 69 insertions(+)

diff -puN include/linux/sysctl.h~sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings
+++ a/include/linux/sysctl.h
@@ -966,6 +966,8 @@ typedef int proc_handler (struct ctl_tab
 
 extern int proc_dostring(struct ctl_table *, int,
 			 void __user *, size_t *, loff_t *);
+extern int proc_rcu_string(struct ctl_table *, int,
+			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec(struct ctl_table *, int,
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(struct ctl_table *, int,
diff -puN kernel/sysctl.c~sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings
+++ a/kernel/sysctl.c
@@ -49,6 +49,7 @@
 #include <linux/acpi.h>
 #include <linux/reboot.h>
 #include <linux/ftrace.h>
+#include <linux/rcustring.h>
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
@@ -2042,6 +2043,60 @@ static int _proc_do_string(void* data, i
 }
 
 /**
+ * proc_rcu_string - sysctl string with rcu protection
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Handle a string sysctl similar to proc_dostring.
+ * The main difference is that the data pointer in the table
+ * points to a pointer to a string. The string should be initially
+ * pointing to a statically allocated (as a C object, not on the heap)
+ * default. When it is replaced old uses will be protected by
+ * RCU. The reader should use rcu_read_lock()/unlock() or
+ * access_rcu_string().
+ */
+int proc_rcu_string(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	if (write) {
+		/* protect writers against each other */
+		static DEFINE_MUTEX(rcu_string_mutex);
+		char *old;
+		char *new;
+
+		new = alloc_rcu_string(table->maxlen, GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+		mutex_lock(&rcu_string_mutex);
+		old = *(char **)(table->data);
+		strcpy(new, old);
+		ret = _proc_do_string(new, table->maxlen, write, buffer, lenp, ppos);
+		rcu_assign_pointer(*(char **)(table->data), new);
+		/*
+		 * For the first initialization allow constant strings.
+		 */
+		if (!kernel_address((unsigned long)old))
+			free_rcu_string(old);
+		mutex_unlock(&rcu_string_mutex);
+	} else {
+		char *str;
+
+		str = access_rcu_string((char **)(table->data), table->maxlen,
+					GFP_KERNEL);
+		if (!str)
+			return -ENOMEM;
+		ret = _proc_do_string(str, table->maxlen, write, buffer, lenp, ppos);
+		kfree(str);
+	}
+	return ret;
+}
+
+/**
  * proc_dostring - read a string sysctl
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
@@ -2056,6 +2111,10 @@ static int _proc_do_string(void* data, i
  * and a newline '\n' is added. It is truncated if the buffer is
  * not large enough.
  *
+ * WARNING: this should be only used for read only strings
+ * or when you have a wrapper with special locking. Otherwise
+ * use proc_rcu_string to avoid races with the consumer.
+ *
  * Returns 0 on success.
  */
 int proc_dostring(struct ctl_table *table, int write,
@@ -2640,6 +2699,12 @@ int proc_dostring(struct ctl_table *tabl
 	return -ENOSYS;
 }
 
+int proc_rcu_string(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2696,6 +2761,7 @@ EXPORT_SYMBOL(proc_dointvec_minmax);
 EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
 EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_dostring);
+EXPORT_SYMBOL(proc_rcu_string);
 EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
 EXPORT_SYMBOL(register_sysctl_table);
diff -puN kernel/sysctl_check.c~sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings
+++ a/kernel/sysctl_check.c
@@ -131,6 +131,7 @@ int sysctl_check_table(struct nsproxy *n
 				set_fail(&fail, table, "Directory with extra2");
 		} else {
 			if ((table->proc_handler == proc_dostring) ||
+			    (table->proc_handler == proc_rcu_string) ||
 			    (table->proc_handler == proc_dointvec) ||
 			    (table->proc_handler == proc_dointvec_minmax) ||
 			    (table->proc_handler == proc_dointvec_jiffies) ||
_

Patches currently in -mm which might be from andi@firstfloor.org are

mm-introduce-dump_page-and-print-symbolic-flag-names.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
modpost-support-objects-with-more-than-64k-sections.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch

