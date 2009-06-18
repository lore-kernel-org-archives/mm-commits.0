From: akpm@linux-foundation.org
Subject: [merged] fs-remove-sparse-errors-in-proc_devtreec.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:43:54 -0700
Message-ID: <200906182243.n5IMhs77002943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbZFRWny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:43:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: monstr@monstr.eu, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     procfs: remove sparse errors in proc_devtree.c
has been removed from the -mm tree.  Its filename was
     fs-remove-sparse-errors-in-proc_devtreec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: remove sparse errors in proc_devtree.c
From: Michal Simek <monstr@monstr.eu>

  CHECK   fs/proc/proc_devtree.c
fs/proc/proc_devtree.c:197:14: warning: Using plain integer as NULL pointer
fs/proc/proc_devtree.c:203:34: warning: Using plain integer as NULL pointer
fs/proc/proc_devtree.c:210:14: warning: Using plain integer as NULL pointer
fs/proc/proc_devtree.c:223:26: warning: Using plain integer as NULL pointer
fs/proc/proc_devtree.c:226:14: warning: Using plain integer as NULL pointer

Signed-off-by: Michal Simek <monstr@monstr.eu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_devtree.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/proc_devtree.c~fs-remove-sparse-errors-in-proc_devtreec fs/proc/proc_devtree.c
--- a/fs/proc/proc_devtree.c~fs-remove-sparse-errors-in-proc_devtreec
+++ a/fs/proc/proc_devtree.c
@@ -195,20 +195,20 @@ void proc_device_tree_add_node(struct de
 			p = fixup_name(np, de, p);
 
 		ent = proc_mkdir(p, de);
-		if (ent == 0)
+		if (ent == NULL)
 			break;
 		proc_device_tree_add_node(child, ent);
 	}
 	of_node_put(child);
 
-	for (pp = np->properties; pp != 0; pp = pp->next) {
+	for (pp = np->properties; pp != NULL; pp = pp->next) {
 		p = pp->name;
 
 		if (duplicate_name(de, p))
 			p = fixup_name(np, de, p);
 
 		ent = __proc_device_tree_add_prop(de, pp, p);
-		if (ent == 0)
+		if (ent == NULL)
 			break;
 	}
 }
@@ -221,10 +221,10 @@ void __init proc_device_tree_init(void)
 	struct device_node *root;
 
 	proc_device_tree = proc_mkdir("device-tree", NULL);
-	if (proc_device_tree == 0)
+	if (proc_device_tree == NULL)
 		return;
 	root = of_find_node_by_path("/");
-	if (root == 0) {
+	if (root == NULL) {
 		printk(KERN_ERR "/proc/device-tree: can't find root\n");
 		return;
 	}
_

Patches currently in -mm which might be from monstr@monstr.eu are

origin.patch

