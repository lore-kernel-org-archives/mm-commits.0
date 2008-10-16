From: akpm@linux-foundation.org
Subject: + mm-extract-do_pages_move-out-of-sys_move_pages.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:47:38 -0700
Message-ID: <200810162047.m9GKlcAp017232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbYJPUro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Brice.Goglin@inria.fr, cl@linux-foundation.org, nickpiggin@yahoo.com.au


The patch titled
     mm: extract do_pages_move() out of sys_move_pages()
has been added to the -mm tree.  Its filename is
     mm-extract-do_pages_move-out-of-sys_move_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: extract do_pages_move() out of sys_move_pages()
From: Brice Goglin <Brice.Goglin@inria.fr>

To prepare the chunking, move the sys_move_pages() code that is used when
nodes!=NULL into do_pages_move().  And rename do_move_pages() into
do_move_page_to_node_array().

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  152 +++++++++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 66 deletions(-)

diff -puN mm/migrate.c~mm-extract-do_pages_move-out-of-sys_move_pages mm/migrate.c
--- a/mm/migrate.c~mm-extract-do_pages_move-out-of-sys_move_pages
+++ a/mm/migrate.c
@@ -826,9 +826,11 @@ static struct page *new_page_node(struct
  * Move a set of pages as indicated in the pm array. The addr
  * field must be set to the virtual address of the page to be moved
  * and the node number must contain a valid target node.
+ * The pm array ends with node = MAX_NUMNODES.
  */
-static int do_move_pages(struct mm_struct *mm, struct page_to_node *pm,
-				int migrate_all)
+static int do_move_page_to_node_array(struct mm_struct *mm,
+				      struct page_to_node *pm,
+				      int migrate_all)
 {
 	int err;
 	struct page_to_node *pp;
@@ -906,6 +908,81 @@ set_status:
 }
 
 /*
+ * Migrate an array of page address onto an array of nodes and fill
+ * the corresponding array of status.
+ */
+static int do_pages_move(struct mm_struct *mm, struct task_struct *task,
+			 unsigned long nr_pages,
+			 const void __user * __user *pages,
+			 const int __user *nodes,
+			 int __user *status, int flags)
+{
+	struct page_to_node *pm = NULL;
+	nodemask_t task_nodes;
+	int err = 0;
+	int i;
+
+	task_nodes = cpuset_mems_allowed(task);
+
+	/* Limit nr_pages so that the multiplication may not overflow */
+	if (nr_pages >= ULONG_MAX / sizeof(struct page_to_node) - 1) {
+		err = -E2BIG;
+		goto out;
+	}
+
+	pm = vmalloc((nr_pages + 1) * sizeof(struct page_to_node));
+	if (!pm) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * Get parameters from user space and initialize the pm
+	 * array. Return various errors if the user did something wrong.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		const void __user *p;
+
+		err = -EFAULT;
+		if (get_user(p, pages + i))
+			goto out_pm;
+
+		pm[i].addr = (unsigned long)p;
+		if (nodes) {
+			int node;
+
+			if (get_user(node, nodes + i))
+				goto out_pm;
+
+			err = -ENODEV;
+			if (!node_state(node, N_HIGH_MEMORY))
+				goto out_pm;
+
+			err = -EACCES;
+			if (!node_isset(node, task_nodes))
+				goto out_pm;
+
+			pm[i].node = node;
+		} else
+			pm[i].node = 0;	/* anything to not match MAX_NUMNODES */
+	}
+	/* End marker */
+	pm[nr_pages].node = MAX_NUMNODES;
+
+	err = do_move_page_to_node_array(mm, pm, flags & MPOL_MF_MOVE_ALL);
+	if (err >= 0)
+		/* Return status information */
+		for (i = 0; i < nr_pages; i++)
+			if (put_user(pm[i].status, status + i))
+				err = -EFAULT;
+
+out_pm:
+	vfree(pm);
+out:
+	return err;
+}
+
+/*
  * Determine the nodes of an array of pages and store it in an array of status.
  */
 static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
@@ -963,12 +1040,9 @@ asmlinkage long sys_move_pages(pid_t pid
 			const int __user *nodes,
 			int __user *status, int flags)
 {
-	int err = 0;
-	int i;
 	struct task_struct *task;
-	nodemask_t task_nodes;
 	struct mm_struct *mm;
-	struct page_to_node *pm = NULL;
+	int err;
 
 	/* Check flags */
 	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
@@ -1000,75 +1074,21 @@ asmlinkage long sys_move_pages(pid_t pid
 	    (current->uid != task->suid) && (current->uid != task->uid) &&
 	    !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
-		goto out2;
+		goto out;
 	}
 
  	err = security_task_movememory(task);
  	if (err)
- 		goto out2;
+		goto out;
 
-	if (!nodes) {
+	if (nodes) {
+		err = do_pages_move(mm, task, nr_pages, pages, nodes, status,
+				    flags);
+	} else {
 		err = do_pages_stat(mm, nr_pages, pages, status);
-		goto out2;
-	}
-
-	task_nodes = cpuset_mems_allowed(task);
-
-	/* Limit nr_pages so that the multiplication may not overflow */
-	if (nr_pages >= ULONG_MAX / sizeof(struct page_to_node) - 1) {
-		err = -E2BIG;
-		goto out2;
 	}
 
-	pm = vmalloc((nr_pages + 1) * sizeof(struct page_to_node));
-	if (!pm) {
-		err = -ENOMEM;
-		goto out2;
-	}
-
-	/*
-	 * Get parameters from user space and initialize the pm
-	 * array. Return various errors if the user did something wrong.
-	 */
-	for (i = 0; i < nr_pages; i++) {
-		const void __user *p;
-
-		err = -EFAULT;
-		if (get_user(p, pages + i))
-			goto out;
-
-		pm[i].addr = (unsigned long)p;
-		if (nodes) {
-			int node;
-
-			if (get_user(node, nodes + i))
-				goto out;
-
-			err = -ENODEV;
-			if (!node_state(node, N_HIGH_MEMORY))
-				goto out;
-
-			err = -EACCES;
-			if (!node_isset(node, task_nodes))
-				goto out;
-
-			pm[i].node = node;
-		} else
-			pm[i].node = 0;	/* anything to not match MAX_NUMNODES */
-	}
-	/* End marker */
-	pm[nr_pages].node = MAX_NUMNODES;
-
-	err = do_move_pages(mm, pm, flags & MPOL_MF_MOVE_ALL);
-	if (err >= 0)
-		/* Return status information */
-		for (i = 0; i < nr_pages; i++)
-			if (put_user(pm[i].status, status + i))
-				err = -EFAULT;
