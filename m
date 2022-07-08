Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F1EC43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbiGHUgL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbiGHUgI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:36:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784049CE33
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F254B824C0
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D82BC341C0;
        Fri,  8 Jul 2022 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657312557;
        bh=plxf0hZY/qmS7Q8KcnJPUhmK1nMXqtPT123t+8QPgoM=;
        h=Date:To:From:Subject:From;
        b=TpFSynIOmyjvV4wVgWGAKSt6LSdNxuXshET3KdRmCUVDIl8vbZzjIYXBFCnDtyMOX
         n5IGMZyKDbv0QYGZQbAtd/zcyTe6ZwxC5HU+pqATEyMq3IjJXnIvLpEQiOauogXCJM
         Vim5HOlOVL1EYGISVCnbM48JAPVysz6HzqLTbWqs=
Date:   Fri, 08 Jul 2022 13:35:56 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + autofs-remove-unused-ino-field-inode.patch added to mm-nonmm-unstable branch
Message-Id: <20220708203557.0D82BC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove unused ino field inode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     autofs-remove-unused-ino-field-inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/autofs-remove-unused-ino-field-inode.patch

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
From: Ian Kent <raven@themaw.net>
Subject: autofs: remove unused ino field inode
Date: Fri, 08 Jul 2022 09:43:23 +0800

Remove the unused inode field of the autofs dentry info structure.

Link: https://lkml.kernel.org/r/165724460393.30914.6511330213821246793.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/autofs_i.h |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/autofs/autofs_i.h~autofs-remove-unused-ino-field-inode
+++ a/fs/autofs/autofs_i.h
@@ -51,8 +51,6 @@ extern struct file_system_type autofs_fs
  */
 struct autofs_info {
 	struct dentry	*dentry;
-	struct inode	*inode;
-
 	int		flags;
 
 	struct completion expire_complete;
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-use-inode-permission-method-for-write-access.patch
autofs-make-dentry-info-count-consistent.patch
autofs-use-dentry-info-count-instead-of-simple_empty.patch
autofs-add-comment-about-autofs_mountpoint_changed.patch
autofs-remove-unused-ino-field-inode.patch

