From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:42:17 -0700
Message-ID: <57489509.kLYws1MlvxOb9jSw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbcE0SmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix possible css ref leak on oom
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom-do-not-reap-task-if-there-are-live-threads-in-threadgroup.patch

