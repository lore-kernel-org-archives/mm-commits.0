Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A7BE78486
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbjJAT4m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbjJAT4l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:56:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5453291
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:56:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB478C433C7;
        Sun,  1 Oct 2023 19:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696190199;
        bh=eF8W+EaCG1wDjEymGfCjsetoGQoEjGI48PQ97vjmT9I=;
        h=Date:To:From:Subject:From;
        b=OGCzHACtol9i2jqN5yTNIeq8BBSBMJzTLPxionaYtkUMUsuLh+f2kF4q7Henw+JVQ
         SmbDnhOIqB3n4tjKRh2mbSoCQ8graNDcloe0JwlSEgW9KOxDnOGfjENnWvPo9godoC
         YzPb7lQU7RwNpnRxGVHeKBsuIDIrnwPpT5i1CbIE=
Date:   Sun, 01 Oct 2023 12:56:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch added to mm-unstable branch
Message-Id: <20231001195638.DB478C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: shrink shmem_inode_info: dir_offsets in a union
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
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

shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch
shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch
shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch
shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch
shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch
shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch
shmem-_add_to_page_cache-before-shmem_inode_acct_blocks.patch
shmempercpu_counter-add-_limited_addfbc-limit-amount.patch

