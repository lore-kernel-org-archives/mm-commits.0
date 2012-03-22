From: akpm@linux-foundation.org
Subject: [merged] memcg-let-css_get_next-rely-upon-rcu_read_lock.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:44 -0700
Message-ID: <20120322201944.702DFA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61078 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab2CVUTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:45 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so401674yen.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, eric.dumazet@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: let css_get_next() rely upon rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     memcg-let-css_get_next-rely-upon-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: let css_get_next() rely upon rcu_read_lock()

Remove lock and unlock around css_get_next()'s call to idr_get_next(). 
memcg iterators (only users of css_get_next) already did rcu_read_lock(),
and its comment demands that; but add a WARN_ON_ONCE to make sure of it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/cgroup.c~memcg-let-css_get_next-rely-upon-rcu_read_lock kernel/cgroup.c
--- a/kernel/cgroup.c~memcg-let-css_get_next-rely-upon-rcu_read_lock
+++ a/kernel/cgroup.c
@@ -5033,6 +5033,8 @@ css_get_next(struct cgroup_subsys *ss, i
 		return NULL;
 
 	BUG_ON(!ss->use_id);
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
 	/* fill start point for scan */
 	tmpid = id;
 	while (1) {
@@ -5040,10 +5042,7 @@ css_get_next(struct cgroup_subsys *ss, i
 		 * scan next entry from bitmap(tree), tmpid is updated after
 		 * idr_get_next().
 		 */
-		spin_lock(&ss->id_lock);
 		tmp = idr_get_next(&ss->idr, &tmpid);
-		spin_unlock(&ss->id_lock);
