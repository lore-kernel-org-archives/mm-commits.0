From: akpm@linux-foundation.org
Subject: [nacked]
 oom-do-not-panic-when-oom-killer-is-sysrq-triggered.patch removed from -mm
 tree
Date: Wed, 08 Jul 2015 16:44:19 -0700
Message-ID: <559db5d3.d6xD6izqduDDp+tZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbbGHXoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 19:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, jakobunt@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: mo not panic when OOM killer is sysrq triggered
has been removed from the -mm tree.  Its filename was
     oom-do-not-panic-when-oom-killer-is-sysrq-triggered.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: oom: mo not panic when OOM killer is sysrq triggered

OOM killer might be triggered explicitly via sysrq+f.  This is supposed to
kill a task no matter what e.g.  a task is selected even though there is
an OOM victim on the way to exit.  This is a big hammer for an admin to
help to resolve a memory short condition when the system is not able to
cope with it on its own in a reasonable time frame (e.g.  when the system
is trashing or the OOM killer cannot make sufficient progress)

E.g.  it doesn't make any sense to obey panic_on_oom setting because a)
administrator could have used other sysrqs to achieve the panic/reboot and
b) the policy would break an existing usecase to kill a memory hog which
would be recoverable unlike the panic which might be configured for the
real OOM condition.

It also doesn't make much sense to panic the system when there is no OOM
killable task because administrator might choose to do additional steps
before rebooting/panicking the system.

While we are there also add a comment explaining why
sysctl_oom_kill_allocating_task doesn't apply to sysrq triggered OOM
killer even though there is no explicit check and we subtly rely on
current->mm being NULL for the context from which it is triggered.

Also be more explicit about sysrq+f behavior in the documentation.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Jakob Unterwurzacher <jakobunt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    5 ++++-
 mm/oom_kill.c           |   15 ++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff -puN Documentation/sysrq.txt~oom-do-not-panic-when-oom-killer-is-sysrq-triggered Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~oom-do-not-panic-when-oom-killer-is-sysrq-triggered
+++ a/Documentation/sysrq.txt
@@ -75,7 +75,10 @@ On all -  write a character to /proc/sys
 
 'e'     - Send a SIGTERM to all processes, except for init.
 
-'f'	- Will call oom_kill to kill a memory hog process.
+'f'	- Will call oom_kill to kill a memory hog process. Please note that
+	  parallel OOM killer is ignored and a task is killed even though
+	  there was an oom victim selected already. panic_on_oom is ignored
+	  and the system doesn't panic if there are no oom killable tasks.
 
 'g'	- Used by kgdb (kernel debugger)
 
diff -puN mm/oom_kill.c~oom-do-not-panic-when-oom-killer-is-sysrq-triggered mm/oom_kill.c
--- a/mm/oom_kill.c~oom-do-not-panic-when-oom-killer-is-sysrq-triggered
+++ a/mm/oom_kill.c
@@ -687,8 +687,13 @@ bool out_of_memory(struct zonelist *zone
 	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
 						&totalpages);
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
-	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask, NULL);
+	if (!force_kill)
+		check_panic_on_oom(constraint, gfp_mask, order, mpol_mask, NULL);
 
+	/*
+	 * not affecting force_kill because sysrq triggered OOM killer runs from
+	 * the workqueue context so current->mm will be NULL
+	 */
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
@@ -702,8 +707,12 @@ bool out_of_memory(struct zonelist *zone
 	p = select_bad_process(&points, totalpages, mpol_mask, force_kill);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
-		panic("Out of memory and no killable processes...\n");
+		if (!force_kill) {
+			dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
+			panic("Out of memory and no killable processes...\n");
+		} else {
+			pr_info("Sysrq triggered out of memory. No killable task found...\n");
+		}
 	}
 	if (p != (void *)-1UL) {
 		oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch
oom-do-not-invoke-oom-notifiers-on-sysrqf.patch
mm-oom-organize-oom-context-into-struct.patch
oom-split-out-forced-oom-killer.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch

