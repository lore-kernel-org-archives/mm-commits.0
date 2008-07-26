From: akpm@linux-foundation.org
Subject: + vfs-increase-pseudo-filesystem-block-size-to-page_size.patch added to -mm tree
Date: Fri, 25 Jul 2008 23:58:12 -0700
Message-ID: <200807260658.m6Q6wC7O021048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbYGZHAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 03:00:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.nixon@citrix.com, Alex.Nixon@citrix.com, Ian.Campbell@eu.citrix.com, andi@firstfloor.org, hugh@veritas.com, jens.axboe@oracle.com, jeremy@goop.org, mingo@elte.hu, peterz@infradead.org, stable@kernel.org, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     VFS: increase pseudo-filesystem block size to PAGE_SIZE
has been added to the -mm tree.  Its filename is
     vfs-increase-pseudo-filesystem-block-size-to-page_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

vfs-increase-pseudo-filesystem-block-size-to-page_size.patch

