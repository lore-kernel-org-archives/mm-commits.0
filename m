From: akpm@linux-foundation.org
Subject: + add-cgroup-write_uint-helper-method.patch added to -mm tree
Date: Tue, 25 Sep 2007 22:12:46 -0700
Message-ID: <200709260512.l8Q5Ckql021729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbXIZFMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 01:12:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com


The patch titled
     Add cgroup write_uint() helper method
has been added to the -mm tree.  Its filename is
     add-cgroup-write_uint-helper-method.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add cgroup write_uint() helper method
From: Paul Menage <menage@google.com>

Add write_uint() helper method for cgroup subsystems

This helper is analagous to the read_uint() helper method for
reporting u64 values to userspace. It's designed to reduce the amount
of boilerplate requierd for creating new cgroup subsystems.

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    8 +++++++
 kernel/cgroup.c        |   42 +++++++++++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 4 deletions(-)

diff -puN include/linux/cgroup.h~add-cgroup-write_uint-helper-method include/linux/cgroup.h
--- a/include/linux/cgroup.h~add-cgroup-write_uint-helper-method
+++ a/include/linux/cgroup.h
@@ -125,6 +125,14 @@ struct cftype {
 	ssize_t (*write) (struct cgroup *cont, struct cftype *cft,
 			  struct file *file,
 			  const char __user *buf, size_t nbytes, loff_t *ppos);
+
+	/*
+	 * write_uint() is a shortcut for the common case of accepting
+	 * a single integer (as parsed by simple_strtoull) from
+	 * userspace. Use in place of write(); return 0 or error.
+	 */
+	int (*write_uint) (struct cgroup *cont, struct cftype *cft, u64 val);
+
 	int (*release) (struct inode *inode, struct file *file);
 };
 
diff -puN kernel/cgroup.c~add-cgroup-write_uint-helper-method kernel/cgroup.c
--- a/kernel/cgroup.c~add-cgroup-write_uint-helper-method
+++ a/kernel/cgroup.c
@@ -829,6 +829,39 @@ enum cgroup_filetype {
 	FILE_TASKLIST,
 };
 
+static ssize_t cgroup_write_uint(struct cgroup *cont, struct cftype *cft,
+				 struct file *file,
+				 const char __user *userbuf,
+				 size_t nbytes, loff_t *unused_ppos)
+{
+	char buffer[64];
+	int retval = 0;
+	u64 val;
+	char *end;
+
+	if (!nbytes)
+		return -EINVAL;
+	if (nbytes >= sizeof(buffer))
+		return -E2BIG;
+	if (copy_from_user(buffer, userbuf, nbytes))
+		return -EFAULT;
+
+	buffer[nbytes] = 0;     /* nul-terminate */
+
+	/* strip newline if necessary */
+	if (nbytes && (buffer[nbytes-1] == '\n'))
+		buffer[nbytes-1] = 0;
+	val = simple_strtoull(buffer, &end, 0);
+	if (*end)
+		return -EINVAL;
+
+	/* Pass to subsystem */
+	retval = cft->write_uint(cont, cft, val);
+	if (!retval)
+		retval = nbytes;
+	return retval;
+}
+
 static ssize_t cgroup_common_file_write(struct cgroup *cont,
 					   struct cftype *cft,
 					   struct file *file,
@@ -886,10 +919,11 @@ static ssize_t cgroup_file_write(struct 
 
 	if (!cft)
 		return -ENODEV;
-	if (!cft->write)
-		return -EINVAL;
-
-	return cft->write(cont, cft, file, buf, nbytes, ppos);
+	if (cft->write)
+		return cft->write(cont, cft, file, buf, nbytes, ppos);
+	if (cft->write_uint)
+		return cgroup_write_uint(cont, cft, file, buf, nbytes, ppos);
+	return -EINVAL;
 }
 
 static ssize_t cgroup_read_uint(struct cgroup *cont, struct cftype *cft,
_

Patches currently in -mm which might be from menage@google.com are

cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-basic-task-container-framework-containers-fix-refcount-bug.patch
task-containersv11-add-tasks-file-interface.patch
add-cgroup-write_uint-helper-method.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-container_clone-interface-containers-fix-refcount-bug.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
containers-implement-namespace-tracking-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
fix-cgroup_create_dir-comments.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
add-a-refcount-check-in-dput.patch
