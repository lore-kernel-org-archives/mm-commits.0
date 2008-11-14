From: akpm@linux-foundation.org
Subject: + cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch added to -mm tree
Date: Thu, 13 Nov 2008 16:56:20 -0800
Message-ID: <200811140056.mAE0uKVZ002581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbYKNA5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 19:57:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     cgroup: fix potential deadlock in pre_destroy
has been added to the -mm tree.  Its filename is
     cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch

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
Subject: cgroup: fix potential deadlock in pre_destroy
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

As Balbir pointed out, memcg's pre_destroy handler has potential deadlock.

It has following lock sequence.

	cgroup_mutex (cgroup_rmdir)
	    -> pre_destroy -> mem_cgroup_pre_destroy-> force_empty
		-> cpu_hotplug.lock. (lru_add_drain_all->
				      schedule_work->
                                      get_online_cpus)

But, cpuset has following.
	cpu_hotplug.lock (call notifier)
		-> cgroup_mutex. (within notifier)

Then, this lock sequence should be fixed.

Considering how pre_destroy works, it's not necessary to holding
cgroup_mutex() while calling it.

As a side effect, we don't have to wait at this mutex while memcg's
force_empty works.(it can be long when there are tons of pages.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN kernel/cgroup.c~cgroup-fix-potential-deadlock-in-pre_destroy-v2 kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-potential-deadlock-in-pre_destroy-v2
+++ a/kernel/cgroup.c
@@ -2472,10 +2472,7 @@ static int cgroup_rmdir(struct inode *un
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-
-	parent = cgrp->parent;
-	root = cgrp->root;
-	sb = root->sb;
+	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * Call pre_destroy handlers of subsys. Notify subsystems
@@ -2483,7 +2480,14 @@ static int cgroup_rmdir(struct inode *un
 	 */
 	cgroup_call_pre_destroy(cgrp);
 
-	if (cgroup_has_css_refs(cgrp)) {
+	mutex_lock(&cgroup_mutex);
+	parent = cgrp->parent;
+	root = cgrp->root;
+	sb = root->sb;
+
+	if (atomic_read(&cgrp->count)
+	    || !list_empty(&cgrp->children)
+	    || cgroup_has_css_refs(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch

