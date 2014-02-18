From: akpm@linux-foundation.org
Subject: + hfsplus-remove-unused-variable-in-hfsplus_get_block.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:58:51 -0800
Message-ID: <5303d79b.hmM4eC4oKF1ksr88%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBRV6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:58:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sougata@tuxera.com

Subject: + hfsplus-remove-unused-variable-in-hfsplus_get_block.patch added to -mm tree
To: sougata@tuxera.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:58:51 -0800


The patch titled
     Subject: fs/hfsplus/extents.c: remove unused variable in hfsplus_get_block
has been added to the -mm tree.  Its filename is
     hfsplus-remove-unused-variable-in-hfsplus_get_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-remove-unused-variable-in-hfsplus_get_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-remove-unused-variable-in-hfsplus_get_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hfsplus-remove-unused-variable-in-hfsplus_get_block.patch

