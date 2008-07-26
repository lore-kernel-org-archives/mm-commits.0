From: akpm@linux-foundation.org
Subject: - mm-introduce-get_user_pages_fast.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:15:43 -0700
Message-ID: <200807262115.m6QLFhDJ019763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757738AbYGZVWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, andi@firstfloor.org, apw@shadowen.org, jens.axboe@oracle.com, mingo@elte.hu, pbadari@us.ibm.com, shaggy@austin.ibm.com, tglx@linutronix.de, za


The patch titled
     mm: introduce get_user_pages_fast
has been removed from the -mm tree.  Its filename was
     mm-introduce-get_user_pages_fast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: coding-style fixes]
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
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-get_user_pages_fast include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-get_user_pages_fast
+++ a/include/linux/mm.h
@@ -833,6 +833,39 @@ extern int mprotect_fixup(struct vm_area
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
 
+#ifdef CONFIG_HAVE_GET_USER_PAGES_FAST
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
+int get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			struct page **pages);
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

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

