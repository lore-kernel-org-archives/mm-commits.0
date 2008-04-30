From: akpm@linux-foundation.org
Subject: - fs-inodec-use-hlist_for_each_entry.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:25 -0700
Message-ID: <200804300541.m3U5fPDD029053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390AbYD3FmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, mm-commits@vger.kernel.org


The patch titled
     fs/inode.c: use hlist_for_each_entry()
has been removed from the -mm tree.  Its filename was
     fs-inodec-use-hlist_for_each_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/inode.c: use hlist_for_each_entry()
From: Matthias Kaehlcke <matthias@kaehlcke.net>

fs/inode.c: use hlist_for_each_entry() in find_inode() and find_inode_fast()

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/inode.c~fs-inodec-use-hlist_for_each_entry fs/inode.c
--- a/fs/inode.c~fs-inodec-use-hlist_for_each_entry
+++ a/fs/inode.c
@@ -495,8 +495,7 @@ static struct inode * find_inode(struct 
 	struct inode * inode = NULL;
 
 repeat:
-	hlist_for_each (node, head) { 
-		inode = hlist_entry(node, struct inode, i_hash);
+	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
@@ -520,8 +519,7 @@ static struct inode * find_inode_fast(st
 	struct inode * inode = NULL;
 
 repeat:
-	hlist_for_each (node, head) {
-		inode = hlist_entry(node, struct inode, i_hash);
+	hlist_for_each_entry(inode, node, head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

origin.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch

