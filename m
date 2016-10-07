From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch removed from -mm
 tree
Date: Fri, 07 Oct 2016 16:27:07 -0700
Message-ID: <57f82f4b.cD3Yg6YoH+ZndY23%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38252 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753920AbcJGX1I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zijun_hu@htc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-align-value-calculation-error-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch

This patch was dropped because it was folded into mm-vmalloc-fix-align-value-calculation-error.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-fix-align-value-calculation-error-v2-fix

locate get_count_order_long() next to get_count_order()

Cc: zijun_hu <zijun_hu@htc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-v2-fix include/linux/bitops.h
--- a/include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-v2-fix
+++ a/include/linux/bitops.h
@@ -75,6 +75,22 @@ static inline int get_count_order(unsign
 	return order;
 }
 
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
 static __always_inline unsigned long hweight_long(unsigned long w)
 {
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
@@ -192,22 +208,6 @@ static inline unsigned fls_long(unsigned
 }
 
 /**
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
