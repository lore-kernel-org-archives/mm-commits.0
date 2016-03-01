From: akpm@linux-foundation.org
Subject: + ocfs2-sysfile-interfaces-for-online-file-check-v4.patch added
 to -mm tree
Date: Mon, 29 Feb 2016 16:05:16 -0800
Message-ID: <56d4dcbc.O+n5qSxnFK4FCEvq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbcCAAFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 19:05:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-sysfile-interfaces-for-online-file-check-v4
has been added to the -mm tree.  Its filename is
     ocfs2-sysfile-interfaces-for-online-file-check-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-sysfile-interfaces-for-online-file-check-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-sysfile-interfaces-for-online-file-check-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ocfs2-sysfile-interfaces-for-online-file-check-v4.patch
ocfs2-create-remove-sysfile-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check-v4.patch
ocfs2-add-feature-document-for-online-file-check.patch

