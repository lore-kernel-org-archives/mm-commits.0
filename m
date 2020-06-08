From: akpm@linux-foundation.org
Subject: [nacked]
 mm-mmapc-do-not-allow-mappings-outside-of-allowed-limits.patch removed from
 -mm tree
Date: Mon, 08 Jun 2020 15:30:14 -0700
Message-ID: <20200608223014.nxgnachxX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgFHWaQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agordeev@linux.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: do not allow mappings outside of allowed limits
has been removed from the -mm tree.  Its filename was
     mm-mmapc-do-not-allow-mappings-outside-of-allowed-limits.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm/mmap.c: do not allow mappings outside of allowed limits

One can set a lowest possible address in /proc/sys/vm/mmap_min_addr 
and mmap below that bound nevertheless.

It is possible to request a fixed mapping address below mmap_min_addr and
succeed.  This update adds early checks of mmap_min_addr and mmap_end
boundaries and fixes the above issue.

Apart from it is wrong I am not aware of any existing issue.

Link: http://lkml.kernel.org/r/d6da1319114a331095052638f0ffa3ccb0be58f1.1584958099.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/mm/mmap.c~mm-mmapc-do-not-allow-mappings-outside-of-allowed-limits
+++ a/mm/mmap.c
@@ -62,6 +62,14 @@
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
 
+#ifndef arch_get_mmap_end
+#define arch_get_mmap_end(addr)	(TASK_SIZE)
+#endif
+
+#ifndef arch_get_mmap_base
+#define arch_get_mmap_base(addr, base) (base)
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
 const int mmap_rnd_bits_min = CONFIG_ARCH_MMAP_RND_BITS_MIN;
 const int mmap_rnd_bits_max = CONFIG_ARCH_MMAP_RND_BITS_MAX;
@@ -1369,6 +1377,7 @@ unsigned long do_mmap(struct file *file,
 			unsigned long pgoff, unsigned long *populate,
 			struct list_head *uf)
 {
+	const unsigned long mmap_end = arch_get_mmap_end(addr);
 	struct mm_struct *mm = current->mm;
 	int pkey = 0;
 
@@ -1391,8 +1400,12 @@ unsigned long do_mmap(struct file *file,
 	if (flags & MAP_FIXED_NOREPLACE)
 		flags |= MAP_FIXED;
 
-	if (!(flags & MAP_FIXED))
+	if (flags & MAP_FIXED) {
+		if ((addr < mmap_min_addr) || (addr > mmap_end))
+			return -ENOMEM;
+	} else {
 		addr = round_hint_to_min(addr);
+	}
 
 	/* Careful about overflows.. */
 	len = PAGE_ALIGN(len);
@@ -2074,14 +2087,6 @@ unsigned long vm_unmapped_area(struct vm
 	return addr;
 }
 
-#ifndef arch_get_mmap_end
-#define arch_get_mmap_end(addr)	(TASK_SIZE)
-#endif
-
-#ifndef arch_get_mmap_base
-#define arch_get_mmap_base(addr, base) (base)
-#endif
