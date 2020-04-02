From: akpm@linux-foundation.org
Subject: [folded-merged] mm-gup-track-foll_pin-pages-fix.patch
 removed from -mm tree
Date: Wed, 01 Apr 2020 20:25:21 -0700
Message-ID: <20200402032521.AKy1daSk-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732664AbgDBDZX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/gup: fixup for ce35133be382 mm/gup: track FOLL_PIN pages
has been removed from the -mm tree.  Its filename was
     mm-gup-track-foll_pin-pages-fix.patch

This patch was dropped because it was folded into mm-gup-track-foll_pin-pages.patch

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: fixup for ce35133be382 mm/gup: track FOLL_PIN pages

This is a fixup for the mmotm commit ce35133be382
("mm/gup: track FOLL_PIN pages").

Add kerneldoc comments for pin_user_pages*() routines, in order
to get rid of "make -W1" warnings when building mm/gup.o.

This just adds @param documentation of:
    pin_user_pages()
    pin_user_pages_fast()
    pin_user_pages_remote()

The param documentation was stolen from other gup.c functions,
because it looks reasonable enough.

Link: http://lkml.kernel.org/r/20200307021157.235726-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/mm/gup.c~mm-gup-track-foll_pin-pages-fix
+++ a/mm/gup.c
@@ -2690,6 +2690,12 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
 /**
  * pin_user_pages_fast() - pin user pages in memory without taking locks
  *
+ * @start:      starting user address
+ * @nr_pages:   number of pages from start to pin
+ * @gup_flags:  flags modifying pin behaviour
+ * @pages:      array that receives pointers to the pages pinned.
+ *              Should be at least nr_pages long.
+ *
  * Nearly the same as get_user_pages_fast(), except that FOLL_PIN is set. See
  * get_user_pages_fast() for documentation on the function arguments, because
  * the arguments here are identical.
@@ -2715,6 +2721,21 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 /**
  * pin_user_pages_remote() - pin pages of a remote process (task != current)
  *
+ * @tsk:	the task_struct to use for page fault accounting, or
+ *		NULL if faults are not to be recorded.
+ * @mm:		mm_struct of target mm
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @gup_flags:	flags modifying lookup behaviour
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long. Or NULL, if caller
+ *		only intends to ensure the pages are faulted in.
+ * @vmas:	array of pointers to vmas corresponding to each page.
+ *		Or NULL if the caller does not require them.
+ * @locked:	pointer to lock flag indicating whether lock is held and
+ *		subsequently whether VM_FAULT_RETRY functionality can be
+ *		utilised. Lock must initially be held.
+ *
  * Nearly the same as get_user_pages_remote(), except that FOLL_PIN is set. See
  * get_user_pages_remote() for documentation on the function arguments, because
  * the arguments here are identical.
@@ -2743,6 +2764,15 @@ EXPORT_SYMBOL(pin_user_pages_remote);
 /**
  * pin_user_pages() - pin user pages in memory for use by other devices
  *
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @gup_flags:	flags modifying lookup behaviour
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long. Or NULL, if caller
+ *		only intends to ensure the pages are faulted in.
+ * @vmas:	array of pointers to vmas corresponding to each page.
+ *		Or NULL if the caller does not require them.
+ *
  * Nearly the same as get_user_pages(), except that FOLL_TOUCH is not set, and
  * FOLL_PIN is set.
  *
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-split-get_user_pages_remote-into-two-routines.patch
mm-gup-pass-a-flags-arg-to-__gup_device_-functions.patch
mm-introduce-page_ref_sub_return.patch
mm-gup-pass-gup-flags-to-two-more-routines.patch
mm-gup-require-foll_get-for-get_user_pages_fast.patch
mm-gup-track-foll_pin-pages.patch
mm-gup-page-hpage_pinned_refcount-exact-pin-counts-for-huge-pages.patch
mm-gup-proc-vmstat-pin_user_pages-foll_pin-reporting.patch
mm-gup_benchmark-support-pin_user_pages-and-related-calls.patch
selftests-vm-run_vmtests-invoke-gup_benchmark-with-basic-foll_pin-coverage.patch
mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch
