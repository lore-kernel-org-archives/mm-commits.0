From: akpm@linux-foundation.org
Subject: [nacked] fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch removed from -mm tree
Date: Mon, 05 Nov 2012 12:06:56 -0800
Message-ID: <20121105200657.1F9EC5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47869 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:07:00 -0500
Received: by mail-wi0-f202.google.com with SMTP id hr7so273538wib.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:06:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, namjae.jeon@samsung.com, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat-exportfs-rebuild-inode-if-ilookup-fails-fix
has been removed from the -mm tree.  Its filename was
     fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fat-exportfs-rebuild-inode-if-ilookup-fails-fix

fix warnings/types

fs/fat/nfs.c: In function 'fat_nfs_get_inode':
fs/fat/nfs.c:68: warning: passing argument 3 of 'fat_get_blknr_offset' from incompatible pointer type
fs/fat/fat.h:218: note: expected 'sector_t *' but argument is of type 'loff_t *'
fs/fat/inode.c: In function '__fat_write_inode':
fs/fat/inode.c:630: warning: passing argument 3 of 'fat_get_blknr_offset' from incompatible pointer type
fs/fat/fat.h:218: note: expected 'sector_t *' but argument is of type 'loff_t *'

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    3 ++-
 fs/fat/nfs.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fat-exportfs-rebuild-inode-if-ilookup-fails-fix fs/fat/inode.c
--- a/fs/fat/inode.c~fat-exportfs-rebuild-inode-if-ilookup-fails-fix
+++ a/fs/fat/inode.c
@@ -616,7 +616,8 @@ static int __fat_write_inode(struct inod
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh;
 	struct msdos_dir_entry *raw_entry;
-	loff_t i_pos, blocknr;
+	loff_t i_pos;
+	sector_t blocknr;
 	int offset, err;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
diff -puN fs/fat/nfs.c~fat-exportfs-rebuild-inode-if-ilookup-fails-fix fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-exportfs-rebuild-inode-if-ilookup-fails-fix
+++ a/fs/fat/nfs.c
@@ -63,7 +63,7 @@ static struct inode *fat_nfs_get_inode(s
 	if (inode == NULL && MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
 		struct buffer_head *bh = NULL;
 		struct msdos_dir_entry *de ;
-		loff_t blocknr;
+		sector_t blocknr;
 		int offset;
 		fat_get_blknr_offset(MSDOS_SB(sb), i_pos, &blocknr, &offset);
 		bh = sb_bread(sb, blocknr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

