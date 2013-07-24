From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 24 Jul 2013 12:25:42 -0700
Message-ID: <51f02a36.4iiIlFiC9aIhYIub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3GXTZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 15:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 12:25:42 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff -puN drivers/md/raid1.c~linux-next-git-rejects drivers/md/raid1.c
--- a/drivers/md/raid1.c~linux-next-git-rejects
+++ a/drivers/md/raid1.c
@@ -1852,38 +1852,10 @@ static int process_checks(struct r1bio *
 	/* Fix variable parts of all bios */
 	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
 	for (i = 0; i < conf->raid_disks * 2; i++) {
-<<<<<<< HEAD
-		int j;
-		int size;
-		struct bio *b = r1_bio->bios[i];
-		if (b->bi_end_io != end_sync_read)
-			continue;
-		/* fixup the bio for reuse */
-		bio_reset(b);
-		b->bi_vcnt = vcnt;
-		b->bi_size = r1_bio->sectors << 9;
-		b->bi_sector = r1_bio->sector +
-			conf->mirrors[i].rdev->data_offset;
-		b->bi_bdev = conf->mirrors[i].rdev->bdev;
-		b->bi_end_io = end_sync_read;
-		b->bi_private = r1_bio;
-
-		size = b->bi_size;
-		for (j = 0; j < vcnt ; j++) {
-			struct bio_vec *bi;
-			bi = &b->bi_io_vec[j];
-			bi->bv_offset = 0;
-			if (size > PAGE_SIZE)
-				bi->bv_len = PAGE_SIZE;
-			else
-				bi->bv_len = size;
-			size -= PAGE_SIZE;
-=======
 		struct bio *b = r1_bio->bios[i];
 		if (b->bi_end_io == end_sync_read) {
 			b->bi_next = NULL;
 			bio_rewind(b);
->>>>>>> linux-next/akpm-base
 		}
 	}
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

