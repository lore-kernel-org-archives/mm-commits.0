From: akpm@linux-foundation.org
Subject: + mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch added to -mm tree
Date: Wed, 10 Aug 2016 14:58:09 -0700
Message-ID: <57aba371.+CPHsGjz2tdpgLij%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbcHJV6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 17:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zijun_hu@htc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-align-value-calculation-error-v2-fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
