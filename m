From: akpm@linux-foundation.org
Subject: + mm-readaheadc-inline-ra_submit.patch added to -mm tree
Date: Mon, 31 Mar 2014 16:14:34 -0700
Message-ID: <5339f6da.RZbQfms2Aew9yqD4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaCaXOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 19:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, fabf@skynet.be

Subject: + mm-readaheadc-inline-ra_submit.patch added to -mm tree
To: fabf@skynet.be,akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 16:14:34 -0700


The patch titled
     Subject: mm/readahead.c: inline ra_submit
has been added to the -mm tree.  Its filename is
     mm-readaheadc-inline-ra_submit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-readaheadc-inline-ra_submit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-readaheadc-inline-ra_submit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1878,9 +1878,6 @@ void page_cache_async_readahead(struct a
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
-
-/*
  * Set the initial window size, round to next power of 2 and square
  * for small size, x 4 for medium, and x 2 for large
  * for 128k (32 page) max ra
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-freevxfs-vxfs_lookupc-update-function-comment.patch
ntfs-logging-clean-up.patch
mm-memblockc-use-pfn_phys.patch
mm-readaheadc-inline-ra_submit.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
coda-add-__init-to-init_inodecache.patch
hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch
fs-reiserfs-superc-add-__init-to-init_inodecache.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
affs-mount-option-to-avoid-filename-truncates.patch
fs-bfs-inodec-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

