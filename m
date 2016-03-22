From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-sysfile-interfaces-for-online-file-check-v4.patch removed from -mm
 tree
Date: Tue, 22 Mar 2016 13:53:05 -0700
Message-ID: <56f1b0b1.0n4e/YNuHE5jRnh9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbcCVUxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-sysfile-interfaces-for-online-file-check-v4
has been removed from the -mm tree.  Its filename was
     ocfs2-sysfile-interfaces-for-online-file-check-v4.patch

This patch was dropped because it was folded into ocfs2-sysfile-interfaces-for-online-file-check.patch

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2-sysfile-interfaces-for-online-file-check-v4

Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |   11 ++++++-----
 fs/ocfs2/filecheck.h |    3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-sysfile-interfaces-for-online-file-check-v4 fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-sysfile-interfaces-for-online-file-check-v4
+++ a/fs/ocfs2/filecheck.c
@@ -5,7 +5,7 @@
  *
  * Code which implements online file check.
  *
- * Copyright (C) 2015 Novell.  All rights reserved.
+ * Copyright (C) 2016 SuSE.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -44,6 +44,7 @@ static const char * const ocfs2_filechec
 	"FAILED",
 	"INPROGRESS",
 	"READONLY",
+	"INJBD",
 	"INVALIDINO",
 	"BLOCKECC",
 	"BLOCKNO",
@@ -86,8 +87,8 @@ struct ocfs2_filecheck_entry {
 	struct list_head fe_list;
 	unsigned long fe_ino;
 	unsigned int fe_type;
-	unsigned short fe_done:1;
-	unsigned short fe_status:15;
+	unsigned int fe_done:1;
+	unsigned int fe_status:31;
 };
 
 struct ocfs2_filecheck_args {
@@ -494,11 +495,11 @@ ocfs2_filecheck_done_entry(struct ocfs2_
 	spin_unlock(&ent->fs_fcheck->fc_lock);
 }
 
-static unsigned short
+static unsigned int
 ocfs2_filecheck_handle(struct super_block *sb,
 		       unsigned long ino, unsigned int flags)
 {
-	unsigned short ret = OCFS2_FILECHECK_ERR_SUCCESS;
+	unsigned int ret = OCFS2_FILECHECK_ERR_SUCCESS;
 	struct inode *inode = NULL;
 	int rc;
 
diff -puN fs/ocfs2/filecheck.h~ocfs2-sysfile-interfaces-for-online-file-check-v4 fs/ocfs2/filecheck.h
--- a/fs/ocfs2/filecheck.h~ocfs2-sysfile-interfaces-for-online-file-check-v4
+++ a/fs/ocfs2/filecheck.h
@@ -5,7 +5,7 @@
  *
  * Online file check.
  *
- * Copyright (C) 2015 Novell.  All rights reserved.
+ * Copyright (C) 2016 SuSE.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -31,6 +31,7 @@ enum {
 	OCFS2_FILECHECK_ERR_FAILED = 1000,	/* Other failure */
 	OCFS2_FILECHECK_ERR_INPROGRESS,		/* In progress */
 	OCFS2_FILECHECK_ERR_READONLY,		/* Read only */
+	OCFS2_FILECHECK_ERR_INJBD,		/* Buffer in jbd */
 	OCFS2_FILECHECK_ERR_INVALIDINO,		/* Invalid ino */
 	OCFS2_FILECHECK_ERR_BLOCKECC,		/* Block ecc */
 	OCFS2_FILECHECK_ERR_BLOCKNO,		/* Block number */
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-export-ocfs2_kset-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check.patch
ocfs2-create-remove-sysfile-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check-v4.patch
ocfs2-add-feature-document-for-online-file-check.patch

