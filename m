From: akpm@linux-foundation.org
Subject: [merged] cgroups-use-hierarchy-mutex-in-creation-failure-path.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:43 -0800
Message-ID: <200901301913.n0UJDhIe026457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbZA3TOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: use hierarchy mutex in creation failure path
has been removed from the -mm tree.  Its filename was
     cgroups-use-hierarchy-mutex-in-creation-failure-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: use hierarchy mutex in creation failure path
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, cgrp->sibling is handled under hierarchy mutex.
error route should do so, too.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cgroup.c~cgroups-use-hierarchy-mutex-in-creation-failure-path kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-use-hierarchy-mutex-in-creation-failure-path
+++ a/kernel/cgroup.c
@@ -2434,7 +2434,9 @@ static long cgroup_create(struct cgroup 
 
  err_remove:
 
+	cgroup_lock_hierarchy(root);
 	list_del(&cgrp->sibling);
+	cgroup_unlock_hierarchy(root);
 	root->number_of_cgroups--;
 
  err_destroy:
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch

