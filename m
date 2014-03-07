From: akpm@linux-foundation.org
Subject: + mm-compactionc-isolate_freepages_block-small-tuneup.patch added to -mm tree
Date: Thu, 06 Mar 2014 16:38:40 -0800
Message-ID: <53191510.A/DD92Zmne5kIdim%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaCGAil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 19:38:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, lauraa@codeaurora.org, iamjoonsoo.kim@lge.com, b.zolnierkie@samsung.com, akpm@linux-foundation.org

Subject: + mm-compactionc-isolate_freepages_block-small-tuneup.patch added to -mm tree
To: akpm@linux-foundation.org,b.zolnierkie@samsung.com,iamjoonsoo.kim@lge.com,lauraa@codeaurora.org,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 16:38:40 -0800


The patch titled
     Subject: mm/compaction.c:isolate_freepages_block(): small tuneup
has been added to the -mm tree.  Its filename is
     mm-compactionc-isolate_freepages_block-small-tuneup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compactionc-isolate_freepages_block-small-tuneup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compactionc-isolate_freepages_block-small-tuneup.patch

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
Subject: mm/compaction.c:isolate_freepages_block(): small tuneup

- remove unneeded `continue'

- expand the scope if the `if (isloated)' test, to optimise a code path
  which is rarely actualyl taken.

Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN mm/compaction.c~mm-compactionc-isolate_freepages_block-small-tuneup mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-isolate_freepages_block-small-tuneup
+++ a/mm/compaction.c
@@ -293,14 +293,14 @@ static unsigned long isolate_freepages_b
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
-		total_isolated += isolated;
-		for (i = 0; i < isolated; i++) {
-			list_add(&page->lru, freelist);
-			page++;
-		}
-
-		/* If a page was split, advance to the end of it */
 		if (isolated) {
+			total_isolated += isolated;
+			for (i = 0; i < isolated; i++) {
+				list_add(&page->lru, freelist);
+				page++;
+			}
+
+			/* If a page was split, advance to the end of it */
 			blockpfn += isolated - 1;
 			cursor += isolated - 1;
 			continue;
@@ -309,9 +309,6 @@ static unsigned long isolate_freepages_b
 isolate_fail:
 		if (strict)
 			break;
-		else
-			continue;
-
 	}
 
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
revert-kallsyms-fix-absolute-addresses-for-kaslr.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

