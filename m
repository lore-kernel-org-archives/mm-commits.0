Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB0CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E322061242
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhIXUqJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhIXUqI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 16:46:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91987611C8;
        Fri, 24 Sep 2021 20:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632516274;
        bh=MQSRvEi8kZ+L3iHbclXY5O6aJm9e9dFlYSV5fL5G3I8=;
        h=Date:From:To:Subject:From;
        b=L+5TzJRevZePxTEbMLL8gWaGOcUN3NbBeGV6PwqdN1vYhq2Aju3C8UfhpKzX9LICa
         Bht4yPrbi3xVZUCTPUwCN+QUVdqS4k1xjSph+VFftEeUR75wqFer666zFMQzXjj1+9
         /C6D0qiylk5QBwQvWyrcBX0F6bYODEwIgov+YgFY=
Date:   Fri, 24 Sep 2021 13:44:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        yangerkun@huawei.com
Subject:  + ramfs-fix-mount-source-show-for-ramfs.patch added to
 -mm tree
Message-ID: <20210924204434.4IOy6Z6z9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: fix mount source show for ramfs
has been added to the -mm tree.  Its filename is
     ramfs-fix-mount-source-show-for-ramfs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ramfs-fix-mount-source-show-for-ramfs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ramfs-fix-mount-source-show-for-ramfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ramfs-fix-mount-source-show-for-ramfs.patch

