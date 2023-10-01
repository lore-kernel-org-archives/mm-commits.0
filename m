Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65575E78488
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbjJAT4t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbjJAT4s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:56:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A99ED9
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:56:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4486C433C7;
        Sun,  1 Oct 2023 19:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696190204;
        bh=gtWzA0QKFs4MJBsv9pJSyzoYFORoRaTuAnFz30SHZQg=;
        h=Date:To:From:Subject:From;
        b=mrFYafBJ90XAgsmEbzKc5r6rWVtkO6M9pk4Rar0a6zu64XrLZS+jxpjujjQxHWK3B
         F99GB2UHsgDRaJIjHs2gp8n/qEhAs3ZMMQtZr4t5IBhJnl5VVlODhccU9vEhlvjIt7
         d2+kWmqwDLOk+xwHA3uEnJWCFxYaAxs4+v08VCTM=
Date:   Sun, 01 Oct 2023 12:56:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch added to mm-unstable branch
Message-Id: <20231001195644.C4486C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: trivial tidyups, removing extra blank lines, etc
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: shmem: trivial tidyups, removing extra blank lines, etc
Date: Fri, 29 Sep 2023 20:28:50 -0700 (PDT)

Mostly removing a few superfluous blank lines, joining short arglines,
imposing some 80-column observance, correcting a couple of comments.  None
of it more interesting than deleting a repeated INIT_LIST_HEAD().

Link: https://lkml.kernel.org/r/b3983d28-5d3f-8649-36af-b819285d7a9e@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   56 +++++++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

--- a/mm/shmem.c~shmem-trivial-tidyups-removing-extra-blank-lines-etc
+++ a/mm/shmem.c
@@ -756,7 +756,7 @@ static unsigned long shmem_unused_huge_s
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
- * Like filemap_add_folio, but error if expected item has gone.
+ * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
 static int shmem_add_to_page_cache(struct folio *folio,
 				   struct address_space *mapping,
@@ -825,7 +825,7 @@ error:
 }
 
 /*
- * Like delete_from_page_cache, but substitutes swap for @folio.
+ * Somewhat like filemap_remove_folio, but substitutes swap for @folio.
  */
 static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 {
@@ -887,7 +887,6 @@ unsigned long shmem_partial_swap_usage(s
 			cond_resched_rcu();
 		}
 	}
-
 	rcu_read_unlock();
 
 	return swapped << PAGE_SHIFT;
@@ -1230,7 +1229,6 @@ static int shmem_setattr(struct mnt_idma
 	if (i_uid_needs_update(idmap, attr, inode) ||
 	    i_gid_needs_update(idmap, attr, inode)) {
 		error = dquot_transfer(idmap, inode, attr);
-
 		if (error)
 			return error;
 	}
@@ -2473,7 +2471,6 @@ static struct inode *__shmem_get_inode(s
 	if (err)
 		return ERR_PTR(err);
 
-
 	inode = new_inode(sb);
 	if (!inode) {
 		shmem_free_inode(sb, 0);
@@ -2498,11 +2495,10 @@ static struct inode *__shmem_get_inode(s
 		shmem_set_inode_flags(inode, info->fsflags);
 	INIT_LIST_HEAD(&info->shrinklist);
 	INIT_LIST_HEAD(&info->swaplist);
-	INIT_LIST_HEAD(&info->swaplist);
-	if (sbinfo->noswap)
-		mapping_set_unevictable(inode->i_mapping);
 	simple_xattrs_init(&info->xattrs);
 	cache_no_acl(inode);
+	if (sbinfo->noswap)
+		mapping_set_unevictable(inode->i_mapping);
 	mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
@@ -2714,7 +2710,6 @@ shmem_write_begin(struct file *file, str
 	}
 
 	ret = shmem_get_folio(inode, index, &folio, SGP_WRITE);
-
 	if (ret)
 		return ret;
 
@@ -3246,8 +3241,7 @@ shmem_mknod(struct mnt_idmap *idmap, str
 	error = simple_acl_create(dir, inode);
 	if (error)
 		goto out_iput;
-	error = security_inode_init_security(inode, dir,
-					     &dentry->d_name,
+	error = security_inode_init_security(inode, dir, &dentry->d_name,
 					     shmem_initxattrs, NULL);
 	if (error && error != -EOPNOTSUPP)
 		goto out_iput;
@@ -3276,14 +3270,11 @@ shmem_tmpfile(struct mnt_idmap *idmap, s
 	int error;
 
 	inode = shmem_get_inode(idmap, dir->i_sb, dir, mode, 0, VM_NORESERVE);
-
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
 		goto err_out;
 	}
-
-	error = security_inode_init_security(inode, dir,
-					     NULL,
+	error = security_inode_init_security(inode, dir, NULL,
 					     shmem_initxattrs, NULL);
 	if (error && error != -EOPNOTSUPP)
 		goto out_iput;
@@ -3320,7 +3311,8 @@ static int shmem_create(struct mnt_idmap
 /*
  * Link a file..
  */
-static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
+static int shmem_link(struct dentry *old_dentry, struct inode *dir,
+		      struct dentry *dentry)
 {
 	struct inode *inode = d_inode(old_dentry);
 	int ret = 0;
@@ -3351,7 +3343,7 @@ static int shmem_link(struct dentry *old
 	inode_inc_iversion(dir);
 	inc_nlink(inode);
 	ihold(inode);	/* New dentry reference */
-	dget(dentry);		/* Extra pinning count for the created dentry */
+	dget(dentry);	/* Extra pinning count for the created dentry */
 	d_instantiate(dentry, inode);
 out:
 	return ret;
@@ -3371,7 +3363,7 @@ static int shmem_unlink(struct inode *di
 					     inode_set_ctime_current(inode));
 	inode_inc_iversion(dir);
 	drop_nlink(inode);
-	dput(dentry);	/* Undo the count from "create" - this does all the work */
+	dput(dentry);	/* Undo the count from "create" - does all the work */
 	return 0;
 }
 
@@ -3481,7 +3473,6 @@ static int shmem_symlink(struct mnt_idma
 
 	inode = shmem_get_inode(idmap, dir->i_sb, dir, S_IFLNK | 0777, 0,
 				VM_NORESERVE);
-
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
@@ -3535,8 +3526,7 @@ static void shmem_put_link(void *arg)
 	folio_put(arg);
 }
 
-static const char *shmem_get_link(struct dentry *dentry,
-				  struct inode *inode,
+static const char *shmem_get_link(struct dentry *dentry, struct inode *inode,
 				  struct delayed_call *done)
 {
 	struct folio *folio = NULL;
@@ -3610,8 +3600,7 @@ static int shmem_fileattr_set(struct mnt
  * Callback for security_inode_init_security() for acquiring xattrs.
  */
 static int shmem_initxattrs(struct inode *inode,
-			    const struct xattr *xattr_array,
-			    void *fs_info)
+			    const struct xattr *xattr_array, void *fs_info)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -3795,7 +3784,6 @@ static struct dentry *shmem_find_alias(s
 	return alias ?: d_find_any_alias(inode);
 }
 
-
 static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
 		struct fid *fid, int fh_len, int fh_type)
 {
@@ -4379,8 +4367,8 @@ static int shmem_fill_super(struct super
 	}
 #endif /* CONFIG_TMPFS_QUOTA */
 
-	inode = shmem_get_inode(&nop_mnt_idmap, sb, NULL, S_IFDIR | sbinfo->mode, 0,
-				VM_NORESERVE);
+	inode = shmem_get_inode(&nop_mnt_idmap, sb, NULL,
+				S_IFDIR | sbinfo->mode, 0, VM_NORESERVE);
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
 		goto failed;
@@ -4679,11 +4667,9 @@ static ssize_t shmem_enabled_show(struct
 
 	for (i = 0; i < ARRAY_SIZE(values); i++) {
 		len += sysfs_emit_at(buf, len,
-				     shmem_huge == values[i] ? "%s[%s]" : "%s%s",
-				     i ? " " : "",
-				     shmem_format_huge(values[i]));
+				shmem_huge == values[i] ? "%s[%s]" : "%s%s",
+				i ? " " : "", shmem_format_huge(values[i]));
 	}
-
 	len += sysfs_emit_at(buf, len, "\n");
 
 	return len;
@@ -4780,8 +4766,9 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 #define shmem_acct_size(flags, size)		0
 #define shmem_unacct_size(flags, size)		do {} while (0)
 
-static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap, struct super_block *sb, struct inode *dir,
-					    umode_t mode, dev_t dev, unsigned long flags)
+static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
+				struct super_block *sb, struct inode *dir,
+				umode_t mode, dev_t dev, unsigned long flags)
 {
 	struct inode *inode = ramfs_get_inode(sb, dir, mode, dev);
 	return inode ? inode : ERR_PTR(-ENOSPC);
@@ -4791,8 +4778,8 @@ static inline struct inode *shmem_get_in
 
 /* common code */
 
-static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name, loff_t size,
-				       unsigned long flags, unsigned int i_flags)
+static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
+			loff_t size, unsigned long flags, unsigned int i_flags)
 {
 	struct inode *inode;
 	struct file *res;
@@ -4811,7 +4798,6 @@ static struct file *__shmem_file_setup(s
 
 	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
 				S_IFREG | S_IRWXUGO, 0, flags);
-
 	if (IS_ERR(inode)) {
 		shmem_unacct_size(flags, size);
 		return ERR_CAST(inode);
_

Patches currently in -mm which might be from hughd@google.com are

shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch
shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch
shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch
shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch
shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch
shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch
shmem-_add_to_page_cache-before-shmem_inode_acct_blocks.patch
shmempercpu_counter-add-_limited_addfbc-limit-amount.patch

