From: akpm@linux-foundation.org
Subject: [merged]
 memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:17 -0700
Message-ID: <5390c9f9.4O8yztcdgZbcJqP5%akpm__46831.3605445021$1401997831$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaFETuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, ebiederm@xmission.com, mhocko@suse.cz

Subject: [merged] memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch removed from -mm tree
To: mhocko@suse.cz,ebiederm@xmission.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,rientjes@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:17 -0700


The patch titled
     Subject: memcg: do not hang on OOM when killed by userspace OOM access to memory reserves
has been removed from the -mm tree.  Its filename was
     memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: do not hang on OOM when killed by userspace OOM access to memory reserves

Eric has reported that he can see task(s) stuck in memcg OOM handler
regularly.  The only way out is to

	echo 0 > $GROUP/memory.oom_control

His usecase is:

- Setup a hierarchy with memory and the freezer (disable kernel oom and
  have a process watch for oom).

- In that memory cgroup add a process with one thread per cpu.

- In one thread slowly allocate once per second I think it is 16M of ram
  and mlock and dirty it (just to force the pages into ram and stay
  there).

- When oom is achieved loop:
  * attempt to freeze all of the tasks.
  * if frozen send every task SIGKILL, unfreeze, remove the directory in
    cgroupfs.

Eric has then pinpointed the issue to be memcg specific.

All tasks are sitting on the memcg_oom_waitq when memcg oom is disabled. 
Those that have received fatal signal will bypass the charge and should
continue on their way out.  The tricky part is that the exit path might
trigger a page fault (e.g.  exit_robust_list), thus the memcg charge,
while its memcg is still under OOM because nobody has released any charges
yet.

Unlike with the in-kernel OOM handler the exiting task doesn't get
TIF_MEMDIE set so it doesn't shortcut further charges of the killed task
and falls to the memcg OOM again without any way out of it as there are no
fatal signals pending anymore.

This patch fixes the issue by checking PF_EXITING early in
mem_cgroup_try_charge and bypass the charge same as if it had fatal
signal pending or TIF_MEMDIE set.

Normally exiting tasks (aka not killed) will bypass the charge now but
this should be OK as the task is leaving and will release memory and
increasing the memory pressure just to release it in a moment seems
dubious wasting of cycles.  Besides that charges after exit_signals should
be rare.

I am bringing this patch again (rebased on the current mmotm tree). I
hope we can move forward finally. If there is still an opposition then
I would really appreciate a concurrent approach so that we can discuss
alternatives.

http://comments.gmane.org/gmane.linux.kernel.stable/77650 is a reference
to the followup discussion when the patch has been dropped from the mmotm
last time.

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves
+++ a/mm/memcontrol.c
@@ -2684,7 +2684,8 @@ static int mem_cgroup_try_charge(struct
 	 * free their memory.
 	 */
 	if (unlikely(test_thread_flag(TIF_MEMDIE) ||
-		     fatal_signal_pending(current)))
+		     fatal_signal_pending(current) ||
+		     current->flags & PF_EXITING))
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

