Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA2EC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 11 Nov 2022 22:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiKKWlA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Nov 2022 17:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiKKWlA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Nov 2022 17:41:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EC7BF4C
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 14:40:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B29262112
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 22:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D01C433D6;
        Fri, 11 Nov 2022 22:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668206457;
        bh=rutcUFOo12vKWSrRzK0dlT9x1QBNwvkYWPs2Rhr7mwg=;
        h=Date:To:From:Subject:From;
        b=Q4GNZ1YYc99A9EBkhf/bU21upiRSiCYmHTImxmvxxWmjb+ibWKVkfBtbCvslvOYj+
         0QvGxB6goiXicJQMaz0WR97pp8d0pw9KeKUGchVbgR3VmLTvF6RAn5r22cw3SuaY7y
         72SvdaAnjqpuDzudtXi8AQEhAwgLNL5DEMVvPGsg=
Date:   Fri, 11 Nov 2022 14:40:56 -0800
To:     mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp,
        liubo03@inspur.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-exportfs-fix-some-kernel-doc-warnings.patch added to mm-nonmm-unstable branch
Message-Id: <20221111224057.B4D01C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat (exportfs): fix some kernel-doc warnings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-exportfs-fix-some-kernel-doc-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-exportfs-fix-some-kernel-doc-warnings.patch

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

fat-exportfs-fix-some-kernel-doc-warnings.patch

