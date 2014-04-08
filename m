From: akpm@linux-foundation.org
Subject: [merged] mm-readaheadc-inline-ra_submit.patch removed from -mm
 tree
Date: Tue, 08 Apr 2014 13:58:37 -0700
Message-ID: <534462fd.rlkJadgazGag3Nf6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHU6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, fabf@skynet.be

Subject: [merged] mm-readaheadc-inline-ra_submit.patch removed from -mm tree
To: fabf@skynet.be,akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:58:37 -0700


The patch titled
     Subject: mm/readahead.c: inline ra_submit
has been removed from the -mm tree.  Its filename was
     mm-readaheadc-inline-ra_submit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/readahead.c: inline ra_submit

f9acc8c7b35a ("readahead: sanify file_ra_state names") left ra_submit with
a single function call.

Move ra_submit to internal.h and inline it to save some stack.  Thanks to
Andrew Morton for commenting different versions.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ---
 mm/internal.h      |   15 +++++++++++++++
 mm/readahead.c     |   21 +++------------------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff -puN include/linux/mm.h~mm-readaheadc-inline-ra_submit include/linux/mm.h
--- a/include/linux/mm.h~mm-readaheadc-inline-ra_submit
+++ a/include/linux/mm.h
@@ -1875,9 +1875,6 @@ void page_cache_async_readahead(struct a
 				unsigned long size);
 
 unsigned long max_sane_readahead(unsigned long nr);
-unsigned long ra_submit(struct file_ra_state *ra,
-			struct address_space *mapping,
-			struct file *filp);
 
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
diff -puN mm/internal.h~mm-readaheadc-inline-ra_submit mm/internal.h
--- a/mm/internal.h~mm-readaheadc-inline-ra_submit
+++ a/mm/internal.h
@@ -11,6 +11,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/fs.h>
 #include <linux/mm.h>
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
@@ -21,6 +22,20 @@ static inline void set_page_count(struct
 	atomic_set(&page->_count, v);
 }
 
+extern int __do_page_cache_readahead(struct address_space *mapping,
+		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
+		unsigned long lookahead_size);
+
+/*
+ * Submit IO for the read-ahead request in file_ra_state.
+ */
+static inline unsigned long ra_submit(struct file_ra_state *ra,
+		struct address_space *mapping, struct file *filp)
+{
+	return __do_page_cache_readahead(mapping, filp,
+					ra->start, ra->size, ra->async_size);
+}
+
 /*
  * Turn a non-refcounted page (->_count == 0) into refcounted with
  * a count of one.
diff -puN mm/readahead.c~mm-readaheadc-inline-ra_submit mm/readahead.c
--- a/mm/readahead.c~mm-readaheadc-inline-ra_submit
+++ a/mm/readahead.c
@@ -8,9 +8,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/gfp.h>
-#include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
@@ -20,6 +18,8 @@
 #include <linux/syscalls.h>
 #include <linux/file.h>
 
+#include "internal.h"
+
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
  * memset *ra to zero.
@@ -149,8 +149,7 @@ out:
  *
  * Returns the number of pages requested, or the maximum amount of I/O allowed.
  */
-static int
-__do_page_cache_readahead(struct address_space *mapping, struct file *filp,
+int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read,
 			unsigned long lookahead_size)
 {
@@ -244,20 +243,6 @@ unsigned long max_sane_readahead(unsigne
 }
 
 /*
- * Submit IO for the read-ahead request in file_ra_state.
- */
-unsigned long ra_submit(struct file_ra_state *ra,
-		       struct address_space *mapping, struct file *filp)
-{
-	int actual;
-
-	actual = __do_page_cache_readahead(mapping, filp,
-					ra->start, ra->size, ra->async_size);
-
-	return actual;
-}
