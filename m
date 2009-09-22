From: akpm@linux-foundation.org
Subject: [merged] flex_array-introduce-define_flex_array.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:41 -0700
Message-ID: <200909222045.n8MKjfef016200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbZIVUqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:46:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     flex_array: introduce DEFINE_FLEX_ARRAY
has been removed from the -mm tree.  Its filename was
     flex_array-introduce-define_flex_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: introduce DEFINE_FLEX_ARRAY
From: David Rientjes <rientjes@google.com>

FLEX_ARRAY_INIT(element_size, total_nr_elements) cannot determine if
either parameter is valid, so flex arrays which are statically allocated
with this interface can easily become corrupted or reference beyond its
allocated memory.

This removes FLEX_ARRAY_INIT() as a struct flex_array initializer since no
initializer may perform the required checking.  Instead, the array is now
defined with a new interface:

	DEFINE_FLEX_ARRAY(name, element_size, total_nr_elements)

This may be prefixed with `static' for file scope.

This interface includes compile-time checking of the parameters to ensure
they are valid.  Since the validity of both element_size and
total_nr_elements depend on FLEX_ARRAY_BASE_SIZE and FLEX_ARRAY_PART_SIZE,
the kernel build will fail if either of these predefined values changes
such that the array parameters are no longer valid.

Since BUILD_BUG_ON() requires compile time constants, several of the
static inline functions that were once local to lib/flex_array.c had to be
moved to include/linux/flex_array.h.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |   30 +++++++++++++++++++++++++----
 lib/flex_array.c           |   36 +++++++++--------------------------
 2 files changed, 36 insertions(+), 30 deletions(-)

diff -puN include/linux/flex_array.h~flex_array-introduce-define_flex_array include/linux/flex_array.h
--- a/include/linux/flex_array.h~flex_array-introduce-define_flex_array
+++ a/include/linux/flex_array.h
@@ -31,10 +31,32 @@ struct flex_array {
 	};
 };
 
-#define FLEX_ARRAY_INIT(size, total) { { {\
-	.element_size = (size),		\
-	.total_nr_elements = (total),	\
-} } }
+/* Number of bytes left in base struct flex_array, excluding metadata */
+#define FLEX_ARRAY_BASE_BYTES_LEFT					\
+	(FLEX_ARRAY_BASE_SIZE - offsetof(struct flex_array, parts))
+
+/* Number of pointers in base to struct flex_array_part pages */
+#define FLEX_ARRAY_NR_BASE_PTRS						\
+	(FLEX_ARRAY_BASE_BYTES_LEFT / sizeof(struct flex_array_part *))
+
+/* Number of elements of size that fit in struct flex_array_part */
+#define FLEX_ARRAY_ELEMENTS_PER_PART(size)				\
+	(FLEX_ARRAY_PART_SIZE / size)
+
+/*
+ * Defines a statically allocated flex array and ensures its parameters are
+ * valid.
+ */
+#define DEFINE_FLEX_ARRAY(__arrayname, __element_size, __total)		\
+	struct flex_array __arrayname = { { {				\
+		.element_size = (__element_size),			\
+		.total_nr_elements = (__total),				\
+	} } };								\
+	static inline void __arrayname##_invalid_parameter(void)	\
+	{								\
+		BUILD_BUG_ON((__total) > FLEX_ARRAY_NR_BASE_PTRS *	\
+			FLEX_ARRAY_ELEMENTS_PER_PART(__element_size));	\
+	}
 
 struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 		gfp_t flags);
diff -puN lib/flex_array.c~flex_array-introduce-define_flex_array lib/flex_array.c
--- a/lib/flex_array.c~flex_array-introduce-define_flex_array
+++ a/lib/flex_array.c
@@ -28,23 +28,6 @@ struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
 };
 
-static inline int __elements_per_part(int element_size)
-{
-	return FLEX_ARRAY_PART_SIZE / element_size;
-}
-
-static inline int bytes_left_in_base(void)
-{
-	int element_offset = offsetof(struct flex_array, parts);
-	int bytes_left = FLEX_ARRAY_BASE_SIZE - element_offset;
-	return bytes_left;
-}
-
-static inline int nr_base_part_ptrs(void)
-{
-	return bytes_left_in_base() / sizeof(struct flex_array_part *);
-}
-
 /*
  * If a user requests an allocation which is small
  * enough, we may simply use the space in the
@@ -54,7 +37,7 @@ static inline int nr_base_part_ptrs(void
 static inline int elements_fit_in_base(struct flex_array *fa)
 {
 	int data_size = fa->element_size * fa->total_nr_elements;
-	if (data_size <= bytes_left_in_base())
+	if (data_size <= FLEX_ARRAY_BASE_BYTES_LEFT)
 		return 1;
 	return 0;
 }
@@ -103,7 +86,8 @@ struct flex_array *flex_array_alloc(int 
 					gfp_t flags)
 {
 	struct flex_array *ret;
-	int max_size = nr_base_part_ptrs() * __elements_per_part(element_size);
+	int max_size = FLEX_ARRAY_NR_BASE_PTRS *
+				FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
 
 	/* max_size will end up 0 if element_size > PAGE_SIZE */
 	if (total > max_size)
@@ -114,14 +98,15 @@ struct flex_array *flex_array_alloc(int 
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
-		memset(ret->parts[0], FLEX_ARRAY_FREE, bytes_left_in_base());
+		memset(ret->parts[0], FLEX_ARRAY_FREE,
+						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }
 
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
 {
-	return element_nr / __elements_per_part(fa->element_size);
+	return element_nr / FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
 }
 
 /**
@@ -133,11 +118,10 @@ static int fa_element_to_part_nr(struct 
 void flex_array_free_parts(struct flex_array *fa)
 {
 	int part_nr;
-	int max_part = nr_base_part_ptrs();
 
 	if (elements_fit_in_base(fa))
 		return;
-	for (part_nr = 0; part_nr < max_part; part_nr++)
+	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++)
 		kfree(fa->parts[part_nr]);
 }
 
@@ -152,7 +136,8 @@ static unsigned int index_inside_part(st
 {
 	unsigned int part_offset;
 
-	part_offset = element_nr % __elements_per_part(fa->element_size);
+	part_offset = element_nr %
+				FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
 	return part_offset * fa->element_size;
 }
 
@@ -313,13 +298,12 @@ static int part_is_free(struct flex_arra
 int flex_array_shrink(struct flex_array *fa)
 {
 	struct flex_array_part *part;
-	int max_part = nr_base_part_ptrs();
 	int part_nr;
 	int ret = 0;
 
 	if (elements_fit_in_base(fa))
 		return ret;
-	for (part_nr = 0; part_nr < max_part; part_nr++) {
+	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++) {
 		part = fa->parts[part_nr];
 		if (!part)
 			continue;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
walk-system-ram-range-fix-2.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

