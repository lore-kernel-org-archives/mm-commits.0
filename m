From: akpm@linux-foundation.org
Subject: + memcg-fix-memoryhigh-target.patch added to -mm tree
Date: Mon, 23 Nov 2015 15:08:50 -0800
Message-ID: <56539c82.X4esX40Q0nJN7+in%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbKWXIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:08:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix memory.high target
has been added to the -mm tree.  Its filename is
     memcg-fix-memoryhigh-target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-memoryhigh-target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-memoryhigh-target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: memcg: fix memory.high target

When the memory.high threshold is exceeded, try_charge() schedules a
task_work to reclaim the excess.  The reclaim target is set to the number
of pages requested by try_charge().  This is wrong, because try_charge()
usually charges more pages than requested (batch > nr_pages) in order to
refill per cpu stocks.  As a result, a process in a cgroup can easily
exceed memory.high significantly when doing a lot of charges w/o returning
to userspace (e.g.  reading a file in big chunks).

Fix this issue by assuring that when exceeding memory.high a process
reclaims as many pages as were actually charged (i.e.  batch).

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-memoryhigh-target mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-memoryhigh-target
+++ a/mm/memcontrol.c
@@ -2128,7 +2128,7 @@ done_restock:
 	 */
 	do {
 		if (page_counter_read(&memcg->memory) > memcg->high) {
-			current->memcg_nr_pages_over_high += nr_pages;
+			current->memcg_nr_pages_over_high += batch;
 			set_notify_resume(current);
 			break;
 		}
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

memcg-fix-memoryhigh-target.patch
revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch

