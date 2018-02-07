From: akpm@linux-foundation.org
Subject: [merged] proc-rearrange-args.patch removed from -mm tree
Date: Wed, 07 Feb 2018 11:56:21 -0800
Message-ID: <20180207195621.XRvYX7AGy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754154AbeBGT4W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:56:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: rearrange args
has been removed from the -mm tree.  Its filename was
     proc-rearrange-args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: rearrange args

Rearrange args for smaller code.

lookup revolves around memcmp() which gets len 3rd arg, so propagate
length as 3rd arg.

readdir and lookup add additional arg to VFS ->readdir and ->lookup, so
better add it to the end.

Space savings on x86_64:

	add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-18 (-18)
	Function                                     old     new   delta
	proc_readdir                                  22      13      -9
	proc_lookup                                   18       9      -9

proc_match() is smaller if not inlined, I promise!

Link: http://lkml.kernel.org/r/20180104175958.GB5204@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |   18 +++++++++---------
 fs/proc/internal.h |    5 ++---
 fs/proc/proc_net.c |    4 ++--
 3 files changed, 13 insertions(+), 14 deletions(-)

diff -puN fs/proc/generic.c~proc-rearrange-args fs/proc/generic.c
--- a/fs/proc/generic.c~proc-rearrange-args
+++ a/fs/proc/generic.c
@@ -28,7 +28,7 @@
 
 static DEFINE_RWLOCK(proc_subdir_lock);
 
-static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
+static int proc_match(const char *name, struct proc_dir_entry *de, unsigned int len)
 {
 	if (len < de->namelen)
 		return -1;
@@ -60,7 +60,7 @@ static struct proc_dir_entry *pde_subdir
 		struct proc_dir_entry *de = rb_entry(node,
 						     struct proc_dir_entry,
 						     subdir_node);
-		int result = proc_match(len, name, de);
+		int result = proc_match(name, de, len);
 
 		if (result < 0)
 			node = node->rb_left;
@@ -84,7 +84,7 @@ static bool pde_subdir_insert(struct pro
 		struct proc_dir_entry *this = rb_entry(*new,
 						       struct proc_dir_entry,
 						       subdir_node);
-		int result = proc_match(de->namelen, de->name, this);
+		int result = proc_match(de->name, this, de->namelen);
 
 		parent = *new;
 		if (result < 0)
@@ -211,8 +211,8 @@ void proc_free_inum(unsigned int inum)
  * Don't create negative dentries here, return -ENOENT by hand
  * instead.
  */
-struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
-		struct dentry *dentry)
+struct dentry *proc_lookup_de(struct inode *dir, struct dentry *dentry,
+			      struct proc_dir_entry *de)
 {
 	struct inode *inode;
 
@@ -235,7 +235,7 @@ struct dentry *proc_lookup_de(struct pro
 struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
 		unsigned int flags)
 {
-	return proc_lookup_de(PDE(dir), dir, dentry);
+	return proc_lookup_de(dir, dentry, PDE(dir));
 }
 
 /*
@@ -247,8 +247,8 @@ struct dentry *proc_lookup(struct inode
  * value of the readdir() call, as long as it's non-negative
  * for success..
  */
-int proc_readdir_de(struct proc_dir_entry *de, struct file *file,
-		    struct dir_context *ctx)
+int proc_readdir_de(struct file *file, struct dir_context *ctx,
+		    struct proc_dir_entry *de)
 {
 	int i;
 
@@ -292,7 +292,7 @@ int proc_readdir(struct file *file, stru
 {
 	struct inode *inode = file_inode(file);
 
-	return proc_readdir_de(PDE(inode), file, ctx);
+	return proc_readdir_de(file, ctx, PDE(inode));
 }
 
 /*
diff -puN fs/proc/internal.h~proc-rearrange-args fs/proc/internal.h
--- a/fs/proc/internal.h~proc-rearrange-args
+++ a/fs/proc/internal.h
@@ -153,10 +153,9 @@ extern bool proc_fill_cache(struct file
  * generic.c
  */
 extern struct dentry *proc_lookup(struct inode *, struct dentry *, unsigned int);
-extern struct dentry *proc_lookup_de(struct proc_dir_entry *, struct inode *,
-				     struct dentry *);
+struct dentry *proc_lookup_de(struct inode *, struct dentry *, struct proc_dir_entry *);
 extern int proc_readdir(struct file *, struct dir_context *);
-extern int proc_readdir_de(struct proc_dir_entry *, struct file *, struct dir_context *);
+int proc_readdir_de(struct file *, struct dir_context *, struct proc_dir_entry *);
 
 static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 {
diff -puN fs/proc/proc_net.c~proc-rearrange-args fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~proc-rearrange-args
+++ a/fs/proc/proc_net.c
@@ -135,7 +135,7 @@ static struct dentry *proc_tgid_net_look
 	de = ERR_PTR(-ENOENT);
 	net = get_proc_task_net(dir);
 	if (net != NULL) {
-		de = proc_lookup_de(net->proc_net, dir, dentry);
+		de = proc_lookup_de(dir, dentry, net->proc_net);
 		put_net(net);
 	}
 	return de;
@@ -172,7 +172,7 @@ static int proc_tgid_net_readdir(struct
 	ret = -EINVAL;
 	net = get_proc_task_net(file_inode(file));
 	if (net != NULL) {
-		ret = proc_readdir_de(net->proc_net, file, ctx);
+		ret = proc_readdir_de(file, ctx, net->proc_net);
 		put_net(net);
 	}
 	return ret;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-delete-small-value-optimization.patch

