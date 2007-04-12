From: akpm@linux-foundation.org
Subject: + remove-redundant-check-from-proc_sys_setattr.patch added to -mm tree
Date: Thu, 12 Apr 2007 12:00:32 -0700
Message-ID: <200704121900.l3CJ0Wma007319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55197 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbXDLTB2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 15:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jjohansen@suse.de, agruen@suse.de, alan@lxorguk.ukuu.org.uk, chrisw@sous-sol.org, jmorris@namei.org, sbeattie@suse.de, sds@tycho.nsa.gov


The patch titled
     Remove redundant check from proc_sys_setattr()
has been added to the -mm tree.  Its filename is
     remove-redundant-check-from-proc_sys_setattr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

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

remove-redundant-check-from-proc_setattr.patch
remove-redundant-check-from-proc_sys_setattr.patch
