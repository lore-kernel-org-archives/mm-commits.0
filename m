From: akpm@linux-foundation.org
Subject: - rename-pg_checked-to-pg_owner_priv_1.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:26 -0800
Message-ID: <200703020506.l2256Qaf000796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42276 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422699AbXCBFG1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     Rename PG_checked to PG_owner_priv_1
has been removed from the -mm tree.  Its filename was
     rename-pg_checked-to-pg_owner_priv_1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Rename PG_checked to PG_owner_priv_1
From: Nick Piggin <nickpiggin@yahoo.com.au>

Rename PG_checked to PG_owner_priv_1 to reflect its availablilty as a
private flag for use by the owner/allocator of the page.  In the case of
pagecache pages (which might be considered to be owned by the mm),
filesystems may use the flag.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 +++-
 mm/page_alloc.c            |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/page-flags.h~rename-pg_checked-to-pg_owner_priv_1 include/linux/page-flags.h
--- a/include/linux/page-flags.h~rename-pg_checked-to-pg_owner_priv_1
+++ a/include/linux/page-flags.h
@@ -76,7 +76,7 @@
 #define PG_active		 6
 #define PG_slab			 7	/* slab debug (Suparna wants this) */
 
-#define PG_checked		 8	/* kill me in 2.5.<early>. */
+#define PG_owner_priv_1		 8	/* Owner use. If pagecache, fs may use*/
 #define PG_arch_1		 9
 #define PG_reserved		10
 #define PG_private		11	/* If pagecache, has fs-private data */
@@ -91,6 +91,8 @@
 #define PG_nosave_free		18	/* Used for system suspend/resume */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
+/* PG_owner_priv_1 users should have descriptive aliases */
+#define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
 #if (BITS_PER_LONG > 32)
 /*
diff -puN mm/page_alloc.c~rename-pg_checked-to-pg_owner_priv_1 mm/page_alloc.c
--- a/mm/page_alloc.c~rename-pg_checked-to-pg_owner_priv_1
+++ a/mm/page_alloc.c
@@ -600,7 +600,7 @@ static int prep_new_page(struct page *pa
 
 	page->flags &= ~(1 << PG_uptodate | 1 << PG_error |
 			1 << PG_referenced | 1 << PG_arch_1 |
-			1 << PG_checked | 1 << PG_mappedtodisk);
+			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
sched-remove-smt-nice.patch
take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
kblockd-use-flush_work.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched2-sched-domain-sysctl.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
