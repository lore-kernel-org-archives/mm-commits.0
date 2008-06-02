From: akpm@linux-foundation.org
Subject: + mm-introduce-get_user_pages_fast.patch added to -mm tree
Date: Mon, 02 Jun 2008 16:56:32 -0700
Message-ID: <200806022356.m52NuWeF006335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbYFBX6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 19:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, andi@firstfloor.org, apw@shadowen.org, jens.axboe@oracle.com, mingo@elte.hu, pbadari@us.ibm.com, shaggy@austin.ibm.com, tglx@linutronix.de, zach.brown@oracle.com


The patch titled
     mm: introduce get_user_pages_fast
has been added to the -mm tree.  Its filename is
     mm-introduce-get_user_pages_fast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce get_user_pages_fast
From: Nick Piggin <npiggin@suse.de>

Introduce a new get_user_pages_fast mm API, which is basically a
get_user_pages with a less general API (but still tends to be suited to
the common case):

- task and mm are always current and current->mm
- force is always 0
- pages is always non-NULL
- don't pass back vmas

This restricted API can be implemented in a much more scalable way on many
architectures when the ptes are present, by walking the page tables
locklessly (no mmap_sem or page table locks).  When the ptes are not
populated, get_user_pages_fast() could be slower.

This is implemented locklessly on x86, and used in some key direct IO call
sites, in later patches, which provides nearly 10% performance improvement
on a threaded database workload.

Lots of other code could use this too, depending on use cases (eg.  grep
drivers/).  And it might inspire some new and clever ways to use it.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-get_user_pages_fast include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-get_user_pages_fast
+++ a/include/linux/mm.h
@@ -12,6 +12,7 @@
 #include <linux/prio_tree.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/uaccess.h> /* for __HAVE_ARCH_GET_USER_PAGES_FAST */
 
 struct mempolicy;
 struct anon_vma;
@@ -828,6 +829,38 @@ extern int mprotect_fixup(struct vm_area
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
 
+#ifdef __HAVE_ARCH_GET_USER_PAGES_FAST
+/*
+ * get_user_pages_fast provides equivalent functionality to get_user_pages,
+ * operating on current and current->mm (force=0 and doesn't return any vmas).
+ *
+ * get_user_pages_fast may take mmap_sem and page tables, so no assumptions
+ * can be made about locking. get_user_pages_fast is to be implemented in a
+ * way that is advantageous (vs get_user_pages()) when the user memory area is
+ * already faulted in and present in ptes. However if the pages have to be
+ * faulted in, it may turn out to be slightly slower).
+ */
+int get_user_pages_fast(unsigned long start, int nr_pages, int write, struct page **pages);
+
+#else
+/*
+ * Should probably be moved to asm-generic, and architectures can include it if
+ * they don't implement their own get_user_pages_fast.
+ */
+#define get_user_pages_fast(start, nr_pages, write, pages)	\
+({								\
+	struct mm_struct *mm = current->mm;			\
+	int ret;						\
+								\
+	down_read(&mm->mmap_sem);				\
+	ret = get_user_pages(current, mm, start, nr_pages,	\
+					write, 0, pages, NULL);	\
+	up_read(&mm->mmap_sem);					\
+								\
+	ret;							\
+})
+#endif
+
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

