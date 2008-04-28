From: akpm@linux-foundation.org
Subject: - mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:06 -0700
Message-ID: <200804282153.m3SLr6Rd017838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935026AbYD1Vx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: write lock mmap_sem while changing task mempolicy
has been removed from the -mm tree.  Its filename was
     mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: write lock mmap_sem while changing task mempolicy
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

A read of /proc/<pid>/numa_maps holds the target task's mmap_sem for read
while examining each vma's mempolicy.  A vma's mempolicy can fall back to the
task's policy.  However, the task could be changing it's task policy and free
the one that the show_numa_maps() is examining.

To prevent this, grab the mmap_sem for write when updating task mempolicy. 
Pointed out to me by Christoph Lameter and extracted and reworked from
Christoph's alternative mempol reference counting patch.

This is analogous to the way that do_mbind() and do_get_mempolicy() prevent
races between task's sharing an mm_struct [a.k.a.  threads] setting and
querying a mempolicy for a particular address.

Note: this is necessary, but not sufficient, to allow us to stop taking an
extra reference on "other task's mempolicy" in get_vma_policy.  Subsequent
patches will complete this update, allowing us to simplify the tests for
whether we need to unref a mempolicy at various points in the code.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/mempolicy.c~mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy
+++ a/mm/mempolicy.c
@@ -591,16 +591,29 @@ static long do_set_mempolicy(unsigned sh
 			     nodemask_t *nodes)
 {
 	struct mempolicy *new;
+	struct mm_struct *mm = current->mm;
 
 	new = mpol_new(mode, flags, nodes);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
+
+	/*
+	 * prevent changing our mempolicy while show_numa_maps()
+	 * is using it.
+	 * Note:  do_set_mempolicy() can be called at init time
+	 * with no 'mm'.
+	 */
+	if (mm)
+		down_write(&mm->mmap_sem);
 	mpol_put(current->mempolicy);
 	current->mempolicy = new;
 	mpol_set_task_struct_flag();
 	if (new && new->policy == MPOL_INTERLEAVE &&
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
+	if (mm)
+		up_write(&mm->mmap_sem);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

