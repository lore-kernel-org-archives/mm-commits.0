Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83985C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 21:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiBKVit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:38:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbiBKVit (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 16:38:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C5CC65
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 13:38:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 377D5B82D42
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 21:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0DAC340E9;
        Fri, 11 Feb 2022 21:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644615522;
        bh=hFH6ZtM4pQe6TzNGNo+oPwRO4KIJJbuqKWdGaKkyZHc=;
        h=Date:To:From:Subject:From;
        b=U1o2koewB33sU3RaAbnZ6qpSYU+L5tTqmpxC79QxLk3sKCEgkcOkPlAXzR7PV6GyT
         B5k8UKBVVy74sOlbBgPBPUbfwpiKykJyhi2C54ZFoLTiKU3uFUI1KbKWoeZ8qxgFnB
         YGdDIL6lbITLkNgTOvfu0i3erx5XiYQHKpHNNNM0=
Date:   Fri, 11 Feb 2022 13:38:42 -0800
To:     mm-commits@vger.kernel.org, jdelvare@suse.de, hughd@google.com,
        xavier.roche@algolia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-support-for-file-creation-time.patch added to -mm tree
Message-Id: <20220211213842.AA0DAC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: support for file creation time
has been added to the -mm tree.  Its filename is
     tmpfs-support-for-file-creation-time.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tmpfs-support-for-file-creation-time.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-support-for-file-creation-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xavier Roche <xavier.roche@algolia.com>
Subject: tmpfs: support for file creation time

Various filesystems (including ext4) now support file creation time.  This
patch adds such support for tmpfs-based filesystems.

Link: https://lkml.kernel.org/r/20220211213628.GA1919658@xavier-xps
Signed-off-by: Xavier Roche <xavier.roche@algolia.com>
Tested-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/shmem_fs.h~tmpfs-support-for-file-creation-time
+++ a/include/linux/shmem_fs.h
@@ -25,6 +25,7 @@ struct shmem_inode_info {
 	struct simple_xattrs	xattrs;		/* list of xattrs */
 	atomic_t		stop_eviction;	/* hold when working on inode */
 	struct inode		vfs_inode;
+	struct timespec64	i_crtime;	/* file creation time */
 };
 
 struct shmem_sb_info {
--- a/mm/shmem.c~tmpfs-support-for-file-creation-time
+++ a/mm/shmem.c
@@ -1061,6 +1061,12 @@ static int shmem_getattr(struct user_nam
 	if (shmem_is_huge(NULL, inode, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
+	if ((request_mask & STATX_BTIME)) {
+		stat->result_mask |= STATX_BTIME;
+		stat->btime.tv_sec = info->i_crtime.tv_sec;
+		stat->btime.tv_nsec = info->i_crtime.tv_nsec;
+	}
+
 	return 0;
 }
 
@@ -2265,6 +2271,7 @@ static struct inode *shmem_get_inode(str
 		atomic_set(&info->stop_eviction, 0);
 		info->seals = F_SEAL_SEAL;
 		info->flags = flags & VM_NORESERVE;
+		info->i_crtime = inode->i_mtime;
 		INIT_LIST_HEAD(&info->shrinklist);
 		INIT_LIST_HEAD(&info->swaplist);
 		simple_xattrs_init(&info->xattrs);
@@ -3196,6 +3203,7 @@ static ssize_t shmem_listxattr(struct de
 #endif /* CONFIG_TMPFS_XATTR */
 
 static const struct inode_operations shmem_short_symlink_operations = {
+	.getattr	= shmem_getattr,
 	.get_link	= simple_get_link,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
@@ -3203,6 +3211,7 @@ static const struct inode_operations shm
 };
 
 static const struct inode_operations shmem_symlink_inode_operations = {
+	.getattr	= shmem_getattr,
 	.get_link	= shmem_get_link,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
@@ -3790,6 +3799,7 @@ static const struct inode_operations shm
 
 static const struct inode_operations shmem_dir_inode_operations = {
 #ifdef CONFIG_TMPFS
+	.getattr	= shmem_getattr,
 	.create		= shmem_create,
 	.lookup		= simple_lookup,
 	.link		= shmem_link,
@@ -3811,6 +3821,7 @@ static const struct inode_operations shm
 };
 
 static const struct inode_operations shmem_special_inode_operations = {
+	.getattr	= shmem_getattr,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
 #endif
_

Patches currently in -mm which might be from xavier.roche@algolia.com are

tmpfs-support-for-file-creation-time.patch

