From: akpm@linux-foundation.org
Subject: [merged] fuse-fix-oops-in-revalidate-when-called-with-null-nameidata.patch removed from -mm tree
Date: Wed, 11 May 2011 12:07:55 -0700
Message-ID: <201105111900.p4BJ0bCF018868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab1EKTBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 May 2011 15:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, baryluk@smp.if.uj.edu.pl, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fuse: fix oops in revalidate when called with NULL nameidata
has been removed from the -mm tree.  Its filename was
     fuse-fix-oops-in-revalidate-when-called-with-null-nameidata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

