From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
 added to -mm tree
Date: Wed, 24 Jul 2013 15:28:35 -0700
Message-ID: <51f05513.awvOKIOWXgy96cnY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GXW2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 18:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, minchan@kernel.org, mel@csn.ul.ie, cody@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch added to -mm tree
To: akpm@linux-foundation.org,cody@linux.vnet.ibm.com,mel@csn.ul.ie,minchan@kernel.org,srivatsa.bhat@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 15:28:35 -0700


The patch titled
     Subject: mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch

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
Subject: mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix

remove unneeded `inline', small coding-style fix

Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix
+++ a/mm/page_alloc.c
@@ -1020,8 +1020,8 @@ static void change_pageblock_range(struc
  * Returns the new migratetype of the pageblock (or the same old migratetype
  * if it was unchanged).
  */
-static inline int try_to_steal_freepages(struct zone *zone, struct page *page,
-					 int start_type, int fallback_type)
+static int try_to_steal_freepages(struct zone *zone, struct page *page,
+				  int start_type, int fallback_type)
 {
 	int current_order = page_order(page);
 
@@ -1037,7 +1037,6 @@ static inline int try_to_steal_freepages
 	if (current_order >= pageblock_order / 2 ||
 	    start_type == MIGRATE_RECLAIMABLE ||
 	    page_group_by_mobility_disabled) {
-
 		int pages;
 
 		pages = move_freepages_block(zone, page, start_type);
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
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
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

