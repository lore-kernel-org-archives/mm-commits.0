From: akpm@linux-foundation.org
Subject: + fs-reiserfs-cleanups.patch added to -mm tree
Date: Tue, 26 Jun 2007 13:24:06 -0700
Message-ID: <200706262024.l5QKO6SY001453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758150AbXFZUYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 16:24:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, npiggin@suse.de, vs@namesys.com


The patch titled
     fs/reiserfs/: cleanups
has been added to the -mm tree.  Its filename is
     fs-reiserfs-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/reiserfs/: cleanups
From: Adrian Bunk <bunk@stusta.de>

- remove the following no longer used functions:
  - bitmap.c: reiserfs_claim_blocks_to_be_allocated()
  - bitmap.c: reiserfs_release_claimed_blocks()
  - bitmap.c: reiserfs_can_fit_pages()

- make the following functions static:
  - inode.c: restart_transaction()
  - journal.c: reiserfs_async_progress_wait()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Vladimir V. Saveliev <vs@namesys.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c        |   57 ----------------------------------
 fs/reiserfs/inode.c         |    4 +-
 fs/reiserfs/journal.c       |    3 +
 include/linux/reiserfs_fs.h |    7 ----
 4 files changed, 4 insertions(+), 67 deletions(-)

diff -puN fs/reiserfs/bitmap.c~fs-reiserfs-cleanups fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~fs-reiserfs-cleanups
+++ a/fs/reiserfs/bitmap.c
@@ -1201,63 +1201,6 @@ int reiserfs_allocate_blocknrs(reiserfs_
 	return ret;
 }
 
-/* These 2 functions are here to provide blocks reservation to the rest of kernel */
-/* Reserve @blocks amount of blocks in fs pointed by @sb. Caller must make sure
-   there are actually this much blocks on the FS available */
-void reiserfs_claim_blocks_to_be_allocated(struct super_block *sb,	/* super block of
-									   filesystem where
-									   blocks should be
-									   reserved */
-					   int blocks	/* How much to reserve */
-    )
-{
-
-	/* Fast case, if reservation is zero - exit immediately. */
-	if (!blocks)
-		return;
-
-	spin_lock(&REISERFS_SB(sb)->bitmap_lock);
-	REISERFS_SB(sb)->reserved_blocks += blocks;
-	spin_unlock(&REISERFS_SB(sb)->bitmap_lock);
-}
-
-/* Unreserve @blocks amount of blocks in fs pointed by @sb */
-void reiserfs_release_claimed_blocks(struct super_block *sb,	/* super block of
-								   filesystem where
-								   blocks should be
-								   reserved */
-				     int blocks	/* How much to unreserve */
-    )
-{
-
-	/* Fast case, if unreservation is zero - exit immediately. */
-	if (!blocks)
-		return;
-
-	spin_lock(&REISERFS_SB(sb)->bitmap_lock);
-	REISERFS_SB(sb)->reserved_blocks -= blocks;
-	spin_unlock(&REISERFS_SB(sb)->bitmap_lock);
-	RFALSE(REISERFS_SB(sb)->reserved_blocks < 0,
-	       "amount of blocks reserved became zero?");
-}
-
-/* This function estimates how much pages we will be able to write to FS
-   used for reiserfs_file_write() purposes for now. */
-int reiserfs_can_fit_pages(struct super_block *sb	/* superblock of filesystem
-							   to estimate space */ )
-{
-	int space;
-
-	spin_lock(&REISERFS_SB(sb)->bitmap_lock);
-	space =
-	    (SB_FREE_BLOCKS(sb) -
-	     REISERFS_SB(sb)->reserved_blocks) >> (PAGE_CACHE_SHIFT -
-						   sb->s_blocksize_bits);
-	spin_unlock(&REISERFS_SB(sb)->bitmap_lock);
-
-	return space > 0 ? space : 0;
-}
-
 void reiserfs_cache_bitmap_metadata(struct super_block *sb,
                                     struct buffer_head *bh,
                                     struct reiserfs_bitmap_info *info)
diff -puN fs/reiserfs/inode.c~fs-reiserfs-cleanups fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~fs-reiserfs-cleanups
+++ a/fs/reiserfs/inode.c
@@ -207,8 +207,8 @@ static int file_capable(struct inode *in
 	return 0;
 }
 
-/*static*/ int restart_transaction(struct reiserfs_transaction_handle *th,
-				   struct inode *inode, struct treepath *path)
+static int restart_transaction(struct reiserfs_transaction_handle *th,
+			       struct inode *inode, struct treepath *path)
 {
 	struct super_block *s = th->t_super;
 	int len = th->t_blocks_allocated;
diff -puN fs/reiserfs/journal.c~fs-reiserfs-cleanups fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~fs-reiserfs-cleanups
+++ a/fs/reiserfs/journal.c
@@ -966,7 +966,8 @@ static int flush_older_commits(struct su
 	}
 	return 0;
 }
-int reiserfs_async_progress_wait(struct super_block *s)
+
+static int reiserfs_async_progress_wait(struct super_block *s)
 {
 	DEFINE_WAIT(wait);
 	struct reiserfs_journal *j = SB_JOURNAL(s);
diff -puN include/linux/reiserfs_fs.h~fs-reiserfs-cleanups include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~fs-reiserfs-cleanups
+++ a/include/linux/reiserfs_fs.h
@@ -1701,8 +1701,6 @@ static inline int reiserfs_transaction_f
 	return th->t_blocks_allocated - th->t_blocks_logged;
 }
 
-int reiserfs_async_progress_wait(struct super_block *s);
-
 struct reiserfs_transaction_handle *reiserfs_persistent_transaction(struct
 								    super_block
 								    *,
@@ -1857,8 +1855,6 @@ void padd_item(char *item, int total_len
 #define GET_BLOCK_NO_IMUX     8	/* i_mutex is not held, don't preallocate */
 #define GET_BLOCK_NO_DANGLE   16	/* don't leave any transactions running */
 
-int restart_transaction(struct reiserfs_transaction_handle *th,
-			struct inode *inode, struct treepath *path);
 void reiserfs_read_locked_inode(struct inode *inode,
 				struct reiserfs_iget_args *args);
 int reiserfs_find_actor(struct inode *inode, void *p);
@@ -2135,9 +2131,6 @@ void reiserfs_discard_prealloc(struct re
 			       struct inode *inode);
 void reiserfs_discard_all_prealloc(struct reiserfs_transaction_handle *th);
 #endif
-void reiserfs_claim_blocks_to_be_allocated(struct super_block *sb, int blocks);
-void reiserfs_release_claimed_blocks(struct super_block *sb, int blocks);
-int reiserfs_can_fit_pages(struct super_block *sb);
 
 /* hashes.c */
 __u32 keyed_hash(const signed char *msg, int len);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
mark-calibrate_xor_blocks-__init.patch
git-mmc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
cafe_nandc-the-olpc-laptop-is-not-available-for-100.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
remove-the-dead-cyberstormiii_scsi-option.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices-fix.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
kernel-sys_nic-should-include-linux-syscallsh.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
