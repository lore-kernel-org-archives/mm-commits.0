Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7EDC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiCVVld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbiCVVlc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:41:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479465E762
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9700B81DAF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82087C340EE;
        Tue, 22 Mar 2022 21:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985196;
        bh=UMDCj61a2EfT3lKHMfB5sf3Xf6ueEGq5nXbQ+6GUdPE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=T0L7CPVySRUVJGUCi5tCP9iqAYAsuFwo4xjoXt0G1m/w+viDHwOFzzJmRZRch0OU5
         fRqeOhUjMKkzlIstnQJc8Ls1T2nWiVvPWHf202GTh6v08xQmtUx9RcidRxyHz+cUUC
         ovcr03rB4YocKfgg/R65DvaBy/bdWMEqxn2FVzSc=
Date:   Tue, 22 Mar 2022 14:39:55 -0700
To:     xavier.grand@algolia.com, sylvain.bellone@algolia.com,
        jdelvare@suse.de, hughd@google.com, xavier.roche@algolia.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 028/227] tmpfs: support for file creation time
Message-Id: <20220322213956.82087C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
