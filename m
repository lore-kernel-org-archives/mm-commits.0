Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4158EC4708D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiLAARZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiLAARC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D951A98968
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:13:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72FCB61978
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A323EC433D7;
        Thu,  1 Dec 2022 00:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853637;
        bh=Yv0HTmS8OtGiQDW137xfn2m3a3XuEdVFNb8HYElhbEo=;
        h=Date:To:From:Subject:From;
        b=yXFjZio38Yun7Xr7I3euIGWzQgEPXkA+iUjkPGbv8y8ue2b21t2K4QyGEwmXkMzK7
         ia9Lp3hTHuXgajxGAb3Ky/J2ToIDBYFVcSXshK6dsYY3EwrEVWD08PeLX1h1w9JOfA
         96mbI8Y102Z2FVri+CeAKkZ4KwKnyFp+3lAXW1Ao=
Date:   Wed, 30 Nov 2022 16:13:56 -0800
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        liubo03@inspur.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-exportfs-fix-some-kernel-doc-warnings.patch removed from -mm tree
Message-Id: <20221201001357.A323EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat (exportfs): fix some kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     fat-exportfs-fix-some-kernel-doc-warnings.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bo Liu <liubo03@inspur.com>
Subject: fat (exportfs): fix some kernel-doc warnings
Date: Fri, 11 Nov 2022 02:56:48 -0500

Fix the following W=1 kernel build warning(s):

  fs/fat/nfs.c:21: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  fs/fat/nfs.c:139: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Link: https://lkml.kernel.org/r/20221111075648.4005-1-liubo03@inspur.com
Signed-off-by: Bo Liu <liubo03@inspur.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/nfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fat/nfs.c~fat-exportfs-fix-some-kernel-doc-warnings
+++ a/fs/fat/nfs.c
@@ -17,7 +17,7 @@ struct fat_fid {
 #define FAT_FID_SIZE_WITHOUT_PARENT 3
 #define FAT_FID_SIZE_WITH_PARENT (sizeof(struct fat_fid)/sizeof(u32))
 
-/**
+/*
  * Look up a directory inode given its starting cluster.
  */
 static struct inode *fat_dget(struct super_block *sb, int i_logstart)
@@ -135,7 +135,7 @@ fat_encode_fh_nostale(struct inode *inod
 	return type;
 }
 
-/**
+/*
  * Map a NFS file handle to a corresponding dentry.
  * The dentry may or may not be connected to the filesystem root.
  */
_

Patches currently in -mm which might be from liubo03@inspur.com are


