From: akpm@linux-foundation.org
Subject: + swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 24 Jul 2013 14:38:56 -0700
Message-ID: <51f04970.QW9O62tCaRrLsyla%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3GXVi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 17:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@kernel.org, akpm@linux-foundation.org

Subject: + swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,shli@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 14:38:56 -0700


The patch titled
     Subject: swap-make-cluster-allocation-per-cpu-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch

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
Subject: swap-make-cluster-allocation-per-cpu-checkpatch-fixes

WARNING: line over 80 characters
#91: FILE: include/linux/swap.h:230:
+	struct percpu_cluster __percpu *percpu_cluster; /* per cpu's swap location */

WARNING: braces {} are not necessary for single statement blocks
#234: FILE: mm/swapfile.c:561:
+		while (scan_swap_map_ssd_cluster_conflict(si, offset)) {
+			scan_swap_map_try_ssd_cluster(si, &offset, &scan_base);
+		}

total: 0 errors, 2 warnings, 195 lines checked

./patches/swap-make-cluster-allocation-per-cpu.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/swapfile.c~swap-make-cluster-allocation-per-cpu-checkpatch-fixes mm/swapfile.c
--- a/mm/swapfile.c~swap-make-cluster-allocation-per-cpu-checkpatch-fixes
+++ a/mm/swapfile.c
@@ -558,9 +558,8 @@ static unsigned long scan_swap_map(struc
 
 checks:
 	if (si->cluster_info) {
-		while (scan_swap_map_ssd_cluster_conflict(si, offset)) {
+		while (scan_swap_map_ssd_cluster_conflict(si, offset))
 			scan_swap_map_try_ssd_cluster(si, &offset, &scan_base);
-		}
 	}
 	if (!(si->flags & SWP_WRITEOK))
 		goto no_page;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
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

