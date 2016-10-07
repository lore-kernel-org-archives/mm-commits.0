From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmalloc-fix-align-value-calculation-error-fix.patch removed from -mm
 tree
Date: Fri, 07 Oct 2016 16:27:01 -0700
Message-ID: <57f82f45./HbJ+9FNn+KQMfRV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38247 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753920AbcJGX1C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:27:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, minchan@kernel.org, rientjes@google.com, tj@kernel.org, zijun_hu@htc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-align-value-calculation-error-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-align-value-calculation-error-fix.patch

This patch was dropped because it was folded into mm-vmalloc-fix-align-value-calculation-error.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-fix-align-value-calculation-error-fix

s/get_order_long()/get_count_order_long()/ to match get_count_order()

Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: zijun_hu <zijun_hu@htc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   34 +++++++++++++++++-----------------
 mm/vmalloc.c           |    2 +-
 2 files changed, 18 insertions(+), 18 deletions(-)

diff -puN include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-fix include/linux/bitops.h
--- a/include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-fix
+++ a/include/linux/bitops.h
@@ -75,6 +75,23 @@ static inline int get_count_order(unsign
 	return order;
 }
 
+/**
+ * get_count_order_long - get order after rounding @l up to power of 2
+ * @l: parameter
+ *
+ * The same as get_count_order() but accepts a long type parameter
+ * or 0 is returned if @l == 0UL
+ */
+static inline int get_count_order_long(unsigned long l)
+{
+	if (l == 0UL)
+		return 0;
+	else if (l & (l - 1UL))
+		return fls_long(l);
+	else
+		return fls_long(l) - 1;
+}
+
 static __always_inline unsigned long hweight_long(unsigned long w)
 {
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
@@ -192,23 +209,6 @@ static inline unsigned fls_long(unsigned
 }
 
 /**
- * get_order_long - get order after rounding @l up to power of 2
- * @l: parameter
- *
- * it is same as get_count_order() but long type parameter
- * or 0 is returned if @l == 0UL
- */
-static inline int get_order_long(unsigned long l)
-{
-	if (l == 0UL)
-		return 0;
-	else if (l & (l - 1UL))
-		return fls_long(l);
-	else
-		return fls_long(l) - 1;
-}
-
-/**
  * __ffs64 - find first set bit in a 64 bit word
  * @word: The 64 bit word
  *
diff -puN mm/vmalloc.c~mm-vmalloc-fix-align-value-calculation-error-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-align-value-calculation-error-fix
+++ a/mm/vmalloc.c
@@ -1360,7 +1360,7 @@ static struct vm_struct *__get_vm_area_n
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP)
-		align = 1ul << clamp_t(int, get_order_long(size),
+		align = 1ul << clamp_t(int, get_count_order_long(size),
 				       PAGE_SHIFT, IOREMAP_MAX_ORDER);
 
 	size = PAGE_ALIGN(size);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-fix-align-value-calculation-error.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
a.patch

