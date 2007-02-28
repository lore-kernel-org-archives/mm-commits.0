From: akpm@linux-foundation.org
Subject: - swapcache-use-pg_owner_priv_1.patch removed from -mm tree
Date: Wed, 28 Feb 2007 00:24:49 -0800
Message-ID: <200702280824.l1S8Onv8010832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbXB1IYy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 03:24:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     Swapcache: use PG_owner_priv_1 
has been removed from the -mm tree.  Its filename was
     swapcache-use-pg_owner_priv_1.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Swapcache: use PG_owner_priv_1 
From: Nick Piggin <nickpiggin@yahoo.com.au>

Swapcache can use PG_owner_priv_1 rather than take up its own bit for
PG_swapcache, thereby saving a page flag.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 +++++-----
 mm/page_alloc.c            |    3 ---
 2 files changed, 5 insertions(+), 8 deletions(-)

diff -puN include/linux/page-flags.h~swapcache-use-pg_owner_priv_1 include/linux/page-flags.h
--- a/include/linux/page-flags.h~swapcache-use-pg_owner_priv_1
+++ a/include/linux/page-flags.h
@@ -84,15 +84,15 @@
 #define PG_writeback		12	/* Page is under writeback */
 #define PG_nosave		13	/* Used for system suspend/resume */
 #define PG_compound		14	/* Part of a compound page */
-#define PG_swapcache		15	/* Swap page: swp_entry_t in private */
+#define PG_mappedtodisk		15	/* Has blocks allocated on-disk */
 
-#define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
-#define PG_reclaim		17	/* To be reclaimed asap */
-#define PG_nosave_free		18	/* Used for system suspend/resume */
-#define PG_buddy		19	/* Page is free, on buddy lists */
+#define PG_reclaim		16	/* To be reclaimed asap */
+#define PG_nosave_free		17	/* Used for system suspend/resume */
+#define PG_buddy		18	/* Page is free, on buddy lists */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
+#define PG_swapcache		PG_owner_priv_1	/* swp_entry_t in private */
 
 #if (BITS_PER_LONG > 32)
 /*
diff -puN mm/page_alloc.c~swapcache-use-pg_owner_priv_1 mm/page_alloc.c
--- a/mm/page_alloc.c~swapcache-use-pg_owner_priv_1
+++ a/mm/page_alloc.c
@@ -201,7 +201,6 @@ static void bad_page(struct page *page)
 			1 << PG_dirty	|
 			1 << PG_reclaim |
 			1 << PG_slab    |
-			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_buddy );
 	set_page_count(page, 0);
@@ -435,7 +434,6 @@ static inline int free_pages_check(struc
 			1 << PG_active	|
 			1 << PG_reclaim	|
 			1 << PG_slab	|
-			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
 			1 << PG_buddy ))))
@@ -585,7 +583,6 @@ static int prep_new_page(struct page *pa
 			1 << PG_dirty	|
 			1 << PG_reclaim	|
 			1 << PG_slab    |
-			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
 			1 << PG_buddy ))))
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

rename-pg_checked-to-pg_owner_priv_1.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
sched-fix-smt-scheduler-bug.patch
adapt-page_lock_anon_vma-to-preempt_rcu.patch
swapcache-use-pg_owner_priv_1.patch
take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
kblockd-use-flush_work.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched2-sched-domain-sysctl.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
