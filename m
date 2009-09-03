From: akpm@linux-foundation.org
Subject: + flex_array-add-missing-kerneldoc-annotations.patch added to -mm tree
Date: Thu, 03 Sep 2009 16:44:34 -0700
Message-ID: <200909032344.n83NiY3A012904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932499AbZICXom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 19:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dave@linux.vnet.ibm.com, randy.dunlap@oracle.com


The patch titled
     flex_array: add missing kerneldoc annotations
has been added to the -mm tree.  Its filename is
     flex_array-add-missing-kerneldoc-annotations.patch

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
Subject: flex_array: add missing kerneldoc annotations
From: David Rientjes <rientjes@google.com>

Add kerneldoc annotations for function formals of type struct flex_array
and gfp_t which are currently lacking.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_array.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN lib/flex_array.c~flex_array-add-missing-kerneldoc-annotations lib/flex_array.c
--- a/lib/flex_array.c~flex_array-add-missing-kerneldoc-annotations
+++ a/lib/flex_array.c
@@ -46,6 +46,7 @@ static inline int elements_fit_in_base(s
  * flex_array_alloc - allocate a new flexible array
  * @element_size:	the size of individual elements in the array
  * @total:		total number of elements that this should hold
+ * @flags:		page allocation flags to use for base array
  *
  * Note: all locking must be provided by the caller.
  *
@@ -111,6 +112,7 @@ static int fa_element_to_part_nr(struct 
 
 /**
  * flex_array_free_parts - just free the second-level pages
+ * @fa:		the flex array from which to free parts
  *
  * This is to be used in cases where the base 'struct flex_array'
  * has been statically allocated and should not be free.
@@ -159,9 +161,12 @@ __fa_get_part(struct flex_array *fa, int
 
 /**
  * flex_array_put - copy data into the array at @element_nr
- * @src:	address of data to copy into the array
+ * @fa:		the flex array to copy data into
  * @element_nr:	index of the position in which to insert
  * 		the new element.
+ * @src:	address of data to copy into the array
+ * @flags:	page allocation flags to use for array expansion
+ *
  *
  * Note that this *copies* the contents of @src into
  * the array.  If you are trying to store an array of
@@ -192,6 +197,7 @@ int flex_array_put(struct flex_array *fa
 
 /**
  * flex_array_clear - clear element in array at @element_nr
+ * @fa:		the flex array of the element.
  * @element_nr:	index of the position to clear.
  *
  * Locking must be provided by the caller.
@@ -218,8 +224,10 @@ int flex_array_clear(struct flex_array *
 
 /**
  * flex_array_prealloc - guarantee that array space exists
+ * @fa:		the flex array for which to preallocate parts
  * @start:	index of first array element for which space is allocated
  * @end:	index of last (inclusive) element for which space is allocated
+ * @flags:	page allocation flags
  *
  * This will guarantee that no future calls to flex_array_put()
  * will allocate memory.  It can be used if you are expecting to
@@ -252,6 +260,7 @@ int flex_array_prealloc(struct flex_arra
 
 /**
  * flex_array_get - pull data back out of the array
+ * @fa:		the flex array from which to extract data
  * @element_nr:	index of the element to fetch from the array
  *
  * Returns a pointer to the data at index @element_nr.  Note
@@ -289,6 +298,7 @@ static int part_is_free(struct flex_arra
 
 /**
  * flex_array_shrink - free unused second-level pages
+ * @fa:		the flex array to shrink
  *
  * Frees all second-level pages that consist solely of unused
  * elements.  Returns the number of pages freed.
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
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
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
flex_array-add-flex_array_clear-function.patch
flex_array-poison-free-elements.patch
flex_array-add-flex_array_shrink-function.patch
flex_array-introduce-define_flex_array.patch
flex_array-add-missing-kerneldoc-annotations.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

