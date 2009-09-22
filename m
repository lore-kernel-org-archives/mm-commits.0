From: akpm@linux-foundation.org
Subject: [merged] flex_array-add-missing-kerneldoc-annotations.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:44 -0700
Message-ID: <200909222045.n8MKjiKO016332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbZIVUqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     flex_array: add missing kerneldoc annotations
has been removed from the -mm tree.  Its filename was
     flex_array-add-missing-kerneldoc-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
walk-system-ram-range-fix-2.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

