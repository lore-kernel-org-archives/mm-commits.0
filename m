From: akpm@linux-foundation.org
Subject: + sysctl-update-sysctl_check_table.patch added to -mm tree
Date: Thu, 09 Aug 2007 18:41:52 -0700
Message-ID: <200708100141.l7A1fqXr029559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbXHJBmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 21:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru


The patch titled
     sysctl: update sysctl_check_table
has been added to the -mm tree.  Its filename is
     sysctl-update-sysctl_check_table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: update sysctl_check_table
From: Eric W. Biederman <ebiederm@xmission.com>

Well it turns out after I dug into the problems a little more I was returning
a few false positives so this patch updates my logic to remove them.

- Don't complain about 0 ctl_names in sysctl_check_binary_path
  It is valid for someone to remove the sysctl binary interface
  and still keep the same sysctl proc interface.

- Count ctl_names and procnames as matching if they both don't
  exist.

- Only warn about missing min&max when the generic functions care.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN kernel/sysctl_check.c~sysctl-update-sysctl_check_table kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-update-sysctl_check_table
+++ a/kernel/sysctl_check.c
@@ -1420,12 +1420,14 @@ static int sysctl_check_dir(struct ctl_t
 	ref = sysctl_check_lookup(table);
 	if (ref) {
 		int match = 0;
-		if (table->procname && ref->procname &&
-		    (strcmp(table->procname, ref->procname) == 0))
+		if ((!table->procname && !ref->procname) ||
+		    (table->procname && ref->procname &&
+		     (strcmp(table->procname, ref->procname) == 0)))
 			match++;
 
-		if (table->ctl_name && ref->ctl_name &&
-		    (table->ctl_name == ref->ctl_name))
+		if ((!table->ctl_name && !ref->ctl_name) ||
+		    (table->ctl_name && ref->ctl_name &&
+		     (table->ctl_name == ref->ctl_name)))
 			match++;
 
 		if (match != 2) {
@@ -1462,8 +1464,8 @@ static void sysctl_check_bin_path(struct
 		     (strcmp(table->procname, ref->procname) != 0)))
 			set_fail(fail, table, "procname does not match binary path procname");
 
-		if (ref->ctl_name &&
-		    (!table->ctl_name || table->ctl_name != ref->ctl_name))
+		if (ref->ctl_name && table->ctl_name &&
+		    (table->ctl_name != ref->ctl_name))
 			set_fail(fail, table, "ctl_name does not match binary path ctl_name");
 	}
 }
@@ -1499,7 +1501,7 @@ int sysctl_check_table(struct ctl_table 
 			if (table->extra2)
 				set_fail(&fail, table, "Directory with extra2");
 			if (sysctl_check_dir(table))
-				set_fail(&fail, table, "Inconsistent directory");
+				set_fail(&fail, table, "Inconsistent directory names");
 		} else {
 			if ((table->strategy == sysctl_data) ||
 			    (table->strategy == sysctl_string) ||
@@ -1520,14 +1522,14 @@ int sysctl_check_table(struct ctl_table 
 				if (!table->maxlen)
 					set_fail(&fail, table, "No maxlen");
 			}
-			if ((table->strategy == sysctl_intvec) ||
-			    (table->proc_handler == proc_dointvec_minmax) ||
-			    (table->proc_handler == proc_doulongvec_minmax) ||
+			if ((table->proc_handler == proc_doulongvec_minmax) ||
 			    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
-				if (!table->extra1)
-					set_fail(&fail, table, "No min");
-				if (!table->extra2)
-					set_fail(&fail, table, "No max");
+				if (table->maxlen > sizeof (unsigned long)) {
+					if (!table->extra1)
+						set_fail(&fail, table, "No min");
+					if (!table->extra2)
+						set_fail(&fail, table, "No max");
+				}
 			}
 			if (table->ctl_name && !table->strategy)
 				set_fail(&fail, table, "Missing strategy");
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
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
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
