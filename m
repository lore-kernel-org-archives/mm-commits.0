From: akpm@linux-foundation.org
Subject: - make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:56 -0700
Message-ID: <200705090249.l492nu8K009282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969883AbXEICuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     make iunique use a do/while loop rather than its obscure goto loop
has been removed from the -mm tree.  Its filename was
     make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN fs/inode.c~make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop fs/inode.c
--- a/fs/inode.c~make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop
+++ a/fs/inode.c
@@ -685,25 +685,21 @@ ino_t iunique(struct super_block *sb, in
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

origin.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
