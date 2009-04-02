From: akpm@linux-foundation.org
Subject: [folded] cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:16:43 -0700
Message-ID: <200904022316.n32NGhqS009896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755179AbZDBXV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:21:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: remove rcu_read_lock() from css_get_next()
has been removed from the -mm tree.  Its filename was
     cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch

This patch was dropped because it was folded into cgroup-css-id-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: remove rcu_read_lock() from css_get_next()
From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Callers of css_get_next() are already calling css_get_next() under
rcu_read_lock() and hence there there is no need for css_get_next() to
re-acquire rcu_read_lock().  As per the comments in css_get_next(), let
the callers accquire the rcu_read_lock().

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/cgroup.c~cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next
+++ a/kernel/cgroup.c
@@ -3500,7 +3500,6 @@ css_get_next(struct cgroup_subsys *ss, i
 		return NULL;
 
 	BUG_ON(!ss->use_id);
-	rcu_read_lock();
 	/* fill start point for scan */
 	tmpid = id;
 	while (1) {
@@ -3524,8 +3523,6 @@ css_get_next(struct cgroup_subsys *ss, i
 		/* continue to scan from next id */
 		tmpid = tmpid + 1;
 	}
