From: akpm@linux-foundation.org
Subject: [to-be-updated] pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 12:03:02 -0700
Message-ID: <20120529190302.64BA9A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:64977 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab2E2TDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2012 15:03:04 -0400
Received: by lagr15 with SMTP id r15so258361lag.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 12:03:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, efault@gmx.de, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix
has been removed from the -mm tree.  Its filename was
     pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix

tweak a few things, might be wrong, also insufficient!

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c          |    5 +++--
 kernel/pid_namespace.c |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix kernel/exit.c
--- a/kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix
+++ a/kernel/exit.c
@@ -74,8 +74,9 @@ static void __unhash_process(struct task
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
 
-		/* If we are the last child process in a pid namespace
-		 * to be reaped notify the child_reaper.
+		/*
+		 * If we are the last child process in a pid namespace to be
+		 * reaped, notify the child_reaper.
 		 */
 		parent = p->real_parent;
 		if ((task_active_pid_ns(p)->child_reaper == parent) &&
diff -puN kernel/pid_namespace.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix
+++ a/kernel/pid_namespace.c
@@ -199,6 +199,7 @@ void zap_pid_ns_processes(struct pid_nam
 		read_lock(&tasklist_lock);
 	}
 	read_unlock(&tasklist_lock);
+	set_current_state(TASK_RUNNING);
 
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-page_allocc-cleanups.patch
mm-fix-slab-page-flags-corruption-fix.patch

