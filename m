Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3717C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbiGRAde (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbiGRAdJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04EC14030
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CCDF60F4A
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECB6C341C0;
        Mon, 18 Jul 2022 00:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104368;
        bh=SG6J7I8gVBEk031EpDRE8hABeU1NcgzXP3z90+sptPA=;
        h=Date:To:From:Subject:From;
        b=aDkSp9At4YkefxGzkTV6kJFki389noHXFLv+9za9ZKTU064s58lsRyCxmw5B9E6V7
         ROdHAL13nqXoF/5HtAsAPh1kvRkfq9Q9fySuWrBMq1zKdGEZeT75AhX3lWif5dGydt
         193rctRmg+e7uxxVwTMn0tyBQwMAux+edswUchZ0=
Date:   Sun, 17 Jul 2022 17:32:48 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] autofs-make-dentry-info-count-consistent.patch removed from -mm tree
Message-Id: <20220718003248.BECB6C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: autofs: make dentry info count consistent
has been removed from the -mm tree.  Its filename was
     autofs-make-dentry-info-count-consistent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


