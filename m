From: akpm@linux-foundation.org
Subject: [merged] cgroups-clean-up-cgroup_pidlist_find-a-bit.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:38 -0400
Message-ID: <201003150659.o2F6xB5C016511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935031Ab0COG7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: clean up cgroup_pidlist_find() a bit
has been removed from the -mm tree.  Its filename was
     cgroups-clean-up-cgroup_pidlist_find-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: clean up cgroup_pidlist_find() a bit
From: Li Zefan <lizf@cn.fujitsu.com>

Don't call get_pid_ns() before we locate/alloc the ns.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN kernel/cgroup.c~cgroups-clean-up-cgroup_pidlist_find-a-bit kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-clean-up-cgroup_pidlist_find-a-bit
+++ a/kernel/cgroup.c
@@ -2597,7 +2597,8 @@ static struct cgroup_pidlist *cgroup_pid
 {
 	struct cgroup_pidlist *l;
 	/* don't need task_nsproxy() if we're looking at ourself */
-	struct pid_namespace *ns = get_pid_ns(current->nsproxy->pid_ns);
+	struct pid_namespace *ns = current->nsproxy->pid_ns;
+
 	/*
 	 * We can't drop the pidlist_mutex before taking the l->mutex in case
 	 * the last ref-holder is trying to remove l from the list at the same
@@ -2607,8 +2608,6 @@ static struct cgroup_pidlist *cgroup_pid
 	mutex_lock(&cgrp->pidlist_mutex);
 	list_for_each_entry(l, &cgrp->pidlists, links) {
 		if (l->key.type == type && l->key.ns == ns) {
-			/* found a matching list - drop the extra refcount */
-			put_pid_ns(ns);
 			/* make sure l doesn't vanish out from under us */
 			down_write(&l->mutex);
 			mutex_unlock(&cgrp->pidlist_mutex);
@@ -2619,13 +2618,12 @@ static struct cgroup_pidlist *cgroup_pid
 	l = kmalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
 	if (!l) {
 		mutex_unlock(&cgrp->pidlist_mutex);
-		put_pid_ns(ns);
 		return l;
 	}
 	init_rwsem(&l->mutex);
 	down_write(&l->mutex);
 	l->key.type = type;
-	l->key.ns = ns;
+	l->key.ns = get_pid_ns(ns);
 	l->use_count = 0; /* don't increment here */
 	l->list = NULL;
 	l->owner = cgrp;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
cgroups-net_cls-as-module.patch
sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path.patch

