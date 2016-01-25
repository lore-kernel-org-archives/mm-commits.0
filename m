From: akpm@linux-foundation.org
Subject: [merged] pmem-add-wb_cache_pmem-to-the-pmem-api.patch removed
 from -mm tree
Date: Mon, 25 Jan 2016 10:58:35 -0800
Message-ID: <56a6705b.vA2i7z2HcTXbbsk0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbcAYS6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 13:58:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.com, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pmem: add wb_cache_pmem() to the PMEM API
has been removed from the -mm tree.  Its filename was
     pmem-add-wb_cache_pmem-to-the-pmem-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: pmem: add wb_cache_pmem() to the PMEM API

__arch_wb_cache_pmem() was already an internal implementation detail of
the x86 PMEM API, but this functionality needs to be exported as part of
the general PMEM API to handle the fsync/msync case for DAX mmaps.

One thing worth noting is that we really do want this to be part of the
PMEM API as opposed to a stand-alone function like clflush_cache_range()
because of ordering restrictions.  By having wb_cache_pmem() as part of
the PMEM API we can leave it unordered, call it multiple times to write
back large amounts of memory, and then order the multiple calls with a
single wmb_pmem().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pmem.h |   11 ++++++-----
 include/linux/pmem.h        |   22 +++++++++++++++++++++-
 2 files changed, 27 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/pmem.h~pmem-add-wb_cache_pmem-to-the-pmem-api arch/x86/include/asm/pmem.h
--- a/arch/x86/include/asm/pmem.h~pmem-add-wb_cache_pmem-to-the-pmem-api
+++ a/arch/x86/include/asm/pmem.h
@@ -67,18 +67,19 @@ static inline void arch_wmb_pmem(void)
 }
 
 /**
- * __arch_wb_cache_pmem - write back a cache range with CLWB
+ * arch_wb_cache_pmem - write back a cache range with CLWB
  * @vaddr:	virtual start address
  * @size:	number of bytes to write back
  *
  * Write back a cache range using the CLWB (cache line write back)
  * instruction.  This function requires explicit ordering with an
- * arch_wmb_pmem() call.  This API is internal to the x86 PMEM implementation.
+ * arch_wmb_pmem() call.
  */
-static inline void __arch_wb_cache_pmem(void *vaddr, size_t size)
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
 {
 	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
 	unsigned long clflush_mask = x86_clflush_size - 1;
+	void *vaddr = (void __force *)addr;
 	void *vend = vaddr + size;
 	void *p;
 
@@ -115,7 +116,7 @@ static inline size_t arch_copy_from_iter
 	len = copy_from_iter_nocache(vaddr, bytes, i);
 
 	if (__iter_needs_pmem_wb(i))
-		__arch_wb_cache_pmem(vaddr, bytes);
+		arch_wb_cache_pmem(addr, bytes);
 
 	return len;
 }
@@ -133,7 +134,7 @@ static inline void arch_clear_pmem(void
 	void *vaddr = (void __force *)addr;
 
 	memset(vaddr, 0, size);
-	__arch_wb_cache_pmem(vaddr, size);
+	arch_wb_cache_pmem(addr, size);
 }
 
 static inline bool __arch_has_wmb_pmem(void)
diff -puN include/linux/pmem.h~pmem-add-wb_cache_pmem-to-the-pmem-api include/linux/pmem.h
--- a/include/linux/pmem.h~pmem-add-wb_cache_pmem-to-the-pmem-api
+++ a/include/linux/pmem.h
@@ -53,12 +53,18 @@ static inline void arch_clear_pmem(void
 {
 	BUG();
 }
+
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	BUG();
+}
 #endif
 
 /*
  * Architectures that define ARCH_HAS_PMEM_API must provide
  * implementations for arch_memcpy_to_pmem(), arch_wmb_pmem(),
- * arch_copy_from_iter_pmem(), arch_clear_pmem() and arch_has_wmb_pmem().
+ * arch_copy_from_iter_pmem(), arch_clear_pmem(), arch_wb_cache_pmem()
+ * and arch_has_wmb_pmem().
  */
 static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
 {
@@ -178,4 +184,18 @@ static inline void clear_pmem(void __pme
 	else
 		default_clear_pmem(addr, size);
 }
+
+/**
+ * wb_cache_pmem - write back processor cache for PMEM memory range
+ * @addr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * Write back the processor cache range starting at 'addr' for 'size' bytes.
+ * This function requires explicit ordering with a wmb_pmem() call.
+ */
+static inline void wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	if (arch_has_pmem_api())
+		arch_wb_cache_pmem(addr, size);
+}
 #endif /* __PMEM_H__ */
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


