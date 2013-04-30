From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-give-exiting-processes-access-to-memory-reserves.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:03 -0700
Message-ID: <20130430185003.7F7F131C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:45164 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3D3SuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:04 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so85776ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: give exiting processes access to memory reserves
has been removed from the -mm tree.  Its filename was
     mm-memcg-give-exiting-processes-access-to-memory-reserves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: give exiting processes access to memory reserves

A memcg may livelock when oom if the process that grabs the hierarchy's
oom lock is never the first process with PF_EXITING set in the memcg's
task iteration.

The oom killer, both global and memcg, will defer if it finds an eligible
process that is in the process of exiting and it is not being ptraced. 
The idea is to allow it to exit without using memory reserves before
needlessly killing another process.

This normally works fine except in the memcg case with a large number of
threads attached to the oom memcg.  In this case, the memcg oom killer
only gets called for the process that grabs the hierarchy's oom lock; all
others end up blocked on the memcg's oom waitqueue.  Thus, if the process
that grabs the hierarchy's oom lock is never the first PF_EXITING process
in the memcg's task iteration, the oom killer is constantly deferred
without anything making progress.

The fix is to give PF_EXITING processes access to memory reserves so that
we've marked them as oom killed without any iteration.  This allows
__mem_cgroup_try_charge() to succeed so that the process may exit.  This
makes the memcg oom killer exemption for TIF_MEMDIE tasks, now immediately
granted for processes with pending SIGKILLs and those in the exit path, to
be equivalent to what is done for the global oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-give-exiting-processes-access-to-memory-reserves mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-give-exiting-processes-access-to-memory-reserves
+++ a/mm/memcontrol.c
@@ -1787,11 +1787,11 @@ static void mem_cgroup_out_of_memory(str
 	struct task_struct *chosen = NULL;
 
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

origin.patch
linux-next.patch
drivers-usb-storage-realtek_crc-fix-build.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch
fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

