Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932E5197A6B
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 19:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725996567; cv=none; b=hRjN16nH60T5v2nPb2Knn8wLxVTjnK4bsNXwZjcXeGdep3GkTCwNp4wy3Dq9Znbn+w79bQ3ui7SRJV/RBTSU3jeSUEuaAOCBQKM66SjWBHTbokyzm/7srf53QwxMxWBX+2yn6aVi46vg2HYP+0gMBOdUItPKFNMZqJqaMF66r7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725996567; c=relaxed/simple;
	bh=WT9AU75RPhjM3cQMaY8qh9hF8hqzt/wJIZ5+/MPf20o=;
	h=Date:To:From:Subject:Message-Id; b=nVnAmoy3l0NdVWE+poFSAUcPRua+sevcDrgwSJkOrQHwDY2BrYYqwyeP7EoF3Pa9MTDYKZGCEeP+awexw7ECLPP0LYF3KsktYTQ5R+lTyORHK7Uy0avBLlMagxsY+54BL1p+92nXWjuVQ4Pz5fnLOmRd65qExU+EgfB7vSAGEdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Y98DUsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Y98DUsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8E6C4CEC3;
	Tue, 10 Sep 2024 19:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725996567;
	bh=WT9AU75RPhjM3cQMaY8qh9hF8hqzt/wJIZ5+/MPf20o=;
	h=Date:To:From:Subject:From;
	b=2Y98DUsDHBXihTMUaAg/qOzMnj2zEYWhoOlz5FCVQQqRkAQTfEwX10riSfWKz/VjY
	 kWWLfHGNpJdWimiBcgzNaf+HeARDTwRa54XZgIEeO3N/kwOnK+Qp0mHQhzfYvMBCK/
	 7z0NUmZN94ohndnn9CAk7XAu+VTUmuccsOf9Py7w=
Date: Tue, 10 Sep 2024 12:29:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tytso@mit.edu,serge@hallyn.com,paul@paul-moore.com,laoar.shao@gmail.com,kent.overstreet@linux.dev,jmorris@namei.org,jack@suse.cz,hch@lst.de,dchinner@redhat.com,brauner@kernel.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcachefs-do-not-use-pf_memalloc_noreclaim.patch added to mm-unstable branch
Message-Id: <20240910192927.2B8E6C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcachefs: do not use PF_MEMALLOC_NORECLAIM
has been added to the -mm mm-unstable branch.  Its filename is
     bcachefs-do-not-use-pf_memalloc_noreclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcachefs-do-not-use-pf_memalloc_noreclaim.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: bcachefs: do not use PF_MEMALLOC_NORECLAIM
Date: Mon, 2 Sep 2024 11:51:49 +0200

Patch series "remove PF_MEMALLOC_NORECLAIM", v2.


This patch (of 2):

bch2_new_inode relies on PF_MEMALLOC_NORECLAIM to try to allocate a new
inode to achieve GFP_NOWAIT semantic while holding locks.  If this
allocation fails it will drop locks and use GFP_NOFS allocation context.

We would like to drop PF_MEMALLOC_NORECLAIM because it is really dangerous
to use if the caller doesn't control the full call chain with this flag
set.  E.g.  if any of the function down the chain needed GFP_NOFAIL
request the PF_MEMALLOC_NORECLAIM would override this and cause unexpected
failure.

While this is not the case in this particular case using the scoped gfp
semantic is not really needed bacause we can easily pus the allocation
context down the chain without too much clutter.

Link: https://lkml.kernel.org/r/20240902095203.1559361-1-mhocko@kernel.org
Link: https://lkml.kernel.org/r/20240902095203.1559361-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz> # For vfs changes
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bcachefs/fs.c          |   14 ++++++--------
 fs/inode.c                |    6 +++---
 include/linux/fs.h        |    7 ++++++-
 include/linux/lsm_hooks.h |    2 +-
 include/linux/security.h  |    4 ++--
 security/security.c       |    8 ++++----
 6 files changed, 22 insertions(+), 19 deletions(-)

--- a/fs/bcachefs/fs.c~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/fs/bcachefs/fs.c
@@ -231,9 +231,9 @@ static struct inode *bch2_alloc_inode(st
 	BUG();
 }
 
-static struct bch_inode_info *__bch2_new_inode(struct bch_fs *c)
+static struct bch_inode_info *__bch2_new_inode(struct bch_fs *c, gfp_t gfp)
 {
-	struct bch_inode_info *inode = kmem_cache_alloc(bch2_inode_cache, GFP_NOFS);
+	struct bch_inode_info *inode = kmem_cache_alloc(bch2_inode_cache, gfp);
 	if (!inode)
 		return NULL;
 
@@ -245,7 +245,7 @@ static struct bch_inode_info *__bch2_new
 	mutex_init(&inode->ei_quota_lock);
 	memset(&inode->ei_devs_need_flush, 0, sizeof(inode->ei_devs_need_flush));
 
-	if (unlikely(inode_init_always(c->vfs_sb, &inode->v))) {
+	if (unlikely(inode_init_always_gfp(c->vfs_sb, &inode->v, gfp))) {
 		kmem_cache_free(bch2_inode_cache, inode);
 		return NULL;
 	}
@@ -258,12 +258,10 @@ static struct bch_inode_info *__bch2_new
  */
 static struct bch_inode_info *bch2_new_inode(struct btree_trans *trans)
 {
-	struct bch_inode_info *inode =
-		memalloc_flags_do(PF_MEMALLOC_NORECLAIM|PF_MEMALLOC_NOWARN,
-				  __bch2_new_inode(trans->c));
+	struct bch_inode_info *inode = __bch2_new_inode(trans->c, GFP_NOWAIT);
 
 	if (unlikely(!inode)) {
-		int ret = drop_locks_do(trans, (inode = __bch2_new_inode(trans->c)) ? 0 : -ENOMEM);
+		int ret = drop_locks_do(trans, (inode = __bch2_new_inode(trans->c, GFP_NOFS)) ? 0 : -ENOMEM);
 		if (ret && inode) {
 			__destroy_inode(&inode->v);
 			kmem_cache_free(bch2_inode_cache, inode);
@@ -328,7 +326,7 @@ __bch2_create(struct mnt_idmap *idmap,
 	if (ret)
 		return ERR_PTR(ret);
 #endif
-	inode = __bch2_new_inode(c);
+	inode = __bch2_new_inode(c, GFP_NOFS);
 	if (unlikely(!inode)) {
 		inode = ERR_PTR(-ENOMEM);
 		goto err;
--- a/fs/inode.c~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/fs/inode.c
@@ -153,7 +153,7 @@ static int no_open(struct inode *inode,
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
  */
-int inode_init_always(struct super_block *sb, struct inode *inode)
+int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp)
 {
 	static const struct inode_operations empty_iops;
 	static const struct file_operations no_open_fops = {.open = no_open};
@@ -230,14 +230,14 @@ int inode_init_always(struct super_block
 #endif
 	inode->i_flctx = NULL;
 
-	if (unlikely(security_inode_alloc(inode)))
+	if (unlikely(security_inode_alloc(inode, gfp)))
 		return -ENOMEM;
 
 	this_cpu_inc(nr_inodes);
 
 	return 0;
 }
-EXPORT_SYMBOL(inode_init_always);
+EXPORT_SYMBOL(inode_init_always_gfp);
 
 void free_inode_nonrcu(struct inode *inode)
 {
--- a/include/linux/fs.h~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/include/linux/fs.h
@@ -3033,7 +3033,12 @@ extern loff_t default_llseek(struct file
 
 extern loff_t vfs_llseek(struct file *file, loff_t offset, int whence);
 
-extern int inode_init_always(struct super_block *, struct inode *);
+extern int inode_init_always_gfp(struct super_block *, struct inode *, gfp_t);
+static inline int inode_init_always(struct super_block *sb, struct inode *inode)
+{
+	return inode_init_always_gfp(sb, inode, GFP_NOFS);
+}
+
 extern void inode_init_once(struct inode *);
 extern void address_space_init_once(struct address_space *mapping);
 extern struct inode * igrab(struct inode *);
--- a/include/linux/lsm_hooks.h~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/include/linux/lsm_hooks.h
@@ -150,6 +150,6 @@ extern struct lsm_info __start_early_lsm
 		__used __section(".early_lsm_info.init")		\
 		__aligned(sizeof(unsigned long))
 
-extern int lsm_inode_alloc(struct inode *inode);
+extern int lsm_inode_alloc(struct inode *inode, gfp_t gfp);
 
 #endif /* ! __LINUX_LSM_HOOKS_H */
--- a/include/linux/security.h~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/include/linux/security.h
@@ -336,7 +336,7 @@ int security_dentry_create_files_as(stru
 					struct cred *new);
 int security_path_notify(const struct path *path, u64 mask,
 					unsigned int obj_type);
-int security_inode_alloc(struct inode *inode);
+int security_inode_alloc(struct inode *inode, gfp_t gfp);
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				 const struct qstr *qstr,
@@ -769,7 +769,7 @@ static inline int security_path_notify(c
 	return 0;
 }
 
-static inline int security_inode_alloc(struct inode *inode)
+static inline int security_inode_alloc(struct inode *inode, gfp_t gfp)
 {
 	return 0;
 }
--- a/security/security.c~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/security/security.c
@@ -660,14 +660,14 @@ static int lsm_file_alloc(struct file *f
  *
  * Returns 0, or -ENOMEM if memory can't be allocated.
  */
-int lsm_inode_alloc(struct inode *inode)
+int lsm_inode_alloc(struct inode *inode, gfp_t gfp)
 {
 	if (!lsm_inode_cache) {
 		inode->i_security = NULL;
 		return 0;
 	}
 
-	inode->i_security = kmem_cache_zalloc(lsm_inode_cache, GFP_NOFS);
+	inode->i_security = kmem_cache_zalloc(lsm_inode_cache, gfp);
 	if (inode->i_security == NULL)
 		return -ENOMEM;
 	return 0;
@@ -1582,9 +1582,9 @@ int security_path_notify(const struct pa
  *
  * Return: Return 0 if operation was successful.
  */
-int security_inode_alloc(struct inode *inode)
+int security_inode_alloc(struct inode *inode, gfp_t gfp)
 {
-	int rc = lsm_inode_alloc(inode);
+	int rc = lsm_inode_alloc(inode, gfp);
 
 	if (unlikely(rc))
 		return rc;
_

Patches currently in -mm which might be from mhocko@suse.com are

bcachefs-do-not-use-pf_memalloc_noreclaim.patch
bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch
revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn.patch

