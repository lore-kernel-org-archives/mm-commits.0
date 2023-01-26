Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEB1C05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 21:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjAZVSc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 16:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjAZVSb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 16:18:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC5F301B9
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 13:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBBA1617CE
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 21:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E766C433D2;
        Thu, 26 Jan 2023 21:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674767909;
        bh=SMZoxCtFsHRGL14avq3xtBfgZfbp9fWoHPbvnjY3Uzw=;
        h=Date:To:From:Subject:From;
        b=X/2FfHhjS17YCcTqDlZ+hqGP7EGHq7UWmwkcniIphQSOpISj0VdG+e5CZQRpE3nuI
         epL5Oo3d58qWcP5oVnml+78nbmwFeiObg83G1gW/dvSVqd2OfMk0KypmFJ8hEngf+Z
         XPmz/rHIojn5hBgvS+gG4EIxzn29ENnRqnDyD8p4=
Date:   Thu, 26 Jan 2023 13:18:28 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+5d5d25f90f195a3cfcb4@syzkaller.appspotmail.com,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-replace-warn_ons-for-invalid-dat-metadata-block-requests.patch added to mm-nonmm-unstable branch
Message-Id: <20230126211829.4E766C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: replace WARN_ONs for invalid DAT metadata block requests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-replace-warn_ons-for-invalid-dat-metadata-block-requests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-replace-warn_ons-for-invalid-dat-metadata-block-requests.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: replace WARN_ONs for invalid DAT metadata block requests
Date: Fri, 27 Jan 2023 01:41:14 +0900

If DAT metadata file block access fails due to corruption of the DAT file
or abnormal virtual block numbers held by b-trees or inodes, a kernel
warning is generated.

This replaces the WARN_ONs by error output, so that a kernel, booted with
panic_on_warn, does not panic.  This patch also replaces the detected
return code -ENOENT with another internal code -EINVAL to notify the bmap
layer of metadata corruption.  When the bmap layer sees -EINVAL, it
handles the abnormal situation with nilfs_bmap_convert_error() and finally
returns code -EIO as it should.

Link: https://lkml.kernel.org/r/0000000000005cc3d205ea23ddcf@google.com
Link: https://lkml.kernel.org/r/20230126164114.6911-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: <syzbot+5d5d25f90f195a3cfcb4@syzkaller.appspotmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dat.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/dat.c~nilfs2-replace-warn_ons-for-invalid-dat-metadata-block-requests
+++ a/fs/nilfs2/dat.c
@@ -40,8 +40,21 @@ static inline struct nilfs_dat_info *NIL
 static int nilfs_dat_prepare_entry(struct inode *dat,
 				   struct nilfs_palloc_req *req, int create)
 {
-	return nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
-					    create, &req->pr_entry_bh);
+	int ret;
+
+	ret = nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
+					   create, &req->pr_entry_bh);
+	if (unlikely(ret == -ENOENT)) {
+		nilfs_err(dat->i_sb,
+			  "DAT doesn't have a block to manage vblocknr = %llu",
+			  (unsigned long long)req->pr_entry_nr);
+		/*
+		 * Return internal code -EINVAL to notify bmap layer of
+		 * metadata corruption.
+		 */
+		ret = -EINVAL;
+	}
+	return ret;
 }
 
 static void nilfs_dat_commit_entry(struct inode *dat,
@@ -123,11 +136,7 @@ static void nilfs_dat_commit_free(struct
 
 int nilfs_dat_prepare_start(struct inode *dat, struct nilfs_palloc_req *req)
 {
-	int ret;
-
-	ret = nilfs_dat_prepare_entry(dat, req, 0);
-	WARN_ON(ret == -ENOENT);
-	return ret;
+	return nilfs_dat_prepare_entry(dat, req, 0);
 }
 
 void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
@@ -154,10 +163,8 @@ int nilfs_dat_prepare_end(struct inode *
 	int ret;
 
 	ret = nilfs_dat_prepare_entry(dat, req, 0);
-	if (ret < 0) {
-		WARN_ON(ret == -ENOENT);
+	if (ret < 0)
 		return ret;
-	}
 
 	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-replace-warn_ons-for-invalid-dat-metadata-block-requests.patch

