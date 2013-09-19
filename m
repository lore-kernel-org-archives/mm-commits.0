From: akpm@linux-foundation.org
Subject: +
 fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch added to
 -mm tree
Date: Thu, 19 Sep 2013 16:26:57 -0700
Message-ID: <523b8841.JIZKM5JR9kr0scJS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3ISX06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, namjae.jeon@samsung.com, akpm@linux-foundation.org

Subject: + fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,namjae.jeon@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:26:57 -0700


The patch titled
     Subject: fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
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

