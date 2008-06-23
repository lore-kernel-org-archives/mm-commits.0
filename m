From: akpm@linux-foundation.org
Subject: - ext4-remove-double-definitions-of-xattr-macros.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:04:10 -0700
Message-ID: <200806232104.m5NL4ACe016252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787AbYFWVEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ext4: remove double definitions of xattr macros
has been removed from the -mm tree.  Its filename was
     ext4-remove-double-definitions-of-xattr-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: remove double definitions of xattr macros
From: Shen Feng <shen@cn.fujitsu.com>

remove the definitions of macros:

XATTR_TRUSTED_PREFIX

XATTR_USER_PREFIX

since they are defined in linux/xattr.h

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/xattr_trusted.c |    4 +---
 fs/ext4/xattr_user.c    |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ext4/xattr_trusted.c~ext4-remove-double-definitions-of-xattr-macros fs/ext4/xattr_trusted.c
--- a/fs/ext4/xattr_trusted.c~ext4-remove-double-definitions-of-xattr-macros
+++ a/fs/ext4/xattr_trusted.c
@@ -13,13 +13,11 @@
 #include "ext4.h"
 #include "xattr.h"
 
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t
 ext4_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
 			const char *name, size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX)-1;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (!capable(CAP_SYS_ADMIN))
diff -puN fs/ext4/xattr_user.c~ext4-remove-double-definitions-of-xattr-macros fs/ext4/xattr_user.c
--- a/fs/ext4/xattr_user.c~ext4-remove-double-definitions-of-xattr-macros
+++ a/fs/ext4/xattr_user.c
@@ -12,13 +12,11 @@
 #include "ext4.h"
 #include "xattr.h"
 
-#define XATTR_USER_PREFIX "user."
