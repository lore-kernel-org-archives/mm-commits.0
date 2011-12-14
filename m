From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:28 -0800
Message-ID: <20111214200629.1705610004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38970 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:30 -0500
Received: by ghbf20 with SMTP id f20so133516ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: ability to stop res charge propagation on bounded ancestor
has been removed from the -mm tree.  Its filename was
     cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroups: ability to stop res charge propagation on bounded ancestor

Moving a task from a cgroup to another may require to substract its
resource charge from the old cgroup and add it to the new one.

For this to happen, the uncharge/charge propagation can just stop when we
reach the common ancestor for the two cgroups.  Further the performance
reasons, we also want to avoid to temporarily overload the common
ancestors with a non-accurate resource counter usage if we charge first
the new cgroup and uncharge the old one thereafter.  This is going to be a
requirement for the coming max number of task subsystem.

To solve this, provide a pair of new API that can charge/uncharge a
resource counter until we reach a given ancestor.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/resource_counter.txt |   18 ++++++++++++++++-
 include/linux/res_counter.h                |   20 ++++++++++++++++---
 kernel/res_counter.c                       |   13 +++++++-----
 3 files changed, 42 insertions(+), 9 deletions(-)

diff -puN Documentation/cgroups/resource_counter.txt~cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor Documentation/cgroups/resource_counter.txt
--- a/Documentation/cgroups/resource_counter.txt~cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor
+++ a/Documentation/cgroups/resource_counter.txt
@@ -83,7 +83,15 @@ to work with it.
 	res_counter->lock internally (it must be called with res_counter->lock
 	held).
 
- e. void res_counter_uncharge[_locked]
+ e. int res_counter_charge_until(struct res_counter *counter,
+			     struct res_counter *limit, unsigned long val,
+			     struct res_counter **limit_fail_at)
+
+	The same as res_counter_charge(), but the charge propagation to
+	the hierarchy stops at the limit given in the "limit" parameter.
+
+
+ f. void res_counter_uncharge[_locked]
 			(struct res_counter *rc, unsigned long val)
 
 	When a resource is released (freed) it should be de-accounted
@@ -92,6 +100,14 @@ to work with it.
 
 	The _locked routines imply that the res_counter->lock is taken.
 
+
+ g. void res_counter_uncharge_until(struct res_counter *counter,
+				struct res_counter *limit,
+				unsigned long val)
+
+	The same as res_counter_charge, but the uncharge propagation to
+	the hierarchy stops at the limit given in the "limit" parameter.
+
  2.1 Other accounting routines
 
     There are more routines that may help you with common needs, like
diff -puN include/linux/res_counter.h~cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor include/linux/res_counter.h
--- a/include/linux/res_counter.h~cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor
+++ a/include/linux/res_counter.h
@@ -117,8 +117,16 @@ void res_counter_init(struct res_counter
 
 int __must_check res_counter_charge_locked(struct res_counter *counter,
 		unsigned long val);
-int __must_check res_counter_charge(struct res_counter *counter,
-		unsigned long val, struct res_counter **limit_fail_at);
+int __must_check res_counter_charge_until(struct res_counter *counter,
+					  struct res_counter *limit,
+					  unsigned long val,
+					  struct res_counter **limit_fail_at);
+static inline int __must_check
+res_counter_charge(struct res_counter *counter, unsigned long val,
+		   struct res_counter **limit_fail_at)
+{
+	return res_counter_charge_until(counter, NULL, val, limit_fail_at);
+}
 
 /*
  * uncharge - tell that some portion of the resource is released
@@ -131,7 +139,13 @@ int __must_check res_counter_charge(stru
  */
 
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
-void res_counter_uncharge(struct res_counter *counter, unsigned long val);
+void res_counter_uncharge_until(struct res_counter *counter,
+				struct res_counter *limit, unsigned long val);
+static inline void res_counter_uncharge(struct res_counter *counter,
+					unsigned long val)
+{
+	res_counter_uncharge_until(counter, NULL, val);
+}
 
 /**
  * res_counter_margin - calculate chargeable space of a counter
diff -puN kernel/res_counter.c~cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor kernel/res_counter.c
--- a/kernel/res_counter.c~cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor
+++ a/kernel/res_counter.c
@@ -35,8 +35,9 @@ int res_counter_charge_locked(struct res
 	return 0;
 }
 
-int res_counter_charge(struct res_counter *counter, unsigned long val,
-			struct res_counter **limit_fail_at)
+int res_counter_charge_until(struct res_counter *counter,
+			     struct res_counter *limit, unsigned long val,
+			     struct res_counter **limit_fail_at)
 {
 	int ret;
 	unsigned long flags;
@@ -44,7 +45,7 @@ int res_counter_charge(struct res_counte
 
 	*limit_fail_at = NULL;
 	local_irq_save(flags);
-	for (c = counter; c != NULL; c = c->parent) {
+	for (c = counter; c != limit; c = c->parent) {
 		spin_lock(&c->lock);
 		ret = res_counter_charge_locked(c, val);
 		spin_unlock(&c->lock);
@@ -74,13 +75,15 @@ void res_counter_uncharge_locked(struct 
 	counter->usage -= val;
 }
 
-void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+void res_counter_uncharge_until(struct res_counter *counter,
+				struct res_counter *limit,
+				unsigned long val)
 {
 	unsigned long flags;
 	struct res_counter *c;
 
 	local_irq_save(flags);
-	for (c = counter; c != NULL; c = c->parent) {
+	for (c = counter; c != limit; c = c->parent) {
 		spin_lock(&c->lock);
 		res_counter_uncharge_locked(c, val);
 		spin_unlock(&c->lock);
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

