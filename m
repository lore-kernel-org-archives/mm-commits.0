From: akpm@linux-foundation.org
Subject: - use-task_pid_nr-in-ip_vs_syncc.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:20 -0700
Message-ID: <200710192253.l9JMrKxY024418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762974AbXJSXFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use task_pid_nr() in ip_vs_sync.c
has been removed from the -mm tree.  Its filename was
     use-task_pid_nr-in-ip_vs_syncc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use task_pid_nr() in ip_vs_sync.c
From: Pavel Emelyanov <xemul@openvz.org>

The sync_master_pid and sync_backup_pid are set in set_sync_pid() and are
used later for set/not-set checks and in printk.  So it is safe to use the
global pid value in this case.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ipvs/ip_vs_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/ipvs/ip_vs_sync.c~use-task_pid_nr-in-ip_vs_syncc net/ipv4/ipvs/ip_vs_sync.c
--- a/net/ipv4/ipvs/ip_vs_sync.c~use-task_pid_nr-in-ip_vs_syncc
+++ a/net/ipv4/ipvs/ip_vs_sync.c
@@ -794,7 +794,7 @@ static int sync_thread(void *startup)
 
 	add_wait_queue(&sync_wait, &wait);
 
-	set_sync_pid(state, current->pid);
+	set_sync_pid(state, task_pid_nr(current));
 	complete(tinfo->startup);
 
 	/*
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
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
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
