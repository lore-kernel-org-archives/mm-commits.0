From: akpm@linux-foundation.org
Subject: + mm-mmapc-use-while-instead-of-ifgoto-fix.patch added to -mm
 tree
Date: Mon, 30 Mar 2015 14:58:33 -0700
Message-ID: <5519c709.KdgZH2oFUQvs0jNh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbbC3V6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Mar 2015 17:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, hughd@google.com, kirill.shutemov@linux.intel.com, klamm@yandex-team.ru, linux@rasmusvillemoes.dk, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmapc-use-while-instead-of-ifgoto-fix
has been added to the -mm tree.  Its filename is
     mm-mmapc-use-while-instead-of-ifgoto-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-use-while-instead-of-ifgoto-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-use-while-instead-of-ifgoto-fix.patch

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
Subject: mm-mmapc-use-while-instead-of-ifgoto-fix

fix 80-col overflows

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-use-while-instead-of-ifgoto-fix mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-use-while-instead-of-ifgoto-fix
+++ a/mm/mmap.c
@@ -1551,7 +1551,8 @@ unsigned long mmap_region(struct file *f
 
 	/* Clear old maps */
 	error = -ENOMEM;
-	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
+	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
+			      &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
 	}
@@ -1569,7 +1570,8 @@ unsigned long mmap_region(struct file *f
 	/*
 	 * Can we just expand an old mapping?
 	 */
-	vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff, NULL);
+	vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff,
+	                NULL);
 	if (vma)
 		goto out;
 
@@ -2737,7 +2739,8 @@ static unsigned long do_brk(unsigned lon
 	/*
 	 * Clear old maps.  this also does some error checking for us
 	 */
-	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
+	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
+			      &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

