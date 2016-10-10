From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-fix-align-value-calculation-error.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:42:47 -0700
Message-ID: <57fc1967.A3iTj+V28T2+/FdT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbcJJWnk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, hannes@cmpxchg.org, minchan@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix align value calculation error
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-align-value-calculation-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: mm/vmalloc.c: fix align value calculation error

It causes double align requirement for __get_vm_area_node() if parameter
size is power of 2 and VM_IOREMAP is set in parameter flags, for example
size=0x10000 -> fls_long(0x10000)=17 -> align=0x20000

get_count_order_long() is implemented and used instead of fls_long() for
fixing the bug, for example
size=0x10000 -> get_count_order_long(0x10000)=16 -> align=0x10000

[akpm@linux-foundation.org: s/get_order_long()/get_count_order_long()/]
[zijun_hu@zoho.com: fixes]
 Link: http://lkml.kernel.org/r/57AABC8B.1040409@zoho.com
[akpm@linux-foundation.org: locate get_count_order_long() next to get_count_order()]
[akpm@linux-foundation.org: move get_count_order[_long] definitions to pick up fls_long()]
[zijun_hu@htc.com: move out get_count_order[_long]() from __KERNEL__ scope]
 Link: http://lkml.kernel.org/r/57B2C4CE.80303@zoho.com
Link: http://lkml.kernel.org/r/fc045ecf-20fa-0722-b3ac-9a6140488fad@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   36 ++++++++++++++++++++++++++----------
 mm/vmalloc.c           |    8 ++++----
 2 files changed, 30 insertions(+), 14 deletions(-)

diff -puN include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error include/linux/bitops.h
--- a/include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error
+++ a/include/linux/bitops.h
@@ -65,16 +65,6 @@ static inline int get_bitmask_order(unsi
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
 static __always_inline unsigned long hweight_long(unsigned long w)
 {
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
@@ -191,6 +181,32 @@ static inline unsigned fls_long(unsigned
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
diff -puN mm/vmalloc.c~mm-vmalloc-fix-align-value-calculation-error mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-align-value-calculation-error
+++ a/mm/vmalloc.c
@@ -1359,14 +1359,14 @@ static struct vm_struct *__get_vm_area_n
 	struct vm_struct *area;
 
 	BUG_ON(in_interrupt());
-	if (flags & VM_IOREMAP)
-		align = 1ul << clamp_t(int, fls_long(size),
-				       PAGE_SHIFT, IOREMAP_MAX_ORDER);
