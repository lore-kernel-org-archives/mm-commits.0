Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497793BBFA5
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 05:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789623767; cv=none; b=YjL9GODEmcfnBt2LuKSLACaQKpfNbcg0vaU+CZahz+Vl6TScZgLsLlefoczViiph9vMk1pO9MrMsCeXFaWfGoBHf+YjX77KxpECrSTygynK0138kkudyX3FjCjBp1nLqIiYZvshoaBvY9IW+Se8s8YYPPgXSy9oEI5P5UWs6A3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789623767; c=relaxed/simple;
	bh=38fi7Nfn0gJRsgmamtx4sXvnIVYMEdVgW8mka82X6TA=;
	h=Date:To:From:Subject:Message-Id; b=TfLkrboEV7m/oeiYfoW+eodDgdLt1fDw8TTsiS6oYcco3AevEaYKdwGFIxVajBWPONimxCZIiIfCF22P8FatmyTm8l2Qz5/GFTMHp4kRBpEjkr3WcoBAbs/xtoydY0B8cjGsEtvgz64Lq7Y91NnBsdFdc6F3htBFSEYoQhkNwsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMh1A+2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMh1A+2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DF51F000FF;
	Thu, 17 Sep 2026 05:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789623765;
	bh=cVmKT8yaRfOXEcgyjhXjHwiJSejgtmNsIZT2oPDJXt4=;
	h=Date:To:From:Subject;
	b=fMh1A+2THFmJ/mnyibpSwXLZvOGS0iRmbK5v/RfQ6kB+2n3E6/5njofQVgYQKL1QG
	 fOUCCKCOfHEayESk63r2q5MmD20trPaAZYaMkouFd55VYfYpnJkEX7jeGacap+St3s
	 lRmtiROSn7Uy33HzSfuS9iYkSKIw+qNhYew9smQo=
Date: Wed, 16 Sep 2026 22:42:44 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,daniel@iogearbox.net,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-retain-all-security-xattrs-during-inode-creation.patch added to mm-nonmm-unstable branch
Message-Id: <20260917054245.13DF51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: retain all security xattrs during inode creation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-retain-all-security-xattrs-during-inode-creation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-retain-all-security-xattrs-during-inode-creation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: retain all security xattrs during inode creation
Date: Thu, 17 Sep 2026 09:48:25 +0800

When creating a new inode, ocfs2_init_security_get() stores the security
xattr returned by the LSM framework in ocfs2_security_xattr_info so that
it can be written later within the same transaction.  But
ocfs2_initxattrs() only ever looks at the first element of the xattr
array, and it keeps the name as a bare pointer into memory owned by the
security layer instead of copying it.  The value, by contrast, is already
duplicated with kmemdup().

With stacked LSMs, security_inode_init_security() provides one xattr per
LSM, so all labels but the first are silently dropped and never written to
disk, leaving newly created files without the security xattrs the other
LSMs rely on.

The borrowed name is not an outright bug with the LSMs in tree today:
security_inode_init_security() frees only ->value once the callback
returns, and documents ->name as the attribute name suffix, so the pointer
stays valid for as long as ocfs2 uses it.  It is fragile though, as an LSM
that allocates the name together with the value would turn it into a
use-after-free, so the rework below copies the names as well.

Fix this by storing copies of all the security xattrs: allocate an array
in ocfs2_initxattrs(), copy the names and values, account for all of them
in the credit calculations, and write each one in
ocfs2_init_security_set().

While at it, switch the allocations from GFP_KERNEL to GFP_NOFS.  The
callback runs in the inode creation path with the parent directory locked,
and the security layer allocates the very same xattr array with GFP_NOFS,
so direct reclaim must not be allowed to recurse into the filesystem from
here.

Link: https://lore.kernel.org/20260917014825.678947-1-joseph.qi@linux.alibaba.com
Fixes: de3004c874e7 ("ocfs2: Switch to security_inode_init_security()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
---

 fs/ocfs2/namei.c |    6 --
 fs/ocfs2/xattr.c |  133 +++++++++++++++++++++++++++++++++++----------
 fs/ocfs2/xattr.h |   12 +++-
 3 files changed, 116 insertions(+), 35 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-retain-all-security-xattrs-during-inode-creation
+++ a/fs/ocfs2/namei.c
@@ -248,7 +248,6 @@ static int ocfs2_mknod(struct mnt_idmap
 	int want_meta = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
-		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota_inode = 0;
@@ -475,7 +474,7 @@ leave:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.value);
+	ocfs2_free_security_xattrs(&si);
 
 	ocfs2_acl_init_release(&acl_state);
 
@@ -1831,7 +1830,6 @@ static int ocfs2_symlink(struct mnt_idma
 	int want_clusters = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
-		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota = 0, did_quota_inode = 0;
@@ -2063,7 +2061,7 @@ bail:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.value);
+	ocfs2_free_security_xattrs(&si);
 	ocfs2_free_dir_lookup_result(&lookup);
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
--- a/fs/ocfs2/xattr.c~ocfs2-retain-all-security-xattrs-during-inode-creation
+++ a/fs/ocfs2/xattr.c
@@ -643,10 +643,15 @@ int ocfs2_calc_security_init(struct inod
 			     int *xattr_credits,
 			     struct ocfs2_alloc_context **xattr_ac)
 {
+	int i;
 	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
-	int s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
-						 si->value_len);
+	int s_size = 0;
+
+	for (i = 0; i < si->count; i++)
+		s_size += ocfs2_xattr_entry_real_size(
+				strlen(si->xattrs[i].name),
+				si->xattrs[i].value_len);
 
 	/*
 	 * The max space of security xattr taken inline is
@@ -663,14 +668,27 @@ int ocfs2_calc_security_init(struct inod
 		*xattr_credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
 	}
 
+	/*
+	 * when blocksize = 512, the security xattrs may not fit in the
+	 * single block reserved above and a bucket has to be allocated
+	 * for them, so reserve the cluster it needs as well.
+	 */
+	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE &&
+	    s_size > OCFS2_XATTR_FREE_IN_BLOCK(dir)) {
+		*want_clusters += 1;
+		*xattr_credits += ocfs2_blocks_per_xattr_bucket(dir->i_sb);
+	}
+
 	/* reserve clusters for xattr value which will be set in B tree*/
-	if (si->value_len > OCFS2_XATTR_INLINE_SIZE) {
-		int new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
-							    si->value_len);
-
-		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
-							   new_clusters);
-		*want_clusters += new_clusters;
+	for (i = 0; i < si->count; i++) {
+		if (si->xattrs[i].value_len > OCFS2_XATTR_INLINE_SIZE) {
+			int new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
+						si->xattrs[i].value_len);
+
+			*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
+								   new_clusters);
+			*want_clusters += new_clusters;
+		}
 	}
 	return ret;
 }
@@ -680,12 +698,16 @@ void ocfs2_calc_xattr_init(struct inode
 			   int *want_clusters, int *xattr_credits,
 			   int *want_meta, struct ocfs2_acl_state *acl_state)
 {
+	int i;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
 
-	if (si->enable)
-		s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
-						     si->value_len);
+	if (si->enable) {
+		for (i = 0; i < si->count; i++)
+			s_size += ocfs2_xattr_entry_real_size(
+					strlen(si->xattrs[i].name),
+					si->xattrs[i].value_len);
+	}
 
 	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
 		if (acl_state->default_acl && S_ISDIR(mode)) {
@@ -732,12 +754,14 @@ void ocfs2_calc_xattr_init(struct inode
 	 * reserve credits and clusters for xattrs which has large value
 	 * and have to be set outside
 	 */
-	if (si->enable && si->value_len > OCFS2_XATTR_INLINE_SIZE) {
-		new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
-							si->value_len);
-		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
-							   new_clusters);
-		*want_clusters += new_clusters;
+	for (i = 0; si->enable && i < si->count; i++) {
+		if (si->xattrs[i].value_len > OCFS2_XATTR_INLINE_SIZE) {
+			new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
+						si->xattrs[i].value_len);
+			*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
+								   new_clusters);
+			*want_clusters += new_clusters;
+		}
 	}
 	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
 		if (acl_state->default_acl && S_ISDIR(mode)) {
@@ -7635,17 +7659,46 @@ static int ocfs2_initxattrs(struct inode
 {
 	struct ocfs2_security_xattr_info *si = fs_info;
 	const struct xattr *xattr;
+	struct ocfs2_security_xattr *xattrs;
+	int count = 0, i;
 	int err = 0;
 
 	if (si) {
-		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
-				    GFP_KERNEL);
-		if (!si->value)
+		for (xattr = xattr_array; xattr->name != NULL; xattr++)
+			count++;
+
+		xattrs = kcalloc(count, sizeof(*xattrs), GFP_NOFS);
+		if (!xattrs)
 			return -ENOMEM;
 
-		si->name = xattr_array->name;
-		si->value_len = xattr_array->value_len;
+		for (i = 0; i < count; i++) {
+			xattrs[i].name = kstrdup(xattr_array[i].name, GFP_NOFS);
+			if (!xattrs[i].name) {
+				err = -ENOMEM;
+				goto out_err;
+			}
+
+			xattrs[i].value = kmemdup(xattr_array[i].value,
+						  xattr_array[i].value_len,
+						  GFP_NOFS);
+			if (!xattrs[i].value) {
+				err = -ENOMEM;
+				goto out_err;
+			}
+			xattrs[i].value_len = xattr_array[i].value_len;
+		}
+
+		si->xattrs = xattrs;
+		si->count = count;
 		return 0;
+
+out_err:
+		for (; i >= 0; i--) {
+			kfree(xattrs[i].name);
+			kfree(xattrs[i].value);
+		}
+		kfree(xattrs);
+		return err;
 	}
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
@@ -7658,6 +7711,19 @@ static int ocfs2_initxattrs(struct inode
 	return err;
 }
 
+void ocfs2_free_security_xattrs(struct ocfs2_security_xattr_info *si)
+{
+	int i;
+
+	for (i = 0; i < si->count; i++) {
+		kfree(si->xattrs[i].name);
+		kfree(si->xattrs[i].value);
+	}
+	kfree(si->xattrs);
+	si->xattrs = NULL;
+	si->count = 0;
+}
+
 int ocfs2_init_security_get(struct inode *inode,
 			    struct inode *dir,
 			    const struct qstr *qstr,
@@ -7675,7 +7741,7 @@ int ocfs2_init_security_get(struct inode
 		 * security_inode_init_security() does not return -EOPNOTSUPP,
 		 * we have to check the xattr ourselves.
 		 */
-		if (!ret && !si->name)
+		if (!ret && !si->count)
 			si->enable = 0;
 
 		return ret;
@@ -7692,10 +7758,21 @@ int ocfs2_init_security_set(handle_t *ha
 			    struct ocfs2_alloc_context *xattr_ac,
 			    struct ocfs2_alloc_context *data_ac)
 {
-	return ocfs2_xattr_set_handle(handle, inode, di_bh,
-				     OCFS2_XATTR_INDEX_SECURITY,
-				     si->name, si->value, si->value_len, 0,
-				     xattr_ac, data_ac);
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < si->count; i++) {
+		ret = ocfs2_xattr_set_handle(handle, inode, di_bh,
+					     OCFS2_XATTR_INDEX_SECURITY,
+					     si->xattrs[i].name,
+					     si->xattrs[i].value,
+					     si->xattrs[i].value_len, 0,
+					     xattr_ac, data_ac);
+		if (ret)
+			break;
+	}
+
+	return ret;
 }
 
 const struct xattr_handler ocfs2_xattr_security_handler = {
--- a/fs/ocfs2/xattr.h~ocfs2-retain-all-security-xattrs-during-inode-creation
+++ a/fs/ocfs2/xattr.h
@@ -20,13 +20,18 @@ enum ocfs2_xattr_type {
 	OCFS2_XATTR_MAX
 };
 
-struct ocfs2_security_xattr_info {
-	int enable;
-	const char *name;
+struct ocfs2_security_xattr {
+	char *name;
 	void *value;
 	size_t value_len;
 };
 
+struct ocfs2_security_xattr_info {
+	int enable;
+	struct ocfs2_security_xattr *xattrs;
+	int count;
+};
+
 extern const struct xattr_handler ocfs2_xattr_user_handler;
 extern const struct xattr_handler ocfs2_xattr_trusted_handler;
 extern const struct xattr_handler ocfs2_xattr_security_handler;
@@ -49,6 +54,7 @@ int ocfs2_xattr_remove(struct inode *, s
 int ocfs2_init_security_get(struct inode *, struct inode *,
 			    const struct qstr *,
 			    struct ocfs2_security_xattr_info *);
+void ocfs2_free_security_xattrs(struct ocfs2_security_xattr_info *);
 int ocfs2_init_security_set(handle_t *, struct inode *,
 			    struct buffer_head *,
 			    struct ocfs2_security_xattr_info *,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-make-ocfs2_calc_xattr_init-return-void.patch
ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch
ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch
ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch
ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch
ocfs2-retain-all-security-xattrs-during-inode-creation.patch

