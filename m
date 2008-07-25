From: akpm@linux-foundation.org
Subject: - proc-always-do-release.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:11 -0700
Message-ID: <200807252302.m6PN2BlI003804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbYGYXGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc: always do ->release
has been removed from the -mm tree.  Its filename was
     proc-always-do-release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: always do ->release
From: Alexey Dobriyan <adobriyan@gmail.com>

Current two-stage scheme of removing PDE emphasizes one bug in proc:

		open
				rmmod
				remove_proc_entry
		close

->release won't be called because ->proc_fops were cleared.  In simple
cases it's small memory leak.

For every ->open, ->release has to be done.  List of openers is introduced
which is traversed at remove_proc_entry() if neeeded.

Discussions with Al long ago (sigh).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   14 +++++++
 fs/proc/inode.c         |   74 +++++++++++++++++++++++++++++++++++---
 fs/proc/internal.h      |    7 +++
 include/linux/proc_fs.h |    1 
 4 files changed, 92 insertions(+), 4 deletions(-)

diff -puN fs/proc/generic.c~proc-always-do-release fs/proc/generic.c
--- a/fs/proc/generic.c~proc-always-do-release
+++ a/fs/proc/generic.c
@@ -597,6 +597,7 @@ static struct proc_dir_entry *__proc_cre
 	ent->pde_users = 0;
 	spin_lock_init(&ent->pde_unload_lock);
 	ent->pde_unload_completion = NULL;
+	INIT_LIST_HEAD(&ent->pde_openers);
  out:
 	return ent;
 }
@@ -789,6 +790,19 @@ void remove_proc_entry(const char *name,
 	spin_unlock(&de->pde_unload_lock);
 
 continue_removing:
+	spin_lock(&de->pde_unload_lock);
+	while (!list_empty(&de->pde_openers)) {
+		struct pde_opener *pdeo;
+
+		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
+		list_del(&pdeo->lh);
+		spin_unlock(&de->pde_unload_lock);
+		pdeo->release(pdeo->inode, pdeo->file);
+		kfree(pdeo);
+		spin_lock(&de->pde_unload_lock);
+	}
+	spin_unlock(&de->pde_unload_lock);
+
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
 	de->nlink = 0;
diff -puN fs/proc/inode.c~proc-always-do-release fs/proc/inode.c
--- a/fs/proc/inode.c~proc-always-do-release
+++ a/fs/proc/inode.c
@@ -126,12 +126,17 @@ static const struct super_operations pro
 	.remount_fs	= proc_remount,
 };
 
-static void pde_users_dec(struct proc_dir_entry *pde)
+static void __pde_users_dec(struct proc_dir_entry *pde)
 {
-	spin_lock(&pde->pde_unload_lock);
 	pde->pde_users--;
 	if (pde->pde_unload_completion && pde->pde_users == 0)
 		complete(pde->pde_unload_completion);
+}
+
+static void pde_users_dec(struct proc_dir_entry *pde)
+{
+	spin_lock(&pde->pde_unload_lock);
+	__pde_users_dec(pde);
 	spin_unlock(&pde->pde_unload_lock);
 }
 
@@ -318,36 +323,97 @@ static int proc_reg_open(struct inode *i
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	int (*open)(struct inode *, struct file *);
+	int (*release)(struct inode *, struct file *);
+	struct pde_opener *pdeo;
+
+	/*
+	 * What for, you ask? Well, we can have open, rmmod, remove_proc_entry
+	 * sequence. ->release won't be called because ->proc_fops will be
+	 * cleared. Depending on complexity of ->release, consequences vary.
+	 *
+	 * We can't wait for mercy when close will be done for real, it's
+	 * deadlockable: rmmod foo </proc/foo . So, we're going to do ->release
+	 * by hand in remove_proc_entry(). For this, save opener's credentials
+	 * for later.
+	 */
+	pdeo = kmalloc(sizeof(struct pde_opener), GFP_KERNEL);
+	if (!pdeo)
+		return -ENOMEM;
 
 	spin_lock(&pde->pde_unload_lock);
 	if (!pde->proc_fops) {
 		spin_unlock(&pde->pde_unload_lock);
+		kfree(pdeo);
 		return rv;
 	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;
+	release = pde->proc_fops->release;
 	spin_unlock(&pde->pde_unload_lock);
 
 	if (open)
 		rv = open(inode, file);
 
-	pde_users_dec(pde);
+	spin_lock(&pde->pde_unload_lock);
+	if (rv == 0 && release) {
+		/* To know what to release. */
+		pdeo->inode = inode;
+		pdeo->file = file;
+		/* Strictly for "too late" ->release in proc_reg_release(). */
+		pdeo->release = release;
+		list_add(&pdeo->lh, &pde->pde_openers);
+	} else
+		kfree(pdeo);
+	__pde_users_dec(pde);
+	spin_unlock(&pde->pde_unload_lock);
 	return rv;
 }
 
+static struct pde_opener *find_pde_opener(struct proc_dir_entry *pde,
+					struct inode *inode, struct file *file)
+{
+	struct pde_opener *pdeo;
+
+	list_for_each_entry(pdeo, &pde->pde_openers, lh) {
+		if (pdeo->inode == inode && pdeo->file == file)
+			return pdeo;
+	}
+	return NULL;
+}
+
 static int proc_reg_release(struct inode *inode, struct file *file)
 {
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	int (*release)(struct inode *, struct file *);
+	struct pde_opener *pdeo;
 
 	spin_lock(&pde->pde_unload_lock);
+	pdeo = find_pde_opener(pde, inode, file);
 	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+		/*
+		 * Can't simply exit, __fput() will think that everything is OK,
+		 * and move on to freeing struct file. remove_proc_entry() will
+		 * find slacker in opener's list and will try to do non-trivial
+		 * things with struct file. Therefore, remove opener from list.
+		 *
+		 * But if opener is removed from list, who will ->release it?
+		 */
+		if (pdeo) {
+			list_del(&pdeo->lh);
+			spin_unlock(&pde->pde_unload_lock);
+			rv = pdeo->release(inode, file);
+			kfree(pdeo);
+		} else
+			spin_unlock(&pde->pde_unload_lock);
 		return rv;
 	}
 	pde->pde_users++;
 	release = pde->proc_fops->release;
+	if (pdeo) {
+		list_del(&pdeo->lh);
+		kfree(pdeo);
+	}
 	spin_unlock(&pde->pde_unload_lock);
 
 	if (release)
diff -puN fs/proc/internal.h~proc-always-do-release fs/proc/internal.h
--- a/fs/proc/internal.h~proc-always-do-release
+++ a/fs/proc/internal.h
@@ -89,3 +89,10 @@ struct dentry *proc_lookup_de(struct pro
 		struct dentry *dentry);
 int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
 		filldir_t filldir);
+
+struct pde_opener {
+	struct inode *inode;
+	struct file *file;
+	int (*release)(struct inode *, struct file *);
+	struct list_head lh;
+};
diff -puN include/linux/proc_fs.h~proc-always-do-release include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-always-do-release
+++ a/include/linux/proc_fs.h
@@ -79,6 +79,7 @@ struct proc_dir_entry {
 	int pde_users;	/* number of callers into module in progress */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	struct completion *pde_unload_completion;
+	struct list_head pde_openers;	/* who did ->open, but not ->release */
 };
 
 struct kcore_list {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
use-warn-in-fs-proc.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

