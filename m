From: akpm@linux-foundation.org
Subject: [merged] cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:32:49 -0700
Message-ID: <201103232036.p2NKaPet028120__31814.1671400101$1300912990$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933404Ab1CWUmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-phil.2.carmody@nokia.com, kirill@shutemov.name, lizf@cn.fujitsu.com, menage@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: if you list_empty() a head then don't list_del() it
has been removed from the -mm tree.  Its filename was
     cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: if you list_empty() a head then don't list_del() it
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

list_del() leaves poison in the prev and next pointers.  The next
list_empty() will compare those poisons, and say the list isn't empty. 
Any list operations that assume the node is on a list because of such a
check will be fooled into dereferencing poison.  One needs to INIT the
node after the del, and fortunately there's already a wrapper for that -
list_del_init().

Some of the dels are followed by deallocations, so can be ignored, and one
can be merged with an add to make a move.  Apart from that, I erred on the
side of caution in making nodes list_empty()-queriable.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/cgroup.c~cgroups-if-you-list_empty-a-head-then-dont-list_del-it kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-if-you-list_empty-a-head-then-dont-list_del-it
+++ a/kernel/cgroup.c
@@ -1813,10 +1813,8 @@ int cgroup_attach_task(struct cgroup *cg
 
 	/* Update the css_set linked lists if we're using them */
 	write_lock(&css_set_lock);
-	if (!list_empty(&tsk->cg_list)) {
-		list_del(&tsk->cg_list);
-		list_add(&tsk->cg_list, &newcg->tasks);
-	}
+	if (!list_empty(&tsk->cg_list))
+		list_move(&tsk->cg_list, &newcg->tasks);
 	write_unlock(&css_set_lock);
 
 	for_each_subsys(root, ss) {
@@ -3655,12 +3653,12 @@ again:
 	spin_lock(&release_list_lock);
 	set_bit(CGRP_REMOVED, &cgrp->flags);
 	if (!list_empty(&cgrp->release_list))
-		list_del(&cgrp->release_list);
+		list_del_init(&cgrp->release_list);
 	spin_unlock(&release_list_lock);
 
 	cgroup_lock_hierarchy(cgrp->root);
 	/* delete this cgroup from parent->children */
-	list_del(&cgrp->sibling);
+	list_del_init(&cgrp->sibling);
 	cgroup_unlock_hierarchy(cgrp->root);
 
 	d = dget(cgrp->dentry);
@@ -3879,7 +3877,7 @@ void cgroup_unload_subsys(struct cgroup_
 	subsys[ss->subsys_id] = NULL;
 
 	/* remove subsystem from rootnode's list of subsystems */
-	list_del(&ss->sibling);
+	list_del_init(&ss->sibling);
 
 	/*
 	 * disentangle the css from all css_sets attached to the dummytop. as
@@ -4241,7 +4239,7 @@ void cgroup_exit(struct task_struct *tsk
 	if (!list_empty(&tsk->cg_list)) {
 		write_lock(&css_set_lock);
 		if (!list_empty(&tsk->cg_list))
-			list_del(&tsk->cg_list);
+			list_del_init(&tsk->cg_list);
 		write_unlock(&css_set_lock);
 	}
 
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

origin.patch
linux-next.patch

