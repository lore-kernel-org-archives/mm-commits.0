From: akpm@linux-foundation.org
Subject: [merged] flex_array-add-flex_array_clear-function.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:32 -0700
Message-ID: <200909222045.n8MKjWMS015897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233AbZIVUqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     flex_array: add flex_array_clear function
has been removed from the -mm tree.  Its filename was
     flex_array-add-flex_array_clear-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: add flex_array_clear function
From: David Rientjes <rientjes@google.com>

Add a new function to the flex_array API:

	int flex_array_clear(struct flex_array *fa,
				unsigned int element_nr)

This function will zero the element at element_nr in the flex_array.

Although this is equivalent to using flex_array_put() and passing a
pointer to zero'd memory, flex_array_clear() does not require such a
pointer to memory that would most likely need to be allocated on the
caller's stack which could be significantly large depending on
element_size.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |    1 +
 lib/flex_array.c           |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff -puN include/linux/flex_array.h~flex_array-add-flex_array_clear-function include/linux/flex_array.h
--- a/include/linux/flex_array.h~flex_array-add-flex_array_clear-function
+++ a/include/linux/flex_array.h
@@ -44,6 +44,7 @@ void flex_array_free(struct flex_array *
 void flex_array_free_parts(struct flex_array *fa);
 int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 		gfp_t flags);
+int flex_array_clear(struct flex_array *fa, unsigned int element_nr);
 void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
 
 #endif /* _FLEX_ARRAY_H */
diff -puN lib/flex_array.c~flex_array-add-flex_array_clear-function lib/flex_array.c
--- a/lib/flex_array.c~flex_array-add-flex_array_clear-function
+++ a/lib/flex_array.c
@@ -207,6 +207,32 @@ int flex_array_put(struct flex_array *fa
 }
 
 /**
+ * flex_array_clear - clear element in array at @element_nr
+ * @element_nr:	index of the position to clear.
+ *
+ * Locking must be provided by the caller.
+ */
+int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
+{
+	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	struct flex_array_part *part;
+	void *dst;
+
+	if (element_nr >= fa->total_nr_elements)
+		return -ENOSPC;
+	if (elements_fit_in_base(fa))
+		part = (struct flex_array_part *)&fa->parts[0];
+	else {
+		part = fa->parts[part_nr];
+		if (!part)
+			return -EINVAL;
+	}
+	dst = &part->elements[index_inside_part(fa, element_nr)];
+	memset(dst, 0, fa->element_size);
+	return 0;
+}
+
+/**
  * flex_array_prealloc - guarantee that array space exists
  * @start:	index of first array element for which space is allocated
  * @end:	index of last (inclusive) element for which space is allocated
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
walk-system-ram-range-fix-2.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

