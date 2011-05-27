From: akpm@linux-foundation.org
Subject: [merged] flex_array-avoid-divisions-when-accessing-elements.patch removed from -mm tree
Date: Fri, 27 May 2011 12:56:58 -0700
Message-ID: <201105271955.p4RJt3Pd017423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223Ab1E0Tz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesse@nicira.com, dave@linux.vnet.ibm.com, eparis@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     flex_array: avoid divisions when accessing elements
has been removed from the -mm tree.  Its filename was
     flex_array-avoid-divisions-when-accessing-elements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: avoid divisions when accessing elements
From: Jesse Gross <jesse@nicira.com>

On most architectures division is an expensive operation and accessing an
element currently requires four of them.  This performance penalty
effectively precludes flex arrays from being used on any kind of fast
path.  However, two of these divisions can be handled at creation time and
the others can be replaced by a reciprocal divide, completely avoiding
real divisions on access.

[eparis@redhat.com: rebase on top of changes to support 0 len elements]
[eparis@redhat.com: initialize part_nr when array fits entirely in base]
Signed-off-by: Jesse Gross <jesse@nicira.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |    2 +
 lib/flex_array.c           |   51 +++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 22 deletions(-)

diff -puN include/linux/flex_array.h~flex_array-avoid-divisions-when-accessing-elements include/linux/flex_array.h
--- a/include/linux/flex_array.h~flex_array-avoid-divisions-when-accessing-elements
+++ a/include/linux/flex_array.h
@@ -21,6 +21,8 @@ struct flex_array {
 		struct {
 			int element_size;
 			int total_nr_elements;
+			int elems_per_part;
+			u32 reciprocal_elems;
 			struct flex_array_part *parts[];
 		};
 		/*
diff -puN lib/flex_array.c~flex_array-avoid-divisions-when-accessing-elements lib/flex_array.c
--- a/lib/flex_array.c~flex_array-avoid-divisions-when-accessing-elements
+++ a/lib/flex_array.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/stddef.h>
 #include <linux/module.h>
+#include <linux/reciprocal_div.h>
 
 struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
@@ -70,15 +71,15 @@ static inline int elements_fit_in_base(s
  * Element size | Objects | Objects |
  * PAGE_SIZE=4k |  32-bit |  64-bit |
  * ---------------------------------|
- *      1 bytes | 4186112 | 2093056 |
- *      2 bytes | 2093056 | 1046528 |
- *      3 bytes | 1395030 |  697515 |
- *      4 bytes | 1046528 |  523264 |
- *     32 bytes |  130816 |   65408 |
- *     33 bytes |  126728 |   63364 |
- *   2048 bytes |    2044 |    1022 |
- *   2049 bytes |    1022 |     511 |
- *       void * | 1046528 |  261632 |
+ *      1 bytes | 4177920 | 2088960 |
+ *      2 bytes | 2088960 | 1044480 |
+ *      3 bytes | 1392300 |  696150 |
+ *      4 bytes | 1044480 |  522240 |
+ *     32 bytes |  130560 |   65408 |
+ *     33 bytes |  126480 |   63240 |
+ *   2048 bytes |    2040 |    1020 |
+ *   2049 bytes |    1020 |     510 |
+ *       void * | 1044480 |  261120 |
  *
  * Since 64-bit pointers are twice the size, we lose half the
  * capacity in the base structure.  Also note that no effort is made
@@ -88,11 +89,15 @@ struct flex_array *flex_array_alloc(int 
 					gfp_t flags)
 {
 	struct flex_array *ret;
+	int elems_per_part = 0;
+	int reciprocal_elems = 0;
 	int max_size = 0;
 
-	if (element_size)
-		max_size = FLEX_ARRAY_NR_BASE_PTRS *
-			   FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
+	if (element_size) {
+		elems_per_part = FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
+		reciprocal_elems = reciprocal_value(elems_per_part);
+		max_size = FLEX_ARRAY_NR_BASE_PTRS * elems_per_part;
+	}
 
 	/* max_size will end up 0 if element_size > PAGE_SIZE */
 	if (total > max_size)
@@ -102,6 +107,8 @@ struct flex_array *flex_array_alloc(int 
 		return NULL;
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
+	ret->elems_per_part = elems_per_part;
+	ret->reciprocal_elems = reciprocal_elems;
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
 		memset(&ret->parts[0], FLEX_ARRAY_FREE,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
@@ -112,7 +119,7 @@ EXPORT_SYMBOL(flex_array_alloc);
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
 {
-	return element_nr / FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
+	return reciprocal_divide(element_nr, fa->reciprocal_elems);
 }
 
 /**
@@ -141,12 +148,12 @@ void flex_array_free(struct flex_array *
 EXPORT_SYMBOL(flex_array_free);
 
 static unsigned int index_inside_part(struct flex_array *fa,
-					unsigned int element_nr)
+					unsigned int element_nr,
+					unsigned int part_nr)
 {
 	unsigned int part_offset;
 
-	part_offset = element_nr %
-				FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
+	part_offset = element_nr - part_nr * fa->elems_per_part;
 	return part_offset * fa->element_size;
 }
 
@@ -186,7 +193,7 @@ __fa_get_part(struct flex_array *fa, int
 int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 			gfp_t flags)
 {
-	int part_nr;
+	int part_nr = 0;
 	struct flex_array_part *part;
 	void *dst;
 
@@ -202,7 +209,7 @@ int flex_array_put(struct flex_array *fa
 		if (!part)
 			return -ENOMEM;
 	}
-	dst = &part->elements[index_inside_part(fa, element_nr)];
+	dst = &part->elements[index_inside_part(fa, element_nr, part_nr)];
 	memcpy(dst, src, fa->element_size);
 	return 0;
 }
@@ -217,7 +224,7 @@ EXPORT_SYMBOL(flex_array_put);
  */
 int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
 {
-	int part_nr;
+	int part_nr = 0;
 	struct flex_array_part *part;
 	void *dst;
 
@@ -233,7 +240,7 @@ int flex_array_clear(struct flex_array *
 		if (!part)
 			return -EINVAL;
 	}
-	dst = &part->elements[index_inside_part(fa, element_nr)];
+	dst = &part->elements[index_inside_part(fa, element_nr, part_nr)];
 	memset(dst, FLEX_ARRAY_FREE, fa->element_size);
 	return 0;
 }
@@ -302,7 +309,7 @@ EXPORT_SYMBOL(flex_array_prealloc);
  */
 void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 {
-	int part_nr;
+	int part_nr = 0;
 	struct flex_array_part *part;
 
 	if (!fa->element_size)
@@ -317,7 +324,7 @@ void *flex_array_get(struct flex_array *
 		if (!part)
 			return NULL;
 	}
-	return &part->elements[index_inside_part(fa, element_nr)];
+	return &part->elements[index_inside_part(fa, element_nr, part_nr)];
 }
 EXPORT_SYMBOL(flex_array_get);
 
_

Patches currently in -mm which might be from jesse@nicira.com are

origin.patch

