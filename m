From: akpm@linux-foundation.org
Subject: - markers-fix-warnings.patch removed from -mm tree
Date: Tue, 13 Nov 2007 13:08:44 -0800
Message-ID: <200711132108.lADL8iBp004151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759478AbXKMVJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 16:09:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     markers: fix warnings
has been removed from the -mm tree.  Its filename was
     markers-fix-warnings.patch

This patch was dropped because new patches broke it

------------------------------------------------------
Subject: markers: fix warnings
From: Dave Hansen <haveblue@us.ibm.com>

kernel/marker.c: In function `marker_probe_unregister':
kernel/marker.c:355: warning: `probe_module' might be used uninitialized in this function
kernel/marker.c: In function `marker_probe_unregister_private_data':
kernel/marker.c:389: warning: `probe_module' might be used uninitialized in this function
kernel/marker.c:392: warning: `entry' might be used uninitialized in this function

It's due to gcc not detecting that the need_update condition is actually
constant, and will never call marker_update_probes() on an uninitialized
probe_module.

However, that need_update bit is all due to dropping the mutex before
calling marker_update_probes().  As far as I can tell, every call to
marker_update_probes() has this lock dropping behavior just before calling
it.  So, let's just hold the locks over the marker_update_probes() and
document that it needs to have a lock taken instead.

This removes code overall.

marker_probe_unregister_private_data() also has a bit of a goto mess
that produces similar warnings.  I'll look at it next.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff -puN kernel/marker.c~markers-fix-warnings kernel/marker.c
--- a/kernel/marker.c~markers-fix-warnings
+++ a/kernel/marker.c
@@ -288,12 +288,13 @@ void marker_update_probe_range(struct ma
  * Issues a synchronize_sched() when no reference to the module passed
  * as parameter is found in the probes so the probe module can be
  * safely unloaded from now on.
+ *
+ * must hold markers_mutex
  */
-static void marker_update_probes(struct module *probe_module)
+static void __marker_update_probes(struct module *probe_module)
 {
 	int refcount = 0;
 
-	mutex_lock(&markers_mutex);
 	/* Core kernel markers */
 	marker_update_probe_range(__start___markers,
 			__stop___markers, probe_module, &refcount);
@@ -303,7 +304,6 @@ static void marker_update_probes(struct 
 		synchronize_sched();
 		deferred_sync = 0;
 	}
-	mutex_unlock(&markers_mutex);
 }
 
 /**
@@ -320,7 +320,7 @@ int marker_probe_register(const char *na
 			marker_probe_func *probe, void *private)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -335,11 +335,9 @@ int marker_probe_register(const char *na
 	ret = add_marker(name, format, probe, private);
 	if (ret)
 		goto end;
-	need_update = 1;
+	__marker_update_probes(NULL);
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_probe_register);
@@ -355,7 +353,6 @@ void *marker_probe_unregister(const char
 	struct module *probe_module;
 	struct marker_entry *entry;
 	void *private;
-	int need_update = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -368,11 +365,9 @@ void *marker_probe_unregister(const char
 	probe_module = __module_text_address((unsigned long)entry->probe);
 	private = remove_marker(name);
 	deferred_sync = 1;
-	need_update = 1;
+	__marker_update_probes(probe_module);
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(probe_module);
 	return private;
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister);
@@ -392,7 +387,6 @@ void *marker_probe_unregister_private_da
 	struct marker_entry *entry;
 	int found = 0;
 	unsigned int i;
-	int need_update = 0;
 
 	mutex_lock(&markers_mutex);
 	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
@@ -414,11 +408,9 @@ iter_end:
 	probe_module = __module_text_address((unsigned long)entry->probe);
 	private = remove_marker(entry->name);
 	deferred_sync = 1;
-	need_update = 1;
+	__marker_update_probes(probe_module);
 end:
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(probe_module);
 	return private;
 }
 EXPORT_SYMBOL_GPL(marker_probe_unregister_private_data);
@@ -434,7 +426,7 @@ EXPORT_SYMBOL_GPL(marker_probe_unregiste
 int marker_arm(const char *name)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -447,11 +439,9 @@ int marker_arm(const char *name)
 	 */
 	if (entry->refcount++)
 		goto end;
-	need_update = 1;
 end:
+	__marker_update_probes(NULL);
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_arm);
@@ -467,7 +457,7 @@ EXPORT_SYMBOL_GPL(marker_arm);
 int marker_disarm(const char *name)
 {
 	struct marker_entry *entry;
-	int ret = 0, need_update = 0;
+	int ret = 0;
 
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
@@ -486,11 +476,9 @@ int marker_disarm(const char *name)
 		ret = -EPERM;
 		goto end;
 	}
-	need_update = 1;
 end:
+	__marker_update_probes(NULL);
 	mutex_unlock(&markers_mutex);
-	if (need_update)
-		marker_update_probes(NULL);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(marker_disarm);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
linux-kernel-markers-fix-marker-mutex-not-taken-upon-module-load.patch
markers-fix-warnings.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
do-namei_flags-calculation-inside-open_namei.patch
make-open_namei-return-a-filp.patch
kill-do_filp_open.patch
kill-filp_open.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
nfsd-fix-wrong-mnt_writer-count-in-rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
