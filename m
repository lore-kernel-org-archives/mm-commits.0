Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CB2C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA8B610E8
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350291AbhICU5r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350231AbhICU5i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 857CA601FD;
        Fri,  3 Sep 2021 20:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702597;
        bh=TJ5A2NYhy6fe59COaSl53nxiRoENzDIzu0dokm0P83k=;
        h=Date:From:To:Subject:From;
        b=va/XWpLp3d5aqiH+babviW2ExeJGYDoYvclCAXhtGTIrbam/hJUXy0SDf70TE7jQh
         EGIwxabJXHdi+xvUJL6mU/gIe7yr9z9k+uIJMNaJ5TGgbGzRt45uPHGjlLf6LoJH6g
         jl2J8g8gPjXrAdCzt3BkTbdklqcZgFhYuHj1D5ZY=
Date:   Fri, 03 Sep 2021 13:56:37 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, jack@suse.cz, mm-commits@vger.kernel.org
Subject:  [merged] fs-mm-fix-race-in-unlinking-swapfile.patch
 removed from -mm tree
Message-ID: <20210903205637.5Ik-GfBH2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs, mm: fix race in unlinking swapfile
has been removed from the -mm tree.  Its filename was
     fs-mm-fix-race-in-unlinking-swapfile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: fs, mm: fix race in unlinking swapfile

We had a recurring situation in which admin procedures setting up
swapfiles would race with test preparation clearing away swapfiles; and
just occasionally that got stuck on a swapfile "(deleted)" which could
never be swapped off.  That is not supposed to be possible.

2.6.28 commit f9454548e17c ("don't unlink an active swapfile") admitted
that it was leaving a race window open: now close it.

may_delete() makes the IS_SWAPFILE check (amongst many others) before
inode_lock has been taken on target: now repeat just that simple check in
vfs_unlink() and vfs_rename(), after taking inode_lock.

Which goes most of the way to fixing the race, but swapon() must also
check after it acquires inode_lock, that the file just opened has not
already been unlinked.

Link: https://lkml.kernel.org/r/e17b91ad-a578-9a15-5e3-4989e0f999b5@google.com
Fixes: f9454548e17c ("don't unlink an active swapfile")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c    |    8 +++++++-
 mm/swapfile.c |    6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/fs/namei.c~fs-mm-fix-race-in-unlinking-swapfile
+++ a/fs/namei.c
@@ -4024,7 +4024,9 @@ int vfs_unlink(struct user_namespace *mn
 		return -EPERM;
 
 	inode_lock(target);
-	if (is_local_mountpoint(dentry))
+	if (IS_SWAPFILE(target))
+		error = -EPERM;
+	else if (is_local_mountpoint(dentry))
 		error = -EBUSY;
 	else {
 		error = security_inode_unlink(dir, dentry);
@@ -4526,6 +4528,10 @@ int vfs_rename(struct renamedata *rd)
 	else if (target)
 		inode_lock(target);
 
+	error = -EPERM;
+	if (IS_SWAPFILE(source) || (target && IS_SWAPFILE(target)))
+		goto out;
+
 	error = -EBUSY;
 	if (is_local_mountpoint(old_dentry) || is_local_mountpoint(new_dentry))
 		goto out;
--- a/mm/swapfile.c~fs-mm-fix-race-in-unlinking-swapfile
+++ a/mm/swapfile.c
@@ -3130,6 +3130,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	struct filename *name;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
+	struct dentry *dentry;
 	int prio;
 	int error;
 	union swap_header *swap_header;
@@ -3173,6 +3174,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	p->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
+	dentry = swap_file->f_path.dentry;
 	inode = mapping->host;
 
 	error = claim_swapfile(p, inode);
@@ -3180,6 +3182,10 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 
 	inode_lock(inode);
+	if (d_unlinked(dentry) || cant_mount(dentry)) {
+		error = -ENOENT;
+		goto bad_swap_unlock_inode;
+	}
 	if (IS_SWAPFILE(inode)) {
 		error = -EBUSY;
 		goto bad_swap_unlock_inode;
_

Patches currently in -mm which might be from hughd@google.com are


