From: akpm@linux-foundation.org
Subject: + mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch added to -mm tree
Date: Fri, 22 Nov 2013 14:34:16 -0800
Message-ID: <528fdbe8.eRiyADZhOCFCykcF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3KVWeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:34:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wdauchy@gmail.com, stable@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: + mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch added to -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,stable@vger.kernel.org,wdauchy@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:34:16 -0800


The patch titled
     Subject: mm: memcg: do not declare OOM from __GFP_NOFAIL allocations
has been added to the -mm tree.  Its filename is
     mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: do not declare OOM from __GFP_NOFAIL allocations

84235de394d9 ("fs: buffer: move allocation failure loop into the
allocator") started recognizing __GFP_NOFAIL in memory cgroups but forgot
to disable the OOM killer.

Any task that does not fail allocation will also not enter the OOM
completion path.  So don't declare an OOM state in this case or it'll be
leaked and the task be able to bypass the limit until the next
userspace-triggered page fault cleans up the OOM state.

Reported-by: William Dauchy <wdauchy@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.12.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memcontrol.c~mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations
+++ a/mm/memcontrol.c
@@ -2696,6 +2696,9 @@ static int __mem_cgroup_try_charge(struc
 	if (unlikely(task_in_memcg_oom(current)))
 		goto bypass;
 
+	if (gfp_mask & __GFP_NOFAIL)
+		oom = false;
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
proc-meminfo-provide-estimated-available-memory.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners.patch

