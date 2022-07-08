Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00702C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbiGHUf5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240115AbiGHUfw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B396D9B182
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:35:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B19D62878
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0EFC341C0;
        Fri,  8 Jul 2022 20:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657312550;
        bh=Z3+TBVGMv+khIXxUgRKxAoKiTVLMt+LIbuyFBOIPRYI=;
        h=Date:To:From:Subject:From;
        b=N3xZi0Te2bmkfTDTRrAhxc+lPQqDaC2H9bA4h/8MNM56y0l8XRIGlTtsQj7rJxEO4
         b2ZUgCwjooOhdHsHQsM7qk0OH84Hf3ddiVOjHA+yt35Gbq7pDtui/scWvErLangCkw
         LRVaoUx9yaAG6qpTWBs05UAPZ3T5D51VdQXI71FU=
Date:   Fri, 08 Jul 2022 13:35:49 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + autofs-make-dentry-info-count-consistent.patch added to mm-nonmm-unstable branch
Message-Id: <20220708203550.9D0EFC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: make dentry info count consistent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     autofs-make-dentry-info-count-consistent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/autofs-make-dentry-info-count-consistent.patch

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
Subject: autofs: make dentry info count consistent
Date: Fri, 08 Jul 2022 09:43:06 +0800

If an autofs dentry is a mount root directory there's no ->mkdir() call to
set its count to one.

To make the dentry info count consistent for all autofs dentries set count
to one when the dentry info struct is allocated.

Link: https://lkml.kernel.org/r/165724458671.30914.2902424437132835325.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/inode.c |    1 +
 fs/autofs/root.c  |    4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/fs/autofs/inode.c~autofs-make-dentry-info-count-consistent
+++ a/fs/autofs/inode.c
@@ -20,6 +20,7 @@ struct autofs_info *autofs_new_ino(struc
 		INIT_LIST_HEAD(&ino->expiring);
 		ino->last_used = jiffies;
 		ino->sbi = sbi;
+		ino->count = 1;
 	}
 	return ino;
 }
--- a/fs/autofs/root.c~autofs-make-dentry-info-count-consistent
+++ a/fs/autofs/root.c
@@ -582,7 +582,6 @@ static int autofs_dir_symlink(struct use
 	d_add(dentry, inode);
 
 	dget(dentry);
-	ino->count++;
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count++;
 
@@ -612,7 +611,6 @@ static int autofs_dir_unlink(struct inod
 	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
-	ino->count--;
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
 	dput(ino->dentry);
@@ -695,7 +693,6 @@ static int autofs_dir_rmdir(struct inode
 	if (sbi->version < 5)
 		autofs_clear_leaf_automount_flags(dentry);
 
-	ino->count--;
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
 	dput(ino->dentry);
@@ -734,7 +731,6 @@ static int autofs_dir_mkdir(struct user_
 		autofs_set_leaf_automount_flags(dentry);
 
 	dget(dentry);
-	ino->count++;
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count++;
 	inc_nlink(dir);
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-use-inode-permission-method-for-write-access.patch
autofs-make-dentry-info-count-consistent.patch
autofs-use-dentry-info-count-instead-of-simple_empty.patch
autofs-add-comment-about-autofs_mountpoint_changed.patch
autofs-remove-unused-ino-field-inode.patch

