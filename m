From: akpm@linux-foundation.org
Subject: + proc-make-struct-proc_maps_private-truly-private.patch added to -mm tree
Date: Wed, 04 May 2011 16:10:43 -0700
Message-ID: <201105042310.p44NAh8U020321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932098Ab1EDXKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 19:10:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com


The patch titled
     proc: make struct proc_maps_private truly private
has been added to the -mm tree.  Its filename is
     proc-make-struct-proc_maps_private-truly-private.patch

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
