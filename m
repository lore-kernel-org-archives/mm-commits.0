Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6988BCCA483
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240153AbiGHUf6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240167AbiGHUf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:35:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5AB9CE3A
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:35:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 229FFB824C0
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD625C341C0;
        Fri,  8 Jul 2022 20:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657312552;
        bh=qkbJpxHdc2qA6BJ3taEE7SRolKlq/tc7F27JSVPsvog=;
        h=Date:To:From:Subject:From;
        b=P0IPYoOap7yI+LaOyb+LOcW6QH7LFrFwpN3bTcSHr1600HaQoZmclml+5cc4RRkPm
         N4m1zdeHFIqvho7tFTKXz3xnDVFWZzV+udPcjz228rvIcAF3cT30NLywc9moP7Csyq
         msjCHAZkoh9GD95/A9vex/ESgQ2Cq9kNUKma6DEM=
Date:   Fri, 08 Jul 2022 13:35:52 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + autofs-use-dentry-info-count-instead-of-simple_empty.patch added to mm-nonmm-unstable branch
Message-Id: <20220708203552.BD625C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: use dentry info count instead of simple_empty()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     autofs-use-dentry-info-count-instead-of-simple_empty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/autofs-use-dentry-info-count-instead-of-simple_empty.patch

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
Subject: autofs: use dentry info count instead of simple_empty()
Date: Fri, 08 Jul 2022 09:43:12 +0800

The dentry info.  field count is used to check if a dentry is in use
during expire.  But, to be used for this the count field must account for
the presence of child dentries in a directory dentry.

Therefore it can also be used to check for an empty directory dentry which
can be done without having to to take an additional lock or account for
the presence of a readdir cursor dentry as is done by simple_empty().

Link: https://lkml.kernel.org/r/165724459238.30914.1504611159945950108.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/autofs_i.h |    5 +++++
 fs/autofs/expire.c   |    2 +-
 fs/autofs/root.c     |   18 ++++++++----------
 3 files changed, 14 insertions(+), 11 deletions(-)

--- a/fs/autofs/autofs_i.h~autofs-use-dentry-info-count-instead-of-simple_empty
+++ a/fs/autofs/autofs_i.h
@@ -148,6 +148,11 @@ static inline int autofs_oz_mode(struct
 		 task_pgrp(current) == sbi->oz_pgrp);
 }
 
+static inline bool autofs_empty(struct autofs_info *ino)
+{
+	return ino->count < 2;
+}
+
 struct inode *autofs_get_inode(struct super_block *, umode_t);
 void autofs_free_ino(struct autofs_info *);
 
--- a/fs/autofs/expire.c~autofs-use-dentry-info-count-instead-of-simple_empty
+++ a/fs/autofs/expire.c
@@ -371,7 +371,7 @@ static struct dentry *should_expire(stru
 		return NULL;
 	}
 
-	if (simple_empty(dentry))
+	if (autofs_empty(ino))
 		return NULL;
 
 	/* Case 2: tree mount, expire iff entire tree is not busy */
--- a/fs/autofs/root.c~autofs-use-dentry-info-count-instead-of-simple_empty
+++ a/fs/autofs/root.c
@@ -79,6 +79,7 @@ static int autofs_dir_open(struct inode
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 
 	pr_debug("file=%p dentry=%p %pd\n", file, dentry, dentry);
 
@@ -95,7 +96,7 @@ static int autofs_dir_open(struct inode
 	 * it.
 	 */
 	spin_lock(&sbi->lookup_lock);
-	if (!path_is_mountpoint(&file->f_path) && simple_empty(dentry)) {
+	if (!path_is_mountpoint(&file->f_path) && autofs_empty(ino)) {
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOENT;
 	}
@@ -364,7 +365,7 @@ static struct vfsmount *autofs_d_automou
 		 * the mount never trigger mounts themselves (they have an
 		 * autofs trigger mount mounted on them). But v4 pseudo direct
 		 * mounts do need the leaves to trigger mounts. In this case
-		 * we have no choice but to use the list_empty() check and
+		 * we have no choice but to use the autofs_empty() check and
 		 * require user space behave.
 		 */
 		if (sbi->version > 4) {
@@ -373,7 +374,7 @@ static struct vfsmount *autofs_d_automou
 				goto done;
 			}
 		} else {
-			if (!simple_empty(dentry)) {
+			if (!autofs_empty(ino)) {
 				spin_unlock(&sbi->fs_lock);
 				goto done;
 			}
@@ -428,9 +429,8 @@ static int autofs_d_manage(const struct
 
 	if (rcu_walk) {
 		/* We don't need fs_lock in rcu_walk mode,
-		 * just testing 'AUTOFS_INFO_NO_RCU' is enough.
-		 * simple_empty() takes a spinlock, so leave it
-		 * to last.
+		 * just testing 'AUTOFS_INF_WANT_EXPIRE' is enough.
+		 *
 		 * We only return -EISDIR when certain this isn't
 		 * a mount-trap.
 		 */
@@ -443,9 +443,7 @@ static int autofs_d_manage(const struct
 		inode = d_inode_rcu(dentry);
 		if (inode && S_ISLNK(inode->i_mode))
 			return -EISDIR;
-		if (list_empty(&dentry->d_subdirs))
-			return 0;
-		if (!simple_empty(dentry))
+		if (!autofs_empty(ino))
 			return -EISDIR;
 		return 0;
 	}
@@ -465,7 +463,7 @@ static int autofs_d_manage(const struct
 		 * we can avoid needless calls ->d_automount() and avoid
 		 * an incorrect ELOOP error return.
 		 */
-		if ((!path_is_mountpoint(path) && !simple_empty(dentry)) ||
+		if ((!path_is_mountpoint(path) && !autofs_empty(ino)) ||
 		    (d_really_is_positive(dentry) && d_is_symlink(dentry)))
 			status = -EISDIR;
 	}
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-use-inode-permission-method-for-write-access.patch
autofs-make-dentry-info-count-consistent.patch
autofs-use-dentry-info-count-instead-of-simple_empty.patch
autofs-add-comment-about-autofs_mountpoint_changed.patch
autofs-remove-unused-ino-field-inode.patch

