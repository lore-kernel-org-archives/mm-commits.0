From: akpm@linux-foundation.org
Subject: + make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:13:30 -0700
Message-ID: <200704131913.l3DJDUGT007318@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbXDMTNu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hch@lst.de


The patch titled
     make-static-counters-in-new_inode-and-iunique-be-32-bits comments
has been added to the -mm tree.  Its filename is
     make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make-static-counters-in-new_inode-and-iunique-be-32-bits comments
From: Jeff Layton <jlayton@redhat.com>

mention that it's only the case for 32bit, non-LFS stat.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~make-static-counters-in-new_inode-and-iunique-be-32-bits-comments fs/inode.c
--- a/fs/inode.c~make-static-counters-in-new_inode-and-iunique-be-32-bits-comments
+++ a/fs/inode.c
@@ -536,7 +536,11 @@ repeat:
  */
 struct inode *new_inode(struct super_block *sb)
 {
-	/* 32 bits for compatability mode stat calls */
+	/*
+	 * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
+	 * error if st_ino won't fit in target struct field. Use 32bit counter
+	 * here to attempt to avoid that.
+	 */
 	static unsigned int last_ino;
 	struct inode * inode;
 
@@ -696,7 +700,11 @@ static unsigned long hash(struct super_b
  */
 ino_t iunique(struct super_block *sb, ino_t max_reserved)
 {
-	/* 32 bits for compatability mode stat calls */
+	/*
+	 * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
+	 * error if st_ino won't fit in target struct field. Use 32bit counter
+	 * here to attempt to avoid that.
+	 */
 	static unsigned int counter;
 	struct inode *inode;
 	struct hlist_head *head;
_

Patches currently in -mm which might be from jlayton@redhat.com are

make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
