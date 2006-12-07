From: akpm@osdl.org
Subject: - fs-reorder-some-struct-inode-fields-to-speedup-i_size-manipulations.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:10 -0800
Message-ID: <200612072307.kB7N7AD1030336@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163936AbWLGXHS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     fs: reorder some 'struct inode' fields to speedup i_size manipulations
has been removed from the -mm tree.  Its filename was
     fs-reorder-some-struct-inode-fields-to-speedup-i_size-manipulations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: reorder some 'struct inode' fields to speedup i_size manipulations
From: Eric Dumazet <dada1@cosmosbay.com>

On 32bits SMP platforms, 64bits i_size is protected by a seqcount
(i_size_seqcount).

When i_size is read or written, i_size_seqcount is read/written as well, so
it make sense to group these two fields together in the same cache line.

This patch moves i_size_seqcount next to i_size, and also moves i_version
to let offsetof(struct inode, i_size) being 0x40 instead of 0x3c (for
32bits platforms).

For 64 bits platforms, i_size_seqcount doesnt exist, and the move of a
'long i_version' should not introduce a new hole because of padding.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/fs.h~fs-reorder-some-struct-inode-fields-to-speedup-i_size-manipulations include/linux/fs.h
--- a/include/linux/fs.h~fs-reorder-some-struct-inode-fields-to-speedup-i_size-manipulations
+++ a/include/linux/fs.h
@@ -548,12 +548,15 @@ struct inode {
 	uid_t			i_uid;
 	gid_t			i_gid;
 	dev_t			i_rdev;
+	unsigned long		i_version;
 	loff_t			i_size;
+#ifdef __NEED_I_SIZE_ORDERED
+	seqcount_t		i_size_seqcount;
+#endif
 	struct timespec		i_atime;
 	struct timespec		i_mtime;
 	struct timespec		i_ctime;
 	unsigned int		i_blkbits;
-	unsigned long		i_version;
 	blkcnt_t		i_blocks;
 	unsigned short          i_bytes;
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
@@ -598,9 +601,6 @@ struct inode {
 	void			*i_security;
 #endif
 	void			*i_private; /* fs or device private pointer */
-#ifdef __NEED_I_SIZE_ORDERED
-	seqcount_t		i_size_seqcount;
-#endif
 };
 
 /*
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
convert-i386-pda-code-to-use-%fs.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch

