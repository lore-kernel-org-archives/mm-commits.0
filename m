From: akpm@linux-foundation.org
Subject: - pidns-place-under-config_experimental.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:46 -0800
Message-ID: <200711152110.lAFLAkkl015688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763480AbXKOVTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:19:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, bunk@kernel.org, clg@fr.ibm.com, dev@sw.ru, jeremy@goop.org, kir@swsoft.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pidns: Place under CONFIG_EXPERIMENTAL
has been removed from the -mm tree.  Its filename was
     pidns-place-under-config_experimental.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pidns: Place under CONFIG_EXPERIMENTAL
From: Eric W. Biederman <ebiederm@xmission.com>

This is my trivial patch to swat innumerable little bugs with a single
blow.

After some intensive review (my apologies for not having gotten to this
sooner) what we have looks like a good base to build on with the current
pid namespace code but it is not complete, and it is still much to simple
to find issues where the kernel does the wrong thing outside of the initial
pid namespace.

Until the dust settles and we are certain we have the ABI and the
implementation is as correct as humanly possible let's keep process ID
namespaces behind CONFIG_EXPERIMENTAL.

Allowing us the option of fixing any ABI or other bugs we find as long as
they are minor.

Allowing users of the kernel to avoid those bugs simply by ensuring their
kernel does not have support for multiple pid namespaces.

[akpm@linux-foundation.org: coding-style cleanups]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kir Kolyshkin <kir@swsoft.com>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |   23 +++++++++++++++++++++++
 init/Kconfig                  |   12 ++++++++++++
 kernel/pid.c                  |    2 ++
 3 files changed, 37 insertions(+)

diff -puN include/linux/pid_namespace.h~pidns-place-under-config_experimental include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pidns-place-under-config_experimental
+++ a/include/linux/pid_namespace.h
@@ -29,6 +29,7 @@ struct pid_namespace {
 
 extern struct pid_namespace init_pid_ns;
 
+#ifdef CONFIG_PID_NS
 static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 {
 	if (ns != &init_pid_ns)
@@ -45,6 +46,28 @@ static inline void put_pid_ns(struct pid
 		kref_put(&ns->kref, free_pid_ns);
 }
 
+#else /* !CONFIG_PID_NS */
+#include <linux/err.h>
+
+static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
+{
+	return ns;
+}
+
+static inline struct pid_namespace *
+copy_pid_ns(unsigned long flags, struct pid_namespace *ns)
+{
+	if (flags & CLONE_NEWPID)
+		ns = ERR_PTR(-EINVAL);
+	return ns;
+}
+
+static inline void put_pid_ns(struct pid_namespace *ns)
+{
+}
+
+#endif /* CONFIG_PID_NS */
+
 static inline struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
 {
 	return tsk->nsproxy->pid_ns;
diff -puN init/Kconfig~pidns-place-under-config_experimental init/Kconfig
--- a/init/Kconfig~pidns-place-under-config_experimental
+++ a/init/Kconfig
@@ -215,6 +215,18 @@ config USER_NS
 	  vservers, to use user namespaces to provide different
 	  user info for different servers.  If unsure, say N.
 
+config PID_NS
+	bool "PID Namespaces (EXPERIMENTAL)"
+	default n
+	depends on EXPERIMENTAL
+	help
+	  Suport process id namespaces.  This allows having multiple
+	  process with the same pid as long as they are in different
+	  pid namespaces.  This is a building block of containers.
+
+	  Unless you want to work with an experimental feature
+	  say N here.
+
 config AUDIT
 	bool "Auditing support"
 	depends on NET
diff -puN kernel/pid.c~pidns-place-under-config_experimental kernel/pid.c
--- a/kernel/pid.c~pidns-place-under-config_experimental
+++ a/kernel/pid.c
@@ -537,6 +537,7 @@ err_alloc:
 	return NULL;
 }
 
+#ifdef CONFIG_PID_NS
 static struct pid_namespace *create_pid_namespace(int level)
 {
 	struct pid_namespace *ns;
@@ -621,6 +622,7 @@ void free_pid_ns(struct kref *kref)
 	if (parent != NULL)
 		put_pid_ns(parent);
 }
+#endif /* CONFIG_PID_NS */
 
 void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 {
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-s390.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
