From: akpm@linux-foundation.org
Subject: [merged] rescounters-add-res_counter_uncharge_until.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:42 -0700
Message-ID: <20120531191742.B3F46A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42498 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:43 -0400
Received: by yhgm50 with SMTP id m50so146859yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@redhat.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rescounters: add res_counter_uncharge_until()
has been removed from the -mm tree.  Its filename was
     rescounters-add-res_counter_uncharge_until.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: rescounters: add res_counter_uncharge_until()

When killing a res_counter which is a child of other counter, we need to
do

	res_counter_uncharge(child, xxx)
	res_counter_charge(parent, xxx)

This is not atomic and wastes CPU.  This patch adds
res_counter_uncharge_until().  This function's uncharge propagates to
ancestors until specified res_counter.

	res_counter_uncharge_until(child, parent, xxx)

Now the operation is atomic and efficient.

Signed-off-by: Frederic Weisbecker <fweisbec@redhat.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/resource_counter.txt |    8 ++++++++
 include/linux/res_counter.h                |    3 +++
 kernel/res_counter.c                       |   10 ++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/resource_counter.txt~rescounters-add-res_counter_uncharge_until Documentation/cgroups/resource_counter.txt
--- a/Documentation/cgroups/resource_counter.txt~rescounters-add-res_counter_uncharge_until
+++ a/Documentation/cgroups/resource_counter.txt
@@ -92,6 +92,14 @@ to work with it.
 
 	The _locked routines imply that the res_counter->lock is taken.
 
+ f. void res_counter_uncharge_until
+		(struct res_counter *rc, struct res_counter *top,
+		 unsinged long val)
+
+	Almost same as res_cunter_uncharge() but propagation of uncharge
+	stops when rc == top. This is useful when kill a res_coutner in
+	child cgroup.
+
  2.1 Other accounting routines
 
     There are more routines that may help you with common needs, like
diff -puN include/linux/res_counter.h~rescounters-add-res_counter_uncharge_until include/linux/res_counter.h
--- a/include/linux/res_counter.h~rescounters-add-res_counter_uncharge_until
+++ a/include/linux/res_counter.h
@@ -135,6 +135,9 @@ int __must_check res_counter_charge_nofa
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
 void res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
+void res_counter_uncharge_until(struct res_counter *counter,
+				struct res_counter *top,
+				unsigned long val);
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff -puN kernel/res_counter.c~rescounters-add-res_counter_uncharge_until kernel/res_counter.c
--- a/kernel/res_counter.c~rescounters-add-res_counter_uncharge_until
+++ a/kernel/res_counter.c
@@ -94,13 +94,15 @@ void res_counter_uncharge_locked(struct 
 	counter->usage -= val;
 }
 
-void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+void res_counter_uncharge_until(struct res_counter *counter,
+				struct res_counter *top,
+				unsigned long val)
 {
 	unsigned long flags;
 	struct res_counter *c;
 
 	local_irq_save(flags);
-	for (c = counter; c != NULL; c = c->parent) {
+	for (c = counter; c != top; c = c->parent) {
 		spin_lock(&c->lock);
 		res_counter_uncharge_locked(c, val);
 		spin_unlock(&c->lock);
@@ -108,6 +110,10 @@ void res_counter_uncharge(struct res_cou
 	local_irq_restore(flags);
 }
 
+void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+{
+	res_counter_uncharge_until(counter, NULL, val);
+}
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch
locking-add-kern_cont-when-needed-to-self-test.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
tools-selftests-add-mq_perf_tests.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

