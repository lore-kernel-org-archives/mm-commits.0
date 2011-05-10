From: akpm@linux-foundation.org
Subject: + fuse-fix-oops-in-revalidate-when-called-with-null-nameidata.patch added to -mm tree
Date: Tue, 10 May 2011 14:57:49 -0700
Message-ID: <201105102157.p4ALvnIA024389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab1EJV6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 17:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, baryluk@smp.if.uj.edu.pl, tyhicks@linux.vnet.ibm.com


The patch titled
     fuse: fix oops in revalidate when called with NULL nameidata
has been added to the -mm tree.  Its filename is
     fuse-fix-oops-in-revalidate-when-called-with-null-nameidata.patch

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
Subject: fuse: fix oops in revalidate when called with NULL nameidata
From: Miklos Szeredi <mszeredi@suse.cz>

Some cases (e.g.  ecryptfs) can call ->dentry_revalidate with NULL
nameidata.

Tyler Hicks pointed out that this bug was introduced by commit e7c0a16786
"fuse: make fuse_dentry_revalidate() RCU aware"

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=34732

Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fuse/dir.c~fuse-fix-oops-in-revalidate-when-called-with-null-nameidata fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-oops-in-revalidate-when-called-with-null-nameidata
+++ a/fs/fuse/dir.c
@@ -174,7 +174,7 @@ static int fuse_dentry_revalidate(struct
 		if (!inode)
 			return 0;
 
-		if (nd->flags & LOOKUP_RCU)
+		if (nd && (nd->flags & LOOKUP_RCU))
 			return -ECHILD;
 
 		fc = get_fuse_conn(inode);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-fix-oops-in-revalidate-when-called-with-null-nameidata.patch

