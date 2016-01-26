From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 13:30:33 -0800
Message-ID: <56a7e579.psXsqbq9fyfczYow%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbcAZVae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:30:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: drop superfluous entry in the per-memcg stats array
has been added to the -mm tree.  Its filename is
     mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch

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
Subject: mm: memcontrol: drop superfluous entry in the per-memcg stats array

MEM_CGROUP_STAT_NSTATS is just a delimiter for cgroup1 statistics, not an
actual array entry.  Reuse it for the first cgroup2 stat entry, like in
the event array.

Fixes: b2807f07f4f8 ("mm: memcontrol: add "sock" to cgroup2 memory.stat")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array
+++ a/include/linux/memcontrol.h
@@ -51,7 +51,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 	/* default hierarchy stats */
-	MEMCG_SOCK,
+	MEMCG_SOCK = MEM_CGROUP_STAT_NSTATS,
 	MEMCG_NR_STAT,
 };
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

