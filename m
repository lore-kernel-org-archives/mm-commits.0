From: akpm@linux-foundation.org
Subject: + fs-remove-sparse-errors-in-proc_devtreec.patch added to -mm tree
Date: Thu, 30 Apr 2009 15:01:49 -0700
Message-ID: <200904302201.n3UM1nMO012707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbZD3WDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 18:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: monstr@monstr.eu, adobriyan@gmail.com


The patch titled
     procfs: remove sparse errors in proc_devtree.c
has been added to the -mm tree.  Its filename is
     fs-remove-sparse-errors-in-proc_devtreec.patch

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

of-make-of_unregister_platform_driver-common-code.patch
fs-remove-sparse-errors-in-proc_devtreec.patch

