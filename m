Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E7AC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiATCJv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43366 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiATCJs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78299615E1
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B8EC340E3;
        Thu, 20 Jan 2022 02:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644587;
        bh=6qJmLn+o/drq4coo4FjSh/QCb2BVfpWMGyxhSv+6u3Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2mD2s2+a/WoXqx3OaWgHOeYYacVrCrXShEhXD3tGGOWDx/3rJBZAxffPxsonev8yK
         7BiNPgdetOlOahr6dBrMu9ymiWKqJxuKV/pdxfM2UY+i3cVrra80ec/Mw3aVhYbD83
         AFx6AkqrH9RvuOeGf0y6UgAluaDWPjnRYMZvUREk=
Date:   Wed, 19 Jan 2022 18:09:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.brauner@ubuntu.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 39/55] hfsplus: use struct_group_attr() for
 memcpy() region
Message-ID: <20220120020947.D5Co4uzsW%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: hfsplus: use struct_group_attr() for memcpy() region

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark the "info" region (containing struct DInfo and
struct DXInfo structs) in struct hfsplus_cat_folder and struct
hfsplus_cat_file that are written into directly, so the compiler can
correctly reason about the expected size of the writes.

"pahole" shows no size nor member offset changes to struct
hfsplus_cat_folder nor struct hfsplus_cat_file.  "objdump -d" shows no
object code changes.

Link: https://lkml.kernel.org/r/20211119192851.1046717-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_raw.h |   12 ++++++++----
 fs/hfsplus/xattr.c       |    4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-use-struct_group_attr-for-memcpy-region
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -260,8 +260,10 @@ struct hfsplus_cat_folder {
 	__be32 access_date;
 	__be32 backup_date;
 	struct hfsplus_perm permissions;
-	struct DInfo user_info;
-	struct DXInfo finder_info;
+	struct_group_attr(info, __packed,
+		struct DInfo user_info;
+		struct DXInfo finder_info;
+	);
 	__be32 text_encoding;
 	__be32 subfolders;	/* Subfolder count in HFSX. Reserved in HFS+. */
 } __packed;
@@ -294,8 +296,10 @@ struct hfsplus_cat_file {
 	__be32 access_date;
 	__be32 backup_date;
 	struct hfsplus_perm permissions;
-	struct FInfo user_info;
-	struct FXInfo finder_info;
+	struct_group_attr(info, __packed,
+		struct FInfo user_info;
+		struct FXInfo finder_info;
+	);
 	__be32 text_encoding;
 	u32 reserved2;
 
--- a/fs/hfsplus/xattr.c~hfsplus-use-struct_group_attr-for-memcpy-region
+++ a/fs/hfsplus/xattr.c
@@ -296,7 +296,7 @@ int __hfsplus_setxattr(struct inode *ino
 					sizeof(hfsplus_cat_entry));
 		if (be16_to_cpu(entry.type) == HFSPLUS_FOLDER) {
 			if (size == folder_finderinfo_len) {
-				memcpy(&entry.folder.user_info, value,
+				memcpy(&entry.folder.info, value,
 						folder_finderinfo_len);
 				hfs_bnode_write(cat_fd.bnode, &entry,
 					cat_fd.entryoffset,
@@ -309,7 +309,7 @@ int __hfsplus_setxattr(struct inode *ino
 			}
 		} else if (be16_to_cpu(entry.type) == HFSPLUS_FILE) {
 			if (size == file_finderinfo_len) {
-				memcpy(&entry.file.user_info, value,
+				memcpy(&entry.file.info, value,
 						file_finderinfo_len);
 				hfs_bnode_write(cat_fd.bnode, &entry,
 					cat_fd.entryoffset,
_
