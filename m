From: akpm@linux-foundation.org
Subject: + fix--typo-in-cifs_setattr.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:06:51 -0800
Message-ID: <200702142106.l1EL6p60009079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45561 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbXBNVG5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:06:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmueller@suse.de, sfrench@us.ibm.com


The patch titled
     Fix &&/& typo in cifs_setattr()
has been added to the -mm tree.  Its filename is
     fix--typo-in-cifs_setattr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix &&/& typo in cifs_setattr()
From: Dirk Mueller <dmueller@suse.de>

This patch fixes a && vs. & typo in cifs_setattr().

Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/inode.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cifs/inode.c~fix--typo-in-cifs_setattr fs/cifs/inode.c
--- a/fs/cifs/inode.c~fix--typo-in-cifs_setattr
+++ a/fs/cifs/inode.c
@@ -1359,7 +1359,7 @@ int cifs_setattr(struct dentry *direntry
 		and this check ensures that we are not being called from
 		sys_utimes in which case we ought to fail the call back to
 		the user when the server rejects the call */
-		if((rc) && (attrs->ia_valid &&
+		if((rc) && (attrs->ia_valid &
 			 (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
 			rc = 0;
 	}
_

Patches currently in -mm which might be from dmueller@suse.de are

fix--typo-in-cifs_setattr.patch
