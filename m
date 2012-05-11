From: akpm@linux-foundation.org
Subject: + remove-__must_check-for-res_counter_charge_nofail.patch added to -mm tree
Date: Fri, 11 May 2012 14:23:50 -0700
Message-ID: <20120511212351.022BDA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:35392 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946149Ab2EKVXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 May 2012 17:23:52 -0400
Received: by yhgm50 with SMTP id m50so479544yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 11 May 2012 14:23:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com


The patch titled
     Subject: rescounter: remove __must_check from res_counter_charge_nofail()
has been added to the -mm tree.  Its filename is
     remove-__must_check-for-res_counter_charge_nofail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: rescounter: remove __must_check from res_counter_charge_nofail()

Since we will succeed with the allocation no matter what, there isn't a
need to use __must_check with it.  It can very well be optional.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/res_counter.h~remove-__must_check-for-res_counter_charge_nofail include/linux/res_counter.h
--- a/include/linux/res_counter.h~remove-__must_check-for-res_counter_charge_nofail
+++ a/include/linux/res_counter.h
@@ -119,7 +119,7 @@ int __must_check res_counter_charge_lock
 					   unsigned long val, bool force);
 int __must_check res_counter_charge(struct res_counter *counter,
 		unsigned long val, struct res_counter **limit_fail_at);
-int __must_check res_counter_charge_nofail(struct res_counter *counter,
+int res_counter_charge_nofail(struct res_counter *counter,
 		unsigned long val, struct res_counter **limit_fail_at);
 
 /*
_
Subject: Subject: rescounter: remove __must_check from res_counter_charge_nofail()

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

