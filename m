From: akpm@linux-foundation.org
Subject: - remove-redundant-check-from-proc_sys_setattr.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:53 -0700
Message-ID: <200705090249.l492nrdV009277@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970022AbXEICux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jjohansen@suse.de, agruen@suse.de, alan@lxorguk.ukuu.org.uk, chrisw@sous-sol.org, hch@lst.de, jmorris@namei.org, sbeattie@suse.de, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Remove redundant check from proc_sys_setattr()
has been removed from the -mm tree.  Its filename was
     remove-redundant-check-from-proc_sys_setattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove redundant check from proc_sys_setattr()
From: John Johansen <jjohansen@suse.de>

notify_change() already calls security_inode_setattr() before
calling iop->setattr.

Alan sayeth

  This is a behaviour change on all of these and limits some behaviour of
  existing established security modules

  When inode_change_ok is called it has side effects.  This includes
  clearing the SGID bit on attribute changes caused by chmod.  If you make
  this change the results of some rulesets may be different before or after
  the change is made.

  I'm not saying the change is wrong but it does change behaviour so that
  needs looking at closely (ditto all other attribute twiddles)

Signed-off-by: Steve Beattie <sbeattie@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/proc/proc_sysctl.c~remove-redundant-check-from-proc_sys_setattr fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~remove-redundant-check-from-proc_sys_setattr
+++ a/fs/proc/proc_sysctl.c
@@ -429,11 +429,8 @@ static int proc_sys_setattr(struct dentr
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
