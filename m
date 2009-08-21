From: akpm@linux-foundation.org
Subject: + flex_array-add-flex_array_clear-function.patch added to -mm tree
Date: Fri, 21 Aug 2009 16:49:45 -0700
Message-ID: <200908212349.n7LNnkDf002264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932584AbZHUXtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 19:49:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dave@linux.vnet.ibm.com


The patch titled
     flex_array: add flex_array_clear function
has been added to the -mm tree.  Its filename is
     flex_array-add-flex_array_clear-function.patch

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

