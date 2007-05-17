From: akpm@linux-foundation.org
Subject: + missing-const-from-reiserfs-min_key-declaration.patch added to -mm tree
Date: Thu, 17 May 2007 15:29:56 -0700
Message-ID: <200705172229.l4HMTu17002011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756784AbXEQWbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 18:31:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org


The patch titled
     Missing 'const' from reiserfs MIN_KEY declaration.
has been added to the -mm tree.  Its filename is
     missing-const-from-reiserfs-min_key-declaration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

remove-slab_ctor_constructor.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-ubi.patch
fix-incorrect-prototype-for-ipxrtr_route_packet.patch
git-battery.patch
ns16550a-restore-hs-settings-in-excr2-on-resume.patch
missing-const-from-reiserfs-min_key-declaration.patch
add-lzo1x-compression-support-to-the-kernel.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
