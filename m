From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix.patch added to
 -mm tree
Date: Tue, 16 Aug 2016 13:29:10 -0700
Message-ID: <57b37796.imis6YXo0EBCk6U5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565AbcHPU3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2016 16:29:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops.h: move out get_count_order[_long]() from __KERNEL__ scope
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
