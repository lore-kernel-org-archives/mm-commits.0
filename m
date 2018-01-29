From: akpm@linux-foundation.org
Subject: + mm-correct-comments-regarding-do_fault_around.patch added to
 -mm tree
Date: Mon, 29 Jan 2018 15:55:51 -0800
Message-ID: <5a6fb487.3OU0T51eOdWrxvEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeA2Xzw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:55:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: william.kucharski@oracle.com, kirill.shutemov@linux.intel.com, larry.bassel@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: correct comments regarding do_fault_around()
has been added to the -mm tree.  Its filename is
     mm-correct-comments-regarding-do_fault_around.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-correct-comments-regarding-do_fault_around.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-correct-comments-regarding-do_fault_around.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: William Kucharski <william.kucharski@oracle.com>
Subject: mm: correct comments regarding do_fault_around()

There are multiple comments surrounding do_fault_around that memtion
fault_around_pages() and fault_around_mask(), two routines that do not
exist.  These comments should be reworded to reference fault_around_bytes,
the value which is used to determine how much do_fault_around() will
attempt to read when processing a fault.

These comments should have been updated when fault_around_pages() and
fault_around_mask() were removed in aecd6f44266c1 ("mm: close race between
do_fault_around() and fault_around_bytes_set()").

Fixes: aecd6f44266c1 ("mm: close race between do_fault_around() and fault_around_bytes_set()")
Link: http://lkml.kernel.org/r/302D0B14-C7E9-44C6-8BED-033F9ACBD030@oracle.com
Signed-off-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Larry Bassel <larry.bassel@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/memory.c~mm-correct-comments-regarding-do_fault_around mm/memory.c
--- a/mm/memory.c~mm-correct-comments-regarding-do_fault_around
+++ a/mm/memory.c
@@ -3511,9 +3511,8 @@ static int fault_around_bytes_get(void *
 }
 
 /*
- * fault_around_pages() and fault_around_mask() expects fault_around_bytes
- * rounded down to nearest page order. It's what do_fault_around() expects to
- * see.
+ * fault_around_bytes must be rounded down to the nearest page order as it's
+ * what do_fault_around() expects to see.
  */
 static int fault_around_bytes_set(void *data, u64 val)
 {
@@ -3556,13 +3555,14 @@ late_initcall(fault_around_debugfs);
  * This function doesn't cross the VMA boundaries, in order to call map_pages()
  * only once.
  *
- * fault_around_pages() defines how many pages we'll try to map.
- * do_fault_around() expects it to return a power of two less than or equal to
- * PTRS_PER_PTE.
+ * fault_around_bytes defines how many bytes we'll try to map.
+ * do_fault_around() expects it to be set to a power of two less than or equal
+ * to PTRS_PER_PTE.
  *
- * The virtual address of the area that we map is naturally aligned to the
- * fault_around_pages() value (and therefore to page order).  This way it's
- * easier to guarantee that we don't cross page table boundaries.
+ * The virtual address of the area that we map is naturally aligned to
+ * fault_around_bytes rounded down to the machine page size
+ * (and therefore to page order).  This way it's easier to guarantee
+ * that we don't cross page table boundaries.
  */
 static int do_fault_around(struct vm_fault *vmf)
 {
@@ -3579,8 +3579,8 @@ static int do_fault_around(struct vm_fau
 	start_pgoff -= off;
 
 	/*
-	 *  end_pgoff is either end of page table or end of vma
-	 *  or fault_around_pages() from start_pgoff, depending what is nearest.
+	 *  end_pgoff is either the end of the page table, the end of
+	 *  the vma or nr_pages from start_pgoff, depending what is nearest.
 	 */
 	end_pgoff = start_pgoff -
 		((vmf->address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)) +
_

Patches currently in -mm which might be from william.kucharski@oracle.com are

mm-correct-comments-regarding-do_fault_around.patch

