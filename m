From: akpm@linux-foundation.org
Subject: + mm-vmalloc-fix-align-value-calculation-error-v2.patch added to
 -mm tree
Date: Wed, 10 Aug 2016 14:58:07 -0700
Message-ID: <57aba36f.wFz0DWzfOs848O/p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbcHJV6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 17:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@zoho.com, zijun_hu@htc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-align-value-calculation-error-v2
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-align-value-calculation-error-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-align-value-calculation-error-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-align-value-calculation-error-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zijun_hu <zijun_hu@zoho.com>
Subject: mm-vmalloc-fix-align-value-calculation-error-v2

i provide another patch called v2 based on your suggestion as shown below
it have following correction against original patch v1
1) use name get_count_order_long() instead of get_order_long()
2) return -1 if @l == 0 to consist with get_order_long()
3) cast type to int before returning from get_count_order_long()
4) move up function parameter checking for __get_vm_area_node()
5) more commit message is offered to make issue and approach clear
any comments about new patch is welcome

Link: http://lkml.kernel.org/r/57AABC8B.1040409@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   33 ++++++++++++++++-----------------
 mm/vmalloc.c           |    8 ++++----
 2 files changed, 20 insertions(+), 21 deletions(-)

diff -puN include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-v2 include/linux/bitops.h
--- a/include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error-v2
+++ a/include/linux/bitops.h
@@ -75,23 +75,6 @@ static inline int get_count_order(unsign
 	return order;
 }
 
-/**
- * get_count_order_long - get order after rounding @l up to power of 2
- * @l: parameter
- *
- * The same as get_count_order() but accepts a long type parameter
- * or 0 is returned if @l == 0UL
- */
-static inline int get_count_order_long(unsigned long l)
-{
-	if (l == 0UL)
-		return 0;
-	else if (l & (l - 1UL))
-		return fls_long(l);
-	else
-		return fls_long(l) - 1;
-}
-
 static __always_inline unsigned long hweight_long(unsigned long w)
 {
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
@@ -209,6 +192,22 @@ static inline unsigned fls_long(unsigned
 }
 
 /**
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
+/**
  * __ffs64 - find first set bit in a 64 bit word
  * @word: The 64 bit word
  *
diff -puN mm/vmalloc.c~mm-vmalloc-fix-align-value-calculation-error-v2 mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-align-value-calculation-error-v2
+++ a/mm/vmalloc.c
@@ -1359,14 +1359,14 @@ static struct vm_struct *__get_vm_area_n
 	struct vm_struct *area;
 
 	BUG_ON(in_interrupt());
-	if (flags & VM_IOREMAP)
-		align = 1ul << clamp_t(int, get_count_order_long(size),
-				       PAGE_SHIFT, IOREMAP_MAX_ORDER);
