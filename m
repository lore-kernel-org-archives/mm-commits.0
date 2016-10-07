From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix.patch removed
 from -mm tree
Date: Fri, 07 Oct 2016 16:27:16 -0700
Message-ID: <57f82f54.B+s4pVlKWFvLUInn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753920AbcJGX1R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:27:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops.h: move out get_count_order[_long]() from __KERNEL__ scope
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix.patch

This patch was dropped because it was folded into mm-vmalloc-fix-align-value-calculation-error.patch

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: bitops.h: move out get_count_order[_long]() from __KERNEL__ scope

move out get_count_order[_long]() definitions from scope limited by macro
__KERNEL__

it not only make both functions available in wider region regardless of
whether __KERNEL__ is defined but also keep original region for
get_count_order() before the recent commit c513b4cd2fe9
("mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix")

Link: http://lkml.kernel.org/r/57B2C4CE.80303@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   52 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix include/linux/bitops.h
--- a/include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix
+++ a/include/linux/bitops.h
@@ -181,6 +181,32 @@ static inline unsigned fls_long(unsigned
 	return fls64(l);
 }
 
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
 /**
  * __ffs64 - find first set bit in a 64 bit word
  * @word: The 64 bit word
@@ -233,32 +259,6 @@ static inline unsigned long __ffs64(u64
 })
 #endif
 
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
