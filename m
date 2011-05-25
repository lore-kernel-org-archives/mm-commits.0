From: akpm@linux-foundation.org
Subject: [merged] proc-make-struct-proc_maps_private-truly-private.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:25 -0700
Message-ID: <201105252028.p4PKSmKx014778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab1EYU30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     proc: make struct proc_maps_private truly private
has been removed from the -mm tree.  Its filename was
     proc-make-struct-proc_maps_private-truly-private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: make struct proc_maps_private truly private
From: Stephen Wilson <wilsons@start.ca>

Now that mm/mempolicy.c is no longer implementing /proc/pid/numa_maps
there is no need to export struct proc_maps_private to the world.  Move it
to fs/proc/internal.h instead.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h      |    9 +++++++++
 include/linux/proc_fs.h |    8 --------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/proc/internal.h~proc-make-struct-proc_maps_private-truly-private fs/proc/internal.h
--- a/fs/proc/internal.h~proc-make-struct-proc_maps_private-truly-private
+++ a/fs/proc/internal.h
@@ -61,6 +61,14 @@ extern const struct file_operations proc
 extern const struct file_operations proc_net_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
+struct proc_maps_private {
+	struct pid *pid;
+	struct task_struct *task;
+#ifdef CONFIG_MMU
+	struct vm_area_struct *tail_vma;
+#endif
+};
+
 void proc_init_inodecache(void);
 
 static inline struct pid *proc_pid(struct inode *inode)
@@ -119,3 +127,4 @@ struct inode *proc_get_inode(struct supe
  */
 int proc_readdir(struct file *, void *, filldir_t);
 struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
+
diff -puN include/linux/proc_fs.h~proc-make-struct-proc_maps_private-truly-private include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-make-struct-proc_maps_private-truly-private
+++ a/include/linux/proc_fs.h
@@ -288,12 +288,4 @@ static inline struct net *PDE_NET(struct
 	return pde->parent->data;
 }
 
-struct proc_maps_private {
-	struct pid *pid;
-	struct task_struct *task;
-#ifdef CONFIG_MMU
-	struct vm_area_struct *tail_vma;
-#endif
-};
