Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5B3C001B0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjGMRLx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjGMRLp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:11:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91067110
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:11:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1689561B07
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F56AC433C7;
        Thu, 13 Jul 2023 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268302;
        bh=bK2Oj1Gq7C5ObHwOn3Cb66/6MuRxLFOZHur6RRE9MNk=;
        h=Date:To:From:Subject:From;
        b=fHRjTVK9GoFRFKS4qBXcSiphTKKQz7UzN0CfEyOGp9QY/luPQwxqZbM5bdRRH41TW
         kQ7q6s8qULnZdJCu92MFx61wFQMsdGiS+gKqmHtEghbwituuU2BfLuBSZjY+6MGDHn
         xU5czp18tnxqQMrssW4i3ngh6DFmlWvzvt3PMHGM=
Date:   Thu, 13 Jul 2023 10:11:41 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        lczerner@redhat.com, jack@suse.cz, hughd@google.com,
        djwong@kernel.org, cmaiolino@redhat.com, brauner@kernel.org,
        cem@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-quota-support.patch added to mm-unstable branch
Message-Id: <20230713171142.6F56AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: quota support
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-quota-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-quota-support.patch

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
From: Carlos Maiolino <cem@kernel.org>
Subject: shmem: quota support
Date: Thu, 13 Jul 2023 15:48:47 +0200

Now the basic infra-structure is in place, enable quota support for tmpfs.

This offers user and group quotas to tmpfs (project quotas will be added
later).  Also, as other filesystems, the tmpfs quota is not supported
within user namespaces yet, so idmapping is not translated.

Link: https://lkml.kernel.org/r/20230713134848.249779-6-cem@kernel.org
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.rst |   15 ++
 include/linux/shmem_fs.h            |    8 +
 mm/shmem.c                          |  180 ++++++++++++++++++++++++--
 3 files changed, 195 insertions(+), 8 deletions(-)

--- a/Documentation/filesystems/tmpfs.rst~shmem-quota-support
+++ a/Documentation/filesystems/tmpfs.rst
@@ -130,6 +130,21 @@ for emergency or testing purposes. The v
     option, for testing
 ==  ============================================================
 
+tmpfs also supports quota with the following mount options
+
+========  =============================================================
+quota     User and group quota accounting and enforcement is enabled on
+          the mount. Tmpfs is using hidden system quota files that are
+          initialized on mount.
+usrquota  User quota accounting and enforcement is enabled on the
+          mount.
+grpquota  Group quota accounting and enforcement is enabled on the
+          mount.
+========  =============================================================
+
+Note that tmpfs quotas do not support user namespaces so no uid/gid
+translation is done if quotas are enabled inside user namespaces.
+
 tmpfs has a mount option to set the NUMA memory allocation policy for
 all files in that instance (if CONFIG_NUMA is enabled) - which can be
 adjusted on the fly via 'mount -o remount ...'
--- a/include/linux/shmem_fs.h~shmem-quota-support
+++ a/include/linux/shmem_fs.h
@@ -31,6 +31,9 @@ struct shmem_inode_info {
 	atomic_t		stop_eviction;	/* hold when working on inode */
 	struct timespec64	i_crtime;	/* file creation time */
 	unsigned int		fsflags;	/* flags for FS_IOC_[SG]ETFLAGS */
+#ifdef CONFIG_TMPFS_QUOTA
+	struct dquot		*i_dquot[MAXQUOTAS];
+#endif
 	struct inode		vfs_inode;
 };
 
@@ -184,4 +187,9 @@ extern int shmem_mfill_atomic_pte(pmd_t
 #define SHMEM_QUOTA_MAX_SPC_LIMIT 0x7fffffffffffffffLL /* 2^63-1 */
 #define SHMEM_QUOTA_MAX_INO_LIMIT 0x7fffffffffffffffLL
 
+#ifdef CONFIG_TMPFS_QUOTA
+extern const struct dquot_operations shmem_quota_operations;
+extern struct quota_format_type shmem_quota_format;
+#endif /* CONFIG_TMPFS_QUOTA */
+
 #endif
--- a/mm/shmem.c~shmem-quota-support
+++ a/mm/shmem.c
@@ -78,6 +78,7 @@ static struct vfsmount *shm_mnt;
 #include <uapi/linux/memfd.h>
 #include <linux/rmap.h>
 #include <linux/uuid.h>
+#include <linux/quotaops.h>
 
 #include <linux/uaccess.h>
 
@@ -116,11 +117,13 @@ struct shmem_options {
 	int huge;
 	int seen;
 	bool noswap;
+	unsigned short quota_types;
 #define SHMEM_SEEN_BLOCKS 1
 #define SHMEM_SEEN_INODES 2
 #define SHMEM_SEEN_HUGE 4
 #define SHMEM_SEEN_INUMS 8
 #define SHMEM_SEEN_NOSWAP 16
+#define SHMEM_SEEN_QUOTA 32
 };
 
 #ifdef CONFIG_TMPFS
@@ -212,7 +215,16 @@ static inline int shmem_inode_acct_block
 		if (percpu_counter_compare(&sbinfo->used_blocks,
 					   sbinfo->max_blocks - pages) > 0)
 			goto unacct;
+
+		err = dquot_alloc_block_nodirty(inode, pages);
+		if (err)
+			goto unacct;
+
 		percpu_counter_add(&sbinfo->used_blocks, pages);
+	} else {
+		err = dquot_alloc_block_nodirty(inode, pages);
+		if (err)
+			goto unacct;
 	}
 
 	return 0;
@@ -227,6 +239,8 @@ static inline void shmem_inode_unacct_bl
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 
+	dquot_free_block_nodirty(inode, pages);
+
 	if (sbinfo->max_blocks)
 		percpu_counter_sub(&sbinfo->used_blocks, pages);
 	shmem_unacct_blocks(info->flags, pages);
@@ -255,6 +269,47 @@ bool vma_is_shmem(struct vm_area_struct
 static LIST_HEAD(shmem_swaplist);
 static DEFINE_MUTEX(shmem_swaplist_mutex);
 
+#ifdef CONFIG_TMPFS_QUOTA
+
+static int shmem_enable_quotas(struct super_block *sb,
+			       unsigned short quota_types)
+{
+	int type, err = 0;
+
+	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE | DQUOT_NOLIST_DIRTY;
+	for (type = 0; type < SHMEM_MAXQUOTAS; type++) {
+		if (!(quota_types & (1 << type)))
+			continue;
+		err = dquot_load_quota_sb(sb, type, QFMT_SHMEM,
+					  DQUOT_USAGE_ENABLED |
+					  DQUOT_LIMITS_ENABLED);
+		if (err)
+			goto out_err;
+	}
+	return 0;
+
+out_err:
+	pr_warn("tmpfs: failed to enable quota tracking (type=%d, err=%d)\n",
+		type, err);
+	for (type--; type >= 0; type--)
+		dquot_quota_off(sb, type);
+	return err;
+}
+
+static void shmem_disable_quotas(struct super_block *sb)
+{
+	int type;
+
+	for (type = 0; type < SHMEM_MAXQUOTAS; type++)
+		dquot_quota_off(sb, type);
+}
+
+static struct dquot **shmem_get_dquots(struct inode *inode)
+{
+	return SHMEM_I(inode)->i_dquot;
+}
+#endif /* CONFIG_TMPFS_QUOTA */
+
 /*
  * shmem_reserve_inode() performs bookkeeping to reserve a shmem inode, and
  * produces a novel ino for the newly allocated inode.
@@ -361,7 +416,6 @@ static void shmem_recalc_inode(struct in
 	freed = info->alloced - info->swapped - inode->i_mapping->nrpages;
 	if (freed > 0) {
 		info->alloced -= freed;
-		inode->i_blocks -= freed * BLOCKS_PER_PAGE;
 		shmem_inode_unacct_blocks(inode, freed);
 	}
 }
@@ -379,7 +433,6 @@ bool shmem_charge(struct inode *inode, l
 
 	spin_lock_irqsave(&info->lock, flags);
 	info->alloced += pages;
-	inode->i_blocks += pages * BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
 	spin_unlock_irqrestore(&info->lock, flags);
 
@@ -395,7 +448,6 @@ void shmem_uncharge(struct inode *inode,
 
 	spin_lock_irqsave(&info->lock, flags);
 	info->alloced -= pages;
-	inode->i_blocks -= pages * BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
 	spin_unlock_irqrestore(&info->lock, flags);
 
@@ -1158,6 +1210,21 @@ static int shmem_setattr(struct mnt_idma
 		}
 	}
 
+	if (is_quota_modification(idmap, inode, attr)) {
+		error = dquot_initialize(inode);
+		if (error)
+			return error;
+	}
+
+	/* Transfer quota accounting */
+	if (i_uid_needs_update(idmap, attr, inode) ||
+	    i_gid_needs_update(idmap, attr, inode)) {
+		error = dquot_transfer(idmap, inode, attr);
+
+		if (error)
+			return error;
+	}
+
 	setattr_copy(idmap, inode, attr);
 	if (attr->ia_valid & ATTR_MODE)
 		error = posix_acl_chmod(idmap, dentry, inode->i_mode);
@@ -1204,6 +1271,10 @@ static void shmem_evict_inode(struct ino
 	WARN_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	clear_inode(inode);
+#ifdef CONFIG_TMPFS_QUOTA
+	dquot_free_inode(inode);
+	dquot_drop(inode);
+#endif
 }
 
 static int shmem_find_swap_entries(struct address_space *mapping,
@@ -2003,7 +2074,6 @@ alloc_nohuge:
 
 	spin_lock_irq(&info->lock);
 	info->alloced += folio_nr_pages(folio);
-	inode->i_blocks += (blkcnt_t)BLOCKS_PER_PAGE << folio_order(folio);
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 	alloced = true;
@@ -2374,9 +2444,10 @@ static void shmem_set_inode_flags(struct
 #define shmem_initxattrs NULL
 #endif
 
-static struct inode *shmem_get_inode(struct mnt_idmap *idmap, struct super_block *sb,
-				     struct inode *dir, umode_t mode, dev_t dev,
-				     unsigned long flags)
+static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
+					     struct super_block *sb,
+					     struct inode *dir, umode_t mode,
+					     dev_t dev, unsigned long flags)
 {
 	struct inode *inode;
 	struct shmem_inode_info *info;
@@ -2453,6 +2524,43 @@ static struct inode *shmem_get_inode(str
 	return inode;
 }
 
+#ifdef CONFIG_TMPFS_QUOTA
+static struct inode *shmem_get_inode(struct mnt_idmap *idmap,
+				     struct super_block *sb, struct inode *dir,
+				     umode_t mode, dev_t dev, unsigned long flags)
+{
+	int err;
+	struct inode *inode;
+
+	inode = __shmem_get_inode(idmap, sb, dir, mode, dev, flags);
+	if (IS_ERR(inode))
+		return inode;
+
+	err = dquot_initialize(inode);
+	if (err)
+		goto errout;
+
+	err = dquot_alloc_inode(inode);
+	if (err) {
+		dquot_drop(inode);
+		goto errout;
+	}
+	return inode;
+
+errout:
+	inode->i_flags |= S_NOQUOTA;
+	iput(inode);
+	return ERR_PTR(err);
+}
+#else
+static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
+				     struct super_block *sb, struct inode *dir,
+				     umode_t mode, dev_t dev, unsigned long flags)
+{
+	return __shmem_get_inode(idmap, sb, dir, mode, dev, flags);
+}
+#endif /* CONFIG_TMPFS_QUOTA */
+
 #ifdef CONFIG_USERFAULTFD
 int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 			   struct vm_area_struct *dst_vma,
@@ -2555,7 +2663,6 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 
 	spin_lock_irq(&info->lock);
 	info->alloced++;
-	inode->i_blocks += BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 
@@ -3533,6 +3640,7 @@ static ssize_t shmem_listxattr(struct de
 
 static const struct inode_operations shmem_short_symlink_operations = {
 	.getattr	= shmem_getattr,
+	.setattr	= shmem_setattr,
 	.get_link	= simple_get_link,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
@@ -3541,6 +3649,7 @@ static const struct inode_operations shm
 
 static const struct inode_operations shmem_symlink_inode_operations = {
 	.getattr	= shmem_getattr,
+	.setattr	= shmem_setattr,
 	.get_link	= shmem_get_link,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
@@ -3640,6 +3749,9 @@ enum shmem_param {
 	Opt_inode32,
 	Opt_inode64,
 	Opt_noswap,
+	Opt_quota,
+	Opt_usrquota,
+	Opt_grpquota,
 };
 
 static const struct constant_table shmem_param_enums_huge[] = {
@@ -3662,6 +3774,11 @@ const struct fs_parameter_spec shmem_fs_
 	fsparam_flag  ("inode32",	Opt_inode32),
 	fsparam_flag  ("inode64",	Opt_inode64),
 	fsparam_flag  ("noswap",	Opt_noswap),
+#ifdef CONFIG_TMPFS_QUOTA
+	fsparam_flag  ("quota",		Opt_quota),
+	fsparam_flag  ("usrquota",	Opt_usrquota),
+	fsparam_flag  ("grpquota",	Opt_grpquota),
+#endif
 	{}
 };
 
@@ -3753,6 +3870,18 @@ static int shmem_parse_one(struct fs_con
 		ctx->noswap = true;
 		ctx->seen |= SHMEM_SEEN_NOSWAP;
 		break;
+	case Opt_quota:
+		ctx->seen |= SHMEM_SEEN_QUOTA;
+		ctx->quota_types |= (QTYPE_MASK_USR | QTYPE_MASK_GRP);
+		break;
+	case Opt_usrquota:
+		ctx->seen |= SHMEM_SEEN_QUOTA;
+		ctx->quota_types |= QTYPE_MASK_USR;
+		break;
+	case Opt_grpquota:
+		ctx->seen |= SHMEM_SEEN_QUOTA;
+		ctx->quota_types |= QTYPE_MASK_GRP;
+		break;
 	}
 	return 0;
 
@@ -3860,6 +3989,12 @@ static int shmem_reconfigure(struct fs_c
 		goto out;
 	}
 
+	if (ctx->seen & SHMEM_SEEN_QUOTA &&
+	    !sb_any_quota_loaded(fc->root->d_sb)) {
+		err = "Cannot enable quota on remount";
+		goto out;
+	}
+
 	if (ctx->seen & SHMEM_SEEN_HUGE)
 		sbinfo->huge = ctx->huge;
 	if (ctx->seen & SHMEM_SEEN_INUMS)
@@ -3951,6 +4086,9 @@ static void shmem_put_super(struct super
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
+#ifdef CONFIG_TMPFS_QUOTA
+	shmem_disable_quotas(sb);
+#endif
 	free_percpu(sbinfo->ino_batch);
 	percpu_counter_destroy(&sbinfo->used_blocks);
 	mpol_put(sbinfo->mpol);
@@ -4030,6 +4168,17 @@ static int shmem_fill_super(struct super
 #endif
 	uuid_gen(&sb->s_uuid);
 
+#ifdef CONFIG_TMPFS_QUOTA
+	if (ctx->seen & SHMEM_SEEN_QUOTA) {
+		sb->dq_op = &shmem_quota_operations;
+		sb->s_qcop = &dquot_quotactl_sysfile_ops;
+		sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
+
+		if (shmem_enable_quotas(sb, ctx->quota_types))
+			goto failed;
+	}
+#endif /* CONFIG_TMPFS_QUOTA */
+
 	inode = shmem_get_inode(&nop_mnt_idmap, sb, NULL, S_IFDIR | sbinfo->mode, 0,
 				VM_NORESERVE);
 	if (IS_ERR(inode)) {
@@ -4206,6 +4355,9 @@ static const struct super_operations shm
 	.statfs		= shmem_statfs,
 	.show_options	= shmem_show_options,
 #endif
+#ifdef CONFIG_TMPFS_QUOTA
+	.get_dquots	= shmem_get_dquots,
+#endif
 	.evict_inode	= shmem_evict_inode,
 	.drop_inode	= generic_delete_inode,
 	.put_super	= shmem_put_super,
@@ -4271,6 +4423,14 @@ void __init shmem_init(void)
 
 	shmem_init_inodecache();
 
+#ifdef CONFIG_TMPFS_QUOTA
+	error = register_quota_format(&shmem_quota_format);
+	if (error < 0) {
+		pr_err("Could not register quota format\n");
+		goto out3;
+	}
+#endif
+
 	error = register_filesystem(&shmem_fs_type);
 	if (error) {
 		pr_err("Could not register tmpfs\n");
@@ -4295,6 +4455,10 @@ void __init shmem_init(void)
 out1:
 	unregister_filesystem(&shmem_fs_type);
 out2:
+#ifdef CONFIG_TMPFS_QUOTA
+	unregister_quota_format(&shmem_quota_format);
+out3:
+#endif
 	shmem_destroy_inodecache();
 	shm_mnt = ERR_PTR(error);
 }
_

Patches currently in -mm which might be from cem@kernel.org are

shmem-make-shmem_get_inode-return-err_ptr-instead-of-null.patch
shmem-prepare-shmem-quota-infrastructure.patch
shmem-quota-support.patch

