From: akpm@linux-foundation.org
Subject: + mm-vmalloc-fix-align-value-calculation-error.patch added to -mm tree
Date: Tue, 09 Aug 2016 14:29:09 -0700
Message-ID: <57aa4b25.5RYiT4/TWrFIYEUJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbcHIV3K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 17:29:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, hannes@cmpxchg.org, minchan@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix align value calculation error
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-align-value-calculation-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-align-value-calculation-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-align-value-calculation-error.patch

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
Subject: mm/vmalloc.c: fix align value calculation error

It causes a doubled alignment requirement for __get_vm_area_node() if
parameter `size' is power of 2 and VM_IOREMAP is set in parameter flags

get_count_order_long() is implemented and used instead of fls_long() to
fix the bug

Link: http://lkml.kernel.org/r/fc045ecf-20fa-0722-b3ac-9a6140488fad@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   17 +++++++++++++++++
 mm/vmalloc.c           |    2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error include/linux/bitops.h
--- a/include/linux/bitops.h~mm-vmalloc-fix-align-value-calculation-error
+++ a/include/linux/bitops.h
@@ -192,6 +192,23 @@ static inline unsigned fls_long(unsigned
 }
 
 /**
+ * get_order_long - get order after rounding @l up to power of 2
+ * @l: parameter
+ *
+ * it is same as get_count_order() but long type parameter
+ * or 0 is returned if @l == 0UL
+ */
+static inline int get_order_long(unsigned long l)
+{
+	if (l == 0UL)
+		return 0;
+	else if (l & (l - 1UL))
+		return fls_long(l);
+	else
+		return fls_long(l) - 1;
+}
+
+/**
  * __ffs64 - find first set bit in a 64 bit word
  * @word: The 64 bit word
  *
diff -puN mm/vmalloc.c~mm-vmalloc-fix-align-value-calculation-error mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-align-value-calculation-error
+++ a/mm/vmalloc.c
@@ -1360,7 +1360,7 @@ static struct vm_struct *__get_vm_area_n
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP)
-		align = 1ul << clamp_t(int, fls_long(size),
+		align = 1ul << clamp_t(int, get_order_long(size),
 				       PAGE_SHIFT, IOREMAP_MAX_ORDER);
 
 	size = PAGE_ALIGN(size);
_

Patches currently in -mm which might be from zijun_hu@htc.com are

mm-vmalloc-fix-align-value-calculation-error.patch

