From: akpm@linux-foundation.org
Subject: + vmpressure-change-vmpressure-sr_lock-to-spinlock.patch added to -mm tree
Date: Fri, 19 Jul 2013 16:00:54 -0700
Message-ID: <51e9c526.tDWuckyLNpThbtj8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3GSXA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 19:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, anton.vorontsov@linaro.org, mhocko@suse.cz

Subject: + vmpressure-change-vmpressure-sr_lock-to-spinlock.patch added to -mm tree
To: mhocko@suse.cz,anton.vorontsov@linaro.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,lizefan@huawei.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 16:00:54 -0700


The patch titled
     Subject: vmpressure: change vmpressure::sr_lock to spinlock
has been added to the -mm tree.  Its filename is
     vmpressure-change-vmpressure-sr_lock-to-spinlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmpressure-change-vmpressure-sr_lock-to-spinlock.patch

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
Subject: vmpressure: change vmpressure::sr_lock to spinlock

There is nothing that can sleep inside critical sections protected by
this lock and those sections are really small so there doesn't make much
sense to use mutex for them. Change the log to a spinlock

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmpressure.h |    2 +-
 mm/vmpressure.c            |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/vmpressure.h~vmpressure-change-vmpressure-sr_lock-to-spinlock include/linux/vmpressure.h
--- a/include/linux/vmpressure.h~vmpressure-change-vmpressure-sr_lock-to-spinlock
+++ a/include/linux/vmpressure.h
@@ -12,7 +12,7 @@ struct vmpressure {
 	unsigned long scanned;
 	unsigned long reclaimed;
 	/* The lock is used to keep the scanned/reclaimed above in sync. */
-	struct mutex sr_lock;
+	struct spinlock sr_lock;
 
 	/* The list of vmpressure_event structs. */
 	struct list_head events;
diff -puN mm/vmpressure.c~vmpressure-change-vmpressure-sr_lock-to-spinlock mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-change-vmpressure-sr_lock-to-spinlock
+++ a/mm/vmpressure.c
@@ -180,12 +180,12 @@ static void vmpressure_work_fn(struct wo
 	if (!vmpr->scanned)
 		return;
 
-	mutex_lock(&vmpr->sr_lock);
+	spin_lock(&vmpr->sr_lock);
 	scanned = vmpr->scanned;
 	reclaimed = vmpr->reclaimed;
 	vmpr->scanned = 0;
 	vmpr->reclaimed = 0;
-	mutex_unlock(&vmpr->sr_lock);
+	spin_unlock(&vmpr->sr_lock);
 
 	do {
 		if (vmpressure_event(vmpr, scanned, reclaimed))
@@ -240,11 +240,11 @@ void vmpressure(gfp_t gfp, struct mem_cg
 	if (!scanned)
 		return;
 
-	mutex_lock(&vmpr->sr_lock);
+	spin_lock(&vmpr->sr_lock);
 	vmpr->scanned += scanned;
 	vmpr->reclaimed += reclaimed;
 	scanned = vmpr->scanned;
-	mutex_unlock(&vmpr->sr_lock);
+	spin_unlock(&vmpr->sr_lock);
 
 	if (scanned < vmpressure_win || work_pending(&vmpr->work))
 		return;
@@ -367,7 +367,7 @@ void vmpressure_unregister_event(struct
  */
 void vmpressure_init(struct vmpressure *vmpr)
 {
-	mutex_init(&vmpr->sr_lock);
+	spin_lock_init(&vmpr->sr_lock);
 	mutex_init(&vmpr->events_lock);
 	INIT_LIST_HEAD(&vmpr->events);
 	INIT_WORK(&vmpr->work, vmpressure_work_fn);
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

