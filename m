From: akpm@linux-foundation.org
Subject: + mm-vmalloc-fix-align-value-calculation-error-fix.patch added to -mm tree
Date: Tue, 09 Aug 2016 14:29:11 -0700
Message-ID: <57aa4b27.Q8UGZRJFNOq0hpEw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbcHIV3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 17:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, minchan@kernel.org, rientjes@google.com, tj@kernel.org, zijun_hu@htc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-align-value-calculation-error-fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-align-value-calculation-error-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-align-value-calculation-error-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-align-value-calculation-error-fix.patch

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-arm-keystone-dts-add-psci-command-definition.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

