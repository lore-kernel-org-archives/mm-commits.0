Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02102CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjJRVft (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjJRVfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40A0111
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18017C433AD;
        Wed, 18 Oct 2023 21:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664901;
        bh=oY+51TMrE7FS+4MZEXhWXKUy2yf1K0fJXx5Fa3JyIq4=;
        h=Date:To:From:Subject:From;
        b=0PC5jRvI2e0/AL10zKnqtM3PsdXeh2Zo4gxAh2iW68BjBcMpBXKNpsWL9rvptrk41
         6iPZjKEv0YjOtcdSx39sLDrdbF+K0kYccc733XvMPASLtbV+NsBzB1oZXe3KRw4NRE
         k3wifgXXEerpIoMx5wC3CpQ0hzDV32+isf0z4jWg=
Date:   Wed, 18 Oct 2023 14:35:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch removed from -mm tree
Message-Id: <20231018213501.18017C433AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: shrink shmem_inode_info: dir_offsets in a union
has been removed from the -mm tree.  Its filename was
     shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: shrink shmem_inode_info: dir_offsets in a union
Date: Fri, 29 Sep 2023 20:25:38 -0700 (PDT)

Patch series "shmem,tmpfs: general maintenance".

Mostly just cosmetic mods in mm/shmem.c, but the last two enforcing the
"size=" limit better.  8/8 goes into percpu counter territory, and could
stand alone.


This patch (of 8):

Shave 32 bytes off (the 64-bit) shmem_inode_info.  There was a 4-byte
pahole after stop_eviction, better filled by fsflags.  And the 24-byte
dir_offsets can only be used by directories, whereas shrinklist and
swaplist only by shmem_mapping() inodes (regular files or long symlinks):
so put those into a union.  No change in mm/shmem.c is required for this.

Link: https://lkml.kernel.org/r/c7441dc6-f3bb-dd60-c670-9f5cbd9f266@google.com
Link: https://lkml.kernel.org/r/86ebb4b-c571-b9e8-27f5-cb82ec50357e@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/shmem_fs.h~shmem-shrink-shmem_inode_info-dir_offsets-in-a-union
+++ a/include/linux/shmem_fs.h
@@ -23,18 +23,22 @@ struct shmem_inode_info {
 	unsigned long		flags;
 	unsigned long		alloced;	/* data pages alloced to file */
 	unsigned long		swapped;	/* subtotal assigned to swap */
-	pgoff_t			fallocend;	/* highest fallocate endindex */
-	struct list_head        shrinklist;     /* shrinkable hpage inodes */
-	struct list_head	swaplist;	/* chain of maybes on swap */
+	union {
+	    struct offset_ctx	dir_offsets;	/* stable directory offsets */
+	    struct {
+		struct list_head shrinklist;	/* shrinkable hpage inodes */
+		struct list_head swaplist;	/* chain of maybes on swap */
+	    };
+	};
+	struct timespec64	i_crtime;	/* file creation time */
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	struct simple_xattrs	xattrs;		/* list of xattrs */
+	pgoff_t			fallocend;	/* highest fallocate endindex */
+	unsigned int		fsflags;	/* for FS_IOC_[SG]ETFLAGS */
 	atomic_t		stop_eviction;	/* hold when working on inode */
-	struct timespec64	i_crtime;	/* file creation time */
-	unsigned int		fsflags;	/* flags for FS_IOC_[SG]ETFLAGS */
 #ifdef CONFIG_TMPFS_QUOTA
 	struct dquot		*i_dquot[MAXQUOTAS];
 #endif
-	struct offset_ctx	dir_offsets;	/* stable entry offsets */
 	struct inode		vfs_inode;
 };
 
_

Patches currently in -mm which might be from hughd@google.com are

hugetlbfs-drop-shared-numa-mempolicy-pretence.patch
kernfs-drop-shared-numa-mempolicy-hooks.patch
mempolicy-fix-migrate_pages2-syscall-return-nr_failed.patch
mempolicy-trivia-delete-those-ancient-pr_debugs.patch
mempolicy-trivia-slightly-more-consistent-naming.patch
mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch
mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch
mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch
mm-add-page_rmappable_folio-wrapper.patch
mempolicy-alloc_pages_mpol-for-numa-policy-without-vma.patch
mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch
mempolicy-migration-attempt-to-match-interleave-nodes.patch

