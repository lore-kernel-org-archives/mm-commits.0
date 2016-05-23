From: akpm@linux-foundation.org
Subject: [patch 03/84] mm: memcontrol: fix possible css ref leak on oom
Date: Mon, 23 May 2016 16:22:29 -0700
Message-ID: <574390b5.ASSwiYr1QGpA577l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbcEWXWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: fix possible css ref leak on oom

mem_cgroup_oom may be invoked multiple times while a process is handling a
page fault, in which case current->memcg_in_oom will be overwritten
leaking the previously taken css reference.

Link: http://lkml.kernel.org/r/1464019330-7579-1-git-send-email-vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-possible-css-ref-leak-on-oom mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-possible-css-ref-leak-on-oom
+++ a/mm/memcontrol.c
@@ -1604,7 +1604,7 @@ static void memcg_oom_recover(struct mem
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	if (!current->memcg_may_oom)
+	if (!current->memcg_may_oom || current->memcg_in_oom)
 		return;
 	/*
 	 * We are in the middle of the charge context here, so we
_
