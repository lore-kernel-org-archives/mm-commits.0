From: akpm@linux-foundation.org
Subject: +
 mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path.patch added to
 -mm tree
Date: Mon, 28 Jul 2014 14:23:46 -0700
Message-ID: <53d6bf62.cgDQzJuS+1v8J8C5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:42435 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaG1VXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jul 2014 17:23:48 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1962853pdj.4
        for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2014 14:23:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: debugfs: move rounddown_pow_of_two() out from do_fault path
has been added to the -mm tree.  Its filename is
     mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Fixes: a9b0f861("mm: nominate faultaround area in bytes rather than page order")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/memory.c~mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path mm/memory.c
--- a/mm/memory.c~mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path
+++ a/mm/memory.c
@@ -2758,20 +2758,16 @@ void do_set_pte(struct vm_area_struct *v
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
 
 
@@ -2782,11 +2778,18 @@ static int fault_around_bytes_get(void *
 	return 0;
 }
 
+/*
+ * fault_around_pages() and fault_around_mask() expects fault_around_bytes
+ * rounded down to nearest page order. It's what do_fault_around() expects to see.
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

mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path.patch
mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch
linux-next.patch

