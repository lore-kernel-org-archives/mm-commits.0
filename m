From: akpm@linux-foundation.org
Subject: - is_power_of_2-in-fs-block_devc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:52 -0700
Message-ID: <200705090244.l492iqnB008643@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970017AbXEICoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vignesh.babu@wipro.com, mm-commits@vger.kernel.org


The patch titled
     is_power_of_2 in fs/block_dev.c
has been removed from the -mm tree.  Its filename was
     is_power_of_2-in-fs-block_devc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -67,7 +68,7 @@ static void kill_bdev(struct block_devic
 int set_blocksize(struct block_device *bdev, int size)
 {
 	/* Size must be a power of two, and between 512 and PAGE_SIZE */
-	if (size > PAGE_SIZE || size < 512 || (size & (size-1)))
+	if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
 		return -EINVAL;
 
 	/* Size cannot be smaller than the size supported by the device */
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

origin.patch
git-alsa.patch
git-ia64.patch
git-scsi-misc.patch
