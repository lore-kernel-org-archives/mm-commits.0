From: akpm@linux-foundation.org
Subject: [merged] proc-change-proc_subdir_lock-to-a-rwlock.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:11:34 -0700
Message-ID: <55f31956.XYB5ZF24SsGyVM+t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbIKSLf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Waiman.Long@hp.com, adobriyan@gmail.com, doug.hatch@hp.com, ebiederm@xmission.com, nicolas.dichtel@6wind.com, scott.norton@hp.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: change proc_subdir_lock to a rwlock
has been removed from the -mm tree.  Its filename was
     proc-change-proc_subdir_lock-to-a-rwlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <Waiman.Long@hp.com>
Subject: proc: change proc_subdir_lock to a rwlock

The proc_subdir_lock spinlock is used to allow only one task to make
change to the proc directory structure as well as looking up information
in it.  However, the information lookup part can actually be entered by
more than one task as the pde_get() and pde_put() reference count update
calls in the critical sections are atomic increment and decrement
respectively and so are safe with concurrent updates.

The x86 architecture has already used qrwlock which is fair and other
architectures like ARM are in the process of switching to qrwlock.  So
unfairness shouldn't be a concern in that conversion.

This patch changed the proc_subdir_lock to a rwlock in order to enable
concurrent lookup. The following functions were modified to take a
write lock:
 - proc_register()
 - remove_proc_entry()
 - remove_proc_subtree()

The following functions were modified to take a read lock:
 - xlate_proc_name()
 - proc_lookup_de()
 - proc_readdir_de()

A parallel /proc filesystem search with the "find" command (1000 threads)
was run on a 4-socket Haswell-EX box (144 threads).  Before the patch, the
parallel search took about 39s.  After the patch, the parallel find took
only 25s, a saving of about 14s.

The micro-benchmark that I used was artificial, but it was used to
reproduce an exit hanging problem that I saw in real application.  In
fact, only allow one task to do a lookup seems too limiting to me.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Douglas Hatch <doug.hatch@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN fs/proc/generic.c~proc-change-proc_subdir_lock-to-a-rwlock fs/proc/generic.c
--- a/fs/proc/generic.c~proc-change-proc_subdir_lock-to-a-rwlock
+++ a/fs/proc/generic.c
@@ -26,7 +26,7 @@
 
 #include "internal.h"
 
-static DEFINE_SPINLOCK(proc_subdir_lock);
+static DEFINE_RWLOCK(proc_subdir_lock);
 
 static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
 {
@@ -172,9 +172,9 @@ static int xlate_proc_name(const char *n
 {
 	int rv;
 
-	spin_lock(&proc_subdir_lock);
+	read_lock(&proc_subdir_lock);
 	rv = __xlate_proc_name(name, ret, residual);
-	spin_unlock(&proc_subdir_lock);
+	read_unlock(&proc_subdir_lock);
 	return rv;
 }
 
@@ -231,11 +231,11 @@ struct dentry *proc_lookup_de(struct pro
 {
 	struct inode *inode;
 
-	spin_lock(&proc_subdir_lock);
+	read_lock(&proc_subdir_lock);
 	de = pde_subdir_find(de, dentry->d_name.name, dentry->d_name.len);
 	if (de) {
 		pde_get(de);
-		spin_unlock(&proc_subdir_lock);
+		read_unlock(&proc_subdir_lock);
 		inode = proc_get_inode(dir->i_sb, de);
 		if (!inode)
 			return ERR_PTR(-ENOMEM);
@@ -243,7 +243,7 @@ struct dentry *proc_lookup_de(struct pro
 		d_add(dentry, inode);
 		return NULL;
 	}
-	spin_unlock(&proc_subdir_lock);
+	read_unlock(&proc_subdir_lock);
 	return ERR_PTR(-ENOENT);
 }
 
@@ -270,12 +270,12 @@ int proc_readdir_de(struct proc_dir_entr
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	spin_lock(&proc_subdir_lock);
+	read_lock(&proc_subdir_lock);
 	de = pde_subdir_first(de);
 	i = ctx->pos - 2;
 	for (;;) {
 		if (!de) {
-			spin_unlock(&proc_subdir_lock);
+			read_unlock(&proc_subdir_lock);
 			return 0;
 		}
 		if (!i)
@@ -287,19 +287,19 @@ int proc_readdir_de(struct proc_dir_entr
 	do {
 		struct proc_dir_entry *next;
 		pde_get(de);
-		spin_unlock(&proc_subdir_lock);
+		read_unlock(&proc_subdir_lock);
 		if (!dir_emit(ctx, de->name, de->namelen,
 			    de->low_ino, de->mode >> 12)) {
 			pde_put(de);
 			return 0;
 		}
-		spin_lock(&proc_subdir_lock);
+		read_lock(&proc_subdir_lock);
 		ctx->pos++;
 		next = pde_subdir_next(de);
 		pde_put(de);
 		de = next;
 	} while (de);
-	spin_unlock(&proc_subdir_lock);
+	read_unlock(&proc_subdir_lock);
 	return 1;
 }
 
@@ -338,16 +338,16 @@ static int proc_register(struct proc_dir
 	if (ret)
 		return ret;
 
-	spin_lock(&proc_subdir_lock);
+	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
 	if (pde_subdir_insert(dir, dp) == false) {
 		WARN(1, "proc_dir_entry '%s/%s' already registered\n",
 		     dir->name, dp->name);
-		spin_unlock(&proc_subdir_lock);
+		write_unlock(&proc_subdir_lock);
 		proc_free_inum(dp->low_ino);
 		return -EEXIST;
 	}
-	spin_unlock(&proc_subdir_lock);
+	write_unlock(&proc_subdir_lock);
 
 	return 0;
 }
@@ -549,9 +549,9 @@ void remove_proc_entry(const char *name,
 	const char *fn = name;
 	unsigned int len;
 
-	spin_lock(&proc_subdir_lock);
+	write_lock(&proc_subdir_lock);
 	if (__xlate_proc_name(name, &parent, &fn) != 0) {
-		spin_unlock(&proc_subdir_lock);
+		write_unlock(&proc_subdir_lock);
 		return;
 	}
 	len = strlen(fn);
@@ -559,7 +559,7 @@ void remove_proc_entry(const char *name,
 	de = pde_subdir_find(parent, fn, len);
 	if (de)
 		rb_erase(&de->subdir_node, &parent->subdir);
-	spin_unlock(&proc_subdir_lock);
+	write_unlock(&proc_subdir_lock);
 	if (!de) {
 		WARN(1, "name '%s'\n", name);
 		return;
@@ -583,16 +583,16 @@ int remove_proc_subtree(const char *name
 	const char *fn = name;
 	unsigned int len;
 
-	spin_lock(&proc_subdir_lock);
+	write_lock(&proc_subdir_lock);
 	if (__xlate_proc_name(name, &parent, &fn) != 0) {
-		spin_unlock(&proc_subdir_lock);
+		write_unlock(&proc_subdir_lock);
 		return -ENOENT;
 	}
 	len = strlen(fn);
 
 	root = pde_subdir_find(parent, fn, len);
 	if (!root) {
-		spin_unlock(&proc_subdir_lock);
+		write_unlock(&proc_subdir_lock);
 		return -ENOENT;
 	}
 	rb_erase(&root->subdir_node, &parent->subdir);
@@ -605,7 +605,7 @@ int remove_proc_subtree(const char *name
 			de = next;
 			continue;
 		}
-		spin_unlock(&proc_subdir_lock);
+		write_unlock(&proc_subdir_lock);
 
 		proc_entry_rundown(de);
 		next = de->parent;
@@ -616,7 +616,7 @@ int remove_proc_subtree(const char *name
 			break;
 		pde_put(de);
 
-		spin_lock(&proc_subdir_lock);
+		write_lock(&proc_subdir_lock);
 		de = next;
 	}
 	pde_put(root);
_

Patches currently in -mm which might be from Waiman.Long@hp.com are


