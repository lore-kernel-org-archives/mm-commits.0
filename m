From: akpm@linux-foundation.org
Subject: + flex_array-convert-element_nr-formals-to-unsigned.patch added to -mm tree
Date: Fri, 21 Aug 2009 16:49:43 -0700
Message-ID: <200908212349.n7LNninD002256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbZHUXtu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 19:49:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dave@linux.vnet.ibm.com


The patch titled
     flex_array: convert element_nr formals to unsigned
has been added to the -mm tree.  Its filename is
     flex_array-convert-element_nr-formals-to-unsigned.patch

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
Subject: flex_array: convert element_nr formals to unsigned
From: David Rientjes <rientjes@google.com>

It's problematic to allow signed element_nr's or total's to be passed as
part of the flex array API.

flex_array_alloc() allows total_nr_elements to be set to a negative
quantity, which is obviously erroneous.

flex_array_get() and flex_array_put() allows negative array indices in
dereferencing an array part, which could address memory mapped before
struct flex_array.

The fix is to convert all existing element_nr formals to be qualified as
unsigned.  Existing checks to compare it to total_nr_elements or the max
array size based on element_size need not be changed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |   10 ++++++----
 lib/flex_array.c           |   24 +++++++++++++-----------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff -puN include/linux/flex_array.h~flex_array-convert-element_nr-formals-to-unsigned include/linux/flex_array.h
--- a/include/linux/flex_array.h~flex_array-convert-element_nr-formals-to-unsigned
+++ a/include/linux/flex_array.h
@@ -36,12 +36,14 @@ struct flex_array {
 	.total_nr_elements = (total),	\
 } } }
 
-struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags);
-int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags);
+struct flex_array *flex_array_alloc(int element_size, unsigned int total,
+		gfp_t flags);
+int flex_array_prealloc(struct flex_array *fa, unsigned int start,
+		unsigned int end, gfp_t flags);
 void flex_array_free(struct flex_array *fa);
 void flex_array_free_parts(struct flex_array *fa);
-int flex_array_put(struct flex_array *fa, int element_nr, void *src,
+int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 		gfp_t flags);
-void *flex_array_get(struct flex_array *fa, int element_nr);
+void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
 
 #endif /* _FLEX_ARRAY_H */
diff -puN lib/flex_array.c~flex_array-convert-element_nr-formals-to-unsigned lib/flex_array.c
--- a/lib/flex_array.c~flex_array-convert-element_nr-formals-to-unsigned
+++ a/lib/flex_array.c
@@ -99,7 +99,8 @@ static inline int elements_fit_in_base(s
  * capacity in the base structure.  Also note that no effort is made
  * to efficiently pack objects across page boundaries.
  */
-struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags)
+struct flex_array *flex_array_alloc(int element_size, unsigned int total,
+					gfp_t flags)
 {
 	struct flex_array *ret;
 	int max_size = nr_base_part_ptrs() * __elements_per_part(element_size);
@@ -115,7 +116,8 @@ struct flex_array *flex_array_alloc(int 
 	return ret;
 }
 
-static int fa_element_to_part_nr(struct flex_array *fa, int element_nr)
+static int fa_element_to_part_nr(struct flex_array *fa,
+					unsigned int element_nr)
 {
 	return element_nr / __elements_per_part(fa->element_size);
 }
@@ -143,14 +145,12 @@ void flex_array_free(struct flex_array *
 	kfree(fa);
 }
 
-static int fa_index_inside_part(struct flex_array *fa, int element_nr)
+static unsigned int index_inside_part(struct flex_array *fa,
+					unsigned int element_nr)
 {
-	return element_nr % __elements_per_part(fa->element_size);
-}
+	unsigned int part_offset;
 
-static int index_inside_part(struct flex_array *fa, int element_nr)
-{
-	int part_offset = fa_index_inside_part(fa, element_nr);
+	part_offset = element_nr % __elements_per_part(fa->element_size);
 	return part_offset * fa->element_size;
 }
 
@@ -185,7 +185,8 @@ __fa_get_part(struct flex_array *fa, int
  *
  * Locking must be provided by the caller.
  */
-int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags)
+int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
+			gfp_t flags)
 {
 	int part_nr = fa_element_to_part_nr(fa, element_nr);
 	struct flex_array_part *part;
@@ -217,7 +218,8 @@ int flex_array_put(struct flex_array *fa
  *
  * Locking must be provided by the caller.
  */
-int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags)
+int flex_array_prealloc(struct flex_array *fa, unsigned int start,
+			unsigned int end, gfp_t flags)
 {
 	int start_part;
 	int end_part;
@@ -248,7 +250,7 @@ int flex_array_prealloc(struct flex_arra
  *
  * Locking must be provided by the caller.
  */
-void *flex_array_get(struct flex_array *fa, int element_nr)
+void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 {
 	int part_nr = fa_element_to_part_nr(fa, element_nr);
 	struct flex_array_part *part;
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

