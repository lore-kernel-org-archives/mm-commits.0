From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin.patch removed from -mm tree
Date: Tue, 31 May 2016 10:50:43 -0700
Message-ID: <574dcef3.LEjurNcOYZ8KiD7H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbcEaRuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roy.qing.li@gmail.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix the margin computation in mem_cgroup_margin()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-the-margin-computation-in-mem_cgroup_margin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-memcontrol-remove-the-useless-parameter-for-mc_handle_swap_pte.patch

