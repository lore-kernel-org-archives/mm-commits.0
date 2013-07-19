From: akpm@linux-foundation.org
Subject: +
 vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
 added to -mm tree
Date: Fri, 19 Jul 2013 16:00:55 -0700
Message-ID: <51e9c527.MKEWzZsvfPQpDNRu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3GSXA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 19:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, anton.vorontsov@linaro.org, mhocko@suse.cz

Subject: + vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch added to -mm tree
To: mhocko@suse.cz,anton.vorontsov@linaro.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,lizefan@huawei.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 16:00:55 -0700


The patch titled
     Subject: vmpressure: do not check for pending work to prevent from new work
has been added to the -mm tree.  Its filename is
     vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmpressure: do not check for pending work to prevent from new work

because it is racy and it doesn't give us much anyway as schedule_work
handles this case already.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmpressure.c~vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work
+++ a/mm/vmpressure.c
@@ -246,7 +246,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 	scanned = vmpr->scanned;
 	spin_unlock(&vmpr->sr_lock);
 
-	if (scanned < vmpressure_win || work_pending(&vmpr->work))
+	if (scanned < vmpressure_win)
 		return;
 	schedule_work(&vmpr->work);
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
staging-lustre-replace-num_physpages-with-totalram_pages.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch

