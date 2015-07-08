From: akpm@linux-foundation.org
Subject: [nacked] oom-do-not-invoke-oom-notifiers-on-sysrqf.patch removed
 from -mm tree
Date: Wed, 08 Jul 2015 16:44:22 -0700
Message-ID: <559db5d6.mdqFekioPKpiT06Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbbGHXoX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 19:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, jakobunt@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: do not invoke oom notifiers on sysrq+f
has been removed from the -mm tree.  Its filename was
     oom-do-not-invoke-oom-notifiers-on-sysrqf.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: oom: do not invoke oom notifiers on sysrq+f

A github user rfjakob has reported the following issue via IRC.
<rfjakob> Manually triggering the OOM killer does not work anymore in 4.0.5
<rfjakob> This is what it looks like: https://gist.github.com/rfjakob/346b7dc611fc3cdf4011
<rfjakob> Basically, what happens is that the GPU driver frees some memory, that satisfies the OOM killer
<rfjakob> But the memory is allocated immediately again, and in the, no processes are killed no matter how often you trigger the oom killer
<rfjakob> "in the end"

Quoting from the github:
"
[19291.202062] sysrq: SysRq : Manual OOM execution
[19291.208335] Purging GPU memory, 74399744 bytes freed, 8728576 bytes still pinned.
[19291.390767] sysrq: SysRq : Manual OOM execution
[19291.396792] Purging GPU memory, 74452992 bytes freed, 8728576 bytes still pinned.
[19291.560349] sysrq: SysRq : Manual OOM execution
[19291.566018] Purging GPU memory, 75489280 bytes freed, 8728576 bytes still pinned.
[19291.729944] sysrq: SysRq : Manual OOM execution
[19291.735686] Purging GPU memory, 74399744 bytes freed, 8728576 bytes still pinned.
[19291.918637] sysrq: SysRq : Manual OOM execution
[19291.924299] Purging GPU memory, 74403840 bytes freed, 8728576 bytes still pinned.
"

The issue is that sysrq+f (force_kill) gets confused by the regular OOM
heuristic which tries to prevent from OOM killer if some of the oom
notifier can relase a memory.  The heuristic doesn't make much sense for
the sysrq+f path because this one is used by the administrator to kill a
memory hog.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Jakob Unterwurzacher <jakobunt@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~oom-do-not-invoke-oom-notifiers-on-sysrqf mm/oom_kill.c
--- a/mm/oom_kill.c~oom-do-not-invoke-oom-notifiers-on-sysrqf
+++ a/mm/oom_kill.c
@@ -661,10 +661,12 @@ bool out_of_memory(struct zonelist *zone
 	if (oom_killer_disabled)
 		return false;
 
-	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
-	if (freed > 0)
-		/* Got some memory back in the last second. */
-		goto out;
+	if (!force_kill) {
+		blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
+		if (freed > 0)
+			/* Got some memory back in the last second. */
+			goto out;
+	}
 
 	/*
 	 * If current has a pending SIGKILL or is exiting, then automatically
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch
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

