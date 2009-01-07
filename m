From: akpm@linux-foundation.org
Subject: - clocksource-pass-clocksource-to-read-callback-v2-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 13:27:33 -0800
Message-ID: <200901072127.n07LRXkK008269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbZAGV1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 16:27:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, damm@igel.co.jp, mm-commits@vger.kernel.org


The patch titled
     clocksource pass clocksource powerpc fix
has been removed from the -mm tree.  Its filename was
     clocksource-pass-clocksource-to-read-callback-v2-fix.patch

This patch was dropped because it was folded into clocksource-pass-clocksource-to-read-callback.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource pass clocksource powerpc fix
From: Hugh Dickins <hugh@veritas.com>

Fix powerpc build of clocksource pass clocksource mods:

arch/powerpc/kernel/time.c:88: warning: initialization from incompatible pointer type
arch/powerpc/kernel/time.c:99: warning: initialization from incompatible pointer type
arch/powerpc/kernel/time.c:770: error: conflicting types for 'rtc_read'
arch/powerpc/kernel/time.c:80: error: previous declaration of 'rtc_read' was here
arch/powerpc/kernel/time.c:775: error: conflicting types for 'timebase_read'
arch/powerpc/kernel/time.c:91: error: previous declaration of 'timebase_read' was here
make[1]: *** [arch/powerpc/kernel/time.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Magnus Damm <damm@igel.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/time.c~clocksource-pass-clocksource-to-read-callback-v2-fix arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~clocksource-pass-clocksource-to-read-callback-v2-fix
+++ a/arch/powerpc/kernel/time.c
@@ -77,7 +77,7 @@
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
 
-static cycle_t rtc_read(void);
+static cycle_t rtc_read(struct clocksource *);
 static struct clocksource clocksource_rtc = {
 	.name         = "rtc",
 	.rating       = 400,
@@ -88,7 +88,7 @@ static struct clocksource clocksource_rt
 	.read         = rtc_read,
 };
 
-static cycle_t timebase_read(void);
+static cycle_t timebase_read(struct clocksource *);
 static struct clocksource clocksource_timebase = {
 	.name         = "timebase",
 	.rating       = 400,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-v2-fix.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
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
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

