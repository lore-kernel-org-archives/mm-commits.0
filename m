From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch removed
 from -mm tree
Date: Thu, 10 Oct 2013 14:59:28 -0700
Message-ID: <52572340.yo2ghYVsRG4uLMD3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3JJV73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 17:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, namjae.jeon@samsung.com, akpm@linux-foundation.org

Subject: [to-be-updated] fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,namjae.jeon@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 14:59:28 -0700


The patch titled
     Subject: fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes

ERROR: code indent should use tabs where possible
#83: FILE: fs/fat/cache.c:331:
+ ^I^I^I * to map cluster in case of read request$

WARNING: please, no space before tabs
#83: FILE: fs/fat/cache.c:331:
+ ^I^I^I * to map cluster in case of read request$

ERROR: code indent should use tabs where possible
#85: FILE: fs/fat/cache.c:333:
+ ^I^I^I */$

WARNING: please, no space before tabs
#85: FILE: fs/fat/cache.c:333:
+ ^I^I^I */$

ERROR: code indent should use tabs where possible
#86: FILE: fs/fat/cache.c:334:
+  ^I^I^Iif (MSDOS_I(inode)->mmu_private >$

WARNING: please, no space before tabs
#86: FILE: fs/fat/cache.c:334:
+  ^I^I^Iif (MSDOS_I(inode)->mmu_private >$

WARNING: please, no spaces at the start of a line
#86: FILE: fs/fat/cache.c:334:
+  ^I^I^Iif (MSDOS_I(inode)->mmu_private >$

ERROR: code indent should use tabs where possible
#214: FILE: fs/fat/inode.c:261:
+ ^I^I * In case of writing in fallocated region, return 0 and$

WARNING: please, no space before tabs
#214: FILE: fs/fat/inode.c:261:
+ ^I^I * In case of writing in fallocated region, return 0 and$

ERROR: code indent should use tabs where possible
#215: FILE: fs/fat/inode.c:262:
+ ^I^I * fallback to buffered write.$

WARNING: please, no space before tabs
#215: FILE: fs/fat/inode.c:262:
+ ^I^I * fallback to buffered write.$

ERROR: code indent should use tabs where possible
#216: FILE: fs/fat/inode.c:263:
+ ^I^I */$

WARNING: please, no space before tabs
#216: FILE: fs/fat/inode.c:263:
+ ^I^I */$

total: 6 errors, 7 warnings, 162 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/fat-additions-to-support-fat_fallocate-v6.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |    6 +++---
 fs/fat/inode.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/fat/cache.c~fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes fs/fat/cache.c
--- a/fs/fat/cache.c~fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes
+++ a/fs/fat/cache.c
@@ -328,10 +328,10 @@ int fat_bmap(struct inode *inode, sector
 	if (sector >= last_block) {
 		if (!create) {
 			/*
- 			 * to map cluster in case of read request
+			 * to map cluster in case of read request
 			 * for a block in fallocated region
- 			 */
-  			if (MSDOS_I(inode)->mmu_private >
+			 */
+			if (MSDOS_I(inode)->mmu_private >
 				round_up(i_size, sb->s_blocksize))
 				goto out_map_cluster;
 
diff -puN fs/fat/inode.c~fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes fs/fat/inode.c
--- a/fs/fat/inode.c~fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes
+++ a/fs/fat/inode.c
@@ -258,9 +258,9 @@ static ssize_t fat_direct_IO(int rw, str
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
 		/*
- 		 * In case of writing in fallocated region, return 0 and
- 		 * fallback to buffered write.
- 		 */
+		 * In case of writing in fallocated region, return 0 and
+		 * fallback to buffered write.
+		 */
 		if (MSDOS_I(inode)->mmu_private >
 			round_up(i_size_read(inode), inode->i_sb->s_blocksize))
 			return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments-fix.patch
mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

