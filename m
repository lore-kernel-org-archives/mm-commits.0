From: akpm@linux-foundation.org
Subject: + mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch
 added to -mm tree
Date: Thu, 29 Jan 2015 13:51:06 -0800
Message-ID: <54caab4a.5fZJoJPJ3mBM3rpy%akpm__16346.4066260078$1422568283$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881AbbA2VvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 16:51:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agshew@gmail.com, khlebnikov@yandex-team.ru, klamm@yandex-team.ru, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix
has been added to the -mm tree.  Its filename is
     mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch

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
Subject: mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix

use min_t

Cc: <stable@vger.kernel.org>
Cc: Andrew Shewmaker <agshew@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Rik van Riel <riel@redhat.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix mm/mmap.c
--- a/mm/mmap.c~mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix
+++ a/mm/mmap.c
@@ -220,7 +220,7 @@ int __vm_enough_memory(struct mm_struct
 	 */
 	if (mm) {
 		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
-		allowed -= min((long)mm->total_vm / 32, reserve);
+		allowed -= min_t(long, mm->total_vm / 32, reserve);
 	}
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

