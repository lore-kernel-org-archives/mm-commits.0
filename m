From: akpm@linux-foundation.org
Subject: + mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
 added to -mm tree
Date: Mon, 19 Aug 2013 15:49:11 -0700
Message-ID: <5212a0e7.aWBfaaoCum7nn030%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3HSWtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 18:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, akpm@linux-foundation.org

Subject: + mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch added to -mm tree
To: akpm@linux-foundation.org,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 15:49:11 -0700


The patch titled
     Subject: mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix
has been added to the -mm tree.  Its filename is
     mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch

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
Subject: mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix

clarify comment

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix mm/mlock.c
--- a/mm/mlock.c~mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix
+++ a/mm/mlock.c
@@ -264,7 +264,10 @@ static bool __putback_lru_fast_prepare(s
 static void __putback_lru_fast(struct pagevec *pvec, int pgrescued)
 {
 	count_vm_events(UNEVICTABLE_PGMUNLOCKED, pagevec_count(pvec));
-	/* This includes put_page so we don't call it explicitly */
+	/*
+	 *__pagevec_lru_add() calls release_pages() so we don't call
+	 * put_page() explicitly
+	 */
 	__pagevec_lru_add(pvec);
 	count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
memcg-trivial-cleanups.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
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

