From: akpm@linux-foundation.org
Subject: + make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:42:30 -0700
Message-ID: <200704131842.l3DIgUce006637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbXDMSnP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hch@lst.de


The patch titled
     make iunique use a do/while loop rather than its obscure goto loop
has been added to the -mm tree.  Its filename is
     make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make iunique use a do/while loop rather than its obscure goto loop
From: Jeffrey Layton <jlayton@redhat.com>

A while back, Christoph mentioned that he thought that iunique ought to be
cleaned up to use a more conventional loop construct. This patch does that,
turning the strange goto loop into a do/while.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff -puN fs/inode.c~make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop fs/inode.c
--- a/fs/inode.c~make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop
+++ a/fs/inode.c
@@ -697,25 +697,21 @@ ino_t iunique(struct super_block *sb, in
 {
 	static ino_t counter;
 	struct inode *inode;
-	struct hlist_head * head;
+	struct hlist_head *head;
 	ino_t res;
+
 	spin_lock(&inode_lock);
-retry:
-	if (counter > max_reserved) {
-		head = inode_hashtable + hash(sb,counter);
+	do {
+		if (counter <= max_reserved)
+			counter = max_reserved + 1;
 		res = counter++;
+		head = inode_hashtable + hash(sb, res);
 		inode = find_inode_fast(sb, head, res);
-		if (!inode) {
-			spin_unlock(&inode_lock);
-			return res;
-		}
-	} else {
-		counter = max_reserved + 1;
-	}
-	goto retry;
-	
-}
+	} while (inode != NULL);
+	spin_unlock(&inode_lock);
 
+	return res;
+}
 EXPORT_SYMBOL(iunique);
 
 struct inode *igrab(struct inode *inode)
_

Patches currently in -mm which might be from jlayton@redhat.com are

make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
