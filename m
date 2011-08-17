From: akpm@linux-foundation.org
Subject: + memcg-replace-ss-id_lock-with-a-rwlock.patch added to -mm tree
Date: Wed, 17 Aug 2011 15:59:17 -0700
Message-ID: <201108172259.p7HMxHwf001630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184Ab1HQW70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 18:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: abrestic@google.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@gmail.com, yinghan@google.com


The patch titled
     memcg: replace ss->id_lock with a rwlock
has been added to the -mm tree.  Its filename is
     memcg-replace-ss-id_lock-with-a-rwlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: replace ss->id_lock with a rwlock
From: Andrew Bresticker <abrestic@google.com>

While back-porting Johannes Weiner's patch "mm: memcg-aware global
reclaim" for an internal effort, we noticed a significant performance
regression during page-reclaim heavy workloads due to high contention of
the ss->id_lock.  This lock protects idr map, and serializes calls to
idr_get_next() in css_get_next() (which is used during the memcg hierarchy
walk).  Since idr_get_next() is just doing a look up, we need only
serialize it with respect to idr_remove()/idr_get_new().  By making the
ss->id_lock a rwlock, contention is greatly reduced and performance
improves.

Tested: cat a 256m file from a ramdisk in a 128m container 50 times on
each core (one file + container per core) in parallel on a NUMA machine. 
Result is the time for the test to complete in 1 of the containers.  Both
kernels included Johannes' memcg-aware global reclaim patches.

Before rwlock patch: 1710.778s
After rwlock patch: 152.227s

Signed-off-by: Andrew Bresticker <abrestic@google.com>
Cc: Paul Menage <menage@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    2 +-
 kernel/cgroup.c        |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/cgroup.h~memcg-replace-ss-id_lock-with-a-rwlock include/linux/cgroup.h
--- a/include/linux/cgroup.h~memcg-replace-ss-id_lock-with-a-rwlock
+++ a/include/linux/cgroup.h
@@ -516,7 +516,7 @@ struct cgroup_subsys {
 	struct list_head sibling;
 	/* used when use_id == true */
 	struct idr idr;
-	spinlock_t id_lock;
+	rwlock_t id_lock;
 
 	/* should be defined only by modular subsystems */
 	struct module *module;
diff -puN kernel/cgroup.c~memcg-replace-ss-id_lock-with-a-rwlock kernel/cgroup.c
--- a/kernel/cgroup.c~memcg-replace-ss-id_lock-with-a-rwlock
+++ a/kernel/cgroup.c
@@ -4880,9 +4880,9 @@ void free_css_id(struct cgroup_subsys *s
 
 	rcu_assign_pointer(id->css, NULL);
 	rcu_assign_pointer(css->id, NULL);
-	spin_lock(&ss->id_lock);
+	write_lock(&ss->id_lock);
 	idr_remove(&ss->idr, id->id);
-	spin_unlock(&ss->id_lock);
+	write_unlock(&ss->id_lock);
 	kfree_rcu(id, rcu_head);
 }
 EXPORT_SYMBOL_GPL(free_css_id);
@@ -4908,10 +4908,10 @@ static struct css_id *get_new_cssid(stru
 		error = -ENOMEM;
 		goto err_out;
 	}
-	spin_lock(&ss->id_lock);
+	write_lock(&ss->id_lock);
 	/* Don't use 0. allocates an ID of 1-65535 */
 	error = idr_get_new_above(&ss->idr, newid, 1, &myid);
-	spin_unlock(&ss->id_lock);
+	write_unlock(&ss->id_lock);
 
 	/* Returns error when there are no free spaces for new ID.*/
 	if (error) {
@@ -4926,9 +4926,9 @@ static struct css_id *get_new_cssid(stru
 	return newid;
 remove_idr:
 	error = -ENOSPC;
-	spin_lock(&ss->id_lock);
+	write_lock(&ss->id_lock);
 	idr_remove(&ss->idr, myid);
-	spin_unlock(&ss->id_lock);
+	write_unlock(&ss->id_lock);
 err_out:
 	kfree(newid);
 	return ERR_PTR(error);
@@ -4940,7 +4940,7 @@ static int __init_or_module cgroup_init_
 {
 	struct css_id *newid;
 
-	spin_lock_init(&ss->id_lock);
+	rwlock_init(&ss->id_lock);
 	idr_init(&ss->idr);
 
 	newid = get_new_cssid(ss, 0);
@@ -5035,9 +5035,9 @@ css_get_next(struct cgroup_subsys *ss, i
 		 * scan next entry from bitmap(tree), tmpid is updated after
 		 * idr_get_next().
 		 */
-		spin_lock(&ss->id_lock);
+		read_lock(&ss->id_lock);
 		tmp = idr_get_next(&ss->idr, &tmpid);
-		spin_unlock(&ss->id_lock);
+		read_unlock(&ss->id_lock);
 
 		if (!tmp)
 			break;
_

Patches currently in -mm which might be from abrestic@google.com are

memcg-replace-ss-id_lock-with-a-rwlock.patch

