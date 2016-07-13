From: akpm@linux-foundation.org
Subject: + dma-mapping-use-unsigned-long-for-dma_attrs.patch added to -mm
 tree
Date: Wed, 13 Jul 2016 14:50:46 -0700
Message-ID: <5786b7b6.AQQjXr7GqOJTiXBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-use-unsigned-long-for-dma_attrs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: dma-mapping: use unsigned long for dma_attrs

The dma-mapping core and the implementations do not change the
DMA attributes passed by pointer.  Thus the pointer can point to const
data.  However the attributes do not have to be a bitfield. Instead
unsigned long will do fine:

1. This is just simpler.  Both in terms of reading the code and setting
   attributes.  Instead of initializing local attributes on the stack
   and passing pointer to it to dma_set_attr(), just set the bits.

2. It brings safeness and checking for const correctness because the
   attributes are passed by value.

Semantic patches for this change (at least most of them):
===
virtual patch
virtual context

@r@
identifier f, attrs;

@@
f(...,
- struct dma_attrs *attrs
+ unsigned long attrs
, ...)
{
...
}

@@
identifier r.f;
@@
f(...,
- NULL
+ 0
 )
===
// Options: --all-includes
virtual patch
virtual context

@r@
identifier f, attrs;
type t;

@@
t f(..., struct dma_attrs *attrs);

@@
identifier r.f;
@@
f(...,
- NULL
+ 0
 )
===

Link: http://lkml.kernel.org/r/1468399300-5399-2-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt        |   29 +++-----
 Documentation/DMA-attributes.txt |    2 
 include/linux/dma-attrs.h        |   71 -------------------
 include/linux/dma-mapping.h      |  105 ++++++++++++++++-------------
 lib/dma-noop.c                   |    9 +-
 5 files changed, 80 insertions(+), 136 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-mapping-use-unsigned-long-for-dma_attrs Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/Documentation/DMA-API.txt
@@ -369,35 +369,32 @@ See also dma_map_single().
 dma_addr_t
 dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
 		     enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 
 void
 dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
 		       size_t size, enum dma_data_direction dir,
-		       struct dma_attrs *attrs)
+		       unsigned long attrs)
 
 int
 dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 		 int nents, enum dma_data_direction dir,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 
 void
 dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
 		   int nents, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
+		   unsigned long attrs)
 
 The four functions above are just like the counterpart functions
 without the _attrs suffixes, except that they pass an optional
-struct dma_attrs*.
-
-struct dma_attrs encapsulates a set of "DMA attributes". For the
-definition of struct dma_attrs see linux/dma-attrs.h.
+dma_attrs.
 
 The interpretation of DMA attributes is architecture-specific, and
 each attribute should be documented in Documentation/DMA-attributes.txt.
 
-If struct dma_attrs* is NULL, the semantics of each of these
-functions is identical to those of the corresponding function
+If dma_attrs are 0, the semantics of each of these functions
+is identical to those of the corresponding function
 without the _attrs suffix. As a result dma_map_single_attrs()
 can generally replace dma_map_single(), etc.
 
@@ -405,15 +402,15 @@ As an example of the use of the *_attrs
 you could pass an attribute DMA_ATTR_FOO when mapping memory
 for DMA:
 
-#include <linux/dma-attrs.h>
-/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h and
+#include <linux/dma-mapping.h>
+/* DMA_ATTR_FOO should be defined in linux/dma-mapping.h and
  * documented in Documentation/DMA-attributes.txt */
 ...
 
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_FOO, &attrs);
+	unsigned long attr;
+	attr |= DMA_ATTR_FOO;
 	....
-	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
+	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, attr);
 	....
 
 Architectures that care about DMA_ATTR_FOO would check for its
@@ -422,7 +419,7 @@ routines, e.g.:
 
 void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
 			     size_t size, enum dma_data_direction dir,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	....
 	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
diff -puN Documentation/DMA-attributes.txt~dma-mapping-use-unsigned-long-for-dma_attrs Documentation/DMA-attributes.txt
--- a/Documentation/DMA-attributes.txt~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/Documentation/DMA-attributes.txt
@@ -2,7 +2,7 @@
 			==============
 
 This document describes the semantics of the DMA attributes that are
-defined in linux/dma-attrs.h.
+defined in linux/dma-mapping.h.
 
 DMA_ATTR_WRITE_BARRIER
 ----------------------
diff -puN include/linux/dma-attrs.h~dma-mapping-use-unsigned-long-for-dma_attrs /dev/null
--- a/include/linux/dma-attrs.h
+++ /dev/null
@@ -1,71 +0,0 @@
-#ifndef _DMA_ATTR_H
-#define _DMA_ATTR_H
-
-#include <linux/bitmap.h>
-#include <linux/bitops.h>
-#include <linux/bug.h>
-
-/**
- * an enum dma_attr represents an attribute associated with a DMA
- * mapping. The semantics of each attribute should be defined in
- * Documentation/DMA-attributes.txt.
- */
-enum dma_attr {
-	DMA_ATTR_WRITE_BARRIER,
-	DMA_ATTR_WEAK_ORDERING,
-	DMA_ATTR_WRITE_COMBINE,
-	DMA_ATTR_NON_CONSISTENT,
-	DMA_ATTR_NO_KERNEL_MAPPING,
-	DMA_ATTR_SKIP_CPU_SYNC,
-	DMA_ATTR_FORCE_CONTIGUOUS,
-	DMA_ATTR_ALLOC_SINGLE_PAGES,
-	DMA_ATTR_MAX,
-};
-
-#define __DMA_ATTRS_LONGS BITS_TO_LONGS(DMA_ATTR_MAX)
-
-/**
- * struct dma_attrs - an opaque container for DMA attributes
- * @flags - bitmask representing a collection of enum dma_attr
- */
-struct dma_attrs {
-	unsigned long flags[__DMA_ATTRS_LONGS];
-};
-
-#define DEFINE_DMA_ATTRS(x) 					\
-	struct dma_attrs x = {					\
-		.flags = { [0 ... __DMA_ATTRS_LONGS-1] = 0 },	\
-	}
-
-static inline void init_dma_attrs(struct dma_attrs *attrs)
-{
-	bitmap_zero(attrs->flags, __DMA_ATTRS_LONGS);
-}
-
-/**
- * dma_set_attr - set a specific attribute
- * @attr: attribute to set
- * @attrs: struct dma_attrs (may be NULL)
- */
-static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
-{
-	if (attrs == NULL)
-		return;
-	BUG_ON(attr >= DMA_ATTR_MAX);
-	__set_bit(attr, attrs->flags);
-}
-
-/**
- * dma_get_attr - check for a specific attribute
- * @attr: attribute to set
- * @attrs: struct dma_attrs (may be NULL)
- */
-static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
-{
-	if (attrs == NULL)
-		return 0;
-	BUG_ON(attr >= DMA_ATTR_MAX);
-	return test_bit(attr, attrs->flags);
-}
-
-#endif /* _DMA_ATTR_H */
diff -puN include/linux/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/linux/dma-mapping.h
@@ -5,13 +5,25 @@
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 #include <linux/kmemcheck.h>
 #include <linux/bug.h>
 
+/**
+ * List of possible attributes associated with a DMA mapping. The semantics
+ * of each attribute should be defined in Documentation/DMA-attributes.txt.
+ */
+#define DMA_ATTR_WRITE_BARRIER		(1UL << 0)
+#define DMA_ATTR_WEAK_ORDERING		(1UL << 1)
+#define DMA_ATTR_WRITE_COMBINE		(1UL << 2)
+#define DMA_ATTR_NON_CONSISTENT		(1UL << 3)
+#define DMA_ATTR_NO_KERNEL_MAPPING	(1UL << 4)
+#define DMA_ATTR_SKIP_CPU_SYNC		(1UL << 5)
+#define DMA_ATTR_FORCE_CONTIGUOUS	(1UL << 6)
+#define DMA_ATTR_ALLOC_SINGLE_PAGES	(1UL << 7)
+
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
  * It can be given to a device to use as a DMA source or target.  A CPU cannot
@@ -21,34 +33,35 @@
 struct dma_map_ops {
 	void* (*alloc)(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp,
-				struct dma_attrs *attrs);
+				unsigned long attrs);
 	void (*free)(struct device *dev, size_t size,
 			      void *vaddr, dma_addr_t dma_handle,
-			      struct dma_attrs *attrs);
+			      unsigned long attrs);
 	int (*mmap)(struct device *, struct vm_area_struct *,
-			  void *, dma_addr_t, size_t, struct dma_attrs *attrs);
+			  void *, dma_addr_t, size_t,
+			  unsigned long attrs);
 
 	int (*get_sgtable)(struct device *dev, struct sg_table *sgt, void *,
-			   dma_addr_t, size_t, struct dma_attrs *attrs);
+			   dma_addr_t, size_t, unsigned long attrs);
 
 	dma_addr_t (*map_page)(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
-			       struct dma_attrs *attrs);
+			       unsigned long attrs);
 	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
 			   size_t size, enum dma_data_direction dir,
-			   struct dma_attrs *attrs);
+			   unsigned long attrs);
 	/*
 	 * map_sg returns 0 on error and a value > 0 on success.
 	 * It should never return a value < 0.
 	 */
 	int (*map_sg)(struct device *dev, struct scatterlist *sg,
 		      int nents, enum dma_data_direction dir,
-		      struct dma_attrs *attrs);
+		      unsigned long attrs);
 	void (*unmap_sg)(struct device *dev,
 			 struct scatterlist *sg, int nents,
 			 enum dma_data_direction dir,
-			 struct dma_attrs *attrs);
+			 unsigned long attrs);
 	void (*sync_single_for_cpu)(struct device *dev,
 				    dma_addr_t dma_handle, size_t size,
 				    enum dma_data_direction dir);
@@ -88,6 +101,16 @@ static inline int is_device_dma_capable(
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
 }
 
+/**
+ * dma_get_attr - check for a specific attribute
+ * @attr: attribute to look for
+ * @attrs: attributes to check within
+ */
+static inline bool dma_get_attr(unsigned long attr, unsigned long attrs)
+{
+	return !!(attr & attrs);
+}
+
 #ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
 /*
  * These three functions are only for dma allocator.
@@ -123,7 +146,7 @@ static inline struct dma_map_ops *get_dm
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      size_t size,
 					      enum dma_data_direction dir,
-					      struct dma_attrs *attrs)
+					      unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
@@ -142,7 +165,7 @@ static inline dma_addr_t dma_map_single_
 static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
 					  size_t size,
 					  enum dma_data_direction dir,
-					  struct dma_attrs *attrs)
+					  unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
@@ -158,7 +181,7 @@ static inline void dma_unmap_single_attr
  */
 static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 				   int nents, enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	int i, ents;
@@ -176,7 +199,7 @@ static inline int dma_map_sg_attrs(struc
 
 static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg,
 				      int nents, enum dma_data_direction dir,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
@@ -195,7 +218,7 @@ static inline dma_addr_t dma_map_page(st
 
 	kmemcheck_mark_initialized(page_address(page) + offset, size);
 	BUG_ON(!valid_dma_direction(dir));
-	addr = ops->map_page(dev, page, offset, size, dir, NULL);
+	addr = ops->map_page(dev, page, offset, size, dir, 0);
 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
 
 	return addr;
@@ -208,7 +231,7 @@ static inline void dma_unmap_page(struct
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
-		ops->unmap_page(dev, addr, size, dir, NULL);
+		ops->unmap_page(dev, addr, size, dir, 0);
 	debug_dma_unmap_page(dev, addr, size, dir, false);
 }
 
@@ -289,10 +312,10 @@ dma_sync_sg_for_device(struct device *de
 
 }
 
-#define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
-#define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, NULL)
-#define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
-#define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, NULL)
+#define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, 0)
+#define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, 0)
+#define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, 0)
+#define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, 0)
 
 extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
@@ -321,7 +344,7 @@ void dma_common_free_remap(void *cpu_add
  */
 static inline int
 dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma, void *cpu_addr,
-	       dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
+	       dma_addr_t dma_addr, size_t size, unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	BUG_ON(!ops);
@@ -330,7 +353,7 @@ dma_mmap_attrs(struct device *dev, struc
 	return dma_common_mmap(dev, vma, cpu_addr, dma_addr, size);
 }
 
-#define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
+#define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, 0)
 
 int
 dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
@@ -338,7 +361,8 @@ dma_common_get_sgtable(struct device *de
 
 static inline int
 dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt, void *cpu_addr,
-		      dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
+		      dma_addr_t dma_addr, size_t size,
+		      unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	BUG_ON(!ops);
@@ -348,7 +372,7 @@ dma_get_sgtable_attrs(struct device *dev
 	return dma_common_get_sgtable(dev, sgt, cpu_addr, dma_addr, size);
 }
 
-#define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, NULL)
+#define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, 0)
 
 #ifndef arch_dma_alloc_attrs
 #define arch_dma_alloc_attrs(dev, flag)	(true)
@@ -356,7 +380,7 @@ dma_get_sgtable_attrs(struct device *dev
 
 static inline void *dma_alloc_attrs(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	void *cpu_addr;
@@ -378,7 +402,7 @@ static inline void *dma_alloc_attrs(stru
 
 static inline void dma_free_attrs(struct device *dev, size_t size,
 				     void *cpu_addr, dma_addr_t dma_handle,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
@@ -398,31 +422,27 @@ static inline void dma_free_attrs(struct
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t flag)
 {
-	return dma_alloc_attrs(dev, size, dma_handle, flag, NULL);
+	return dma_alloc_attrs(dev, size, dma_handle, flag, 0);
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_handle)
 {
-	return dma_free_attrs(dev, size, cpu_addr, dma_handle, NULL);
+	return dma_free_attrs(dev, size, cpu_addr, dma_handle, 0);
 }
 
 static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
 {
-	DEFINE_DMA_ATTRS(attrs);
-
-	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
-	return dma_alloc_attrs(dev, size, dma_handle, gfp, &attrs);
+	return dma_alloc_attrs(dev, size, dma_handle, gfp,
+			       DMA_ATTR_NON_CONSISTENT);
 }
 
 static inline void dma_free_noncoherent(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_handle)
 {
-	DEFINE_DMA_ATTRS(attrs);
-
-	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
-	dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
+	dma_free_attrs(dev, size, cpu_addr, dma_handle,
+		       DMA_ATTR_NON_CONSISTENT);
 }
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
@@ -646,9 +666,8 @@ static inline void dmam_release_declared
 static inline void *dma_alloc_wc(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t gfp)
 {
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_alloc_attrs(dev, size, dma_addr, gfp, &attrs);
+	return dma_alloc_attrs(dev, size, dma_addr, gfp,
+			       DMA_ATTR_WRITE_COMBINE);
 }
 #ifndef dma_alloc_writecombine
 #define dma_alloc_writecombine dma_alloc_wc
@@ -657,9 +676,8 @@ static inline void *dma_alloc_wc(struct
 static inline void dma_free_wc(struct device *dev, size_t size,
 			       void *cpu_addr, dma_addr_t dma_addr)
 {
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_free_attrs(dev, size, cpu_addr, dma_addr, &attrs);
+	return dma_free_attrs(dev, size, cpu_addr, dma_addr,
+			      DMA_ATTR_WRITE_COMBINE);
 }
 #ifndef dma_free_writecombine
 #define dma_free_writecombine dma_free_wc
@@ -670,9 +688,8 @@ static inline int dma_mmap_wc(struct dev
 			      void *cpu_addr, dma_addr_t dma_addr,
 			      size_t size)
 {
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
+	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size,
+			      DMA_ATTR_WRITE_COMBINE);
 }
 #ifndef dma_mmap_writecombine
 #define dma_mmap_writecombine dma_mmap_wc
diff -puN lib/dma-noop.c~dma-mapping-use-unsigned-long-for-dma_attrs lib/dma-noop.c
--- a/lib/dma-noop.c~dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/lib/dma-noop.c
@@ -10,7 +10,7 @@
 
 static void *dma_noop_alloc(struct device *dev, size_t size,
 			    dma_addr_t *dma_handle, gfp_t gfp,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	void *ret;
 
@@ -22,7 +22,7 @@ static void *dma_noop_alloc(struct devic
 
 static void dma_noop_free(struct device *dev, size_t size,
 			  void *cpu_addr, dma_addr_t dma_addr,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	free_pages((unsigned long)cpu_addr, get_order(size));
 }
@@ -30,13 +30,14 @@ static void dma_noop_free(struct device
 static dma_addr_t dma_noop_map_page(struct device *dev, struct page *page,
 				      unsigned long offset, size_t size,
 				      enum dma_data_direction dir,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	return page_to_phys(page) + offset;
 }
 
 static int dma_noop_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
-			     enum dma_data_direction dir, struct dma_attrs *attrs)
+			     enum dma_data_direction dir,
+			     unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
avr32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
blackfin-dma-mapping-use-unsigned-long-for-dma_attrs.patch
c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch
cris-dma-mapping-use-unsigned-long-for-dma_attrs.patch
frv-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs.patch
infiniband-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-dma-mapping-use-unsigned-long-for-dma_attrs.patch
media-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xen-dma-mapping-use-unsigned-long-for-dma_attrs.patch
swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs.patch
powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
video-dma-mapping-use-unsigned-long-for-dma_attrs.patch
x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-intel-dma-mapping-use-unsigned-long-for-dma_attrs.patch
h8300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
hexagon-dma-mapping-use-unsigned-long-for-dma_attrs.patch
ia64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
m68k-dma-mapping-use-unsigned-long-for-dma_attrs.patch
metag-dma-mapping-use-unsigned-long-for-dma_attrs.patch
microblaze-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mips-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mn10300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
nios2-dma-mapping-use-unsigned-long-for-dma_attrs.patch
openrisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs.patch
s390-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
tile-dma-mapping-use-unsigned-long-for-dma_attrs.patch
unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

