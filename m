Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE40C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F4061208
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhKIChK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhKIChK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2BC060FDA;
        Tue,  9 Nov 2021 02:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425265;
        bh=JKwN510HjETkEStpkCVOBah6WhPKr31LUjs3rMf9Bnk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jMAe5YwBE+CivrxB89hRLcgZI2eg42pF/Xg/BK/rkMF12hj1CTQH6CBmaX1F2FDrd
         bIls0JYLThJBOQrBEyK8QGAehRhniAc56g+F2Z2sc8LAbHIoC1zkcw/SW7VNymrA19
         4QeIJ/3trXbpCT/UeYVGfW/rUd1JMxANXoW7WqEo=
Date:   Mon, 08 Nov 2021 18:34:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, yangerkun@huawei.com
Subject:  [patch 55/87] ramfs: fix mount source show for ramfs
Message-ID: <20211109023424.RYBPS5CtO%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>
Subject: ramfs: fix mount source show for ramfs

ramfs_parse_param does not parse key "source", and will convert -ENOPARAM
to 0.  This will skip vfs_parse_fs_param_source in vfs_parse_fs_param,
which lead always "none" mount source for ramfs.  Fix it by parse "source"
in ramfs_parse_param like cgroup1_parse_param has do.

Link: https://lkml.kernel.org/r/20210924091756.1906118-1-yangerkun@huawei.com
Signed-off-by: yangerkun <yangerkun@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ramfs/inode.c~ramfs-fix-mount-source-show-for-ramfs
+++ a/fs/ramfs/inode.c
@@ -203,17 +203,20 @@ static int ramfs_parse_param(struct fs_c
 	int opt;
 
 	opt = fs_parse(fc, ramfs_fs_parameters, param, &result);
-	if (opt < 0) {
+	if (opt == -ENOPARAM) {
+		opt = vfs_parse_fs_param_source(fc, param);
+		if (opt != -ENOPARAM)
+			return opt;
 		/*
 		 * We might like to report bad mount options here;
 		 * but traditionally ramfs has ignored all mount options,
 		 * and as it is used as a !CONFIG_SHMEM simple substitute
 		 * for tmpfs, better continue to ignore other mount options.
 		 */
-		if (opt == -ENOPARAM)
-			opt = 0;
-		return opt;
+		return 0;
 	}
+	if (opt < 0)
+		return opt;
 
 	switch (opt) {
 	case Opt_mode:
_
