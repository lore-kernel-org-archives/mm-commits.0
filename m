From: akpm@linux-foundation.org
Subject: + cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch added to -mm tree
Date: Tue, 15 Mar 2011 13:42:49 -0700
Message-ID: <201103152042.p2FKgocX010224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758301Ab1COUnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 16:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com, kirill@shutemov.name, lizf@cn.fujitsu.com, menage@google.com, stable@kernel.org


The patch titled
     cgroups: if you list_empty() a head then don't list_del() it
has been added to the -mm tree.  Its filename is
     cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch

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
@@ -4253,7 +4251,7 @@ void cgroup_exit(struct task_struct *tsk
 	if (!list_empty(&tsk->cg_list)) {
 		write_lock(&css_set_lock);
 		if (!list_empty(&tsk->cg_list))
-			list_del(&tsk->cg_list);
+			list_del_init(&tsk->cg_list);
 		write_unlock(&css_set_lock);
 	}
 
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch
linux-next.patch
calibrate-extract-fall-back-calculation-into-own-helper.patch
calibrate-home-in-on-correct-lpj-value-more-quickly.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
listh-add-debug-version-of-list_empty.patch

