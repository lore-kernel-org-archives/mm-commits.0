Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A279C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiGRAdg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiGRAdJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2400140F7
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F1F760FC0
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C99C3411E;
        Mon, 18 Jul 2022 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104369;
        bh=6/sw5bv4hsFAIL8vcjunkPOQLMQziPlstIdQpHwTIVg=;
        h=Date:To:From:Subject:From;
        b=vvJ+a6jIpD72C8vgkA3rRmjNYKLboNvzOCNjc6uY9uddEGCdMKsxe1qtVmYHKSqUv
         lLcFxuY/mHmaLsLsXNVyLnmOz3txYokpevhVkFOyn/7U+3i25aT8k7nMHXVZlfgjYl
         uRN1ZVDs7xfk0GeSd+kbuo+rLeODAS6+0iKWcq+k=
Date:   Sun, 17 Jul 2022 17:32:49 -0700
To:     mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk,
        miklos@szeredi.hu, dhowells@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] autofs-use-dentry-info-count-instead-of-simple_empty.patch removed from -mm tree
Message-Id: <20220718003249.C3C99C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: autofs: use dentry info count instead of simple_empty()
has been removed from the -mm tree.  Its filename was
     autofs-use-dentry-info-count-instead-of-simple_empty.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


