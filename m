Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69829C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiLUViB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiLUViA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:38:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F05F24BF0
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4C96B81B9C
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DD2C433EF;
        Wed, 21 Dec 2022 21:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671658676;
        bh=BaG7qvt2FNffQ5tP0lplAjshZwdnb0zeQZztJKumfDk=;
        h=Date:To:From:Subject:From;
        b=i0m7zOJ/r51HNMin2r3Nka2HCxfMLHIs4Ob62XnbWHEVcsNXaX2tmWcWoD1RLtMMQ
         nau17yzf6rMpGf+e0bZAEIBl+rJYZy7P9otbFxA1v9zuF9/4CNKoEQIyJbVGIcA3d6
         o8W79F+sMCArv/m23eZNs/1NC4FO/HpjHeJs3jcQ=
Date:   Wed, 21 Dec 2022 13:37:55 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        brauner@kernel.org, akpm@linux-foudation.org,
        xupengfei@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfsplus-remove-unnecessary-variable-initialization.patch added to mm-nonmm-unstable branch
Message-Id: <20221221213756.89DD2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: remove unnecessary variable initialization
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfsplus-remove-unnecessary-variable-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfsplus-remove-unnecessary-variable-initialization.patch

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
From: XU pengfei <xupengfei@nfschina.com>
Subject: hfsplus: remove unnecessary variable initialization
Date: Wed, 21 Dec 2022 11:21:20 +0800

Variables are assigned first and then used. Initialization is not required.

Link: https://lkml.kernel.org/r/20221221032119.10037-1-xupengfei@nfschina.com
Signed-off-by: XU pengfei <xupengfei@nfschina.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

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
@@ -674,10 +674,10 @@ end_listxattr_finder_info:
 ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
 	ssize_t err;
-	ssize_t res = 0;
+	ssize_t res;
 	struct inode *inode = d_inode(dentry);
 	struct hfs_find_data fd;
-	u16 key_len = 0;
+	u16 key_len;
 	struct hfsplus_attr_key attr_key;
 	char *strbuf;
 	int xattr_name_len;
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

hfsplus-remove-unnecessary-variable-initialization.patch

