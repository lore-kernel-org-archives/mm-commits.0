From: akpm@linux-foundation.org
Subject: + doc-filesystems-more-mount-cleanups.patch added to -mm tree
Date: Fri, 31 Jul 2009 13:53:23 -0700
Message-ID: <200907312053.n6VKrNCH006177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZGaUxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 16:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bergwolf@gmail.com, hch@infradead.org, miklos@szeredi.hu, randy.dunlap@oracle.com


The patch titled
     doc/filesystems: more mount cleanups
has been added to the -mm tree.  Its filename is
     doc-filesystems-more-mount-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc/filesystems: more mount cleanups
From: Peng Tao <bergwolf@gmail.com>

Documentation/filesystems/sharedsubtree.txt needs updating because the
mount command in util-linux package is well aware of shared subtree
features now.  The patch also fixes two typos in sharedsubtree.txt.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/sharedsubtree.txt |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN Documentation/filesystems/sharedsubtree.txt~doc-filesystems-more-mount-cleanups Documentation/filesystems/sharedsubtree.txt
--- a/Documentation/filesystems/sharedsubtree.txt~doc-filesystems-more-mount-cleanups
+++ a/Documentation/filesystems/sharedsubtree.txt
@@ -4,7 +4,7 @@ Shared Subtrees
 Contents:
 	1) Overview
 	2) Features
-	3) smount command
+	3) Setting mount states
 	4) Use-case
 	5) Detailed semantics
 	6) Quiz
@@ -135,10 +135,15 @@ replicas continue to be exactly same.
 	Binding a unbindable mount is a invalid operation.
 
 
-3) smount command
+3) Setting mount states
 
-	Modern mount(8) command is aware of shared subtree features,
-	so use it instead of the 'smount' command. [source code removed]
+	The mount command (util-linux package) can be used to set mount
+	states:
+
+	mount --make-shared mountpoint
+	mount --make-slave mountpoint
+	mount --make-private mountpoint
+	mount --make-unbindable mountpoint
 
 
 4) Use cases
@@ -209,7 +214,7 @@ replicas continue to be exactly same.
 		mount --rbind / /view/v3
 		mount --rbind / /view/v4
 
-		and if /usr has a versioning filesystem mounted, than that
+		and if /usr has a versioning filesystem mounted, then that
 		mount appears at /view/v1/usr, /view/v2/usr, /view/v3/usr and
 		/view/v4/usr too
 
@@ -249,7 +254,7 @@ replicas continue to be exactly same.
 
 		For example:
 			mount --make-shared /mnt
-			mount --bin /mnt /tmp
+			mount --bind /mnt /tmp
 
 		The mount at /mnt and that at /tmp are both shared and belong
 		to the same peer group. Anything mounted or unmounted under
_

Patches currently in -mm which might be from bergwolf@gmail.com are

doc-filesystems-more-mount-cleanups.patch

