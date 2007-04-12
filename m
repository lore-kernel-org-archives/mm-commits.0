From: akpm@linux-foundation.org
Subject: + remove-redundant-check-from-proc_setattr.patch added to -mm tree
Date: Thu, 12 Apr 2007 11:58:38 -0700
Message-ID: <200704121858.l3CIwcTl007120@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXDLS7j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 14:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jjohansen@suse.de, agruen@suse.de, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, tonyj@suse.de


The patch titled
     Remove redundant check from proc_setattr()
has been added to the -mm tree.  Its filename is
     remove-redundant-check-from-proc_setattr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove redundant check from proc_setattr()
From: John Johansen <jjohansen@suse.de>

notify_change() already calls security_inode_setattr() before
calling iop->setattr.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~remove-redundant-check-from-proc_setattr fs/proc/base.c
--- a/fs/proc/base.c~remove-redundant-check-from-proc_setattr
+++ a/fs/proc/base.c
@@ -344,11 +344,8 @@ static int proc_setattr(struct dentry *d
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

remove-redundant-check-from-proc_setattr.patch
