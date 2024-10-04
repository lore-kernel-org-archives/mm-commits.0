Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6577F3BBEF
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 02:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008770; cv=none; b=nEORdw+dowgZPBcy4xk2TD6ovlZtLwp5xVjH/G8zysRcWguKgmdXHaZlmX5aMof569tMAiRTdrLxlS8aK7Fie5ac6o2Z0BJvnAzO8TRyWEjwOx2F71rRpa3DKwQ8+YXVuwjWIC5rjNQ6wjE4prn2KjJjfvkyZjsvDHF5JElpA/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008770; c=relaxed/simple;
	bh=WfRW/cZp+aatlyg6mtz/ippGGRD/KS4F67gFKu9oSX0=;
	h=Date:To:From:Subject:Message-Id; b=D+P/zdeSfBOjrT5y1zXnQZ4itRd1VJMdjIXTqZGuh4uMDOjSwbwASZesIod6C1E7yVs3b9H19unp7ZmcDqiMOcaeKK3XeyVbSlVNuz8OmQqV3LA56yETUMzkvpKhZHTEDUaciipsNhQhsfyDjLrpyZcUGqfo1mB2ufgM+T091nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kN6PKArN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kN6PKArN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5884C4CEC7;
	Fri,  4 Oct 2024 02:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008769;
	bh=WfRW/cZp+aatlyg6mtz/ippGGRD/KS4F67gFKu9oSX0=;
	h=Date:To:From:Subject:From;
	b=kN6PKArNXq19W+u9ow9iVn9imb+iTipzOehk1MIE22pScKud5ZF+wuN7rS+EZYgya
	 FOYlan0MoH9azoPD9FaQUfmQBX5gq351hdFwJZHKIk8s1UWYEPCxWfJPlxm/nPYn51
	 0LrNYO2/2JSoe11OQHY+VPYO2nQYsh+epmBXi7jI=
Date: Thu, 03 Oct 2024 19:26:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,serge@hallyn.com,paul@paul-moore.com,laoar.shao@gmail.com,kent.overstreet@linux.dev,jmorris@namei.org,jack@suse.cz,hch@lst.de,dchinner@redhat.com,brauner@kernel.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] bcachefs-do-not-use-pf_memalloc_noreclaim.patch removed from -mm tree
Message-Id: <20241004022609.D5884C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcachefs: do not use PF_MEMALLOC_NORECLAIM
has been removed from the -mm tree.  Its filename was
     bcachefs-do-not-use-pf_memalloc_noreclaim.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: bcachefs: do not use PF_MEMALLOC_NORECLAIM
Date: Thu, 26 Sep 2024 19:11:50 +0200

Patch series "remove PF_MEMALLOC_NORECLAIM" v3.


This patch (of 2):

bch2_new_inode relies on PF_MEMALLOC_NORECLAIM to try to allocate a new
inode to achieve GFP_NOWAIT semantic while holding locks. If this
allocation fails it will drop locks and use GFP_NOFS allocation context.

We would like to drop PF_MEMALLOC_NORECLAIM because it is really
dangerous to use if the caller doesn't control the full call chain with
this flag set. E.g. if any of the function down the chain needed
GFP_NOFAIL request the PF_MEMALLOC_NORECLAIM would override this and
cause unexpected failure.

While this is not the case in this particular case using the scoped gfp
semantic is not really needed bacause we can easily pus the allocation
context down the chain without too much clutter.

[akpm@linux-foundation.org: fix kerneldoc warnings]
Link: https://lkml.kernel.org/r/20240926172940.167084-1-mhocko@kernel.org
Link: https://lkml.kernel.org/r/20240926172940.167084-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz> # For vfs changes
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bcachefs/fs.c         |   14 ++++++--------
 fs/inode.c               |   10 ++++++----
 include/linux/fs.h       |    7 ++++++-
 include/linux/security.h |    4 ++--
 security/security.c      |   10 ++++++----
 5 files changed, 26 insertions(+), 19 deletions(-)

--- a/fs/bcachefs/fs.c~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/fs/bcachefs/fs.c
@@ -291,10 +291,10 @@ static struct inode *bch2_alloc_inode(st
 	BUG();
 }
 
-static struct bch_inode_info *__bch2_new_inode(struct bch_fs *c)
+static struct bch_inode_info *__bch2_new_inode(struct bch_fs *c, gfp_t gfp)
 {
 	struct bch_inode_info *inode = alloc_inode_sb(c->vfs_sb,
-						bch2_inode_cache, GFP_NOFS);
+						bch2_inode_cache, gfp);
 	if (!inode)
 		return NULL;
 
@@ -306,7 +306,7 @@ static struct bch_inode_info *__bch2_new
 	mutex_init(&inode->ei_quota_lock);
 	memset(&inode->ei_devs_need_flush, 0, sizeof(inode->ei_devs_need_flush));
 
-	if (unlikely(inode_init_always(c->vfs_sb, &inode->v))) {
+	if (unlikely(inode_init_always_gfp(c->vfs_sb, &inode->v, gfp))) {
 		kmem_cache_free(bch2_inode_cache, inode);
 		return NULL;
 	}
@@ -319,12 +319,10 @@ static struct bch_inode_info *__bch2_new
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
@@ -398,7 +396,7 @@ __bch2_create(struct mnt_idmap *idmap,
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
@@ -146,14 +146,16 @@ static int no_open(struct inode *inode,
 }
 
 /**
- * inode_init_always - perform inode structure initialisation
+ * inode_init_always_gfp - perform inode structure initialisation
  * @sb: superblock inode belongs to
  * @inode: inode to initialise
+ * @gfp: allocation flags
  *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
+ * If there are additional allocations required @gfp is used.
  */
-int inode_init_always(struct super_block *sb, struct inode *inode)
+int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp)
 {
 	static const struct inode_operations empty_iops;
 	static const struct file_operations no_open_fops = {.open = no_open};
@@ -230,14 +232,14 @@ int inode_init_always(struct super_block
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
@@ -3082,7 +3082,12 @@ extern loff_t default_llseek(struct file
 
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
--- a/include/linux/security.h~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/include/linux/security.h
@@ -348,7 +348,7 @@ int security_dentry_create_files_as(stru
 					struct cred *new);
 int security_path_notify(const struct path *path, u64 mask,
 					unsigned int obj_type);
-int security_inode_alloc(struct inode *inode);
+int security_inode_alloc(struct inode *inode, gfp_t gfp);
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				 const struct qstr *qstr,
@@ -789,7 +789,7 @@ static inline int security_path_notify(c
 	return 0;
 }
 
-static inline int security_inode_alloc(struct inode *inode)
+static inline int security_inode_alloc(struct inode *inode, gfp_t gfp)
 {
 	return 0;
 }
--- a/security/security.c~bcachefs-do-not-use-pf_memalloc_noreclaim
+++ a/security/security.c
@@ -740,19 +740,20 @@ static int lsm_file_alloc(struct file *f
 /**
  * lsm_inode_alloc - allocate a composite inode blob
  * @inode: the inode that needs a blob
+ * @gfp: allocation flags
  *
  * Allocate the inode blob for all the modules
  *
  * Returns 0, or -ENOMEM if memory can't be allocated.
  */
-static int lsm_inode_alloc(struct inode *inode)
+static int lsm_inode_alloc(struct inode *inode, gfp_t gfp)
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
@@ -1678,6 +1679,7 @@ int security_path_notify(const struct pa
 /**
  * security_inode_alloc() - Allocate an inode LSM blob
  * @inode: the inode
+ * @gfp: allocation flags
  *
  * Allocate and attach a security structure to @inode->i_security.  The
  * i_security field is initialized to NULL when the inode structure is
@@ -1685,9 +1687,9 @@ int security_path_notify(const struct pa
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


