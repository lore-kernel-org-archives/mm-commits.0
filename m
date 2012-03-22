From: akpm@linux-foundation.org
Subject: + mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch added to -mm tree
Date: Thu, 22 Mar 2012 16:08:36 -0700
Message-ID: <20120322230836.C20A9A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:36854 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab2CVXIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 19:08:38 -0400
Received: by ggnd2 with SMTP id d2so427085ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 16:08:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, oleg@redhat.com


The patch titled
     Subject: mm, coredump: fail allocations when coredumping instead of oom killing
has been added to the -mm tree.  Its filename is
     mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch

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
Subject: mm, coredump: fail allocations when coredumping instead of oom killing

The size of coredump files is limited by RLIMIT_CORE, however, allocating
large amounts of memory results in three negative consequences:

 - the coredumping process may be chosen for oom kill and quickly deplete
   all memory reserves in oom conditions preventing further progress from
   being made or tasks from exiting,

 - the coredumping process may cause other processes to be oom killed
   without fault of their own as the result of a SIGSEGV, for example, in
   the coredumping process, or

 - the coredumping process may result in a livelock while writing to the
   dump file if it needs memory to allocate while other threads are in
   the exit path waiting on the coredumper to complete.

This is fixed by implying __GFP_NORETRY in the page allocator for
coredumping processes when reclaim has failed so the allocations fail and
the process continues to exit.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing mm/page_alloc.c
--- a/mm/page_alloc.c~mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing
+++ a/mm/page_alloc.c
@@ -2308,6 +2308,10 @@ rebalance:
 		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
 			if (oom_killer_disabled)
 				goto nopage;
+			/* Coredumps can quickly deplete all memory reserves */
+			if ((current->flags & PF_DUMPCORE) &&
+			    !(gfp_mask & __GFP_NOFAIL))
+				goto nopage;
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
_
Subject: Subject: mm, coredump: fail allocations when coredumping instead of oom killing

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch

