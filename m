From: akpm@linux-foundation.org
Subject: + proc-make-struct-proc_maps_private-truly-private.patch added to -mm tree
Date: Wed, 18 May 2011 14:37:28 -0700
Message-ID: <201105182137.p4ILbS7I025441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605Ab1ERVhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:37:36 -0400
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
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h      |    7 +++++++
 include/linux/proc_fs.h |    8 --------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN fs/proc/internal.h~proc-make-struct-proc_maps_private-truly-private fs/proc/internal.h
--- a/fs/proc/internal.h~proc-make-struct-proc_maps_private-truly-private
+++ a/fs/proc/internal.h
@@ -137,3 +137,10 @@ int proc_setattr(struct dentry *dentry, 
 extern const struct inode_operations proc_ns_dir_inode_operations;
 extern const struct file_operations proc_ns_dir_operations;
 
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
@@ -309,12 +309,4 @@ static inline struct net *PDE_NET(struct
 	return pde->parent->data;
 }
 
-struct proc_maps_private {
-	struct pid *pid;
-	struct task_struct *task;
-#ifdef CONFIG_MMU
-	struct vm_area_struct *tail_vma;
-#endif
-};
