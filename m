Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CC5C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiB1FCk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiB1FCj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:02:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FA466FB5
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:02:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4674860F99
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD85C340E7;
        Mon, 28 Feb 2022 05:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646024520;
        bh=zaz1ZJnHK7Fhc2oEzXTKoG+f7vMX6N+pEj+E1nJHx4M=;
        h=Date:To:From:Subject:From;
        b=vFeX5AzYv3x3puRcf71rBN/POoBV6noHuTNaO0Hr8clua6JFcNgYB7ZxfF63aTmrt
         7U0yeV2jK66UonblaYVtaAnk5rJi8qQC+rEhy1rpHufWaRyACU+uIfl0pLsf86aBrl
         gbFMd3hvQbLADX2aBJU1BWB9PIbjoianHDq1Ftjk=
Date:   Sun, 27 Feb 2022 21:01:59 -0800
To:     mm-commits@vger.kernel.org, xavier.roche@algolia.com,
        jdelvare@suse.de, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-support-for-file-creation-time-fix.patch added to -mm tree
Message-Id: <20220228050200.9CD85C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: three tweaks to creation time patch
has been added to the -mm tree.  Its filename is
     tmpfs-support-for-file-creation-time-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tmpfs-support-for-file-creation-time-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-support-for-file-creation-time-fix.patch

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
Subject: tmpfs: three tweaks to creation time patch

Thank you to Xavier Roche for his tmpfs file creation time patch.  Please
apply these 3 tweaks on top (and fold in when sending to Linus):

1. Move vfs_inode back to being last element of shmem_inode_info.
2. Remove unnecessary parentheses from condition in shmem_getattr().
3. Using shmem_getattr() on other file types than regular requires that
   shmem_is_huge() check type, to stop incorrect HPAGE_PMD_SIZE blksize.

Link: https://lkml.kernel.org/r/b954973a-b8d1-cab8-63bd-6ea8063de3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Xavier Roche <xavier.roche@algolia.com>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 +-
 mm/shmem.c               |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/include/linux/shmem_fs.h~tmpfs-support-for-file-creation-time-fix
+++ a/include/linux/shmem_fs.h
@@ -24,8 +24,8 @@ struct shmem_inode_info {
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	struct simple_xattrs	xattrs;		/* list of xattrs */
 	atomic_t		stop_eviction;	/* hold when working on inode */
-	struct inode		vfs_inode;
 	struct timespec64	i_crtime;	/* file creation time */
+	struct inode		vfs_inode;
 };
 
 struct shmem_sb_info {
--- a/mm/shmem.c~tmpfs-support-for-file-creation-time-fix
+++ a/mm/shmem.c
@@ -476,6 +476,8 @@ bool shmem_is_huge(struct vm_area_struct
 {
 	loff_t i_size;
 
+	if (!S_ISREG(inode->i_mode))
+		return false;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
 	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
@@ -1061,7 +1063,7 @@ static int shmem_getattr(struct user_nam
 	if (shmem_is_huge(NULL, inode, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
-	if ((request_mask & STATX_BTIME)) {
+	if (request_mask & STATX_BTIME) {
 		stat->result_mask |= STATX_BTIME;
 		stat->btime.tv_sec = info->i_crtime.tv_sec;
 		stat->btime.tv_nsec = info->i_crtime.tv_nsec;
@@ -1860,9 +1862,6 @@ repeat:
 		return 0;
 	}
 
-	/* Never use a huge page for shmem_symlink() */
-	if (S_ISLNK(inode->i_mode))
-		goto alloc_nohuge;
 	if (!shmem_is_huge(vma, inode, index))
 		goto alloc_nohuge;
 
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-support-for-file-creation-time-fix.patch

