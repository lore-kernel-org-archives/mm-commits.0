From: akpm@linux-foundation.org
Subject: + dcache-dont-expose-uninitialized-memory-in.patch added to -mm tree
Date: Wed, 17 Oct 2007 15:32:06 -0700
Message-ID: <200710172232.l9HMW6S4011667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757083AbXJQWcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 18:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     dcache: don't expose uninitialized memory in /proc/<pid>/fd/<fd>
has been added to the -mm tree.  Its filename is
     dcache-dont-expose-uninitialized-memory-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dcache: don't expose uninitialized memory in /proc/<pid>/fd/<fd>
From: J. Bruce Fields <bfields@citi.umich.edu>

Well, it's not especially important that target->d_iname get the contents
of dentry->d_iname, but it's important that it get initialized with
*something*, otherwise we're just exposing some random piece of memory to
anyone who reads the link at /proc/<pid>/fd/<fd> for the deleted file, when
it's still held open by someone.

I've run a test program that copies a short (<36 character) name ontop of a
long (>=36 character) name and see that the first time I run it, without
this patch, I get unpredicatable results out of /proc/<pid>/fd/<fd>.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/dcache.c~dcache-dont-expose-uninitialized-memory-in fs/dcache.c
--- a/fs/dcache.c~dcache-dont-expose-uninitialized-memory-in
+++ a/fs/dcache.c
@@ -1479,6 +1479,8 @@ static void switch_names(struct dentry *
 			 * dentry:internal, target:external.  Steal target's
 			 * storage and make target internal.
 			 */
+			memcpy(target->d_iname, dentry->d_name.name,
+					dentry->d_name.len + 1);
 			dentry->d_name.name = target->d_name.name;
 			target->d_name.name = target->d_iname;
 		}
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
dcache-trivial-comment-fix.patch
dcache-dont-expose-uninitialized-memory-in.patch
git-nfsd-broke-reiser4.patch
