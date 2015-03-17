From: akpm@linux-foundation.org
Subject: +
 hfsplus-fix-b-tree-corruption-after-insertion-at-position-0.patch added to
 -mm tree
Date: Tue, 17 Mar 2015 16:34:27 -0700
Message-ID: <5508ba03.riF8pGW0mJrTMJdm%akpm__47448.6928819262$1426635282$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbbCQXe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Mar 2015 19:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: saproj@gmail.com, aia21@cam.ac.uk, hch@infradead.org, htl10@users.sourceforge.net, joe@perches.com, slava@dubeyko.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: fix B-tree corruption after insertion at position 0
has been added to the -mm tree.  Its filename is
     hfsplus-fix-b-tree-corruption-after-insertion-at-position-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-fix-b-tree-corruption-after-insertion-at-position-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-fix-b-tree-corruption-after-insertion-at-position-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Antonov <saproj@gmail.com>
Subject: hfsplus: fix B-tree corruption after insertion at position 0

Fix B-tree corruption when a new record is inserted at position 0 in the
node in hfs_brec_insert().  In this case a hfs_brec_update_parent() is
called to update the parent index node (if exists) and it is passed
hfs_find_data with a search_key containing a newly inserted key instead of
the key to be updated.  This results in an inconsistent index node.  The
bug reproduces on my machine after an extents overflow record for the
catalog file (CNID=4) is inserted into the extents overflow B-tree. 
Because of a low (reserved) value of CNID=4, it has to become the first
record in the first leaf node.

The resulting first leaf node is correct:

----------------------------------------------------
| key0.CNID=4 | key1.CNID=123 | key2.CNID=456, ... |
----------------------------------------------------
But the parent index key0 still contains the previous key CNID=123:
-----------------------
| key0.CNID=123 | ... |
-----------------------

A change in hfs_brec_insert() makes hfs_brec_update_parent() work
correctly by preventing it from getting fd->record=-1 value from
__hfs_brec_find().

Along the way, I removed duplicate code with unification of the if
condition.  The resulting code is equivalent to the original code because
node is never 0.

Also hfs_brec_update_parent() will now return an error after getting a
negative fd->record value.  However, the return value of
hfs_brec_update_parent() is not checked anywhere in the file and I'm
leaving it unchanged by this patch.  brec.c lacks error checking after
some other calls too, but this issue is of less importance than the one
being fixed by this patch.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Joe Perches <joe@perches.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/brec.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN fs/hfsplus/brec.c~hfsplus-fix-b-tree-corruption-after-insertion-at-position-0 fs/hfsplus/brec.c
--- a/fs/hfsplus/brec.c~hfsplus-fix-b-tree-corruption-after-insertion-at-position-0
+++ a/fs/hfsplus/brec.c
@@ -131,13 +131,16 @@ skip:
 	hfs_bnode_write(node, entry, data_off + key_len, entry_len);
 	hfs_bnode_dump(node);
 
-	if (new_node) {
-		/* update parent key if we inserted a key
-		 * at the start of the first node
-		 */
-		if (!rec && new_node != node)
-			hfs_brec_update_parent(fd);
+	/*
+	 * update parent key if we inserted a key
+	 * at the start of the node and it is not the new node
+	 */
+	if (!rec && new_node != node) {
+		hfs_bnode_read_key(node, fd->search_key, data_off + size);
+		hfs_brec_update_parent(fd);
+	}
 
+	if (new_node) {
 		hfs_bnode_put(fd->bnode);
 		if (!new_node->parent) {
 			hfs_btree_inc_height(tree);
@@ -168,9 +171,6 @@ skip:
 		goto again;
 	}
 
-	if (!rec)
-		hfs_brec_update_parent(fd);
