Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DDCC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 19 Nov 2021 22:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhKSWm0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 17:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhKSWm0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 17:42:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C597861A89;
        Fri, 19 Nov 2021 22:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637361564;
        bh=34s5XnMkpBAVtGzE4CC2OrctupeipWJ5sImGFLpAXOA=;
        h=Date:From:To:Subject:From;
        b=GRyXUyN5C8x6vMCTYXXiNqs3cYejd8dIeyyd1jDlPu17DHXxYsbW9iQa87h+aE20v
         p8V+H/01zSHtw+ogdi+khjkJkczGShp28Uit+u41Pb6yHknndZM/F0Ok6YEKLoLs0+
         ECKuTnhy28nT1iLMZCObUm62jf++0W4RZeWTPMqk=
Date:   Fri, 19 Nov 2021 14:39:23 -0800
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com
Subject:  + hfsplus-use-struct_group_attr-for-memcpy-region.patch
 added to -mm tree
Message-ID: <20211119223923.rsaTbFAA6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: use struct_group_attr() for memcpy() region
has been added to the -mm tree.  Its filename is
     hfsplus-use-struct_group_attr-for-memcpy-region.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hfsplus-use-struct_group_attr-for-memcpy-region.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-use-struct_group_attr-for-memcpy-region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
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

kasan-test-silence-intentional-read-overflow-warnings.patch
hfsplus-use-struct_group_attr-for-memcpy-region.patch

