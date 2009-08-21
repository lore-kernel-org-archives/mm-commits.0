From: akpm@linux-foundation.org
Subject: + flex_array-add-flex_array_shrink-function.patch added to -mm tree
Date: Fri, 21 Aug 2009 16:49:49 -0700
Message-ID: <200908212349.n7LNnnOT002324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932469AbZHUXtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 19:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dave@linux.vnet.ibm.com


The patch titled
     flex_array: add flex_array_shrink function
has been added to the -mm tree.  Its filename is
     flex_array-add-flex_array_shrink-function.patch

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
flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero.patch
flex_array-fix-flex_array_free_parts-comment.patch
flex_array-declare-parts-member-to-have-incomplete-type.patch
flex_array-convert-element_nr-formals-to-unsigned.patch
flex_array-add-flex_array_clear-function.patch
flex_array-poison-free-elements.patch
flex_array-add-flex_array_shrink-function.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

