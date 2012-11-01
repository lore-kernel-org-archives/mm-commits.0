From: akpm@linux-foundation.org
Subject: + mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch added to -mm tree
Date: Thu, 01 Nov 2012 15:43:11 -0700
Message-ID: <20121101224312.287C35C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:43161 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992604Ab2KAWnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 18:43:15 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so190480fae.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 15:43:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, minchan@kernel.org, semenzato@google.com


The patch titled
     Subject: mm, oom: allow exiting threads to have access to memory reserves
has been added to the -mm tree.  Its filename is
     mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: allow exiting threads to have access to memory reserves

Exiting threads, those with PF_EXITING set, can pagefault and require
memory before they can make forward progress.  This happens, for instance,
when a process must fault task->robust_list, a userspace structure, before
detaching its memory.

These threads also aren't guaranteed to get access to memory reserves
unless oom killed or killed from userspace.  The oom killer won't grant
memory reserves if other threads are also exiting other than current and
stalling at the same point.  This prevents needlessly killing processes
when others are already exiting.

Instead of special casing all the possible situations between PF_EXITING
getting set and a thread detaching its mm where it may allocate memory,
which probably wouldn't get updated when a change is made to the exit
path, the solution is to give all exiting threads access to memory
reserves if they call the oom killer.  This allows them to quickly
allocate, detach its mm, and free the memory it represents.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Tested-by: Luigi Semenzato <semenzato@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves
+++ a/mm/oom_kill.c
@@ -310,26 +310,13 @@ enum oom_scan_t oom_scan_process_thread(
 	if (!task->mm)
 		return OOM_SCAN_CONTINUE;
 
-	if (task->flags & PF_EXITING) {
+	if (task->flags & PF_EXITING && !force_kill) {
 		/*
-		 * If task is current and is in the process of releasing memory,
-		 * allow the "kill" to set TIF_MEMDIE, which will allow it to
-		 * access memory reserves.  Otherwise, it may stall forever.
-		 *
-		 * The iteration isn't broken here, however, in case other
-		 * threads are found to have already been oom killed.
+		 * If this task is not being ptraced on exit, then wait for it
+		 * to finish before killing some other task unnecessarily.
 		 */
-		if (task == current)
-			return OOM_SCAN_SELECT;
-		else if (!force_kill) {
-			/*
-			 * If this task is not being ptraced on exit, then wait
-			 * for it to finish before killing some other task
-			 * unnecessarily.
-			 */
-			if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
-				return OOM_SCAN_ABORT;
-		}
+		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
+			return OOM_SCAN_ABORT;
 	}
 	return OOM_SCAN_OK;
 }
@@ -706,11 +693,11 @@ void out_of_memory(struct zonelist *zone
 		return;
 
 	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current)) {
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-clean-up-__collapse_huge_page_isolate.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch

