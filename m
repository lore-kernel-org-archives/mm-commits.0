Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E31C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A17561872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhKKCz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhKKCz4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 963FB6162E;
        Thu, 11 Nov 2021 02:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599187;
        bh=m9VplfYN6y7oyLUFWD4oMFVl2hayQv8p9YgaaLPF5Vg=;
        h=Date:From:To:Subject:From;
        b=KV4G3YZUipHlpuuTgAidSX3IJdPYE2z1YjlFdg6JPyphGT1t+d4iq3Xw8zddIsLla
         Gk4q+vOwTd8aXDWfd4nc2hfapLyCEfr0cLKSmZvCVPPWTYpZOIKz+Flmy85daVmKsU
         XsgzTSnU4vFxRoAHpv0vuLvN4XJpCF1RY+JTvT5E=
Date:   Wed, 10 Nov 2021 18:53:07 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        yangerkun@huawei.com
Subject:  [merged] ramfs-fix-mount-source-show-for-ramfs.patch
 removed from -mm tree
Message-ID: <20211111025307.MbZf2Y4LV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: fix mount source show for ramfs
has been removed from the -mm tree.  Its filename was
     ramfs-fix-mount-source-show-for-ramfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yangerkun@huawei.com are


