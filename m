From: akpm@linux-foundation.org
Subject: [merged] fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:20 -0700
Message-ID: <5591af14.vxo/3DrbSSKpDirU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbbF2UsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ext4/super.c: use strreplace() in ext4_fill_super()
has been removed from the -mm tree.  Its filename was
     fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: fs/ext4/super.c: use strreplace() in ext4_fill_super()

This makes a very large function a little smaller.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ext4/super.c~fs-ext4-superc-use-strreplace-in-ext4_fill_super fs/ext4/super.c
--- a/fs/ext4/super.c~fs-ext4-superc-use-strreplace-in-ext4_fill_super
+++ a/fs/ext4/super.c
@@ -3420,7 +3420,6 @@ static int ext4_fill_super(struct super_
 	unsigned long journal_devnum = 0;
 	unsigned long def_mount_opts;
 	struct inode *root;
-	char *cp;
 	const char *descr;
 	int ret = -ENOMEM;
 	int blocksize, clustersize;
@@ -3456,8 +3455,7 @@ static int ext4_fill_super(struct super_
 #endif
 
 	/* Cleanup superblock name */
-	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
-		*cp = '!';
+	strreplace(sb->s_id, '/', '!');
 
 	/* -EINVAL is default */
 	ret = -EINVAL;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

