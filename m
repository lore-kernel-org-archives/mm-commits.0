From: akpm@linux-foundation.org
Subject: + fs-inodec-use-hlist_for_each_entry.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:29:36 -0800
Message-ID: <200802290129.m1T1TaKd031362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801AbYB2BaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:30:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net


The patch titled
     fs/inode.c: use hlist_for_each_entry()
has been added to the -mm tree.  Its filename is
     fs-inodec-use-hlist_for_each_entry.patch

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
Subject: fs/inode.c: use hlist_for_each_entry()
From: Matthias Kaehlcke <matthias@kaehlcke.net>

fs/inode.c: use hlist_for_each_entry() in find_inode() and find_inode_fast()

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
+	hlist_for_each_entry (inode, node, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;
 		if (!test(inode, data))
@@ -520,8 +519,7 @@ static struct inode * find_inode_fast(st
 	struct inode * inode = NULL;
 
 repeat:
-	hlist_for_each (node, head) {
-		inode = hlist_entry(node, struct inode, i_hash);
+	hlist_for_each_entry (inode, node, head, i_hash) {
 		if (inode->i_ino != ino)
 			continue;
 		if (inode->i_sb != sb)
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

cosa-srp-convert-channel_datarsem-to-mutex.patch
convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch
fs-inodec-use-hlist_for_each_entry.patch

