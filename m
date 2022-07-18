Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631AFC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiGRAdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiGRAdJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B585140E0
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 262F7B80EF1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B920CC3411E;
        Mon, 18 Jul 2022 00:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104367;
        bh=pagzm4yYbvN07KXnoyW02XWsK+JI5mURVJIF/AFzISo=;
        h=Date:To:From:Subject:From;
        b=hmuNBwtQHdJ5tdM9WuCglF8FmFf/0nwFyTXsxeAOhcrMBqmI6Fzf8lTSCYonAUll3
         TLkoF1HrW7UQ0WDVCKPEfxQtDCG53PV3vL3q5XaxGu2nBo4llXDxfQ4RDaKGB5Bvwy
         C0Be2NPjxdXghHdvEPWxnFnL5/qxpNkI4ycebSJU=
Date:   Sun, 17 Jul 2022 17:32:47 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] autofs-use-inode-permission-method-for-write-access.patch removed from -mm tree
Message-Id: <20220718003247.B920CC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: autofs: use inode permission method for write access
has been removed from the -mm tree.  Its filename was
     autofs-use-inode-permission-method-for-write-access.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: use inode permission method for write access
Date: Fri, 08 Jul 2022 09:43:01 +0800

Patch series "autofs: misc patches".

This series contains several patches that resulted mostly from comments
made by Al Viro (quite a long time ago now).


This patch (of 5):

Eliminate some code duplication from mkdir/rmdir/symlink/unlink methods by
using the inode operation .permission().

Link: https://lkml.kernel.org/r/165724445154.30914.10970894936827635879.stgit@donald.themaw.net
Link: https://lkml.kernel.org/r/165724458096.30914.13499431569758625806.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/root.c |   63 +++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

--- a/fs/autofs/root.c~autofs-use-inode-permission-method-for-write-access
+++ a/fs/autofs/root.c
@@ -10,6 +10,7 @@
 
 #include "autofs_i.h"
 
+static int autofs_dir_permission(struct user_namespace *, struct inode *, int);
 static int autofs_dir_symlink(struct user_namespace *, struct inode *,
 			      struct dentry *, const char *);
 static int autofs_dir_unlink(struct inode *, struct dentry *);
@@ -50,6 +51,7 @@ const struct file_operations autofs_dir_
 
 const struct inode_operations autofs_dir_inode_operations = {
 	.lookup		= autofs_lookup,
+	.permission	= autofs_dir_permission,
 	.unlink		= autofs_dir_unlink,
 	.symlink	= autofs_dir_symlink,
 	.mkdir		= autofs_dir_mkdir,
@@ -526,11 +528,30 @@ static struct dentry *autofs_lookup(stru
 	return NULL;
 }
 
+static int autofs_dir_permission(struct user_namespace *mnt_userns,
+				 struct inode *inode, int mask)
+{
+	if (mask & MAY_WRITE) {
+		struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
+
+		if (!autofs_oz_mode(sbi))
+			return -EACCES;
+
+		/* autofs_oz_mode() needs to allow path walks when the
+		 * autofs mount is catatonic but the state of an autofs
+		 * file system needs to be preserved over restarts.
+		 */
+		if (sbi->flags & AUTOFS_SBI_CATATONIC)
+			return -EACCES;
+	}
+
+	return generic_permission(mnt_userns, inode, mask);
+}
+
 static int autofs_dir_symlink(struct user_namespace *mnt_userns,
 			      struct inode *dir, struct dentry *dentry,
 			      const char *symname)
 {
-	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	struct inode *inode;
@@ -539,16 +560,6 @@ static int autofs_dir_symlink(struct use
 
 	pr_debug("%s <- %pd\n", symname, dentry);
 
-	if (!autofs_oz_mode(sbi))
-		return -EACCES;
-
-	/* autofs_oz_mode() needs to allow path walks when the
-	 * autofs mount is catatonic but the state of an autofs
-	 * file system needs to be preserved over restarts.
-	 */
-	if (sbi->flags & AUTOFS_SBI_CATATONIC)
-		return -EACCES;
-
 	BUG_ON(!ino);
 
 	autofs_clean_ino(ino);
@@ -601,16 +612,6 @@ static int autofs_dir_unlink(struct inod
 	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
-	if (!autofs_oz_mode(sbi))
-		return -EACCES;
-
-	/* autofs_oz_mode() needs to allow path walks when the
-	 * autofs mount is catatonic but the state of an autofs
-	 * file system needs to be preserved over restarts.
-	 */
-	if (sbi->flags & AUTOFS_SBI_CATATONIC)
-		return -EACCES;
-
 	ino->count--;
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
@@ -683,16 +684,6 @@ static int autofs_dir_rmdir(struct inode
 
 	pr_debug("dentry %p, removing %pd\n", dentry, dentry);
 
-	if (!autofs_oz_mode(sbi))
-		return -EACCES;
-
-	/* autofs_oz_mode() needs to allow path walks when the
-	 * autofs mount is catatonic but the state of an autofs
-	 * file system needs to be preserved over restarts.
-	 */
-	if (sbi->flags & AUTOFS_SBI_CATATONIC)
-		return -EACCES;
-
 	if (ino->count != 1)
 		return -ENOTEMPTY;
 
@@ -726,16 +717,6 @@ static int autofs_dir_mkdir(struct user_
 	struct autofs_info *p_ino;
 	struct inode *inode;
 
-	if (!autofs_oz_mode(sbi))
-		return -EACCES;
-
-	/* autofs_oz_mode() needs to allow path walks when the
-	 * autofs mount is catatonic but the state of an autofs
-	 * file system needs to be preserved over restarts.
-	 */
-	if (sbi->flags & AUTOFS_SBI_CATATONIC)
-		return -EACCES;
-
 	pr_debug("dentry %p, creating %pd\n", dentry, dentry);
 
 	BUG_ON(!ino);
_

Patches currently in -mm which might be from raven@themaw.net are


