From: akpm@linux-foundation.org
Subject: [merged] remove-__must_check-for-res_counter_charge_nofail.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:51 -0700
Message-ID: <20120531191751.7B5A1A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42498 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab2EaTRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:52 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so146859yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rescounter: remove __must_check from res_counter_charge_nofail()
has been removed from the -mm tree.  Its filename was
     remove-__must_check-for-res_counter_charge_nofail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Reviewed-by: Tejun Heo <tj@kernel.org>
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

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
slab-move-full-state-transition-to-an-initcall.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

