From: akpm@linux-foundation.org
Subject: + reiserfs-remove-double-definitions-of-xattr-macros.patch added to -mm tree
Date: Wed, 28 May 2008 21:24:31 -0700
Message-ID: <200805290424.m4T4OVAs016131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYE2EZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 00:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shen@cn.fujitsu.com, cmm@us.ibm.com


The patch titled
     reiserfs: remove double definitions of xattr macros
has been added to the -mm tree.  Its filename is
     reiserfs-remove-double-definitions-of-xattr-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: remove double definitions of xattr macros
From: Shen Feng <shen@cn.fujitsu.com>

remove the definitions of macros:
XATTR_SECURITY_PREFIX
XATTR_TRUSTED_PREFIX
XATTR_USER_PREFIX
since they are defined in linux/xattr.h

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr_security.c |    2 --
 fs/reiserfs/xattr_trusted.c  |    2 --
 fs/reiserfs/xattr_user.c     |    2 --
 3 files changed, 6 deletions(-)

diff -puN fs/reiserfs/xattr_security.c~reiserfs-remove-double-definitions-of-xattr-macros fs/reiserfs/xattr_security.c
--- a/fs/reiserfs/xattr_security.c~reiserfs-remove-double-definitions-of-xattr-macros
+++ a/fs/reiserfs/xattr_security.c
@@ -6,8 +6,6 @@
 #include <linux/reiserfs_xattr.h>
 #include <asm/uaccess.h>
 
-#define XATTR_SECURITY_PREFIX "security."
-
 static int
 security_get(struct inode *inode, const char *name, void *buffer, size_t size)
 {
diff -puN fs/reiserfs/xattr_trusted.c~reiserfs-remove-double-definitions-of-xattr-macros fs/reiserfs/xattr_trusted.c
--- a/fs/reiserfs/xattr_trusted.c~reiserfs-remove-double-definitions-of-xattr-macros
+++ a/fs/reiserfs/xattr_trusted.c
@@ -7,8 +7,6 @@
 #include <linux/reiserfs_xattr.h>
 #include <asm/uaccess.h>
 
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static int
 trusted_get(struct inode *inode, const char *name, void *buffer, size_t size)
 {
diff -puN fs/reiserfs/xattr_user.c~reiserfs-remove-double-definitions-of-xattr-macros fs/reiserfs/xattr_user.c
--- a/fs/reiserfs/xattr_user.c~reiserfs-remove-double-definitions-of-xattr-macros
+++ a/fs/reiserfs/xattr_user.c
@@ -10,8 +10,6 @@
 # include <linux/reiserfs_acl.h>
 #endif
 
-#define XATTR_USER_PREFIX "user."
