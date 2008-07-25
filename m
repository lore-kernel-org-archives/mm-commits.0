From: akpm@linux-foundation.org
Subject: - ext2-remove-double-definitions-of-xattr-macros.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:13 -0700
Message-ID: <200807252256.m6PMuDfO003070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbYGYW4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shen@cn.fujitsu.com, cmm@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext2: remove double definitions of xattr macros
has been removed from the -mm tree.  Its filename was
     ext2-remove-double-definitions-of-xattr-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: remove double definitions of xattr macros
From: Shen Feng <shen@cn.fujitsu.com>

remove the definitions of macros:
XATTR_TRUSTED_PREFIX
XATTR_USER_PREFIX
since they are defined in linux/xattr.h

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/xattr_security.c |    2 +-
 fs/ext2/xattr_trusted.c  |    4 +---
 fs/ext2/xattr_user.c     |    4 +---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff -puN fs/ext2/xattr_security.c~ext2-remove-double-definitions-of-xattr-macros fs/ext2/xattr_security.c
--- a/fs/ext2/xattr_security.c~ext2-remove-double-definitions-of-xattr-macros
+++ a/fs/ext2/xattr_security.c
@@ -14,7 +14,7 @@ static size_t
 ext2_xattr_security_list(struct inode *inode, char *list, size_t list_size,
 			 const char *name, size_t name_len)
 {
-	const int prefix_len = sizeof(XATTR_SECURITY_PREFIX)-1;
+	const int prefix_len = XATTR_SECURITY_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (list && total_len <= list_size) {
diff -puN fs/ext2/xattr_trusted.c~ext2-remove-double-definitions-of-xattr-macros fs/ext2/xattr_trusted.c
--- a/fs/ext2/xattr_trusted.c~ext2-remove-double-definitions-of-xattr-macros
+++ a/fs/ext2/xattr_trusted.c
@@ -12,13 +12,11 @@
 #include <linux/ext2_fs.h>
 #include "xattr.h"
 
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t
 ext2_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
 			const char *name, size_t name_len)
 {
-	const int prefix_len = sizeof(XATTR_TRUSTED_PREFIX)-1;
+	const int prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (!capable(CAP_SYS_ADMIN))
diff -puN fs/ext2/xattr_user.c~ext2-remove-double-definitions-of-xattr-macros fs/ext2/xattr_user.c
--- a/fs/ext2/xattr_user.c~ext2-remove-double-definitions-of-xattr-macros
+++ a/fs/ext2/xattr_user.c
@@ -11,13 +11,11 @@
 #include "ext2.h"
 #include "xattr.h"
 
-#define XATTR_USER_PREFIX "user."
