From: akpm@linux-foundation.org
Subject: + memcg-fix-race-in-file_mapped-accouting-flag-management.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:48 -0700
Message-ID: <201009132248.o8DMmmgS025716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266Ab0IMWtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, gthelen@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix race in file_mapped accouting flag management
has been added to the -mm tree.  Its filename is
     memcg-fix-race-in-file_mapped-accouting-flag-management.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix race in file_mapped accouting flag management
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently memory cgroup accounts file-mapped by counter and flag.  counter
is working in the same way with zone_stat but FileMapped flag only exists
in memcg (for helping move_account).

This flag can be updated wrongly in a case.  Assume CPU0 and CPU1 and a
thread mapping a page on CPU0, another thread unmapping it on CPU1.

    CPU0                   		CPU1
				rmv rmap (mapcount 1->0)
   add rmap (mapcount 0->1)
   lock_page_cgroup()
   memcg counter+1		(some delay)
   set MAPPED FLAG.
   unlock_page_cgroup()
				lock_page_cgroup()
				memcg counter-1
				clear MAPPED flag

In above sequence, counter is properly updated but FLAG is not.  This
means that representing a state by a flag which is maintained by counter
needs some specail care.

To handle this, at claering a flag, this patch check mapcount directly and
clear the flag only when mapcount == 0.  (if mapcount >0, someone will
make it to zero later and flag will be cleared.)

Reverse case, dec-after-inc cannot be a problem because page_table_lock()
works well for it.  (IOW, to make above sequence, 2 processes should touch
the same page at once with map/unmap.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-race-in-file_mapped-accouting-flag-management mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-race-in-file_mapped-accouting-flag-management
+++ a/mm/memcontrol.c
@@ -1485,7 +1485,8 @@ void mem_cgroup_update_file_mapped(struc
 		SetPageCgroupFileMapped(pc);
 	} else {
 		__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		ClearPageCgroupFileMapped(pc);
+		if (!page_mapped(page)) /* for race between dec->inc counter */
+			ClearPageCgroupFileMapped(pc);
 	}
 
 done:
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
memcg-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-avoid-lock-in-updating-file_mapped-was-fix-race-in-file_mapped-accouting-flag-management.patch

