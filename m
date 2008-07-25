From: akpm@linux-foundation.org
Subject: - reiserfs-remove-double-definitions-of-xattr-macros.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:21 -0700
Message-ID: <200807252257.m6PMvLJ3003178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbYGYXDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shen@cn.fujitsu.com, cmm@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: remove double definitions of xattr macros
has been removed from the -mm tree.  Its filename was
     reiserfs-remove-double-definitions-of-xattr-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
