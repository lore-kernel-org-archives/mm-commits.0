From: akpm@linux-foundation.org
Subject: [merged] flex_array-add-flex_array_shrink-function.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:38 -0700
Message-ID: <200909222045.n8MKjcCs016116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbZIVUqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     flex_array: add flex_array_shrink function
has been removed from the -mm tree.  Its filename was
     flex_array-add-flex_array_shrink-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: add flex_array_shrink function
From: David Rientjes <rientjes@google.com>

Add a new function to the flex_array API:

	int flex_array_shrink(struct flex_array *fa)

This function will free all unused second-level pages.  Since elements are
now poisoned if they are not allocated with __GFP_ZERO, it's possible to
identify parts that consist solely of unused elements.

flex_array_shrink() returns the number of pages freed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |    1 
 lib/flex_array.c           |   40 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff -puN include/linux/flex_array.h~flex_array-add-flex_array_shrink-function include/linux/flex_array.h
--- a/include/linux/flex_array.h~flex_array-add-flex_array_shrink-function
+++ a/include/linux/flex_array.h
@@ -46,5 +46,6 @@ int flex_array_put(struct flex_array *fa
 		gfp_t flags);
 int flex_array_clear(struct flex_array *fa, unsigned int element_nr);
 void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
+int flex_array_shrink(struct flex_array *fa);
 
 #endif /* _FLEX_ARRAY_H */
diff -puN lib/flex_array.c~flex_array-add-flex_array_shrink-function lib/flex_array.c
--- a/lib/flex_array.c~flex_array-add-flex_array_shrink-function
+++ a/lib/flex_array.c
@@ -291,3 +291,43 @@ void *flex_array_get(struct flex_array *
 	}
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
+
+static int part_is_free(struct flex_array_part *part)
+{
+	int i;
+
+	for (i = 0; i < sizeof(struct flex_array_part); i++)
+		if (part->elements[i] != FLEX_ARRAY_FREE)
+			return 0;
+	return 1;
+}
+
+/**
+ * flex_array_shrink - free unused second-level pages
+ *
+ * Frees all second-level pages that consist solely of unused
+ * elements.  Returns the number of pages freed.
+ *
+ * Locking must be provided by the caller.
+ */
+int flex_array_shrink(struct flex_array *fa)
+{
+	struct flex_array_part *part;
+	int max_part = nr_base_part_ptrs();
+	int part_nr;
+	int ret = 0;
+
+	if (elements_fit_in_base(fa))
+		return ret;
+	for (part_nr = 0; part_nr < max_part; part_nr++) {
+		part = fa->parts[part_nr];
+		if (!part)
+			continue;
+		if (part_is_free(part)) {
+			fa->parts[part_nr] = NULL;
+			kfree(part);
+			ret++;
+		}
+	}
+	return ret;
+}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
walk-system-ram-range-fix-2.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

