From: akpm@linux-foundation.org
Subject: + mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch added to -mm tree
Date: Thu, 08 Dec 2011 16:09:02 -0800
Message-ID: <201112090009.pB9093Zg028360@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55780 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1LIAJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Dec 2011 19:09:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, mgorman@suse.de, nai.xia@gmail.com, pluto@agmk.net, stable@vger.kernel.org


The patch titled
     Subject: mremap: enforce rmap src/dst vma ordering in case of vma_merge() succeeding in copy_vma()
has been added to the -mm tree.  Its filename is
     mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch

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
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mremap: enforce rmap src/dst vma ordering in case of vma_merge() succeeding in copy_vma()

migrate was doing an rmap_walk with speculative lock-less access on
pagetables.  That could lead it to not serializing properly against mremap
PT locks.  But a second problem remains in the order of vmas in the
same_anon_vma list used by the rmap_walk.

If vma_merge succeeds in copy_vma, the src vma could be placed after the
dst vma in the same_anon_vma list.  That could still lead to migrate
missing some pte.

This patch adds an anon_vma_moveto_tail() function to force the dst vma at
the end of the list before mremap starts to solve the problem.

If the mremap is very large and there are a lots of parents or childs
sharing the anon_vma root lock, this should still scale better than taking
the anon_vma root lock around every pte copy practically for the whole
duration of mremap.

Update: Hugh noticed special care is needed in the error path where
move_page_tables goes in the reverse direction, a second
anon_vma_moveto_tail() call is needed in the error path.

This program exercises the anon_vma_moveto_tail:

===

int main()
{
	static struct timeval oldstamp, newstamp;
	long diffsec;
	char *p, *p2, *p3, *p4;
	if (posix_memalign((void **)&p, 2*1024*1024, SIZE))
		perror("memalign"), exit(1);
	if (posix_memalign((void **)&p2, 2*1024*1024, SIZE))
		perror("memalign"), exit(1);
	if (posix_memalign((void **)&p3, 2*1024*1024, SIZE))
		perror("memalign"), exit(1);

	memset(p, 0xff, SIZE);
	printf("%p\n", p);
	memset(p2, 0xff, SIZE);
	memset(p3, 0x77, 4096);
	if (memcmp(p, p2, SIZE))
		printf("error\n");
	p4 = mremap(p+SIZE/2, SIZE/2, SIZE/2, MREMAP_FIXED|MREMAP_MAYMOVE, p3);
	if (p4 != p3)
		perror("mremap"), exit(1);
	p4 = mremap(p4, SIZE/2, SIZE/2, MREMAP_FIXED|MREMAP_MAYMOVE, p+SIZE/2);
	if (p4 != p+SIZE/2)
		perror("mremap"), exit(1);
	if (memcmp(p, p2, SIZE))
		printf("error\n");
	printf("ok\n");

	return 0;
}
===

$ perf probe -a anon_vma_moveto_tail
Add new event:
  probe:anon_vma_moveto_tail (on anon_vma_moveto_tail)

You can now use it on all perf tools, such as:

        perf record -e probe:anon_vma_moveto_tail -aR sleep 1

$ perf record -e probe:anon_vma_moveto_tail -aR ./anon_vma_moveto_tail
0x7f2ca2800000
ok
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.043 MB perf.data (~1860 samples) ]
$ perf report --stdio
   100.00%  anon_vma_moveto  [kernel.kallsyms]  [k] anon_vma_moveto_tail

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Nai Xia <nai.xia@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pawel Sikora <pluto@agmk.net
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 
 mm/mmap.c            |   22 ++++++++++++++++++--
 mm/mremap.c          |    1 
 mm/rmap.c            |   45 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 67 insertions(+), 2 deletions(-)

diff -puN include/linux/rmap.h~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma include/linux/rmap.h
--- a/include/linux/rmap.h~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma
+++ a/include/linux/rmap.h
@@ -120,6 +120,7 @@ void anon_vma_init(void);	/* create anon
 int  anon_vma_prepare(struct vm_area_struct *);
 void unlink_anon_vmas(struct vm_area_struct *);
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
+void anon_vma_moveto_tail(struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 void __anon_vma_link(struct vm_area_struct *);
 
diff -puN mm/mmap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma mm/mmap.c
--- a/mm/mmap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma
+++ a/mm/mmap.c
@@ -2349,13 +2349,16 @@ struct vm_area_struct *copy_vma(struct v
 	struct vm_area_struct *new_vma, *prev;
 	struct rb_node **rb_link, *rb_parent;
 	struct mempolicy *pol;
+	bool faulted_in_anon_vma = true;
 
 	/*
 	 * If anonymous vma has not yet been faulted, update new pgoff
 	 * to match new location, to increase its chance of merging.
 	 */
-	if (!vma->vm_file && !vma->anon_vma)
+	if (!vma->vm_file && !vma->anon_vma) {
 		pgoff = addr >> PAGE_SHIFT;
+		faulted_in_anon_vma = false;
+	}
 
 	find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
@@ -2365,8 +2368,23 @@ struct vm_area_struct *copy_vma(struct v
 		 * Source vma may have been merged into new_vma
 		 */
 		if (vma_start >= new_vma->vm_start &&
-		    vma_start < new_vma->vm_end)
+		    vma_start < new_vma->vm_end) {
+			/*
+			 * The only way we can get a vma_merge with
+			 * self during an mremap is if the vma hasn't
+			 * been faulted in yet and we were allowed to
+			 * reset the dst vma->vm_pgoff to the
+			 * destination address of the mremap to allow
+			 * the merge to happen. mremap must change the
+			 * vm_pgoff linearity between src and dst vmas
+			 * (in turn preventing a vma_merge) to be
+			 * safe. It is only safe to keep the vm_pgoff
+			 * linear if there are no pages mapped yet.
+			 */
+			VM_BUG_ON(faulted_in_anon_vma);
 			*vmap = new_vma;
+		} else
+			anon_vma_moveto_tail(new_vma);
 	} else {
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (new_vma) {
diff -puN mm/mremap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma mm/mremap.c
--- a/mm/mremap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma
+++ a/mm/mremap.c
@@ -225,6 +225,7 @@ static unsigned long move_vma(struct vm_
 		 * which will succeed since page tables still there,
 		 * and then proceed to unmap new area instead of old.
 		 */
+		anon_vma_moveto_tail(vma);
 		move_page_tables(new_vma, new_addr, vma, old_addr, moved_len);
 		vma = new_vma;
 		old_len = new_len;
diff -puN mm/rmap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma mm/rmap.c
--- a/mm/rmap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma
+++ a/mm/rmap.c
@@ -272,6 +272,51 @@ int anon_vma_clone(struct vm_area_struct
 }
 
 /*
+ * Some rmap walk that needs to find all ptes/hugepmds without false
+ * negatives (like migrate and split_huge_page) running concurrent
+ * with operations that copy or move pagetables (like mremap() and
+ * fork()) to be safe. They depend on the anon_vma "same_anon_vma"
+ * list to be in a certain order: the dst_vma must be placed after the
+ * src_vma in the list. This is always guaranteed by fork() but
+ * mremap() needs to call this function to enforce it in case the
+ * dst_vma isn't newly allocated and chained with the anon_vma_clone()
+ * function but just an extension of a pre-existing vma through
+ * vma_merge.
+ *
+ * NOTE: the same_anon_vma list can still be changed by other
+ * processes while mremap runs because mremap doesn't hold the
+ * anon_vma mutex to prevent modifications to the list while it
+ * runs. All we need to enforce is that the relative order of this
+ * process vmas isn't changing (we don't care about other vmas
+ * order). Each vma corresponds to an anon_vma_chain structure so
+ * there's no risk that other processes calling anon_vma_moveto_tail()
+ * and changing the same_anon_vma list under mremap() will screw with
+ * the relative order of this process vmas in the list, because we
+ * they can't alter the order of any vma that belongs to this
+ * process. And there can't be another anon_vma_moveto_tail() running
+ * concurrently with mremap() coming from this process because we hold
+ * the mmap_sem for the whole mremap(). fork() ordering dependency
+ * also shouldn't be affected because fork() only cares that the
+ * parent vmas are placed in the list before the child vmas and
+ * anon_vma_moveto_tail() won't reorder vmas from either the fork()
+ * parent or child.
+ */
+void anon_vma_moveto_tail(struct vm_area_struct *dst)
+{
+	struct anon_vma_chain *pavc;
+	struct anon_vma *root = NULL;
+
+	list_for_each_entry_reverse(pavc, &dst->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = pavc->anon_vma;
+		VM_BUG_ON(pavc->vma != dst);
+		root = lock_anon_vma_root(root, anon_vma);
+		list_del(&pavc->same_anon_vma);
+		list_add_tail(&pavc->same_anon_vma, &anon_vma->head);
+	}
+	unlock_anon_vma_root(root);
+}
+
+/*
  * Attach vma to its own anon_vma, as well as to the anon_vmas that
  * the corresponding VMA in the parent process is attached to.
  * Returns 0 on success, non-zero on failure.
_
Subject: Subject: mremap: enforce rmap src/dst vma ordering in case of vma_merge() succeeding in copy_vma()

Patches currently in -mm which might be from aarcange@redhat.com are

fs-proc-meminfoc-fix-compilation-error.patch
thp-reduce-khugepaged-freezing-latency.patch
printk-avoid-double-lock-acquire.patch
thp-add-compound-tail-page-_mapcount-when-mapped.patch
thp-set-compound-tail-page-_count-to-zero.patch
mm-migratec-pair-unlock_page-and-lock_page-when-migrating-huge-pages.patch
mm-ensure-that-pfn_valid-is-called-once-per-pageblock-when-reserving-pageblocks.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch

