From: akpm@linux-foundation.org
Subject: [merged] mm-mm_struct-remove-16-bytes-of-alignment-padding-on-64-bit-builds.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:25 -0700
Message-ID: <201103232040.p2NKe1ua028489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600Ab1CWUyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     mm: mm_struct: remove 16 bytes of alignment padding on 64 bit builds
has been removed from the -mm tree.  Its filename was
     mm-mm_struct-remove-16-bytes-of-alignment-padding-on-64-bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: mm_struct: remove 16 bytes of alignment padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder mm_struct to remove 16 bytes of alignment padding on 64 bit
builds.  On my config this shrinks mm_struct by enough to fit in one fewer
cache lines and allows more objects per slab in mm_struct kmem_cache under
SLUB.

slabinfo before patch :-
    Sizes (bytes)     Slabs
    --------------------------------
    Object :     848  Total  :       9
    SlabObj:     896  Full   :       2
    SlabSiz:   16384  Partial:       5
    Loss   :      48  CpuSlab:       2
    Align  :      64  Objects:      18

 slabinfo after :-
    Sizes (bytes)     Slabs
    --------------------------------
    Object :     832  Total  :       7
    SlabObj:     832  Full   :       2
    SlabSiz:   16384  Partial:       3
    Loss   :       0  CpuSlab:       2
    Align  :      64  Objects:      19

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/mm_types.h~mm-mm_struct-remove-16-bytes-of-alignment-padding-on-64-bit-builds include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-mm_struct-remove-16-bytes-of-alignment-padding-on-64-bit-builds
+++ a/include/linux/mm_types.h
@@ -237,8 +237,9 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	int map_count;				/* number of VMAs */
-	struct rw_semaphore mmap_sem;
+
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
+	struct rw_semaphore mmap_sem;
 
 	struct list_head mmlist;		/* List of maybe swapped mm's.	These are globally strung
 						 * together off init_mm.mmlist, and are protected
@@ -281,6 +282,9 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
+	/* How many tasks sharing this mm are OOM_DISABLE */
+	atomic_t oom_disable_count;
+
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	struct core_state *core_state; /* coredumping support */
@@ -313,8 +317,6 @@ struct mm_struct {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
 #endif
-	/* How many tasks sharing this mm are OOM_DISABLE */
-	atomic_t oom_disable_count;
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch
linux-next.patch

