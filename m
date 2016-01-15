From: akpm@linux-foundation.org
Subject: [merged] mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:09 -0800
Message-ID: <569973a5.ar0Qt996fEqoCb3Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbcAOWdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hughd@google.com, jmarchan@redhat.com, khlebnikov@yandex-team.ru, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, proc: account for shmem swap in /proc/pid/smaps
has been removed from the -mm tree.  Its filename was
     mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, proc: account for shmem swap in /proc/pid/smaps

Currently, /proc/pid/smaps will always show "Swap: 0 kB" for shmem-backed
mappings, even if the mapped portion does contain pages that were swapped
out.  This is because unlike private anonymous mappings, shmem does not
change pte to swap entry, but pte_none when swapping the page out.  In the
smaps page walk, such page thus looks like it was never faulted in.

This patch changes smaps_pte_entry() to determine the swap status for such
pte_none entries for shmem mappings, similarly to how mincore_page() does
it.  Swapped out shmem pages are thus accounted for.  For private mappings
of tmpfs files that COWed some of the pages, swaped out status of the
original shmem pages is naturally ignored.  If some of the private copies
was also swapped out, they are accounted via their page table swap
entries, so the resulting reported swap usage is then a sum of both
swapped out private copies, and swapped out shmem pages that were not
COWed.  No double accounting can thus happen.

The accounting is arguably still not as precise as for private anonymous
mappings, since now we will count also pages that the process in question
never accessed, but another process populated them and then let them
become swapped out.  I believe it is still less confusing and subtle than
not showing any swap usage by shmem mappings at all.  Swapped out counter
might of interest of users who would like to prevent from future swapins
during performance critical operation and pre-fault them at their
convenience.  Especially for larger swapped out regions the cost of swapin
is much higher than a fresh page allocation.  So a differentiation between
pte_none vs.  swapped out is important for those usecases.

One downside of this patch is that it makes /proc/pid/smaps more expensive
for shmem mappings, as we consult the radix tree for each pte_none entry,
so the overal complexity is O(n*log(n)).  I have measured this on a
process that creates a 2GB mapping and dirties single pages with a stride
of 2MB, and time how long does it take to cat /proc/pid/smaps of this
process 100 times.

Private anonymous mapping:

real    0m0.949s
user    0m0.116s
sys     0m0.348s

Mapping of a /dev/shm/file:

real    0m3.831s
user    0m0.180s
sys     0m3.212s

The difference is rather substantial, so the next patch will reduce the
cost for shared or read-only mappings.

In a less controlled experiment, I've gathered pids of processes on my
desktop that have either '/dev/shm/*' or 'SYSV*' in smaps.  This included
the Chrome browser and some KDE processes.  Again, I've run cat
/proc/pid/smaps on each 100 times.

Before this patch:

real    0m9.050s
user    0m0.518s
sys     0m8.066s

After this patch:

real    0m9.221s
user    0m0.541s
sys     0m8.187s

This suggests low impact on average systems.

Note that this patch doesn't attempt to adjust the SwapPss field for shmem
mappings, which would need extra work to determine who else could have the
pages mapped.  Thus the value stays zero except for COWed swapped out
pages in a shmem mapping, which are accounted as usual.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    5 ++
 fs/proc/task_mmu.c                 |   51 +++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-proc-account-for-shmem-swap-in-proc-pid-smaps Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-proc-account-for-shmem-swap-in-proc-pid-smaps
+++ a/Documentation/filesystems/proc.txt
@@ -460,7 +460,10 @@ and a page is modified, the file page is
 hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
 reasons. And these are not included in {Shared,Private}_{Clean,Dirty} field.
 "Swap" shows how much would-be-anonymous memory is also used, but out on swap.
-"SwapPss" shows proportional swap share of this mapping.
+For shmem mappings, "Swap" includes also the size of the mapped (and not
+replaced by copy-on-write) part of the underlying shmem object out on swap.
+"SwapPss" shows proportional swap share of this mapping. Unlike "Swap", this
+does not take into account swapped out page of underlying shmem objects.
 "Locked" indicates whether the mapping is locked in memory or not.
 
 "VmFlags" field deserves a separate description. This member represents the kernel
diff -puN fs/proc/task_mmu.c~mm-proc-account-for-shmem-swap-in-proc-pid-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-account-for-shmem-swap-in-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -451,6 +451,7 @@ struct mem_size_stats {
 	unsigned long private_hugetlb;
 	u64 pss;
 	u64 swap_pss;
+	bool check_shmem_swap;
 };
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
@@ -485,6 +486,45 @@ static void smaps_account(struct mem_siz
 	}
 }
 
+#ifdef CONFIG_SHMEM
+static unsigned long smaps_shmem_swap(struct vm_area_struct *vma,
+		unsigned long addr)
+{
+	struct page *page;
+
+	page = find_get_entry(vma->vm_file->f_mapping,
+					linear_page_index(vma, addr));
+	if (!page)
+		return 0;
+
+	if (radix_tree_exceptional_entry(page))
+		return PAGE_SIZE;
+
+	page_cache_release(page);
+	return 0;
+
+}
+
+static int smaps_pte_hole(unsigned long addr, unsigned long end,
+		struct mm_walk *walk)
+{
+	struct mem_size_stats *mss = walk->private;
+
+	while (addr < end) {
+		mss->swap += smaps_shmem_swap(walk->vma, addr);
+		addr += PAGE_SIZE;
+	}
+
+	return 0;
+}
+#else
+static unsigned long smaps_shmem_swap(struct vm_area_struct *vma,
+		unsigned long addr)
+{
+	return 0;
+}
+#endif
+
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
@@ -512,6 +552,9 @@ static void smaps_pte_entry(pte_t *pte,
 			}
 		} else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
+	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
+							&& pte_none(*pte))) {
+		mss->swap += smaps_shmem_swap(vma, addr);
 	}
 
 	if (!page)
@@ -671,6 +714,14 @@ static int show_smap(struct seq_file *m,
 	};
 
 	memset(&mss, 0, sizeof mss);
+
+#ifdef CONFIG_SHMEM
+	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
+		mss.check_shmem_swap = true;
+		smaps_walk.pte_hole = smaps_pte_hole;
+	}
+#endif
+
 	/* mmap_sem is held in m_start */
 	walk_page_vma(vma, &smaps_walk);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are


