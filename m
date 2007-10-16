From: akpm@linux-foundation.org
Subject: - remove-fs-ext2-balloccreserve_blocks.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:50:14 -0700
Message-ID: <200710162250.l9GMoEvW021863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbXJPWub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mbligh@mbligh.org, mm-commits@vger.kernel.org


The patch titled
     remove fs/ext2/balloc.c:reserve_blocks()
has been removed from the -mm tree.  Its filename was
     remove-fs-ext2-balloccreserve_blocks.patch

This patch was dropped because it was folded into ext2-reservations.patch

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
 1 file changed, 35 deletions(-)

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
-	percpu_counter_sub(&sbi->s_freeblocks_counter, count);
-	sb->s_dirt = 1;
-	return count;
-}
-
 static void release_blocks(struct super_block *sb, int count)
 {
 	if (count) {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
ext2-reservations.patch
remove-fs-ext2-balloccreserve_blocks.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
