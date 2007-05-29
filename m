From: akpm@linux-foundation.org
Subject: - missing-const-from-reiserfs-min_key-declaration.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:35 -0700
Message-ID: <200705291851.l4TIpYeY008349@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757066AbXE2SwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Missing 'const' from reiserfs MIN_KEY declaration.
has been removed from the -mm tree.  Its filename was
     missing-const-from-reiserfs-min_key-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Missing 'const' from reiserfs MIN_KEY declaration.
From: David Woodhouse <dwmw2@infradead.org>

In stree.c, MIN_KEY is declared const. The extern declaration in dir.c
doesn't match...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/dir.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/dir.c~missing-const-from-reiserfs-min_key-declaration fs/reiserfs/dir.c
--- a/fs/reiserfs/dir.c~missing-const-from-reiserfs-min_key-declaration
+++ a/fs/reiserfs/dir.c
@@ -10,7 +10,7 @@
 #include <linux/buffer_head.h>
 #include <asm/uaccess.h>
 
-extern struct reiserfs_key MIN_KEY;
+extern const struct reiserfs_key MIN_KEY;
 
 static int reiserfs_readdir(struct file *, void *, filldir_t);
 static int reiserfs_dir_fsync(struct file *filp, struct dentry *dentry,
_

Patches currently in -mm which might be from dwmw2@infradead.org are

git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-ubi.patch
git-battery.patch
add-lzo1x-compression-support-to-the-kernel.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
