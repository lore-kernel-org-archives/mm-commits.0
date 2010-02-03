From: akpm@linux-foundation.org
Subject: [folded] fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:19:37 -0800
Message-ID: <201002032019.o13KJbpZ016667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757867Ab0BCUTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:19:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs-symlink-write_begin-allocation-context-fix: reiser4 fix
has been removed from the -mm tree.  Its filename was
     fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-symlink-write_begin-allocation-context-fix: reiser4 fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

build fix.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file_conversion.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/file/file_conversion.c~fs-symlink-write_begin-allocation-context-fix-reiser4-fix fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~fs-symlink-write_begin-allocation-context-fix-reiser4-fix
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -692,7 +692,8 @@ int reiser4_write_begin_careful(struct f
 	start = pos & (PAGE_CACHE_SIZE - 1);
 	end = start + len;
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					   flags & AOP_FLAG_NOFS);
 	*pagep = page;
 	if (!page)
 		return -ENOMEM;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-mempolicyc-fix-indentation-of-the-comments-of-do_migrate_pages.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch
rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch
rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch
mm-remove-vm_lock_rmap-code.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

