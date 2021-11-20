Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5222C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 20 Nov 2021 00:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhKTAzL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 19:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhKTAzL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 19:55:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78C9061406;
        Sat, 20 Nov 2021 00:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637369528;
        bh=ZAJ0VK3rZSBT6PDQ9OCdxtpqdEa9fa+CI/qianMXgMc=;
        h=Date:From:To:Subject:From;
        b=FEw22fNb82jF1wuMxl6/Eo996PnED+6BmcRk7qF/8g/xVbdIQAECv/pgpA4/uRTtk
         MTa7Vm5BBXAulCqdrTONr2LfxAIObK0FImHGqdiUVmKbNo+rbO+DXhXVV5ZMp13LDU
         1+RE8xNuvhVXTGPruwKIQKZjcCWEYpwDO5cSCMkM=
Date:   Fri, 19 Nov 2021 16:52:07 -0800
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, lkp@intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [wrecked]
 hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr.patch removed from
 -mm tree
Message-ID: <20211120005207.s1JqfAxho%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: fix out-of-bounds warnings in __hfsplus_setxattr
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: hfsplus: fix out-of-bounds warnings in __hfsplus_setxattr

Fix the following out-of-bounds warnings by enclosing structure members
file and finder into new struct info:

fs/hfsplus/xattr.c:300:5: warning: 'memcpy' offset [65, 80] from the object at 'entry' is out of the bounds of referenced subobject 'user_info' with type 'struct DInfo' at offset 48 [-Warray-bounds]
fs/hfsplus/xattr.c:313:5: warning: 'memcpy' offset [65, 80] from the object at 'entry' is out of the bounds of referenced subobject 'user_info' with type 'struct FInfo' at offset 48 [-Warray-bounds]

Refactor the code by making it more "structured."

Also, this helps with the ongoing efforts to enable -Warray-bounds and
makes the code clearer and avoid confusing the compiler.

Matthew said:

: The offending line is this:
: 
: -                               memcpy(&entry.file.user_info, value,
: +                               memcpy(&entry.file.info, value,
:                                                 file_finderinfo_len);
: 
: what it's trying to do is copy two structs which are adjacent to each
: other in a single call to memcpy().  gcc legitimately complains that
: the memcpy to this struct overruns the bounds of the struct.  What
: Gustavo has done here is introduce a new struct that contains the two
: structs, and now gcc is happy that the memcpy doesn't overrun the
: length of this containing struct.

Link: https://github.com/KSPP/linux/issues/109
Link: https://lkml.kernel.org/r/20210330145226.GA207011@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/catalog.c     |   16 ++++++++--------
 fs/hfsplus/dir.c         |    4 ++--
 fs/hfsplus/hfsplus_raw.h |   12 ++++++++----
 fs/hfsplus/xattr.c       |   18 ++++++++----------
 4 files changed, 26 insertions(+), 24 deletions(-)

--- a/fs/hfsplus/catalog.c~hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr
+++ a/fs/hfsplus/catalog.c
@@ -124,7 +124,7 @@ static int hfsplus_cat_build_record(hfsp
 		hfsplus_cat_set_perms(inode, &folder->permissions);
 		if (inode == sbi->hidden_dir)
 			/* invisible and namelocked */
-			folder->user_info.frFlags = cpu_to_be16(0x5000);
+			folder->info.user.frFlags = cpu_to_be16(0x5000);
 		return sizeof(*folder);
 	} else {
 		struct hfsplus_cat_file *file;
@@ -142,14 +142,14 @@ static int hfsplus_cat_build_record(hfsp
 		if (cnid == inode->i_ino) {
 			hfsplus_cat_set_perms(inode, &file->permissions);
 			if (S_ISLNK(inode->i_mode)) {
-				file->user_info.fdType =
+				file->info.user.fdType =
 					cpu_to_be32(HFSP_SYMLINK_TYPE);
-				file->user_info.fdCreator =
+				file->info.user.fdCreator =
 					cpu_to_be32(HFSP_SYMLINK_CREATOR);
 			} else {
-				file->user_info.fdType =
+				file->info.user.fdType =
 					cpu_to_be32(sbi->type);
-				file->user_info.fdCreator =
+				file->info.user.fdCreator =
 					cpu_to_be32(sbi->creator);
 			}
 			if (HFSPLUS_FLG_IMMUTABLE &
@@ -158,11 +158,11 @@ static int hfsplus_cat_build_record(hfsp
 				file->flags |=
 					cpu_to_be16(HFSPLUS_FILE_LOCKED);
 		} else {
-			file->user_info.fdType =
+			file->info.user.fdType =
 				cpu_to_be32(HFSP_HARDLINK_TYPE);
-			file->user_info.fdCreator =
+			file->info.user.fdCreator =
 				cpu_to_be32(HFSP_HFSPLUS_CREATOR);
-			file->user_info.fdFlags =
+			file->info.user.fdFlags =
 				cpu_to_be16(0x100);
 			file->create_date =
 				HFSPLUS_I(sbi->hidden_dir)->create_date;
--- a/fs/hfsplus/dir.c~hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr
+++ a/fs/hfsplus/dir.c
@@ -73,9 +73,9 @@ again:
 			goto fail;
 		}
 		cnid = be32_to_cpu(entry.file.id);
-		if (entry.file.user_info.fdType ==
+		if (entry.file.info.user.fdType ==
 				cpu_to_be32(HFSP_HARDLINK_TYPE) &&
-				entry.file.user_info.fdCreator ==
+				entry.file.info.user.fdCreator ==
 				cpu_to_be32(HFSP_HFSPLUS_CREATOR) &&
 				HFSPLUS_SB(sb)->hidden_dir &&
 				(entry.file.create_date ==
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -260,8 +260,10 @@ struct hfsplus_cat_folder {
 	__be32 access_date;
 	__be32 backup_date;
 	struct hfsplus_perm permissions;
-	struct DInfo user_info;
-	struct DXInfo finder_info;
+	struct {
+		struct DInfo user;
+		struct DXInfo finder;
+	} info;
 	__be32 text_encoding;
 	__be32 subfolders;	/* Subfolder count in HFSX. Reserved in HFS+. */
 } __packed;
@@ -294,8 +296,10 @@ struct hfsplus_cat_file {
 	__be32 access_date;
 	__be32 backup_date;
 	struct hfsplus_perm permissions;
-	struct FInfo user_info;
-	struct FXInfo finder_info;
+	struct {
+		struct FInfo user;
+		struct FXInfo finder;
+	} info;
 	__be32 text_encoding;
 	u32 reserved2;
 
--- a/fs/hfsplus/xattr.c~hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr
+++ a/fs/hfsplus/xattr.c
@@ -261,10 +261,8 @@ int __hfsplus_setxattr(struct inode *ino
 	struct hfs_find_data cat_fd;
 	hfsplus_cat_entry entry;
 	u16 cat_entry_flags, cat_entry_type;
-	u16 folder_finderinfo_len = sizeof(struct DInfo) +
-					sizeof(struct DXInfo);
-	u16 file_finderinfo_len = sizeof(struct FInfo) +
-					sizeof(struct FXInfo);
+	u16 folder_finderinfo_len = sizeof(entry.folder.info);
+	u16 file_finderinfo_len = sizeof(entry.file.info);
 
 	if ((!S_ISREG(inode->i_mode) &&
 			!S_ISDIR(inode->i_mode)) ||
@@ -296,7 +294,7 @@ int __hfsplus_setxattr(struct inode *ino
 					sizeof(hfsplus_cat_entry));
 		if (be16_to_cpu(entry.type) == HFSPLUS_FOLDER) {
 			if (size == folder_finderinfo_len) {
-				memcpy(&entry.folder.user_info, value,
+				memcpy(&entry.folder.info, value,
 						folder_finderinfo_len);
 				hfs_bnode_write(cat_fd.bnode, &entry,
 					cat_fd.entryoffset,
@@ -309,7 +307,7 @@ int __hfsplus_setxattr(struct inode *ino
 			}
 		} else if (be16_to_cpu(entry.type) == HFSPLUS_FILE) {
 			if (size == file_finderinfo_len) {
-				memcpy(&entry.file.user_info, value,
+				memcpy(&entry.file.info, value,
 						file_finderinfo_len);
 				hfs_bnode_write(cat_fd.bnode, &entry,
 					cat_fd.entryoffset,
@@ -462,14 +460,14 @@ static ssize_t hfsplus_getxattr_finder_i
 		if (entry_type == HFSPLUS_FOLDER) {
 			hfs_bnode_read(fd.bnode, folder_finder_info,
 				fd.entryoffset +
-				offsetof(struct hfsplus_cat_folder, user_info),
+				offsetof(struct hfsplus_cat_folder, info.user),
 				folder_rec_len);
 			memcpy(value, folder_finder_info, folder_rec_len);
 			res = folder_rec_len;
 		} else if (entry_type == HFSPLUS_FILE) {
 			hfs_bnode_read(fd.bnode, file_finder_info,
 				fd.entryoffset +
-				offsetof(struct hfsplus_cat_file, user_info),
+				offsetof(struct hfsplus_cat_file, info.user),
 				file_rec_len);
 			memcpy(value, file_finder_info, file_rec_len);
 			res = file_rec_len;
@@ -630,14 +628,14 @@ static ssize_t hfsplus_listxattr_finder_
 		len = sizeof(struct DInfo) + sizeof(struct DXInfo);
 		hfs_bnode_read(fd.bnode, folder_finder_info,
 				fd.entryoffset +
-				offsetof(struct hfsplus_cat_folder, user_info),
+				offsetof(struct hfsplus_cat_folder, info.user),
 				len);
 		found_bit = find_first_bit((void *)folder_finder_info, len*8);
 	} else if (entry_type == HFSPLUS_FILE) {
 		len = sizeof(struct FInfo) + sizeof(struct FXInfo);
 		hfs_bnode_read(fd.bnode, file_finder_info,
 				fd.entryoffset +
-				offsetof(struct hfsplus_cat_file, user_info),
+				offsetof(struct hfsplus_cat_file, info.user),
 				len);
 		found_bit = find_first_bit((void *)file_finder_info, len*8);
 	} else {
_

Patches currently in -mm which might be from gustavoars@kernel.org are


