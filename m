From: akpm@linux-foundation.org
Subject: [folded-merged]
 fat-additions-to-support-fat_fallocate-fix-fix.patch removed from -mm tree
Date: Thu, 19 Sep 2013 16:22:28 -0700
Message-ID: <523b8734.3Em6w+axUWcp5HdQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3ISXW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:22:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, namjae.jeon@samsung.com, hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org

Subject: [folded-merged] fat-additions-to-support-fat_fallocate-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,hirofumi@mail.parknet.co.jp,namjae.jeon@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:22:28 -0700


The patch titled
     Subject: fat-additions-to-support-fat_fallocate-fix-fix
has been removed from the -mm tree.  Its filename was
     fat-additions-to-support-fat_fallocate-fix-fix.patch

This patch was dropped because it was folded into fat-additions-to-support-fat_fallocate.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fat-additions-to-support-fat_fallocate-fix-fix

use the new d_count()

Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-additions-to-support-fat_fallocate-fix-fix fs/fat/inode.c
diff -puN fs/fat/file.c~fat-additions-to-support-fat_fallocate-fix-fix fs/fat/file.c
--- a/fs/fat/file.c~fat-additions-to-support-fat_fallocate-fix-fix
+++ a/fs/fat/file.c
@@ -163,7 +163,7 @@ static int fat_file_release(struct inode
 	mmu_private_ideal = round_up(inode->i_size, sb->s_blocksize);
 
 	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
-	    filp->f_dentry->d_count == 1)
+	    d_count(filp->f_dentry) == 1)
 		fat_truncate_blocks(inode, inode->i_size);
 	mutex_unlock(&inode->i_mutex);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly-fix.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

