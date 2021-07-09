Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9801EC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 22:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B70613BF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 22:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIWzl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 18:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhGIWzl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 18:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F27A61167;
        Fri,  9 Jul 2021 22:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625871177;
        bh=6yA89T9oE1UJomhjy226LCAqb4rW0t5/AqsDveCVt6s=;
        h=Date:From:To:Subject:From;
        b=e/g12OmvQLtpowb+WR7lLCZCw2tidP1CAWzGcGQqEy9skaU/Ow173rTWQHDWncwqR
         Fmgsh+iFAYb++T3k0i4MGnhz8XAA7qmPTxTmFc7LzwduVefG6q0JAvmjZvz0j6OcHk
         C0PMOvOMvciiHs2gRbRRlLs/Djlylnd9wIpoMZZo=
Date:   Fri, 09 Jul 2021 15:52:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hughd@google.com
Subject:  + fs-mm-fix-race-in-unlinking-swapfile.patch added to -mm
 tree
Message-ID: <20210709225255.Gyzfb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs, mm: fix race in unlinking swapfile
has been added to the -mm tree.  Its filename is
     fs-mm-fix-race-in-unlinking-swapfile.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-mm-fix-race-in-unlinking-swapfile.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-mm-fix-race-in-unlinking-swapfile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-mm-fix-race-in-unlinking-swapfile.patch

