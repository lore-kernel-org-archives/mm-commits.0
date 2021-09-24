Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8920C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D15611C8
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhIXUpi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230030AbhIXUpi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 16:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A363610CB;
        Fri, 24 Sep 2021 20:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632516244;
        bh=gA9i4NxGnfUbLLzzS+w7O3cgXe7ej+5FCilwlqOrWD8=;
        h=Date:From:To:Subject:From;
        b=pud4j1pvwUkop8/5BXiDfScrhIT8tpXhCj93kCY/f6KmGTEJCCCwfvCTpb7BymjkU
         YpSir2WhxZxDTLaXY3QlqTGJtVQGHChjyFCLT9H7sa65u8GB/Q3hW2sJ+D0CHE3yef
         LrPV7k8Dtgc+fOfMZ7r07SMaDGSTADGEdnZzu3Mc=
Date:   Fri, 24 Sep 2021 13:44:03 -0700
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, jack@suse.cz,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        yangerkun@huawei.com, yukuai3@huawei.com
Subject:  [to-be-updated]
 ramfs-fix-mount-source-show-for-ramfs.patch removed from -mm tree
Message-ID: <20210924204403.BXKwUGgpJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: fix mount source show for ramfs
has been removed from the -mm tree.  Its filename was
     ramfs-fix-mount-source-show-for-ramfs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: yangerkun <yangerkun@huawei.com>
Subject: ramfs: fix mount source show for ramfs

ramfs_parse_param does not parse the key "source", and will convert
-ENOPARAM to 0.  This will skip calling vfs_parse_fs_param_source() in
vfs_parse_fs_param(), which leads to always presenting "none" as the mount
source for ramfs.  Fix it by parsing "source" in ramfs_parse_param().

Link: https://lkml.kernel.org/r/20210811122811.2288041-1-yangerkun@huawei.com
Signed-off-by: yangerkun <yangerkun@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: ErKun Yang <yangerkun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ramfs/inode.c~ramfs-fix-mount-source-show-for-ramfs
+++ a/fs/ramfs/inode.c
@@ -202,6 +202,10 @@ static int ramfs_parse_param(struct fs_c
 	struct ramfs_fs_info *fsi = fc->s_fs_info;
 	int opt;
 
+	opt = vfs_parse_fs_param_source(fc, param);
+	if (opt != -ENOPARAM)
+		return opt;
+
 	opt = fs_parse(fc, ramfs_fs_parameters, param, &result);
 	if (opt < 0) {
 		/*
_

Patches currently in -mm which might be from yangerkun@huawei.com are


