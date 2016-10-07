From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch removed from
 -mm tree
Date: Fri, 07 Oct 2016 16:27:10 -0700
Message-ID: <57f82f4e.35+tqdnhYxezkI87%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753920AbcJGX1L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zijun_hu@htc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch

This patch was dropped because it was folded into mm-vmalloc-fix-align-value-calculation-error.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix

move get_count_order[_long] definitions to pick up fls_long()

Cc: zijun_hu <zijun_hu@htc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   52 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix include/linux/bitops.h
--- a/include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix
+++ a/include/linux/bitops.h
@@ -65,32 +65,6 @@ static inline int get_bitmask_order(unsi
 	return order;	/* We could be slightly more clever with -1 here... */
 }
 
-static inline int get_count_order(unsigned int count)
-{
-	int order;
-
-	order = fls(count) - 1;
-	if (count & (count - 1))
-		order++;
-	return order;
-}
-
-/**
- * get_count_order_long - get order after rounding @l up to power of 2
- * @l: parameter
- *
- * it is same as get_count_order() but with long type parameter
- */
-static inline int get_count_order_long(unsigned long l)
-{
-	if (l == 0UL)
-		return -1;
-	else if (l & (l - 1UL))
-		return (int)fls_long(l);
-	else
-		return (int)fls_long(l) - 1;
-}
-
 static __always_inline unsigned long hweight_long(unsigned long w)
 {
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
@@ -259,6 +233,32 @@ static inline unsigned long __ffs64(u64
 })
 #endif
 
+static inline int get_count_order(unsigned int count)
+{
+	int order;
+
+	order = fls(count) - 1;
+	if (count & (count - 1))
+		order++;
+	return order;
+}
+
+/**
+ * get_count_order_long - get order after rounding @l up to power of 2
+ * @l: parameter
+ *
+ * it is same as get_count_order() but with long type parameter
+ */
+static inline int get_count_order_long(unsigned long l)
+{
+	if (l == 0UL)
+		return -1;
+	else if (l & (l - 1UL))
+		return (int)fls_long(l);
+	else
+		return (int)fls_long(l) - 1;
+}
+
 #ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-fix-align-value-calculation-error.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
a.patch

