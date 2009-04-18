From: akpm@linux-foundation.org
Subject: + smack-check-for-smack-xattr-validity-in-smack_inode_setxattr.patch added to -mm tree
Date: Sat, 18 Apr 2009 14:25:33 -0700
Message-ID: <200904182125.n3ILPXfq004557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbZDRV2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Apr 2009 17:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: etienne.basset@numericable.fr, casey@schaufler-ca.com, jmorris@namei.org


The patch titled
     Smack: check for SMACK xattr validity in smack_inode_setxattr
has been added to the -mm tree.  Its filename is
     smack-check-for-smack-xattr-validity-in-smack_inode_setxattr.patch

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
Subject: Smack: check for SMACK xattr validity in smack_inode_setxattr
From: Etienne Basset <etienne.basset@numericable.fr>

Move checks for SMACK xattr validity from smack_inode_post_setxattr (which
cannot return an error to the user) to smack_inode_setxattr (which can
return an error).

Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN security/smack/smack_lsm.c~smack-check-for-smack-xattr-validity-in-smack_inode_setxattr security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-check-for-smack-xattr-validity-in-smack_inode_setxattr
+++ a/security/smack/smack_lsm.c
@@ -675,8 +675,12 @@ static int smack_inode_setxattr(struct d
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
-		/* a label cannot be void and cannot begin with '-' */
-		if (size == 0 || (size > 0 && ((char *)value)[0] == '-'))
+		/*
+		 * check label validity here so import wont fail on
+		 * post_setxattr
+		 */
+		if (size == 0 || size >= SMK_LABELLEN ||
+		    smk_import(value, size) == NULL)
 			rc = -EINVAL;
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
@@ -713,9 +717,6 @@ static void smack_inode_post_setxattr(st
 	if (strcmp(name, XATTR_NAME_SMACK))
 		return;
 
-	if (size >= SMK_LABELLEN)
-		return;
