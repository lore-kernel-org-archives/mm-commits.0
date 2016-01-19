From: akpm@linux-foundation.org
Subject: [merged] asm-sections-add-helpers-to-check-for-section-data.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:48 -0800
Message-ID: <569e9938.No1VwlII9JEf3fkA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, arnd@arndb.de, gregkh@linuxfoundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: asm/sections: add helpers to check for section data
has been removed from the -mm tree.  Its filename was
     asm-sections-add-helpers-to-check-for-section-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: asm/sections: add helpers to check for section data

Add a helper to check if an object (given an address and a size) is part
of a section (given beginning and end addresses).  For convenience, also
provide a helper that performs this check for __init data using the
__init_begin and __init_end limits.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |   65 +++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff -puN include/asm-generic/sections.h~asm-sections-add-helpers-to-check-for-section-data include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~asm-sections-add-helpers-to-check-for-section-data
+++ a/include/asm-generic/sections.h
@@ -4,6 +4,7 @@
 /* References to section boundaries */
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 /*
  * Usage guidelines:
@@ -63,4 +64,68 @@ static inline int arch_is_kernel_data(un
 }
 #endif
 
+/**
+ * memory_contains - checks if an object is contained within a memory region
+ * @begin: virtual address of the beginning of the memory region
+ * @end: virtual address of the end of the memory region
+ * @virt: virtual address of the memory object
+ * @size: size of the memory object
+ *
+ * Returns: true if the object specified by @virt and @size is entirely
+ * contained within the memory region defined by @begin and @end, false
+ * otherwise.
+ */
+static inline bool memory_contains(void *begin, void *end, void *virt,
+				   size_t size)
+{
+	return virt >= begin && virt + size <= end;
+}
+
+/**
+ * memory_intersects - checks if the region occupied by an object intersects
+ *                     with another memory region
+ * @begin: virtual address of the beginning of the memory regien
+ * @end: virtual address of the end of the memory region
+ * @virt: virtual address of the memory object
+ * @size: size of the memory object
+ *
+ * Returns: true if an object's memory region, specified by @virt and @size,
+ * intersects with the region specified by @begin and @end, false otherwise.
+ */
+static inline bool memory_intersects(void *begin, void *end, void *virt,
+				     size_t size)
+{
+	void *vend = virt + size;
+
+	return (virt >= begin && virt < end) || (vend >= begin && vend < end);
+}
+
+/**
+ * init_section_contains - checks if an object is contained within the init
+ *                         section
+ * @virt: virtual address of the memory object
+ * @size: size of the memory object
+ *
+ * Returns: true if the object specified by @virt and @size is entirely
+ * contained within the init section, false otherwise.
+ */
+static inline bool init_section_contains(void *virt, size_t size)
+{
+	return memory_contains(__init_begin, __init_end, virt, size);
+}
+
+/**
+ * init_section_intersects - checks if the region occupied by an object
+ *                           intersects with the init section
+ * @virt: virtual address of the memory object
+ * @size: size of the memory object
+ *
+ * Returns: true if an object's memory region, specified by @virt and @size,
+ * intersects with the init section, false otherwise.
+ */
+static inline bool init_section_intersects(void *virt, size_t size)
+{
+	return memory_intersects(__init_begin, __init_end, virt, size);
+}
+
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
_

Patches currently in -mm which might be from treding@nvidia.com are


