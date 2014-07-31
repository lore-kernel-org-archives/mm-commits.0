From: akpm@linux-foundation.org
Subject: [merged]
 mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path.patch removed
 from -mm tree
Date: Thu, 31 Jul 2014 13:22:14 -0700
Message-ID: <53daa576.pMGDxsfUg1SewVfI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:57209 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaGaUWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 16:22:15 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so432774vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 13:22:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: debugfs: move rounddown_pow_of_two() out from do_fault path
has been removed from the -mm tree.  Its filename was
     mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: debugfs: move rounddown_pow_of_two() out from do_fault path

do_fault_around() expects fault_around_bytes rounded down to nearest page
order.  Instead of calling rounddown_pow_of_two every time in
fault_around_pages()/fault_around_mask() we could do round down when user
changes fault_around_bytes via debugfs interface.

This also fixes bug when user set fault_around_bytes to 0.  Result of
rounddown_pow_of_two(0) is not defined, therefore fault_around_bytes == 0
doesn't work without this patch.

Let's set fault_around_bytes to PAGE_SIZE if user sets to something less
than PAGE_SIZE

[akpm@linux-foundation.org: tweak code layout]
Fixes: a9b0f861("mm: nominate faultaround area in bytes rather than page order")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN mm/memory.c~mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path mm/memory.c
--- a/mm/memory.c~mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path
+++ a/mm/memory.c
@@ -2758,23 +2758,18 @@ void do_set_pte(struct vm_area_struct *v
 	update_mmu_cache(vma, address, pte);
 }
 
-static unsigned long fault_around_bytes = 65536;
+static unsigned long fault_around_bytes = rounddown_pow_of_two(65536);
 
-/*
- * fault_around_pages() and fault_around_mask() round down fault_around_bytes
- * to nearest page order. It's what do_fault_around() expects to see.
- */
 static inline unsigned long fault_around_pages(void)
 {
-	return rounddown_pow_of_two(fault_around_bytes) / PAGE_SIZE;
+	return fault_around_bytes >> PAGE_SHIFT;
 }
 
 static inline unsigned long fault_around_mask(void)
 {
-	return ~(rounddown_pow_of_two(fault_around_bytes) - 1) & PAGE_MASK;
+	return ~(fault_around_bytes - 1) & PAGE_MASK;
 }
 
-
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
 {
@@ -2782,11 +2777,19 @@ static int fault_around_bytes_get(void *
 	return 0;
 }
 
+/*
+ * fault_around_pages() and fault_around_mask() expects fault_around_bytes
+ * rounded down to nearest page order. It's what do_fault_around() expects to
+ * see.
+ */
 static int fault_around_bytes_set(void *data, u64 val)
 {
 	if (val / PAGE_SIZE > PTRS_PER_PTE)
 		return -EINVAL;
-	fault_around_bytes = val;
+	if (val > PAGE_SIZE)
+		fault_around_bytes = rounddown_pow_of_two(val);
+	else
+		fault_around_bytes = PAGE_SIZE; /* rounddown_pow_of_two(0) is undefined */
 	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fault_around_bytes_fops,
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch
linux-next.patch

