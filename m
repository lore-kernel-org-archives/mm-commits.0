From: akpm@linux-foundation.org
Subject: - vfs-increase-pseudo-filesystem-block-size-to-page_size.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:13:57 -0700
Message-ID: <200807301913.m6UJDvoI010805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbYG3TPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.nixon@citrix.com, Alex.Nixon@citrix.com, Ian.Campbell@eu.citrix.com, andi@firstfloor.org, hugh@veritas.com, jens.axboe@oracle.com, jeremy@goop.org, mingo@elte.hu, peterz@infradea


The patch titled
     VFS: increase pseudo-filesystem block size to PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     vfs-increase-pseudo-filesystem-block-size-to-page_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VFS: increase pseudo-filesystem block size to PAGE_SIZE
From: Alex Nixon <alex.nixon@citrix.com>

This commit:

    commit ba52de123d454b57369f291348266d86f4b35070
    Author: Theodore Ts'o <tytso@mit.edu>
    Date:   Wed Sep 27 01:50:49 2006 -0700

        [PATCH] inode-diet: Eliminate i_blksize from the inode structure
    

caused the block size used by pseudo-filesystems to decrease from
PAGE_SIZE to 1024 leading to a doubling of the number of context switches
during a kernbench run.

Signed-off-by: Alex Nixon <Alex.Nixon@citrix.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/libfs.c~vfs-increase-pseudo-filesystem-block-size-to-page_size fs/libfs.c
--- a/fs/libfs.c~vfs-increase-pseudo-filesystem-block-size-to-page_size
+++ a/fs/libfs.c
@@ -216,8 +216,8 @@ int get_sb_pseudo(struct file_system_typ
 
 	s->s_flags = MS_NOUSER;
 	s->s_maxbytes = ~0ULL;
-	s->s_blocksize = 1024;
-	s->s_blocksize_bits = 10;
+	s->s_blocksize = PAGE_SIZE;
+	s->s_blocksize_bits = PAGE_SHIFT;
 	s->s_magic = magic;
 	s->s_op = ops ? ops : &simple_super_operations;
 	s->s_time_gran = 1;
_

Patches currently in -mm which might be from alex.nixon@citrix.com are

origin.patch

