From: akpm@linux-foundation.org
Subject: +
 document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
 added to -mm tree
Date: Mon, 30 Mar 2015 15:09:50 -0700
Message-ID: <5519c9ae.9f0UC9fCitcuHI/b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbbC3WJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Mar 2015 18:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, emunson@akamai.com, mgorman@suse.de, mhocko@suse.cz, peterz@infradead.org, riel@redhat.com, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: document-interaction-between-compaction-and-the-unevictable-lru-fix
has been added to the -mm tree.  Its filename is
     document-interaction-between-compaction-and-the-unevictable-lru-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/document-interaction-between-compaction-and-the-unevictable-lru-fix.patch

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
Subject: document-interaction-between-compaction-and-the-unevictable-lru-fix

identify /proc/sys/vm/compact_unevictable directly

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~document-interaction-between-compaction-and-the-unevictable-lru-fix Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~document-interaction-between-compaction-and-the-unevictable-lru-fix
+++ a/Documentation/vm/unevictable-lru.txt
@@ -455,10 +455,11 @@ COMPACTING MLOCKED PAGES
 ------------------------
 
 The unevictable LRU can be scanned for compactable regions and the default
-behavior is to do so.  There is a sysctl to control this behavior (see
-Documentation/sysctl/vm.txt).  Once scanning of the unevictable LRU is
-enabled, the work of compaction is mostly handled by the page migration code
-and the same work flow as described in MIGRATING MLOCKED PAGES will apply.
+behavior is to do so.  /proc/sys/vm/compact_unevictable_allowed controls
+this behavior (see Documentation/sysctl/vm.txt).  Once scanning of the
+unevictable LRU is enabled, the work of compaction is mostly handled by
+the page migration code and the same work flow as described in MIGRATING
+MLOCKED PAGES will apply.
 
 
 mmap(MAP_LOCKED) SYSTEM CALL HANDLING
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
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
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

