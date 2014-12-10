From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch removed
 from -mm tree
Date: Wed, 10 Dec 2014 15:17:40 -0800
Message-ID: <5488d494.wgFXzWsZkINPkUaF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbaLJXRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch

This patch was dropped because it was folded into mm-fix-huge-zero-page-accounting-in-smaps-report.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix

use do_div to fix 32-bit build

fs/built-in.o: In function `smaps_account':
task_mmu.c:(.text+0x943a3): undefined reference to `__udivdi3'

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix
+++ a/fs/proc/task_mmu.c
@@ -461,11 +461,15 @@ static void smaps_account(struct mem_siz
 		mss->referenced += size;
 	mapcount = page_mapcount(page);
 	if (mapcount >= 2) {
+		u64 pss_delta;
+
 		if (dirty || PageDirty(page))
 			mss->shared_dirty += size;
 		else
 			mss->shared_clean += size;
-		mss->pss += ((u64)size << PSS_SHIFT) / mapcount;
+		pss_delta = (u64)size << PSS_SHIFT;
+		do_div(pss_delta, mapcount);
+		mss->pss += pss_delta;
 	} else {
 		if (dirty || PageDirty(page))
 			mss->private_dirty += size;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch

