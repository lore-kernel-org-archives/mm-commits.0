Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674B5C352A1
	for <mm-commits@archiver.kernel.org>; Tue,  6 Dec 2022 22:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiLFWGN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Dec 2022 17:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLFWGM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2022 17:06:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6726E490BF
        for <mm-commits@vger.kernel.org>; Tue,  6 Dec 2022 14:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D8B061909
        for <mm-commits@vger.kernel.org>; Tue,  6 Dec 2022 22:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E87C433C1;
        Tue,  6 Dec 2022 22:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670364369;
        bh=d9gohToNxYajWekFXaGDaDJrV92dXMfJPWOKs6gXSmQ=;
        h=Date:To:From:Subject:From;
        b=rh2fdRR+XqZlPp+YCp0mUqOTAih9CWziSIi1NPgm9CAYqCQNf993LSNmy+Mhdo6ge
         fwDI/Y6UCoHjvWRlt28AEmbvcToiFI9yuoH0mXTGKbrgfftiyoaqhrC3bK1ckwVQKf
         FiFd+FB0T91+smNWC31a4rv4c5MIe23td5uZiIuI=
Date:   Tue, 06 Dec 2022 14:06:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, slava@dubeyko.com, keescook@chromium.org,
        ira.weiny@intel.com, bvanassche@acm.org, axboe@kernel.dk,
        gargaditya08@live.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount.patch removed from -mm tree
Message-Id: <20221206220609.59E87C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Aditya Garg <gargaditya08@live.com>
Subject: hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount
Date: Fri, 2 Dec 2022 15:39:36 +0000

Despite specifying UID and GID in mount command, the specified UID and GID
were not being assigned.  This patch fixes this issue.

Link: https://lkml.kernel.org/r/93F5197D-2B61-4129-B5D4-771934F70577@live.com
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h |    2 ++
 fs/hfsplus/inode.c      |    4 ++--
 fs/hfsplus/options.c    |    2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -198,6 +198,8 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_HFSX		3
 #define HFSPLUS_SB_CASEFOLD	4
 #define HFSPLUS_SB_NOBARRIER	5
+#define HFSPLUS_SB_UID		6
+#define HFSPLUS_SB_GID		7
 
 static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 {
--- a/fs/hfsplus/inode.c~hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount
+++ a/fs/hfsplus/inode.c
@@ -192,11 +192,11 @@ static void hfsplus_get_perms(struct ino
 	mode = be16_to_cpu(perms->mode);
 
 	i_uid_write(inode, be32_to_cpu(perms->owner));
-	if (!i_uid_read(inode) && !mode)
+	if (test_bit(HFSPLUS_SB_UID, &sbi->flags))
 		inode->i_uid = sbi->uid;
 
 	i_gid_write(inode, be32_to_cpu(perms->group));
-	if (!i_gid_read(inode) && !mode)
+	if (test_bit(HFSPLUS_SB_GID, &sbi->flags))
 		inode->i_gid = sbi->gid;
 
 	if (dir) {
--- a/fs/hfsplus/options.c~hfsplus-fix-bug-causing-custom-uid-and-gid-being-unable-to-be-assigned-with-mount
+++ a/fs/hfsplus/options.c
@@ -137,6 +137,7 @@ int hfsplus_parse_options(char *input, s
 				return 0;
 			}
 			sbi->uid = make_kuid(current_user_ns(), (uid_t)tmp);
+			set_bit(HFSPLUS_SB_UID, &sbi->flags);
 			if (!uid_valid(sbi->uid)) {
 				pr_err("invalid uid specified\n");
 				return 0;
@@ -148,6 +149,7 @@ int hfsplus_parse_options(char *input, s
 				return 0;
 			}
 			sbi->gid = make_kgid(current_user_ns(), (gid_t)tmp);
+			set_bit(HFSPLUS_SB_GID, &sbi->flags);
 			if (!gid_valid(sbi->gid)) {
 				pr_err("invalid gid specified\n");
 				return 0;
_

Patches currently in -mm which might be from gargaditya08@live.com are


