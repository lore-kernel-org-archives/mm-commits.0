From: akpm@linux-foundation.org
Subject: - fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:58 -0700
Message-ID: <200710180654.l9I6swxr030560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760733AbXJRHjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:39:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     fs/autofs4/inode.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/autofs4/inode.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/autofs4/inode.c | 10467 -> 10435 (-32 bytes)
 fs/autofs4/inode.o | 98576 -> 98552 (-24 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/autofs4/inode.c~fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/autofs4/inode.c
@@ -312,13 +312,11 @@ int autofs4_fill_super(struct super_bloc
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
 
-	sbi = kmalloc(sizeof(*sbi), GFP_KERNEL);
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
 	DPRINTK("starting up, sbi = %p",sbi);
 
-	memset(sbi, 0, sizeof(*sbi));
-
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
 	sbi->pipefd = -1;
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-cifs.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
