From: akpm@linux-foundation.org
Subject: + flex_array-avoid-divisions-when-accessing-elements.patch added to -mm tree
Date: Tue, 26 Apr 2011 15:08:33 -0700
Message-ID: <201104262208.p3QM8Xcn022929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab1DZWJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 18:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesse@nicira.com, dave@linux.vnet.ibm.com, eparis@redhat.com, rientjes@google.com


The patch titled
     flex_array: avoid divisions when accessing elements
has been added to the -mm tree.  Its filename is
     flex_array-avoid-divisions-when-accessing-elements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Jesse Gross <jesse@nicira.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |    2 ++
 lib/flex_array.c           |   21 ++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

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
@@ -88,8 +89,8 @@ struct flex_array *flex_array_alloc(int 
 					gfp_t flags)
 {
 	struct flex_array *ret;
-	int max_size = FLEX_ARRAY_NR_BASE_PTRS *
-				FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
+	int elems_per_part = FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
+	int max_size = FLEX_ARRAY_NR_BASE_PTRS * elems_per_part;
 
 	/* max_size will end up 0 if element_size > PAGE_SIZE */
 	if (total > max_size)
@@ -99,6 +100,8 @@ struct flex_array *flex_array_alloc(int 
 		return NULL;
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
+	ret->elems_per_part = elems_per_part;
+	ret->reciprocal_elems = reciprocal_value(elems_per_part);
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
 		memset(&ret->parts[0], FLEX_ARRAY_FREE,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
@@ -109,7 +112,7 @@ EXPORT_SYMBOL(flex_array_alloc);
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
 {
-	return element_nr / FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
+	return reciprocal_divide(element_nr, fa->reciprocal_elems);
 }
 
 /**
@@ -138,12 +141,12 @@ void flex_array_free(struct flex_array *
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
 
@@ -196,7 +199,7 @@ int flex_array_put(struct flex_array *fa
 		if (!part)
 			return -ENOMEM;
 	}
-	dst = &part->elements[index_inside_part(fa, element_nr)];
+	dst = &part->elements[index_inside_part(fa, element_nr, part_nr)];
 	memcpy(dst, src, fa->element_size);
 	return 0;
 }
@@ -224,7 +227,7 @@ int flex_array_clear(struct flex_array *
 		if (!part)
 			return -EINVAL;
 	}
-	dst = &part->elements[index_inside_part(fa, element_nr)];
+	dst = &part->elements[index_inside_part(fa, element_nr, part_nr)];
 	memset(dst, FLEX_ARRAY_FREE, fa->element_size);
 	return 0;
 }
@@ -293,7 +296,7 @@ void *flex_array_get(struct flex_array *
 		if (!part)
 			return NULL;
 	}
-	return &part->elements[index_inside_part(fa, element_nr)];
+	return &part->elements[index_inside_part(fa, element_nr, part_nr)];
 }
 EXPORT_SYMBOL(flex_array_get);
 
_

Patches currently in -mm which might be from jesse@nicira.com are

linux-next.patch
flex_array-avoid-divisions-when-accessing-elements.patch

