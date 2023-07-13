Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42768C001E0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjGMRLy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjGMRLr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:11:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ADD1BF3
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2E1161B0A
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2399EC433C8;
        Thu, 13 Jul 2023 17:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268305;
        bh=ZzMnvXItlIXVAPqASL5cJcdRKPX6POIbm+iu0kRtHWk=;
        h=Date:To:From:Subject:From;
        b=AsfIv0J8KY670YQ6xytqPKZEjxPwKO8m42/JGAiwtCST+SaUgQyxVR8L8PXPKjuzB
         vweOlXhTQpagzbIGPFx3TGSco72VI/25derFUg+6TnGLaSFLXSe8bkn34KpNar5saR
         YRzwtdhwO9JOWF/9r81LeJpUK/TWVR21qbc/9H58=
Date:   Thu, 13 Jul 2023 10:11:44 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        hughd@google.com, djwong@kernel.org, cmaiolino@redhat.com,
        brauner@kernel.org, lczerner@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + add-default-quota-limit-mount-options.patch added to mm-unstable branch
Message-Id: <20230713171145.2399EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: add default quota limit mount options
has been added to the -mm mm-unstable branch.  Its filename is
     add-default-quota-limit-mount-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/add-default-quota-limit-mount-options.patch

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
From: Lukas Czerner <lczerner@redhat.com>
Subject: add default quota limit mount options
Date: Thu, 13 Jul 2023 15:48:48 +0200

Allow system administrator to set default global quota limits at tmpfs
mount time.

Link: https://lkml.kernel.org/r/20230713134848.249779-7-cem@kernel.org
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.rst |   34 ++++++++++----
 include/linux/shmem_fs.h            |    8 +++
 mm/shmem.c                          |   61 ++++++++++++++++++++++++++
 mm/shmem_quota.c                    |   34 ++++++++++++++
 4 files changed, 127 insertions(+), 10 deletions(-)

--- a/Documentation/filesystems/tmpfs.rst~add-default-quota-limit-mount-options
+++ a/Documentation/filesystems/tmpfs.rst
@@ -132,15 +132,31 @@ for emergency or testing purposes. The v
 
 tmpfs also supports quota with the following mount options
 
-========  =============================================================
-quota     User and group quota accounting and enforcement is enabled on
-          the mount. Tmpfs is using hidden system quota files that are
-          initialized on mount.
-usrquota  User quota accounting and enforcement is enabled on the
-          mount.
-grpquota  Group quota accounting and enforcement is enabled on the
-          mount.
-========  =============================================================
+======================== =================================================
+quota                    User and group quota accounting and enforcement
+                         is enabled on the mount. Tmpfs is using hidden
+                         system quota files that are initialized on mount.
+usrquota                 User quota accounting and enforcement is enabled
+                         on the mount.
+grpquota                 Group quota accounting and enforcement is enabled
+                         on the mount.
+usrquota_block_hardlimit Set global user quota block hard limit.
+usrquota_inode_hardlimit Set global user quota inode hard limit.
+grpquota_block_hardlimit Set global group quota block hard limit.
+grpquota_inode_hardlimit Set global group quota inode hard limit.
+======================== =================================================
+
+None of the quota related mount options can be set or changed on remount.
+
+Quota limit parameters accept a suffix k, m or g for kilo, mega and giga
+and can't be changed on remount. Default global quota limits are taking
+effect for any and all user/group/project except root the first time the
+quota entry for user/group/project id is being accessed - typically the
+first time an inode with a particular id ownership is being created after
+the mount. In other words, instead of the limits being initialized to zero,
+they are initialized with the particular value provided with these mount
+options. The limits can be changed for any user/group id at any time as they
+normally can be.
 
 Note that tmpfs quotas do not support user namespaces so no uid/gid
 translation is done if quotas are enabled inside user namespaces.
--- a/include/linux/shmem_fs.h~add-default-quota-limit-mount-options
+++ a/include/linux/shmem_fs.h
@@ -42,6 +42,13 @@ struct shmem_inode_info {
 	(FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL | FS_NOATIME_FL)
 #define SHMEM_FL_INHERITED		(FS_NODUMP_FL | FS_NOATIME_FL)
 
+struct shmem_quota_limits {
+	qsize_t usrquota_bhardlimit; /* Default user quota block hard limit */
+	qsize_t usrquota_ihardlimit; /* Default user quota inode hard limit */
+	qsize_t grpquota_bhardlimit; /* Default group quota block hard limit */
+	qsize_t grpquota_ihardlimit; /* Default group quota inode hard limit */
+};
+
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
 	struct percpu_counter used_blocks;  /* How many are allocated */
@@ -60,6 +67,7 @@ struct shmem_sb_info {
 	spinlock_t shrinklist_lock;   /* Protects shrinklist */
 	struct list_head shrinklist;  /* List of shinkable inodes */
 	unsigned long shrinklist_len; /* Length of shrinklist */
+	struct shmem_quota_limits qlimits; /* Default quota limits */
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
--- a/mm/shmem.c~add-default-quota-limit-mount-options
+++ a/mm/shmem.c
@@ -118,6 +118,7 @@ struct shmem_options {
 	int seen;
 	bool noswap;
 	unsigned short quota_types;
+	struct shmem_quota_limits qlimits;
 #define SHMEM_SEEN_BLOCKS 1
 #define SHMEM_SEEN_INODES 2
 #define SHMEM_SEEN_HUGE 4
@@ -3752,6 +3753,10 @@ enum shmem_param {
 	Opt_quota,
 	Opt_usrquota,
 	Opt_grpquota,
+	Opt_usrquota_block_hardlimit,
+	Opt_usrquota_inode_hardlimit,
+	Opt_grpquota_block_hardlimit,
+	Opt_grpquota_inode_hardlimit,
 };
 
 static const struct constant_table shmem_param_enums_huge[] = {
@@ -3778,6 +3783,10 @@ const struct fs_parameter_spec shmem_fs_
 	fsparam_flag  ("quota",		Opt_quota),
 	fsparam_flag  ("usrquota",	Opt_usrquota),
 	fsparam_flag  ("grpquota",	Opt_grpquota),
+	fsparam_string("usrquota_block_hardlimit", Opt_usrquota_block_hardlimit),
+	fsparam_string("usrquota_inode_hardlimit", Opt_usrquota_inode_hardlimit),
+	fsparam_string("grpquota_block_hardlimit", Opt_grpquota_block_hardlimit),
+	fsparam_string("grpquota_inode_hardlimit", Opt_grpquota_inode_hardlimit),
 #endif
 	{}
 };
@@ -3882,6 +3891,42 @@ static int shmem_parse_one(struct fs_con
 		ctx->seen |= SHMEM_SEEN_QUOTA;
 		ctx->quota_types |= QTYPE_MASK_GRP;
 		break;
+	case Opt_usrquota_block_hardlimit:
+		size = memparse(param->string, &rest);
+		if (*rest || !size)
+			goto bad_value;
+		if (size > SHMEM_QUOTA_MAX_SPC_LIMIT)
+			return invalfc(fc,
+				       "User quota block hardlimit too large.");
+		ctx->qlimits.usrquota_bhardlimit = size;
+		break;
+	case Opt_grpquota_block_hardlimit:
+		size = memparse(param->string, &rest);
+		if (*rest || !size)
+			goto bad_value;
+		if (size > SHMEM_QUOTA_MAX_SPC_LIMIT)
+			return invalfc(fc,
+				       "Group quota block hardlimit too large.");
+		ctx->qlimits.grpquota_bhardlimit = size;
+		break;
+	case Opt_usrquota_inode_hardlimit:
+		size = memparse(param->string, &rest);
+		if (*rest || !size)
+			goto bad_value;
+		if (size > SHMEM_QUOTA_MAX_INO_LIMIT)
+			return invalfc(fc,
+				       "User quota inode hardlimit too large.");
+		ctx->qlimits.usrquota_ihardlimit = size;
+		break;
+	case Opt_grpquota_inode_hardlimit:
+		size = memparse(param->string, &rest);
+		if (*rest || !size)
+			goto bad_value;
+		if (size > SHMEM_QUOTA_MAX_INO_LIMIT)
+			return invalfc(fc,
+				       "Group quota inode hardlimit too large.");
+		ctx->qlimits.grpquota_ihardlimit = size;
+		break;
 	}
 	return 0;
 
@@ -3995,6 +4040,18 @@ static int shmem_reconfigure(struct fs_c
 		goto out;
 	}
 
+#ifdef CONFIG_TMPFS_QUOTA
+#define CHANGED_LIMIT(name)						\
+	(ctx->qlimits.name## hardlimit &&				\
+	(ctx->qlimits.name## hardlimit != sbinfo->qlimits.name## hardlimit))
+
+	if (CHANGED_LIMIT(usrquota_b) || CHANGED_LIMIT(usrquota_i) ||
+	    CHANGED_LIMIT(grpquota_b) || CHANGED_LIMIT(grpquota_i)) {
+		err = "Cannot change global quota limit on remount";
+		goto out;
+	}
+#endif /* CONFIG_TMPFS_QUOTA */
+
 	if (ctx->seen & SHMEM_SEEN_HUGE)
 		sbinfo->huge = ctx->huge;
 	if (ctx->seen & SHMEM_SEEN_INUMS)
@@ -4174,6 +4231,10 @@ static int shmem_fill_super(struct super
 		sb->s_qcop = &dquot_quotactl_sysfile_ops;
 		sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 
+		/* Copy the default limits from ctx into sbinfo */
+		memcpy(&sbinfo->qlimits, &ctx->qlimits,
+		       sizeof(struct shmem_quota_limits));
+
 		if (shmem_enable_quotas(sb, ctx->quota_types))
 			goto failed;
 	}
--- a/mm/shmem_quota.c~add-default-quota-limit-mount-options
+++ a/mm/shmem_quota.c
@@ -166,6 +166,7 @@ static int shmem_acquire_dquot(struct dq
 {
 	struct mem_dqinfo *info = sb_dqinfo(dquot->dq_sb, dquot->dq_id.type);
 	struct rb_node **n = &((struct rb_root *)info->dqi_priv)->rb_node;
+	struct shmem_sb_info *sbinfo = dquot->dq_sb->s_fs_info;
 	struct rb_node *parent = NULL, *new_node = NULL;
 	struct quota_id *new_entry, *entry;
 	qid_t id = from_kqid(&init_user_ns, dquot->dq_id);
@@ -195,6 +196,14 @@ static int shmem_acquire_dquot(struct dq
 	}
 
 	new_entry->id = id;
+	if (dquot->dq_id.type == USRQUOTA) {
+		new_entry->bhardlimit = sbinfo->qlimits.usrquota_bhardlimit;
+		new_entry->ihardlimit = sbinfo->qlimits.usrquota_ihardlimit;
+	} else if (dquot->dq_id.type == GRPQUOTA) {
+		new_entry->bhardlimit = sbinfo->qlimits.grpquota_bhardlimit;
+		new_entry->ihardlimit = sbinfo->qlimits.grpquota_ihardlimit;
+	}
+
 	new_node = &new_entry->node;
 	rb_link_node(new_node, parent, n);
 	rb_insert_color(new_node, (struct rb_root *)info->dqi_priv);
@@ -224,6 +233,29 @@ out_unlock:
 	return ret;
 }
 
+static bool shmem_is_empty_dquot(struct dquot *dquot)
+{
+	struct shmem_sb_info *sbinfo = dquot->dq_sb->s_fs_info;
+	qsize_t bhardlimit;
+	qsize_t ihardlimit;
+
+	if (dquot->dq_id.type == USRQUOTA) {
+		bhardlimit = sbinfo->qlimits.usrquota_bhardlimit;
+		ihardlimit = sbinfo->qlimits.usrquota_ihardlimit;
+	} else if (dquot->dq_id.type == GRPQUOTA) {
+		bhardlimit = sbinfo->qlimits.grpquota_bhardlimit;
+		ihardlimit = sbinfo->qlimits.grpquota_ihardlimit;
+	}
+
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
+		(dquot->dq_dqb.dqb_curspace == 0 &&
+		 dquot->dq_dqb.dqb_curinodes == 0 &&
+		 dquot->dq_dqb.dqb_bhardlimit == bhardlimit &&
+		 dquot->dq_dqb.dqb_ihardlimit == ihardlimit))
+		return true;
+
+	return false;
+}
 /*
  * Store limits from dquot in the tree unless it's fake. If it is fake
  * remove the id from the tree since there is no useful information in
@@ -261,7 +293,7 @@ static int shmem_release_dquot(struct dq
 	return -ENOENT;
 
 found:
-	if (test_bit(DQ_FAKE_B, &dquot->dq_flags)) {
+	if (shmem_is_empty_dquot(dquot)) {
 		/* Remove entry from the tree */
 		rb_erase(&entry->node, info->dqi_priv);
 		kfree(entry);
_

Patches currently in -mm which might be from lczerner@redhat.com are

shmem-make-shmem_inode_acct_block-return-error.patch
add-default-quota-limit-mount-options.patch

