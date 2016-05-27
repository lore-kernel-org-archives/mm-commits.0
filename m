From: akpm@linux-foundation.org
Subject: [patch 17/19] mm/memcontrol.c: fix the margin computation in
 mem_cgroup_margin()
Date: Fri, 27 May 2016 14:27:43 -0700
Message-ID: <5748bbcf.7F2WKDH9JmnhGuCl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbcE0V1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, roy.qing.li@gmail.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com

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
