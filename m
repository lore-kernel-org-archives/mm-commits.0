From: akpm@linux-foundation.org
Subject: + is_power_of_2-in-fs-block_devc.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:31:42 -0800
Message-ID: <200702251231.l1PCViRU029348@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34789 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964853AbXBYMb6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:31:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vignesh.babu@wipro.com


The patch titled
     is_power_of_2 in fs/block_dev.c
has been added to the -mm tree.  Its filename is
     is_power_of_2-in-fs-block_devc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: is_power_of_2 in fs/block_dev.c
From: Vignesh Babu BM <vignesh.babu@wipro.com>

Replace (n & (n-1)) in the context of power of 2 checks with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~is_power_of_2-in-fs-block_devc fs/block_dev.c
--- a/fs/block_dev.c~is_power_of_2-in-fs-block_devc
+++ a/fs/block_dev.c
@@ -22,6 +22,7 @@
 #include <linux/mount.h>
 #include <linux/uio.h>
 #include <linux/namei.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -65,7 +66,7 @@ static void kill_bdev(struct block_devic
 int set_blocksize(struct block_device *bdev, int size)
 {
 	/* Size must be a power of two, and between 512 and PAGE_SIZE */
-	if (size > PAGE_SIZE || size < 512 || (size & (size-1)))
+	if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
 		return -EINVAL;
 
 	/* Size cannot be smaller than the size supported by the device */
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

is_power_of_2-in-fat.patch
is_power_of_2-in-fs-hfs.patch
is_power_of_2-in-fs-block_devc.patch
