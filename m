Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F9F2907
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 02:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718420159; cv=none; b=J10In8kn+/ktAMyCNVW4w80TYlatQ8GzNWlX3+iY9styZnA7AxmS7NBhAO/3wtQr3ZnD+dn0X8c5/gZSWXTN+GhGG76/Z84D43YRDgW7BA4HJm3buTEtblWgEA9MO504Mh8+VwQz5fica44OBkyugLQ1EHjZPrN2YPlpX7XF+S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718420159; c=relaxed/simple;
	bh=mnR7KUuWKUw/LKGjrZRdF6Kd4m4Sh2JQ2YgbFwh6FRI=;
	h=Date:To:From:Subject:Message-Id; b=KNH6hFthOYkT+sDh6bPD4k9Ry7N7qXLz+JT9BfomnXw5YxNZClIbq16Gq7M1EbSFhEWX5/+5x5WiHD7cui/9VQN0pcCe/UhDcFcUx3sQvlSgxeCPM2aeXzAwAExySPzR8BlwrNyBgftgb/Nm+KdMRq1jeCB0zZQdy7LnJy9G3CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=THmlZEal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="THmlZEal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EC6C2BD10;
	Sat, 15 Jun 2024 02:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718420158;
	bh=mnR7KUuWKUw/LKGjrZRdF6Kd4m4Sh2JQ2YgbFwh6FRI=;
	h=Date:To:From:Subject:From;
	b=THmlZEal7+rWe1zLLA69RPypycurNmwYCwUHBbv52s4GlCW3zW8OJx5VzuhziiaMi
	 uUR/Os7R0NaZlKP29mCPb7AEpJHQ9eQS5GRfSuXb2qi+egrgG5SGjCCBX9UrGEZ+VJ
	 Dhdk7jL08EJyBl5cjEptOiFI5pwEffTEq580TEvM=
Date: Fri, 14 Jun 2024 19:55:58 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,ghe@suse.com,gechangwei@live.cn,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-constify-struct-ocfs2_lock_res_ops.patch added to mm-nonmm-unstable branch
Message-Id: <20240615025558.B3EC6C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: constify struct ocfs2_lock_res_ops
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-constify-struct-ocfs2_lock_res_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-constify-struct-ocfs2_lock_res_ops.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: constify struct ocfs2_lock_res_ops
Date: Fri, 14 Jun 2024 18:25:07 +0200

"struct ocfs2_lock_res_ops" are not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increase overall security.

In order to do it, "struct ocfs2_lock_res" also needs to be adjusted to
this new const qualifier.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  83038	   2632	    400	  86070	  15036	fs/ocfs2/dlmglue.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  83806	   1992	    272	  86070	  15036	fs/ocfs2/dlmglue.o

Link: https://lkml.kernel.org/r/43d3e2ae3a97d3cbe93d6ba6ce48ae5ec04d7526.1718382288.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   28 ++++++++++++++--------------
 fs/ocfs2/ocfs2.h   |    2 +-
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-constify-struct-ocfs2_lock_res_ops
+++ a/fs/ocfs2/dlmglue.c
@@ -221,12 +221,12 @@ struct ocfs2_lock_res_ops {
  */
 #define LOCK_TYPE_USES_LVB		0x2
 
-static struct ocfs2_lock_res_ops ocfs2_inode_rw_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_rw_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_inode_inode_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_inode_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.check_downconvert = ocfs2_check_meta_downconvert,
 	.set_lvb	= ocfs2_set_meta_lvb,
@@ -234,50 +234,50 @@ static struct ocfs2_lock_res_ops ocfs2_i
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_super_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_super_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_rename_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_rename_lops = {
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_nfs_sync_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_nfs_sync_lops = {
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_trim_fs_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_trim_fs_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
 	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
 	.downconvert_worker = ocfs2_dentry_convert_worker,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_flock_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_flock_lops = {
 	.get_osb	= ocfs2_get_file_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
 	.set_lvb	= ocfs2_set_qinfo_lvb,
 	.get_osb	= ocfs2_get_qinfo_osb,
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH | LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
 	.check_downconvert = ocfs2_check_refcount_downconvert,
 	.downconvert_worker = ocfs2_refcount_convert_worker,
 	.flags		= 0,
@@ -510,7 +510,7 @@ static inline void ocfs2_init_start_time
 static void ocfs2_lock_res_init_common(struct ocfs2_super *osb,
 				       struct ocfs2_lock_res *res,
 				       enum ocfs2_lock_type type,
-				       struct ocfs2_lock_res_ops *ops,
+				       const struct ocfs2_lock_res_ops *ops,
 				       void *priv)
 {
 	res->l_type          = type;
@@ -553,7 +553,7 @@ void ocfs2_inode_lock_res_init(struct oc
 			       unsigned int generation,
 			       struct inode *inode)
 {
-	struct ocfs2_lock_res_ops *ops;
+	const struct ocfs2_lock_res_ops *ops;
 
 	switch(type) {
 		case OCFS2_LOCK_TYPE_RW:
--- a/fs/ocfs2/ocfs2.h~ocfs2-constify-struct-ocfs2_lock_res_ops
+++ a/fs/ocfs2/ocfs2.h
@@ -154,7 +154,7 @@ struct ocfs2_lock_stats {
 
 struct ocfs2_lock_res {
 	void                    *l_priv;
-	struct ocfs2_lock_res_ops *l_ops;
+	const struct ocfs2_lock_res_ops *l_ops;
 
 
 	struct list_head         l_blocked_list;
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
most-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
ocfs2-constify-struct-ocfs2_lock_res_ops.patch
ocfs2-constify-struct-ocfs2_stack_operations.patch

