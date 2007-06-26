From: akpm@linux-foundation.org
Subject: + introduce-i_sync-fix.patch added to -mm tree
Date: Tue, 26 Jun 2007 13:26:37 -0700
Message-ID: <200706262026.l5QKQbIF001489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757521AbXFZU0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 16:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, joern@wohnheim.fh-wedel.de


The patch titled
     make fs/inode.c:wake_up_inode() static
has been added to the -mm tree.  Its filename is
     introduce-i_sync-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make fs/inode.c:wake_up_inode() static
From: Adrian Bunk <bunk@stusta.de>

wake_up_inode() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Joern Engel <joern@wohnheim.fh-wedel.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c                |   18 +++++++++---------
 include/linux/writeback.h |    1 -
 2 files changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/inode.c~introduce-i_sync-fix fs/inode.c
--- a/fs/inode.c~introduce-i_sync-fix
+++ a/fs/inode.c
@@ -99,6 +99,15 @@ struct inodes_stat_t inodes_stat;
 
 static struct kmem_cache * inode_cachep __read_mostly;
 
+static void wake_up_inode(struct inode *inode)
+{
+	/*
+	 * Prevent speculative execution through spin_unlock(&inode_lock);
+	 */
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_LOCK);
+}
+
 static struct inode *alloc_inode(struct super_block *sb)
 {
 	static const struct address_space_operations empty_aops;
@@ -1296,15 +1305,6 @@ static void __wait_on_freeing_inode(stru
 	spin_lock(&inode_lock);
 }
 
-void wake_up_inode(struct inode *inode)
-{
-	/*
-	 * Prevent speculative execution through spin_unlock(&inode_lock);
-	 */
-	smp_mb();
-	wake_up_bit(&inode->i_state, __I_LOCK);
-}
-
 /*
  * We rarely want to lock two inodes that do not have a parent/child
  * relationship (such as directory, child inode) simultaneously. The
diff -puN include/linux/writeback.h~introduce-i_sync-fix include/linux/writeback.h
--- a/include/linux/writeback.h~introduce-i_sync-fix
+++ a/include/linux/writeback.h
@@ -69,7 +69,6 @@ struct writeback_control {
  * fs/fs-writeback.c
  */	
 void writeback_inodes(struct writeback_control *wbc);
-void wake_up_inode(struct inode *inode);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
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
introduce-i_sync-fix.patch
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
