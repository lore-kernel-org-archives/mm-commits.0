From: akpm@linux-foundation.org
Subject: [folded] drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:53:28 -0700
Message-ID: <200906172253.n5HMrSRa013238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850AbZFQWxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adrianosf@uol.com.br, mm-commits@vger.kernel.org


The patch titled
     drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#82: FILE: drivers/char/mem.c:885:
+	{11,"kmsg",    S_IRUGO | S_IWUSR,           &kmsg_fops, NULL},
 	   ^

ERROR: space required after that ',' (ctx:VxV)
#87: FILE: drivers/char/mem.c:887:
+	{12,"oldmem",    S_IRUSR | S_IWUSR | S_IRGRP, &oldmem_fops, NULL},
 	   ^

ERROR: "foo * bar" should be "foo *bar"
#94: FILE: drivers/char/mem.c:891:
+static int memory_open(struct inode * inode, struct file * filp)

ERROR: space required after that ',' (ctx:VxV)
#119: FILE: drivers/char/mem.c:914:
+			ret = filp->f_op->open(inode,filp);
 			                            ^

total: 4 errors, 0 warnings, 134 lines checked

./patches/drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Adriano dos Santos Fernandes <adrianosf@uol.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/mem.c~drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes
+++ a/drivers/char/mem.c
@@ -888,7 +888,7 @@ static const struct {
 #endif
 };
 
-static int memory_open(struct inode * inode, struct file * filp)
+static int memory_open(struct inode *inode, struct file *filp)
 {
 	int ret = 0;
 	int i;
@@ -911,7 +911,7 @@ static int memory_open(struct inode * in
 		ret = -ENXIO;
 	else
 		if (filp->f_op && filp->f_op->open)
-			ret = filp->f_op->open(inode,filp);
+			ret = filp->f_op->open(inode, filp);
 
 	unlock_kernel();
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

