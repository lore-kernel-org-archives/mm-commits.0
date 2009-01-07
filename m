From: akpm@linux-foundation.org
Subject: - ia64-implement-interrupt-enabling-rwlocks-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:33:02 -0800
Message-ID: <200901072333.n07NX3eP014690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbZAGXdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:33:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl, holt@sgi.com, mingo@elte.hu, ptesarik@suse.cz, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: typo fix of implement interrupt-enabling rwlocks
has been removed from the -mm tree.  Its filename was
     ia64-implement-interrupt-enabling-rwlocks-fix.patch

This patch was dropped because it was folded into ia64-implement-interrupt-enabling-rwlocks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: typo fix of implement interrupt-enabling rwlocks
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Applied after: ia64-implement-interrupt-enabling-rwlocks.patch
==
Recently, __raw_read_lock_flags and __raw_write_lock_flags for ia64 was implemented.

But its patch has typo. then following warnings happend.

  CC      lib/spinlock_debug.o
lib/spinlock_debug.c: In function '_raw_read_lock':
lib/spinlock_debug.c:199: warning: passing argument 1 of '__raw_read_lock_flags' from incompatible pointer type
lib/spinlock_debug.c: In function '_raw_write_lock':
lib/spinlock_debug.c:274: warning: passing argument 1 of '__raw_write_lock_flags' from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Petr Tesarik <ptesarik@suse.cz>
Cc: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/spinlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/include/asm/spinlock.h~ia64-implement-interrupt-enabling-rwlocks-fix arch/ia64/include/asm/spinlock.h
--- a/arch/ia64/include/asm/spinlock.h~ia64-implement-interrupt-enabling-rwlocks-fix
+++ a/arch/ia64/include/asm/spinlock.h
@@ -123,7 +123,7 @@ do {											\
 #ifdef ASM_SUPPORTED
 
 static __always_inline void
-__raw_read_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+__raw_read_lock_flags(raw_rwlock_t *lock, unsigned long flags)
 {
 	__asm__ __volatile__ (
 		"tbit.nz p6, p0 = %1,%2\n"
@@ -174,7 +174,7 @@ do {								\
 #ifdef ASM_SUPPORTED
 
 static __always_inline void
-__raw_write_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+__raw_write_lock_flags(raw_rwlock_t *lock, unsigned long flags)
 {
 	__asm__ __volatile__ (
 		"tbit.nz p6, p0 = %1, %2\n"
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
devices-cgroup-allow-mkfifo.patch
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
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

