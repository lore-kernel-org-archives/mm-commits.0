From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin.patch added
 to -mm tree
Date: Thu, 26 May 2016 14:15:54 -0700
Message-ID: <5747678a.ntx9YRPBKjCLaJKo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbcEZVQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 17:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roy.qing.li@gmail.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix the margin computation in mem_cgroup_margin()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li RongQing <roy.qing.li@gmail.com>
Subject: mm/memcontrol.c: fix the margin computation in mem_cgroup_margin()

mem_cgroup_margin() might return (memory.limit - memory_count) when the
memsw.limit is in excess.  This doesn't happen usually because we do not
allow excess on hard limits and (memory.limit <= memsw.limit), but
__GFP_NOFAIL charges can force the charge and cause the excess when no
memory is really swappable (swap is full or no anonymous memory is left).

[mhocko@suse.com: rewrote changelog]
  Link: http://lkml.kernel.org/r/20160525155122.GK20132@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/1464068266-27736-1-git-send-email-roy.qing.li@gmail.com
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin
+++ a/mm/memcontrol.c
@@ -1108,6 +1108,8 @@ static unsigned long mem_cgroup_margin(s
 		limit = READ_ONCE(memcg->memsw.limit);
 		if (count <= limit)
 			margin = min(margin, limit - count);
+		else
+			margin = 0;
 	}
 
 	return margin;
_

Patches currently in -mm which might be from roy.qing.li@gmail.com are

mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin.patch
mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch

