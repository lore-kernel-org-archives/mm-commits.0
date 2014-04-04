From: akpm@linux-foundation.org
Subject: [merged]
 hfsplus-remove-unused-variable-in-hfsplus_get_block.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:36:39 -0700
Message-ID: <533f09c7.4/gzt3qk8JBGfQCG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDTgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sougata@tuxera.com

Subject: [merged] hfsplus-remove-unused-variable-in-hfsplus_get_block.patch removed from -mm tree
To: sougata@tuxera.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:36:39 -0700


The patch titled
     Subject: fs/hfsplus/extents.c: remove unused variable in hfsplus_get_block
has been removed from the -mm tree.  Its filename was
     hfsplus-remove-unused-variable-in-hfsplus_get_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sougata Santra <sougata@tuxera.com>
Subject: fs/hfsplus/extents.c: remove unused variable in hfsplus_get_block

The variable is defined but not used.  Generally it compiles away with -O2
optimization hence it does not show a warning.

Signed-off-by: Sougata Santra <sougata@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-remove-unused-variable-in-hfsplus_get_block fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-remove-unused-variable-in-hfsplus_get_block
+++ a/fs/hfsplus/extents.c
@@ -227,10 +227,8 @@ int hfsplus_get_block(struct inode *inod
 	u32 ablock, dblock, mask;
 	sector_t sector;
 	int was_dirty = 0;
-	int shift;
 
 	/* Convert inode block to disk allocation block */
-	shift = sbi->alloc_blksz_shift - sb->s_blocksize_bits;
 	ablock = iblock >> sbi->fs_shift;
 
 	if (iblock >= hip->fs_blocks) {
_

Patches currently in -mm which might be from sougata@tuxera.com are

origin.patch
hfsplus-fix-longname-handling.patch

