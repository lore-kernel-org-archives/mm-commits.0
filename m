Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6E4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377949AbiATVbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377939AbiATVbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD7EC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 446AE61715
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C04CC340E0;
        Thu, 20 Jan 2022 21:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714275;
        bh=NqPQWwNf1Jp8ZYJ6h90/S+jq1riASakoCZZkvFxNf6M=;
        h=Date:From:To:Subject:From;
        b=FrLnwnZh7/o9P11OEg5TCZmrDYhHrhjdV5tI6tjwF1FaboubTco0swCR8nNUJgHXi
         DIYv/tMifRMih4wqNXGYoToTjScXFUxhgdczqqxPrdVYDk1E3G72I12xsJUf0ZONSa
         TzQNDffurrw8jNr5n/jcp40pgVba851P+ditRkOE=
Date:   Thu, 20 Jan 2022 13:31:15 -0800
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com
Subject:  [merged]
 hfsplus-use-struct_group_attr-for-memcpy-region.patch removed from -mm tree
Message-ID: <20220120213115.y_HaMzf5J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: use struct_group_attr() for memcpy() region
has been removed from the -mm tree.  Its filename was
     hfsplus-use-struct_group_attr-for-memcpy-region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from keescook@chromium.org are


