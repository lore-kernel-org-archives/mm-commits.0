From: akpm@linux-foundation.org
Subject: + fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch added to -mm tree
Date: Tue, 03 Jun 2014 13:01:21 -0700
Message-ID: <538e2991.OWWckPps7+jBwVpq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaFCUBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2014 16:01:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cse.cem@gmail.com, alan@linux.intel.com, hirofumi@mail.parknet.co.jp

Subject: + fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch added to -mm tree
To: hirofumi@mail.parknet.co.jp,alan@linux.intel.com,cse.cem@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 03 Jun 2014 13:01:21 -0700


The patch titled
     Subject: fat: Fix missed error code by "add support for DOS 1.x formatted volumes"
has been added to the -mm tree.  Its filename is
     fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-fat-add-support-for-dos-1x-formatted-volumes-fix.patch
fs-fat-cleanup-string-initializations-char-instead-of-char.patch
fat-add-i_disksize-to-represent-uninitialized-size-v4.patch
fat-add-fat_fallocate-operation-v4.patch
fat-zero-out-seek-range-on-_fat_get_block-v4.patch
fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch

