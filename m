From: akpm@linux-foundation.org
Subject: - remove-redundant-check-from-proc_setattr.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:50 -0700
Message-ID: <200705090249.l492noOx009267@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969994AbXEICus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jjohansen@suse.de, agruen@suse.de, chrisw@sous-sol.org, hch@lst.de, jmorris@namei.org, sds@tycho.nsa.gov, tonyj@suse.de, mm-commits@vger.kernel.org


The patch titled
     Remove redundant check from proc_setattr()
has been removed from the -mm tree.  Its filename was
     remove-redundant-check-from-proc_setattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove redundant check from proc_setattr()
From: John Johansen <jjohansen@suse.de>

notify_change() already calls security_inode_setattr() before
calling iop->setattr.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~remove-redundant-check-from-proc_setattr fs/proc/base.c
--- a/fs/proc/base.c~remove-redundant-check-from-proc_setattr
+++ a/fs/proc/base.c
@@ -347,11 +347,8 @@ static int proc_setattr(struct dentry *d
 		return -EPERM;
 
 	error = inode_change_ok(inode, attr);
-	if (!error) {
-		error = security_inode_setattr(dentry, attr);
-		if (!error)
-			error = inode_setattr(inode, attr);
-	}
+	if (!error)
+		error = inode_setattr(inode, attr);
 	return error;
 }
 
_

Patches currently in -mm which might be from jjohansen@suse.de are

origin.patch
