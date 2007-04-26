From: akpm@linux-foundation.org
Subject: + mm-document-fault_data-and-flags.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:35:29 -0700
Message-ID: <200704260035.l3Q0ZTHD017074@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423466AbXDZAfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: document fault_data and flags
has been added to the -mm tree.  Its filename is
     mm-document-fault_data-and-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: document fault_data and flags
From: Nick Piggin <npiggin@suse.de>

Document fault_data fields and flags a bit better.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN include/linux/mm.h~mm-document-fault_data-and-flags include/linux/mm.h
--- a/include/linux/mm.h~mm-document-fault_data-and-flags
+++ a/include/linux/mm.h
@@ -200,8 +200,8 @@ extern unsigned int kobjsize(const void 
  */
 extern pgprot_t protection_map[16];
 
-#define FAULT_FLAG_WRITE	0x01
-#define FAULT_FLAG_NONLINEAR	0x02
+#define FAULT_FLAG_WRITE	0x01	/* Write fault (read fault if not set)*/
+#define FAULT_FLAG_NONLINEAR	0x02	/* Nonlinear pte fault */
 
 /*
  * fault_data is filled in the the pagefault handler and passed to the
@@ -209,15 +209,17 @@ extern pgprot_t protection_map[16];
  * 'type', which is the type of fault if a page is returned, or the type
  * of error if NULL is returned.
  *
- * pgoff should be used in favour of address, if possible. If pgoff is
- * used, one may set VM_CAN_NONLINEAR in the vma->vm_flags to get
- * nonlinear mapping support.
+ * pgoff should be used rather than address to find the page, if possible.
+ * If pgoff is used, one may set VM_CAN_NONLINEAR in the vma->vm_flags to get
+ * nonlinear mapping support (because nonlinear pgoffs are not based on
+ * address). Address could be used for auxiliary input (eg. for page coloring).
  */
 struct fault_data {
-	unsigned long address;
-	pgoff_t pgoff;
-	unsigned int flags;
-	int type;
+	unsigned long address;	/* Virtual address where the fault occurred */
+	pgoff_t pgoff;		/* Logical page offset, based on the vma */
+	unsigned int flags;	/* FAULT_FLAG_xxx flags, described above */
+
+	int type;		/* VM_FAULT_xxx value, set by fault handler */
 };
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-madvise-avoid-exclusive-mmap_sem.patch
mm-document-fault_data-and-flags.patch
exec-fix-remove_arg_zero.patch
exec-fix-remove_arg_zero-add-comment.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
