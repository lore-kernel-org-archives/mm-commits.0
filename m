From: akpm@linux-foundation.org
Subject: + out-of-line-dma_alloc-free_attrs.patch added to -mm tree
Date: Wed, 15 Mar 2017 14:49:21 -0700
Message-ID: <58c9b6e1.qUQdRMUZgBr2ABTo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753063AbdCOVtX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 17:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/dma-mapping.h: uninline dma_alloc/free_attrs
has been added to the -mm tree.  Its filename is
     out-of-line-dma_alloc-free_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/out-of-line-dma_alloc-free_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/out-of-line-dma_alloc-free_attrs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: include/linux/dma-mapping.h: uninline dma_alloc/free_attrs

These functions are very big and frequently used.  I don't see any sense
in inlining them because they do slow operations.

Out of lining them saves ~19k text in my kernel.

   text    data     bss     dec     hex filename
9047801 5367568 11116544        25531913        1859609 vmlinux-after-dma
9067798 5367600 11116544        25551942        185e446 vmlinux-before-dma

Link: http://lkml.kernel.org/r/20170315021431.13107-6-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   47 +++++-----------------------------
 lib/Makefile                |    2 -
 lib/dma-mapping.c           |   47 ++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 41 deletions(-)

diff -puN include/linux/dma-mapping.h~out-of-line-dma_alloc-free_attrs include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~out-of-line-dma_alloc-free_attrs
+++ a/include/linux/dma-mapping.h
@@ -473,46 +473,13 @@ dma_get_sgtable_attrs(struct device *dev
 #define arch_dma_alloc_attrs(dev, flag)	(true)
 #endif
 
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flag,
-				       unsigned long attrs)
-{
-	const struct dma_map_ops *ops = get_dma_ops(dev);
-	void *cpu_addr;
-
-	BUG_ON(!ops);
-
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &cpu_addr))
-		return cpu_addr;
-
-	if (!arch_dma_alloc_attrs(&dev, &flag))
-		return NULL;
-	if (!ops->alloc)
-		return NULL;
-
-	cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
-	return cpu_addr;
-}
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				     void *cpu_addr, dma_addr_t dma_handle,
-				     unsigned long attrs)
-{
-	const struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!ops);
-	WARN_ON(irqs_disabled());
-
-	if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
-		return;
-
-	if (!ops->free || !cpu_addr)
-		return;
-
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-	ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
+void *dma_alloc_attrs(struct device *dev, size_t size,
+		      dma_addr_t *dma_handle, gfp_t flag,
+		      unsigned long attrs);
+
+void dma_free_attrs(struct device *dev, size_t size,
+		    void *cpu_addr, dma_addr_t dma_handle,
+		    unsigned long attrs);
 
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t flag)
diff -puN lib/Makefile~out-of-line-dma_alloc-free_attrs lib/Makefile
--- a/lib/Makefile~out-of-line-dma_alloc-free_attrs
+++ a/lib/Makefile
@@ -23,7 +23,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o \
-	 nmi_backtrace.o nodemask.o win_minmax.o
+	 nmi_backtrace.o nodemask.o win_minmax.o dma-mapping.o
 
 CFLAGS_radix-tree.o += -DCONFIG_SPARSE_RCU_POINTER
 CFLAGS_idr.o += -DCONFIG_SPARSE_RCU_POINTER
diff -puN /dev/null lib/dma-mapping.c
--- /dev/null
+++ a/lib/dma-mapping.c
@@ -0,0 +1,47 @@
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+
+void *dma_alloc_attrs(struct device *dev, size_t size,
+		      dma_addr_t *dma_handle, gfp_t flag,
+		      unsigned long attrs)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	void *cpu_addr;
+
+	BUG_ON(!ops);
+
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &cpu_addr))
+		return cpu_addr;
+
+	if (!arch_dma_alloc_attrs(&dev, &flag))
+		return NULL;
+	if (!ops->alloc)
+		return NULL;
+
+	cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
+	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
+	return cpu_addr;
+}
+
+EXPORT_SYMBOL(dma_alloc_attrs);
+
+void dma_free_attrs(struct device *dev, size_t size,
+		    void *cpu_addr, dma_addr_t dma_handle,
+		    unsigned long attrs)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!ops);
+	WARN_ON(irqs_disabled());
+
+	if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
+		return;
+
+	if (!ops->free || !cpu_addr)
+		return;
+
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
+	ops->free(dev, size, cpu_addr, dma_handle, attrs);
+}
+
+EXPORT_SYMBOL(dma_free_attrs);
_

Patches currently in -mm which might be from ak@linux.intel.com are

trace-move-trace_seq_overflowed-out-of-line.patch
sched-out-of-line-__update_load_avg.patch
kref-remove-warn_on-for-null-release-functions.patch
out-of-line-dma_alloc-free_attrs.patch
megasas-remove-expensive-inline-from-megasas_return_cmd.patch
remove-expensive-warn_on-in-pagefault_disabled_dec.patch

