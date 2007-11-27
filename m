From: akpm@linux-foundation.org
Subject: + isolate-the-uts-namespaces-domainname-and-hostname-back.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:10:14 -0800
Message-ID: <200711270410.lAR4ADfr026211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbXK0EK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:10:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, clg@fr.ibm.com


The patch titled
     Isolate the UTS namespace's domainname and hostname back
has been added to the -mm tree.  Its filename is
     isolate-the-uts-namespaces-domainname-and-hostname-back.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Isolate the UTS namespace's domainname and hostname back
From: Pavel Emelyanov <xemul@openvz.org>

The commit

commit 7d69a1f4a72b18876c99c697692b78339d491568
Author: Cedric Le Goater <clg@fr.ibm.com>
Date:   Sun Jul 15 23:40:58 2007 -0700

    remove CONFIG_UTS_NS and CONFIG_IPC_NS

accidentally removed the code, that prevented the uts->hostname
and uts->domainname values from being overwritten from another
namespace. In other words, setting hostname/domainname via sysfs
(echo xxx > /proc/sys/kernel/(host|domain)name) cased the new
value to be set in init UTS namespace only.

Return the isolation back.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/utsname_sysctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/utsname_sysctl.c~isolate-the-uts-namespaces-domainname-and-hostname-back kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~isolate-the-uts-namespaces-domainname-and-hostname-back
+++ a/kernel/utsname_sysctl.c
@@ -18,6 +18,10 @@
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
+	struct uts_namespace *uts_ns;
+
+	uts_ns = current->nsproxy->uts_ns;
+	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
 
 	if (!write)
 		down_read(&uts_sem);
_

Patches currently in -mm which might be from xemul@openvz.org are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
ipc-lost-unlock-and-fput-in-mqueuec-on-error-path.patch
isolate-the-uts-namespaces-domainname-and-hostname-back.patch
git-net.patch
dont-forget-to-unlock-uids_mutex-on-error-paths.patch
merge-multiple-error-paths-in-alloc_uid-into-one.patch
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
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
reiser4.patch
