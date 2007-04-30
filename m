From: akpm@linux-foundation.org
Subject: - make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:16:04 -0700
Message-ID: <200704302016.l3UKG4gl013967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946764AbXD3UVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:21:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     make-static-counters-in-new_inode-and-iunique-be-32-bits comments
has been removed from the -mm tree.  Its filename was
     make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch

This patch was dropped because it was folded into make-static-counters-in-new_inode-and-iunique-be-32-bits.patch

------------------------------------------------------
Subject: make-static-counters-in-new_inode-and-iunique-be-32-bits comments
From: Jeff Layton <jlayton@redhat.com>

mention that it's only the case for 32bit, non-LFS stat.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~make-static-counters-in-new_inode-and-iunique-be-32-bits-comments fs/inode.c
--- a/fs/inode.c~make-static-counters-in-new_inode-and-iunique-be-32-bits-comments
+++ a/fs/inode.c
@@ -535,7 +535,11 @@ repeat:
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
 
@@ -695,7 +699,11 @@ static unsigned long hash(struct super_b
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

nfs-suppress-warnings-about-nfs4err_old_stateid-in-nfs4_handle_exception.patch
make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
