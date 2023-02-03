Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603D2C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjBCGvN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBCGvC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1E9DBD4
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74509B82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A60C433EF;
        Fri,  3 Feb 2023 06:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407053;
        bh=P25IIHFUFjnwZg09ltqvNPlwyZnpw/6iL0W+2jD0zVM=;
        h=Date:To:From:Subject:From;
        b=Z9PhXpTXfidLf5iYyE9WTyYddnIumDxAop+iuzKVaIQb03wz57txjFhAEGyR3E/w4
         nv6GqhUcSNjLG8oViOSzIWXZpHg672V0ejXJvY/+nU1zttZF+7CSNsSBu4lnLNK5hq
         VMPDLG1fFYwyu1ajIyO851l0/V5Kwb1lzqO8HCwM=
Date:   Thu, 02 Feb 2023 22:50:52 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        brauner@kernel.org, akpm@linux-foudation.org,
        xupengfei@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hfsplus-remove-unnecessary-variable-initialization.patch removed from -mm tree
Message-Id: <20230203065053.11A60C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfsplus: remove unnecessary variable initialization
has been removed from the -mm tree.  Its filename was
     hfsplus-remove-unnecessary-variable-initialization.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: XU pengfei <xupengfei@nfschina.com>
Subject: hfsplus: remove unnecessary variable initialization
Date: Wed, 21 Dec 2022 11:21:20 +0800

Variables are assigned first and then used.  Initialization is not
required.

[akpm@linux-foundation.org: give hfsplus_listxattr:key_len narrower scope]
Link: https://lkml.kernel.org/r/20221221032119.10037-1-xupengfei@nfschina.com
Signed-off-by: XU pengfei <xupengfei@nfschina.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hfsplus/xattr.c~hfsplus-remove-unnecessary-variable-initialization
+++ a/fs/hfsplus/xattr.c
@@ -257,7 +257,7 @@ end_attr_file_creation:
 int __hfsplus_setxattr(struct inode *inode, const char *name,
 			const void *value, size_t size, int flags)
 {
-	int err = 0;
+	int err;
 	struct hfs_find_data cat_fd;
 	hfsplus_cat_entry entry;
 	u16 cat_entry_flags, cat_entry_type;
@@ -494,7 +494,7 @@ ssize_t __hfsplus_getxattr(struct inode
 	__be32 xattr_record_type;
 	u32 record_type;
 	u16 record_length = 0;
-	ssize_t res = 0;
+	ssize_t res;
 
 	if ((!S_ISREG(inode->i_mode) &&
 			!S_ISDIR(inode->i_mode)) ||
@@ -606,7 +606,7 @@ static inline int can_list(const char *x
 static ssize_t hfsplus_listxattr_finder_info(struct dentry *dentry,
 						char *buffer, size_t size)
 {
-	ssize_t res = 0;
+	ssize_t res;
 	struct inode *inode = d_inode(dentry);
 	struct hfs_find_data fd;
 	u16 entry_type;
@@ -674,10 +674,9 @@ end_listxattr_finder_info:
 ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
 	ssize_t err;
-	ssize_t res = 0;
+	ssize_t res;
 	struct inode *inode = d_inode(dentry);
 	struct hfs_find_data fd;
-	u16 key_len = 0;
 	struct hfsplus_attr_key attr_key;
 	char *strbuf;
 	int xattr_name_len;
@@ -719,7 +718,8 @@ ssize_t hfsplus_listxattr(struct dentry
 	}
 
 	for (;;) {
-		key_len = hfs_bnode_read_u16(fd.bnode, fd.keyoffset);
+		u16 key_len = hfs_bnode_read_u16(fd.bnode, fd.keyoffset);
+
 		if (key_len == 0 || key_len > fd.tree->max_key_len) {
 			pr_err("invalid xattr key length: %d\n", key_len);
 			res = -EIO;
@@ -766,12 +766,12 @@ out:
 
 static int hfsplus_removexattr(struct inode *inode, const char *name)
 {
-	int err = 0;
+	int err;
 	struct hfs_find_data cat_fd;
 	u16 flags;
 	u16 cat_entry_type;
-	int is_xattr_acl_deleted = 0;
-	int is_all_xattrs_deleted = 0;
+	int is_xattr_acl_deleted;
+	int is_all_xattrs_deleted;
 
 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
 		return -EOPNOTSUPP;
_

Patches currently in -mm which might be from xupengfei@nfschina.com are


