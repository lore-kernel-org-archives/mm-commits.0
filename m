From: akpm@linux-foundation.org
Subject: [merged] const-struct-quota_format_ops.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:54 -0800
Message-ID: <200911091955.nA9JtsE4024993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbZKITzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     const: struct quota_format_ops
has been removed from the -mm tree.  Its filename was
     const-struct-quota_format_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: struct quota_format_ops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ocfs2/quota_local.c~const-struct-quota_format_ops fs/ocfs2/quota_local.c
--- a/fs/ocfs2/quota_local.c~const-struct-quota_format_ops
+++ a/fs/ocfs2/quota_local.c
@@ -1325,7 +1325,7 @@ out:
 	return status;
 }
 
-static struct quota_format_ops ocfs2_format_ops = {
+static const struct quota_format_ops ocfs2_format_ops = {
 	.check_quota_file	= ocfs2_local_check_quota_file,
 	.read_file_info		= ocfs2_local_read_info,
 	.write_file_info	= ocfs2_global_write_info,
diff -puN fs/quota/quota_v1.c~const-struct-quota_format_ops fs/quota/quota_v1.c
--- a/fs/quota/quota_v1.c~const-struct-quota_format_ops
+++ a/fs/quota/quota_v1.c
@@ -204,7 +204,7 @@ out:
 	return ret;
 }
 
-static struct quota_format_ops v1_format_ops = {
+static const struct quota_format_ops v1_format_ops = {
 	.check_quota_file	= v1_check_quota_file,
 	.read_file_info		= v1_read_file_info,
 	.write_file_info	= v1_write_file_info,
diff -puN fs/quota/quota_v2.c~const-struct-quota_format_ops fs/quota/quota_v2.c
--- a/fs/quota/quota_v2.c~const-struct-quota_format_ops
+++ a/fs/quota/quota_v2.c
@@ -207,7 +207,7 @@ static int v2_free_file_info(struct supe
 	return 0;
 }
 
-static struct quota_format_ops v2_format_ops = {
+static const struct quota_format_ops v2_format_ops = {
 	.check_quota_file	= v2_check_quota_file,
 	.read_file_info		= v2_read_file_info,
 	.write_file_info	= v2_write_file_info,
diff -puN include/linux/quota.h~const-struct-quota_format_ops include/linux/quota.h
--- a/include/linux/quota.h~const-struct-quota_format_ops
+++ a/include/linux/quota.h
@@ -334,7 +334,7 @@ struct quotactl_ops {
 
 struct quota_format_type {
 	int qf_fmt_id;	/* Quota format id */
-	struct quota_format_ops *qf_ops;	/* Operations of format */
+	const struct quota_format_ops *qf_ops;	/* Operations of format */
 	struct module *qf_owner;		/* Module implementing quota format */
 	struct quota_format_type *qf_next;
 };
@@ -394,7 +394,7 @@ struct quota_info {
 	struct rw_semaphore dqptr_sem;		/* serialize ops using quota_info struct, pointers from inode to dquots */
 	struct inode *files[MAXQUOTAS];		/* inodes of quotafiles */
 	struct mem_dqinfo info[MAXQUOTAS];	/* Information for each quota type */
-	struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
+	const struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
 };
 
 int register_quota_format(struct quota_format_type *fmt);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
uml-irq-register-race-condition.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

