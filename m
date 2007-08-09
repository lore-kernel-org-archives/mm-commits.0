From: akpm@linux-foundation.org
Subject: + sysctl-factor-out-sysctl_data.patch added to -mm tree
Date: Thu, 09 Aug 2007 15:11:48 -0700
Message-ID: <200708092211.l79MBmr8022134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbXHIWMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 18:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru


The patch titled
     sysctl: Factor out sysctl_data.
has been added to the -mm tree.  Its filename is
     sysctl-factor-out-sysctl_data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: Factor out sysctl_data.
From: Eric W. Biederman <ebiederm@xmission.com>

There as been no easy way to wrap the default sysctl strategy routine except
for returning 0.  Which is not always what we want.  The few instances I have
seen that want different behaviour have written their own version of
sysctl_data.  While not too hard it is unnecessary code and has the potential
for extra bugs.

So to make these situations easier and make that part of sysctl more symetric
I have factord sysctl_data out of do_sysctl_strategy and exported as a
function everyone can use.

Further having sysctl_data be an explicit function makes checking for badly
formed sysctl tables much easier.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 
 kernel/sysctl.c        |   66 +++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 20 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-factor-out-sysctl_data include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-factor-out-sysctl_data
+++ a/include/linux/sysctl.h
@@ -972,6 +972,7 @@ extern int do_sysctl_strategy (struct ct
 			       void __user *oldval, size_t __user *oldlenp,
 			       void __user *newval, size_t newlen);
 
+extern ctl_handler sysctl_data;
 extern ctl_handler sysctl_string;
 extern ctl_handler sysctl_intvec;
 extern ctl_handler sysctl_jiffies;
diff -puN kernel/sysctl.c~sysctl-factor-out-sysctl_data kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-factor-out-sysctl_data
+++ a/kernel/sysctl.c
@@ -1457,7 +1457,6 @@ int do_sysctl_strategy (struct ctl_table
 			void __user *newval, size_t newlen)
 {
 	int op = 0, rc;
-	size_t len;
 
 	if (oldval)
 		op |= 004;
@@ -1478,25 +1477,10 @@ int do_sysctl_strategy (struct ctl_table
 	/* If there is no strategy routine, or if the strategy returns
 	 * zero, proceed with automatic r/w */
 	if (table->data && table->maxlen) {
-		if (oldval && oldlenp) {
-			if (get_user(len, oldlenp))
-				return -EFAULT;
-			if (len) {
-				if (len > table->maxlen)
-					len = table->maxlen;
-				if(copy_to_user(oldval, table->data, len))
-					return -EFAULT;
-				if(put_user(len, oldlenp))
-					return -EFAULT;
-			}
-		}
-		if (newval && newlen) {
-			len = newlen;
-			if (len > table->maxlen)
-				len = table->maxlen;
-			if(copy_from_user(table->data, newval, len))
-				return -EFAULT;
-		}
+		rc = sysctl_data(table, name, nlen, oldval, oldlenp,
+				 newval, newlen);
+		if (rc < 0)
+			return rc;
 	}
 	return 0;
 }
@@ -2395,6 +2379,40 @@ int proc_doulongvec_ms_jiffies_minmax(st
  * General sysctl support routines 
  */
 
+/* The generic sysctl data routine (used if no strategy routine supplied) */
+int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	size_t len;
+
+	/* Get out of I don't have a variable */
+	if (!table->data || !table->maxlen)
+		return -ENOTDIR;
+
+	if (oldval && oldlenp) {
+		if (get_user(len, oldlenp))
+			return -EFAULT;
+		if (len) {
+			if (len > table->maxlen)
+				len = table->maxlen;
+			if (copy_to_user(oldval, table->data, len))
+				return -EFAULT;
+			if (put_user(len, oldlenp))
+				return -EFAULT;
+		}
+	}
+
+	if (newval && newlen) {
+		if (newlen > table->maxlen)
+			newlen = table->maxlen;
+
+		if (copy_from_user(table->data, newval, newlen))
+			return -EFAULT;
+	}
+	return 1;
+}
+
 /* The generic string strategy routine: */
 int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
@@ -2583,6 +2601,13 @@ out:
 	return -ENOSYS;
 }
 
+int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen)
+{
+	return -ENOSYS;
+}
+
 int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
@@ -2630,4 +2655,5 @@ EXPORT_SYMBOL(sysctl_intvec);
 EXPORT_SYMBOL(sysctl_jiffies);
 EXPORT_SYMBOL(sysctl_ms_jiffies);
 EXPORT_SYMBOL(sysctl_string);
+EXPORT_SYMBOL(sysctl_data);
 EXPORT_SYMBOL(unregister_sysctl_table);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

remove-unused-struct-proc_dir_entryset.patch
dvb_en_50221-convert-to-kthread-api.patch
x86_64-remove-sync_arb_ids.patch
x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
