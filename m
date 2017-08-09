From: akpm@linux-foundation.org
Subject: + mm-swap-add-swap-readahead-hit-statistics-fix.patch added to
 -mm tree
Date: Wed, 09 Aug 2017 14:52:59 -0700
Message-ID: <598b843b.z4XOTxyP43x5Atrg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58646 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdHIVxA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 17:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@intel.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-add-swap-readahead-hit-statistics-fix
has been added to the -mm tree.  Its filename is
     mm-swap-add-swap-readahead-hit-statistics-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-add-swap-readahead-hit-statistics-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-add-swap-readahead-hit-statistics-fix.patch

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
Subject: mm-swap-add-swap-readahead-hit-statistics-fix

don't display swap stats if CONFOG_SWAP=n

Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 ++
 mm/vmstat.c                   |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/vm_event_item.h~mm-swap-add-swap-readahead-hit-statistics-fix include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-swap-add-swap-readahead-hit-statistics-fix
+++ a/include/linux/vm_event_item.h
@@ -106,8 +106,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		VMACACHE_FIND_HITS,
 		VMACACHE_FULL_FLUSHES,
 #endif
+#ifdef CONFIG_SWAP
 		SWAP_RA,
 		SWAP_RA_HIT,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/vmstat.c~mm-swap-add-swap-readahead-hit-statistics-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-swap-add-swap-readahead-hit-statistics-fix
+++ a/mm/vmstat.c
@@ -1098,9 +1098,10 @@ const char * const vmstat_text[] = {
 	"vmacache_find_hits",
 	"vmacache_full_flushes",
 #endif
-
+#ifdef CONFIG_SWAP
 	"swap_ra",
 	"swap_ra_hit",
+#endif
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-make-tlb_flush_pending-global-fix.patch
mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

