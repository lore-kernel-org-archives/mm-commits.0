From: akpm@linux-foundation.org
Subject: - profile-dont-include-asm-ptraceh-twice.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:12 -0800
Message-ID: <200901072216.n07MGCf6015920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894AbZAGWQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     profile: don't include <asm/ptrace.h> twice.
has been removed from the -mm tree.  Its filename was
     profile-dont-include-asm-ptraceh-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: profile: don't include <asm/ptrace.h> twice.
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, kernel/profile.c include <asm/ptrace.h> twice.  It can be
removed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/profile.c~profile-dont-include-asm-ptraceh-twice kernel/profile.c
--- a/kernel/profile.c~profile-dont-include-asm-ptraceh-twice
+++ a/kernel/profile.c
@@ -445,7 +445,6 @@ void profile_tick(int type)
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 #include <asm/uaccess.h>
-#include <asm/ptrace.h>
 
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

