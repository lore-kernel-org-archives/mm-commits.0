Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D43CC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357333AbiCYBb7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357342AbiCYBbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035F637AB2
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CD96B82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FD8C340EC;
        Fri, 25 Mar 2022 01:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171807;
        bh=CyQDSOYf/FOHRjDdC8HlaDkpLMlUwOIX2o/l3SeokJ4=;
        h=Date:To:From:Subject:From;
        b=evqty8d62A/Cc1qt48hnSoCbuXGPdLyiUhQfbODxFvdod0IduDWJrzZZVBu1WYA0R
         kgDd1exrT+54qfUyoUlyBBAxaetJMpJzvT0RlFaW/GiotyaNChwNJrZTWC25jJ4Vla
         ROaiKyBWsvffi53Hj7EgzQ3fy6Q/blb8j763Fz1s=
Date:   Thu, 24 Mar 2022 18:30:06 -0700
To:     mm-commits@vger.kernel.org, xavier.grand@algolia.com,
        sylvain.bellone@algolia.com, jdelvare@suse.de, hughd@google.com,
        xavier.roche@algolia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tmpfs-support-for-file-creation-time.patch removed from -mm tree
Message-Id: <20220325013007.20FD8C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: support for file creation time
has been removed from the -mm tree.  Its filename was
     tmpfs-support-for-file-creation-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xavier Roche <xavier.roche@algolia.com>
Subject: tmpfs: support for file creation time

Various filesystems (including ext4) now support file creation time.  This
patch adds such support for tmpfs-based filesystems.

Note that using shmem_getattr() on other file types than regular requires
that shmem_is_huge() check type, to stop incorrect HPAGE_PMD_SIZE blksize.

[hughd@google.com: three tweaks to creation time patch]
  Link: https://lkml.kernel.org/r/b954973a-b8d1-cab8-63bd-6ea8063de3@google.com
Link: https://lkml.kernel.org/r/20220314211150.GA123458@xavier-xps
Link: https://lkml.kernel.org/r/b954973a-b8d1-cab8-63bd-6ea8063de3@google.com
Link: https://lkml.kernel.org/r/20220211213628.GA1919658@xavier-xps
Signed-off-by: Xavier Roche <xavier.roche@algolia.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Jean Delvare <jdelvare@suse.de>
Tested-by: Sylvain Bellone <sylvain.bellone@algolia.com>
Reported-by: Xavier Grand <xavier.grand@algolia.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    1 +
 mm/shmem.c               |   16 +++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/shmem_fs.h~tmpfs-support-for-file-creation-time
+++ a/include/linux/shmem_fs.h
@@ -24,6 +24,7 @@ struct shmem_inode_info {
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	struct simple_xattrs	xattrs;		/* list of xattrs */
 	atomic_t		stop_eviction;	/* hold when working on inode */
+	struct timespec64	i_crtime;	/* file creation time */
 	struct inode		vfs_inode;
 };
 
--- a/mm/shmem.c~tmpfs-support-for-file-creation-time
+++ a/mm/shmem.c
@@ -476,6 +476,8 @@ bool shmem_is_huge(struct vm_area_struct
 {
 	loff_t i_size;
 
+	if (!S_ISREG(inode->i_mode))
+		return false;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
 	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
@@ -1061,6 +1063,12 @@ static int shmem_getattr(struct user_nam
 	if (shmem_is_huge(NULL, inode, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
+	if (request_mask & STATX_BTIME) {
+		stat->result_mask |= STATX_BTIME;
+		stat->btime.tv_sec = info->i_crtime.tv_sec;
+		stat->btime.tv_nsec = info->i_crtime.tv_nsec;
+	}
+
 	return 0;
 }
 
@@ -1854,9 +1862,6 @@ repeat:
 		return 0;
 	}
 
-	/* Never use a huge page for shmem_symlink() */
-	if (S_ISLNK(inode->i_mode))
-		goto alloc_nohuge;
 	if (!shmem_is_huge(vma, inode, index))
 		goto alloc_nohuge;
 
@@ -2265,6 +2270,7 @@ static struct inode *shmem_get_inode(str
 		atomic_set(&info->stop_eviction, 0);
 		info->seals = F_SEAL_SEAL;
 		info->flags = flags & VM_NORESERVE;
+		info->i_crtime = inode->i_mtime;
 		INIT_LIST_HEAD(&info->shrinklist);
 		INIT_LIST_HEAD(&info->swaplist);
 		simple_xattrs_init(&info->xattrs);
@@ -3196,6 +3202,7 @@ static ssize_t shmem_listxattr(struct de
 #endif /* CONFIG_TMPFS_XATTR */
 
 static const struct inode_operations shmem_short_symlink_operations = {
+	.getattr	= shmem_getattr,
 	.get_link	= simple_get_link,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
@@ -3203,6 +3210,7 @@ static const struct inode_operations shm
 };
 
 static const struct inode_operations shmem_symlink_inode_operations = {
+	.getattr	= shmem_getattr,
 	.get_link	= shmem_get_link,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
@@ -3790,6 +3798,7 @@ static const struct inode_operations shm
 
 static const struct inode_operations shmem_dir_inode_operations = {
 #ifdef CONFIG_TMPFS
+	.getattr	= shmem_getattr,
 	.create		= shmem_create,
 	.lookup		= simple_lookup,
 	.link		= shmem_link,
@@ -3811,6 +3820,7 @@ static const struct inode_operations shm
 };
 
 static const struct inode_operations shmem_special_inode_operations = {
+	.getattr	= shmem_getattr,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
 #endif
_

Patches currently in -mm which might be from xavier.roche@algolia.com are


