From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch removed from -mm
 tree
Date: Fri, 06 Jun 2014 14:05:37 -0700
Message-ID: <53922d21.wtNL4a0GqdqzIiOc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaFFVFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cse.cem@gmail.com, alan@linux.intel.com, hirofumi@mail.parknet.co.jp

Subject: [folded-merged] fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch removed from -mm tree
To: hirofumi@mail.parknet.co.jp,alan@linux.intel.com,cse.cem@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:05:37 -0700


The patch titled
     Subject: fat: Fix missed error code by "add support for DOS 1.x formatted volumes"
has been removed from the -mm tree.  Its filename was
     fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch

This patch was dropped because it was folded into fs-fat-add-support-for-dos-1x-formatted-volumes.patch

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: Fix missed error code by "add support for DOS 1.x formatted volumes"

In "add support for DOS 1.x formatted volumes" patch, "error" is
overwritten by fat_read_bpb().

This patch reset "error" to -EIO, to return proper error.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: Conrad Meyer <cse.cem@gmail.com>
Tested-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fat/inode.c~fs-fat-add-support-for-dos-1x-formatted-volumes-fix fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-add-support-for-dos-1x-formatted-volumes-fix
+++ a/fs/fat/inode.c
@@ -1543,6 +1543,7 @@ int fat_fill_super(struct super_block *s
 	logical_sector_size = bpb.fat_sector_size;
 	sbi->sec_per_clus = bpb.fat_sec_per_clus;
 
+	error = -EIO;
 	if (logical_sector_size < sb->s_blocksize) {
 		fat_msg(sb, KERN_ERR, "logical sector size too small for device"
 		       " (logical sector size = %u)", logical_sector_size);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fs-fat-add-support-for-dos-1x-formatted-volumes.patch
fs-fat-cleanup-string-initializations-char-instead-of-char.patch

