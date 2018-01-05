From: akpm@linux-foundation.org
Subject: +
 mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch added to
 -mm tree
Date: Fri, 05 Jan 2018 12:54:10 -0800
Message-ID: <5a4fe5f2.hkonm7Ipo0nLEa+A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752948AbeAEUyM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jan 2018 15:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jinli.zjl@alibaba-inc.com, mgorman@techsingularity.net, shidao.ytt@alibaba-inc.com, zhiche.yy@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix
has been added to the -mm tree.  Its filename is
     mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch

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
Subject: mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix

tweak code comment

Cc: Caspar Zhang <jinli.zjl@alibaba-inc.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oliver Yang <zhiche.yy@alibaba-inc.com>
Cc: shidao.ytt <shidao.ytt@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/fadvise.c~mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix
+++ a/mm/fadvise.c
@@ -128,12 +128,11 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 		start_index = (offset+(PAGE_SIZE-1)) >> PAGE_SHIFT;
 		end_index = (endbyte >> PAGE_SHIFT);
 		/*
-		 * page at end_index will be inclusively discarded according
-		 * to invalidate_mapping_pages() implementation, thus, minus
-		 * end_index by 1 means we would skip the last page.
-		 * Yet, if endbyte is page-aligned, or it is at the end of
-		 * file, we should not skip, discarding the last page is just
-		 * safe enough.
+		 * The page at end_index will be inclusively discarded according
+		 * by invalidate_mapping_pages(), so subtracting 1 from
+		 * end_index means we will skip the last page.  But if endbyte
+		 * is page aligned or is at the end of file, we should not skip
+		 * that page - discarding the last page is safe enough.
 		 */
 		if ((endbyte & ~PAGE_MASK) != ~PAGE_MASK &&
 				endbyte != inode->i_size - 1) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
kernel-exitc-export-abort-to-modules.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

