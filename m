From: akpm@linux-foundation.org
Subject: [patch 3/7] revert "mm: memcontrol: fix possible css ref leak on
 oom"
Date: Wed, 08 Jun 2016 15:33:47 -0700
Message-ID: <57589d4b.dx7ElKOteS8vnP3e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161279AbcFHWdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 18:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "mm: memcontrol: fix possible css ref leak on oom"

Revert 1383399d7be02 ("mm: memcontrol: fix possible css ref leak on oom").
Johannes points out "There is a task_in_memcg_oom() check before calling
mem_cgroup_oom()".

Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom mm/memcontrol.c
--- a/mm/memcontrol.c~revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom
+++ a/mm/memcontrol.c
@@ -1608,7 +1608,7 @@ static void memcg_oom_recover(struct mem
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	if (!current->memcg_may_oom || current->memcg_in_oom)
+	if (!current->memcg_may_oom)
 		return;
 	/*
 	 * We are in the middle of the charge context here, so we
_
