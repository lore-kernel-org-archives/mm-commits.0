From: akpm@linux-foundation.org
Subject: [to-be-updated] rcu-add-rcustring-adt-for-rcu-protected-strings.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:29:38 -0800
Message-ID: <201003102029.o2AKTdcX001888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757003Ab0CJUaP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     rcu: add rcustring ADT for RCU protected strings
has been removed from the -mm tree.  Its filename was
     rcu-add-rcustring-adt-for-rcu-protected-strings.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: add rcustring ADT for RCU protected strings
From: Andi Kleen <andi@firstfloor.org>

With BKL-less sysctls most of the writable string sysctls are racy.  There
is no locking on the reader side, so a reader could see an inconsistent
string or worse miss the terminating null and walk of beyond it.

This patchkit adds a new "rcu string" variant to avoid these problems and
convers the racy users.  One the writer side the strings are always copied
to new memory and the readers use rcu_read_lock() to get a stable view. 
For readers who access the string over sleeps the reader copies the
string.  

This is all hidden in a new generic "rcu_string" ADT which can be also
used for other purposes.

This finally implements all the letters in RCU, most other users leave out
the 'C'.

I left some obscure users in architectures (sparc, mips) alone and audited
all of the others.  The sparc reboot_cmd one has references to asm files
which I didn't want to touch and the mips variant seemd just too obscure.

All the others are not racy.



This patch:

Add a little ADT for RCU protected strings.  RCU is a convenient way to
manage modifications to read-often-write-seldom strings.  Add some helper
functions to make this more straight forward.

Used by follow-on patches to implement RCU protected sysctl strings.

 * General rules:
 * Reader has to use rcu_read_lock() and not sleep while accessing the string,
 * or alternatively get a copy with access_rcu_string()
 * Writer needs an own lock against each other.
 * Each modification should allocate a new string first and free the old
 * one with free_rcu_string()
 * In writers use rcu_assign_pointer to publicize the updated string to
 * global readers.
 * The size passed to access_rcu_string() must be the same as passed
 * to alloc_rcu_string() and be known in advance. Don't use strlen()!
 *
 * For sysctls also see proc_rcu_string() as a convenient wrapper

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcustring.h |   20 ++++++
 lib/Makefile              |    3 
 lib/rcustring.c           |  115 ++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/rcustring.h
--- /dev/null
+++ a/include/linux/rcustring.h
@@ -0,0 +1,20 @@
+#ifndef _RCUSTRING_H
+#define _RCUSTRING_H 1
+
+#include <linux/gfp.h>
+#include <linux/rcupdate.h>
+
+/*
+ * Simple wrapper to manage strings by RCU.
+ */
+
+extern char *alloc_rcu_string(int size, gfp_t gfp);
+extern void free_rcu_string(const char *string);
+
+/*
+ * size must be the same as alloc_rcu_string, don't
+ * use strlen on str!
+ */
+extern char *access_rcu_string(char **str, int size, gfp_t gfp);
+
+#endif
diff -puN lib/Makefile~rcu-add-rcustring-adt-for-rcu-protected-strings lib/Makefile
--- a/lib/Makefile~rcu-add-rcustring-adt-for-rcu-protected-strings
+++ a/lib/Makefile
@@ -12,7 +12,8 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o flex_array.o
+	 is_single_threaded.o plist.o decompress.o flex_array.o \
+	 rcustring.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -puN /dev/null lib/rcustring.c
--- /dev/null
+++ a/lib/rcustring.c
@@ -0,0 +1,115 @@
+/*
+ * Manage strings by Read-Copy-Update. This is useful for global strings
+ * that change only very rarely, but are read often.
+ *
+ * Author: Andi Kleen
+ *
+ * General rules:
+ * Reader has to use rcu_read_lock() and not sleep while accessing the string,
+ * or alternatively get a copy with access_rcu_string()
+ * Writer needs an own lock against each other.
+ * Each modification should allocate a new string first and free the old
+ * one with free_rcu_string()
+ * In writers use rcu_assign_pointer to publicize the updated string to
+ * global readers.
+ * The size passed to access_rcu_string() must be the same as passed
+ * to alloc_rcu_string() and be known in advance. Don't use strlen()!
+ * The pointer passed to access_rcu_string must be to the variable modified
+ * by the writer.
+ *
+ * For sysctls also see proc_rcu_string() as a convenient wrapper
+ *
+ * Typical example:
+ * #define MAX_GLOBAL_SIZE ...
+ * char *global = "default";
+ *
+ * Rare writer:
+ * char *old, *new;
+ * DECLARE_MUTEX(writer_lock);
+ * mutex_lock(&writer_lock);
+ * new = alloc_rcu_string(MAX_GLOBAL_SIZE, GFP_KERNEL);
+ * if (!new) {
+ *      mutex_unlock(&writer_lock);
+ *      return -ENOMEM;
+ * }
+ * strlcpy(new, new_value, MAX_GLOBAL_SIZE);
+ * old = global;
+ * rcu_assign_pointer(global, new);
+ * mutex_unlock(&writer_lock);
+ * free_rcu_string(old);
+ *
+ * Sleepy reader:
+ * char *str = access_rcu_string(&global, MAX_GLOBAL_SIZE, GFP_KERNEL);
+ * if (!str)
+ *     return -ENOMEM;
+ * ... use str while sleeping ...
+ * kfree(string);
+ *
+ * Non sleepy reader:
+ * rcu_read_lock();
+ * str = rcu_dereference(&global);
+ * ... use str without sleeping ...
+ * rcu_read_unlock();
+ *
+ * Note this code could be relatively easily generalized for other kinds
+ * of non-atomic data, but this initial version only handles strings.
+ * Only need to change the strlcpy() below to memcpy()
+ */
+#include <linux/kernel.h>
+#include <linux/rcustring.h>
+#include <linux/slab.h>
+#include <linux/rcupdate.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+struct rcu_string {
+	struct rcu_head rcu;
+	char str[0];
+};
+
+char *alloc_rcu_string(int size, gfp_t gfp)
+{
+	struct rcu_string *rs = kmalloc(sizeof(struct rcu_string) + size, gfp);
+	if (!rs)
+		return NULL;
+	return rs->str;
+}
+EXPORT_SYMBOL(alloc_rcu_string);
+
+static void do_free_rcu_string(struct rcu_head *h)
+{
+	kfree(container_of(h, struct rcu_string, rcu));
+}
+
+static inline struct rcu_string *str_to_rcustr(const char *str)
+{
+	/*
+	 * Opencoded container_of because the strict type checking
+	 * in normal container_of cannot deal with char str[0] vs char *str.
+	 */
+	return (struct rcu_string *)(str - offsetof(struct rcu_string, str));
+}
+
+void free_rcu_string(const char *str)
+{
+	struct rcu_string *rs = str_to_rcustr(str);
+	call_rcu(&rs->rcu, do_free_rcu_string);
+}
+EXPORT_SYMBOL(free_rcu_string);
+
+/*
+ * Get a local private copy of a RCU protected string.
+ * Mostly useful to get a string that is stable while sleeping.
+ * Caller must free returned string.
+ */
+char *access_rcu_string(char **str, int size, gfp_t gfp)
+{
+	char *copy = kmalloc(size, gfp);
+	if (!str)
+		return NULL;
+	rcu_read_lock();
+	strlcpy(copy, rcu_dereference(*str), size);
+	rcu_read_unlock();
+	return copy;
+}
+EXPORT_SYMBOL(access_rcu_string);
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
rcu-add-rcustring-adt-for-rcu-protected-strings.patch
add-a-kernel_address-that-works-for-data-too.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch

