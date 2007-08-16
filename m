From: akpm@linux-foundation.org
Subject: + remove-fs-ext2-balloccreserve_blocks.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:03:57 -0700
Message-ID: <200708162103.l7GL3vZ6006624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759648AbXHPVEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mbligh@mbligh.org


The patch titled
     remove fs/ext2/balloc.c:reserve_blocks()
has been added to the -mm tree.  Its filename is
     remove-fs-ext2-balloccreserve_blocks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove fs/ext2/balloc.c:reserve_blocks()
From: Adrian Bunk <bunk@kernel.org>

reserve_blocks() is no longer used.

Spotted by the GNU C compiler.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |   35 -----------------------------------
 1 files changed, 35 deletions(-)

diff -puN fs/ext2/balloc.c~remove-fs-ext2-balloccreserve_blocks fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~remove-fs-ext2-balloccreserve_blocks
+++ a/fs/ext2/balloc.c
@@ -133,41 +133,6 @@ error_out:
 	return NULL;
 }
 
-/*
- * Set sb->s_dirt here because the superblock was "logically" altered.  We
- * need to recalculate its free blocks count and flush it out.
- */
-static int reserve_blocks(struct super_block *sb, int count)
-{
-	struct ext2_sb_info *sbi = EXT2_SB(sb);
-	struct ext2_super_block *es = sbi->s_es;
-	unsigned free_blocks;
-	unsigned root_blocks;
-
-	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
-	root_blocks = le32_to_cpu(es->s_r_blocks_count);
-
-	if (free_blocks < count)
-		count = free_blocks;
-
-	if (free_blocks < root_blocks + count && !capable(CAP_SYS_RESOURCE) &&
-	    sbi->s_resuid != current->fsuid &&
-	    (sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
-		/*
-		 * We are too close to reserve and we are not privileged.
-		 * Can we allocate anything at all?
-		 */
-		if (free_blocks > root_blocks)
-			count = free_blocks - root_blocks;
-		else
-			return 0;
-	}
-
-	percpu_counter_mod(&sbi->s_freeblocks_counter, -count);
-	sb->s_dirt = 1;
-	return count;
-}
-
 static void release_blocks(struct super_block *sb, int count)
 {
 	if (count) {
_

Patches currently in -mm which might be from bunk@kernel.org are

pass-g-to-assembler-under-config_debug_info-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
