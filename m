Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8BAC4338F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 21:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22FF260EE2
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 21:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhHLVuy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 17:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhHLVux (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 17:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9960660F57;
        Thu, 12 Aug 2021 21:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628805027;
        bh=kKphNjuP0wpR/N8WcQv46np5wWLMb8ptVs90ljF4+9Y=;
        h=Date:From:To:Subject:From;
        b=JoyEgvisQ2YIqFd+/KTq8Vcps6PlguOuPSHw/1GRjRCEJ5NRNK0N9i9aRTe1Y6Q+9
         aM9SJmwhUR7KCRGjgQGFd75ID/5xw01p7JmQ69XBVDWjNsli0nz/adWFZNWelee8ym
         oEA1waCvSS5/MFetmsyqCqMyKiV5BVNDnd/RUgQk=
Date:   Thu, 12 Aug 2021 14:50:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, gregkh@linuxfoundation.org,
        yangerkun@huawei.com
Subject:  + ramfs-fix-mount-source-show-for-ramfs.patch added to -mm
 tree
Message-ID: <20210812215024.Ttv4y%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
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

ramfs-fix-mount-source-show-for-ramfs.patch

