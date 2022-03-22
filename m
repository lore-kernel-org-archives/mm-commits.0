Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2333FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiCVTJs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiCVTJp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:09:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB3312AE7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:08:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF5E9B81D65
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7386DC340EC;
        Tue, 22 Mar 2022 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976092;
        bh=Mlj1pSKZqsOZyA5gHdipDOu/s9HIjpjSSG8Dt9Uj2dQ=;
        h=Date:To:From:Subject:From;
        b=gaRkyRUvwyRHkLM62DHr6hHW1WsG2nzO15XFx902Izpv90fGdtzlUmOg1Xf5SJft2
         9O2wYV1TFj156aPWM001hDW5nPRN593cLl6MBW7tzh9Yng19ym4RqPKdejZBwymqgB
         EBI+v3tyd94BxfCI4MU0VlfDSntOJbuPnpJhT6pc=
Date:   Tue, 22 Mar 2022 12:08:11 -0700
To:     mm-commits@vger.kernel.org, xavier.roche@algolia.com,
        jdelvare@suse.de, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tmpfs-support-for-file-creation-time-fix.patch removed from -mm tree
Message-Id: <20220322190812.7386DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: three tweaks to creation time patch
has been removed from the -mm tree.  Its filename was
     tmpfs-support-for-file-creation-time-fix.patch

This patch was dropped because it was folded into tmpfs-support-for-file-creation-time.patch

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

tmpfs-support-for-file-creation-time.patch
shmem-mapping_set_exiting-to-help-mapped-resilience.patch
tmpfs-do-not-allocate-pages-on-read.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mm-fs-delete-pf_swapwrite.patch
mm-__isolate_lru_page_prepare-in-isolate_migratepages_block.patch
mempolicy-mbind_range-set_policy-after-vma_merge.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch
mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch

