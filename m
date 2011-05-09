From: akpm@linux-foundation.org
Subject: [to-be-updated] proc-make-struct-proc_maps_private-truly-private.patch removed from -mm tree
Date: Mon, 09 May 2011 13:07:47 -0700
Message-ID: <201105092007.p49K7lCI014941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab1EIUHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 16:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     proc: make struct proc_maps_private truly private
has been removed from the -mm tree.  Its filename was
     proc-make-struct-proc_maps_private-truly-private.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: make struct proc_maps_private truly private
From: Stephen Wilson <wilsons@start.ca>

Now that mm/mempolicy.c is no longer implementing /proc/pid/numa_maps
there is no need to export struct proc_maps_private to the world.  Move it
to fs/proc/internal.h instead.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h      |    8 ++++++++
 include/linux/proc_fs.h |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/proc/internal.h~proc-make-struct-proc_maps_private-truly-private fs/proc/internal.h
--- a/fs/proc/internal.h~proc-make-struct-proc_maps_private-truly-private
+++ a/fs/proc/internal.h
@@ -119,3 +119,11 @@ struct inode *proc_get_inode(struct supe
  */
 int proc_readdir(struct file *, void *, filldir_t);
 struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
+
+struct proc_maps_private {
+	struct pid *pid;
+	struct task_struct *task;
+#ifdef CONFIG_MMU
+	struct vm_area_struct *tail_vma;
+#endif
+};
diff -puN include/linux/proc_fs.h~proc-make-struct-proc_maps_private-truly-private include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-make-struct-proc_maps_private-truly-private
+++ a/include/linux/proc_fs.h
@@ -286,12 +286,4 @@ static inline struct net *PDE_NET(struct
 	return pde->parent->data;
 }
 
-struct proc_maps_private {
-	struct pid *pid;
-	struct task_struct *task;
-#ifdef CONFIG_MMU
-	struct vm_area_struct *tail_vma;
-#endif
-};
