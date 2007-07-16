From: akpm@linux-foundation.org
Subject: - is_power_of_2-ufs-superc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:28 -0700
Message-ID: <200707162058.l6GKwSl2002346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757357AbXGPVMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vignesh.babu@wipro.com, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     is_power_of_2: ufs/super.c
has been removed from the -mm tree.  Its filename was
     is_power_of_2-ufs-superc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: is_power_of_2: ufs/super.c
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ufs/super.c~is_power_of_2-ufs-superc fs/ufs/super.c
--- a/fs/ufs/super.c~is_power_of_2-ufs-superc
+++ a/fs/ufs/super.c
@@ -87,6 +87,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/log2.h>
 
 #include "swab.h"
 #include "util.h"
@@ -854,7 +855,7 @@ magic_found:
 	uspi->s_fmask = fs32_to_cpu(sb, usb1->fs_fmask);
 	uspi->s_fshift = fs32_to_cpu(sb, usb1->fs_fshift);
 
-	if (uspi->s_fsize & (uspi->s_fsize - 1)) {
+	if (!is_power_of_2(uspi->s_fsize)) {
 		printk(KERN_ERR "ufs_read_super: fragment size %u is not a power of 2\n",
 			uspi->s_fsize);
 			goto failed;
@@ -869,7 +870,7 @@ magic_found:
 			uspi->s_fsize);
 		goto failed;
 	}
-	if (uspi->s_bsize & (uspi->s_bsize - 1)) {
+	if (!is_power_of_2(uspi->s_bsize)) {
 		printk(KERN_ERR "ufs_read_super: block size %u is not a power of 2\n",
 			uspi->s_bsize);
 		goto failed;
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

origin.patch
git-ubi.patch
git-xfs.patch
is_power_of_2-ext4-superc.patch
