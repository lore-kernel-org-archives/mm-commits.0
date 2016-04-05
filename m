From: akpm@linux-foundation.org
Subject: +
 huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch added to
 -mm tree
Date: Tue, 05 Apr 2016 16:16:00 -0700
Message-ID: <57044730.L2kbURTXQHmG6VUf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbcDEXQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: use Unevictable lru with variable hpage_nr_pages
has been added to the -mm tree.  Its filename is
     huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: use Unevictable lru with variable hpage_nr_pages

A big advantage of huge tmpfs over hugetlbfs is that its pages can be
swapped out; but too often it OOMs before swapping them out.

At first I tried changing page_evictable(), to treat all tail pages of a
hugely mapped team as unevictable: the anon LRUs were otherwise swamped by
pages that could not be freed before the head.

That worked quite well, some of the time, but has some drawbacks.

Most obviously, /proc/meminfo is liable to show 511/512ths of all the
ShmemPmdMapped as Unevictable; which is rather sad for a feature intended
to improve on hugetlbfs by letting the pages be swappable.

But more seriously, although it is helpful to have those tails out of the
way on the Unevictable list, page reclaim can very easily come to a point
where all the team heads to be freed are on the Active list, but the
Inactive is large enough that !inactive_anon_is_low(), so the Active is
never scanned to unmap those heads to release all the tails.  Eventually
we OOM.

Perhaps that could be dealt with by hacking inactive_anon_is_low(): but it
wouldn't help the Unevictable numbers, and has never been necessary for
anon THP.  How does anon THP avoid this?  It doesn't put tails on the LRU
at all, so doesn't then need to shift them to Unevictable; but there would
still be the danger of an Active list full of heads, holding the unseen
tails, but the ratio too high for for Active scanning - except that
hpage_nr_pages() weights each THP head by the number of small pages the
huge page holds, instead of the usual 1, and that is what keeps the
Active/Inactive balance working.

So in this patch we try to do the same for huge tmpfs pages.  However, a
team is not one huge compound page, but a collection of independent pages,
and the fair and lazy way to accomplish this seems to be to transfer each
tail's weight to head at the time when shmem_writepage() has been asked to
evict the page, but refuses because the head has not yet been evicted.  So
although the failed-to-be-evicted tails are moved to the Unevictable LRU,
each counts for 0kB in the Unevictable amount, its 4kB going to the head
in the Active(anon) or Inactive(anon) amount.

With a few exceptions, hpage_nr_pages() is now only called on a
maybe-PageTeam page while under lruvec lock: and we do need to hold lruvec
lock when transferring weight from one page to another.  Exceptions:
mlock.c (next patch), subsequently self-correcting calls to
page_evictable(), and the "nr_rotated +=" line in shrink_active_list(),
which has no need to be precise.

(Aside: quite a few of our calls to hpage_nr_pages() are no more than ways
to side-step the THP-off BUILD_BUG_ON() buried in HPAGE_PMD_NR: we might
do better to kill that BUILD_BUG_ON() at last.)

Lru lock is a new overhead, which shmem_disband_hugehead() prefers to
avoid, if the head's weight is just the default 1.  And it's not clear how
well this will all play out if different pages of a team are charged to
different memcgs: but the code allows for that, and it should be fine
while that's just an exceptional minority case.

A change I like in principle, but have not made, and do not intend to make
unless we see a workload that demands it: it would be natural for
mark_page_accessed() to retrieve such a 0-weight page from the Unevictable
LRU, assigning it weight again and giving it a new life on the Active and
Inactive LRUs.  As it is, I'm hoping PageReferenced gives a good enough
hint as to whether a page should be retained, when
shmem_evictify_hugetails() brings it back from Unevictable to Inactive.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |   15 ++
 include/linux/huge_mm.h              |   14 ++
 include/linux/pageteam.h             |   48 ++++++
 mm/memcontrol.c                      |   10 +
 mm/shmem.c                           |  173 +++++++++++++++++++++----
 mm/swap.c                            |    5 
 mm/vmscan.c                          |   39 +++++
 7 files changed, 274 insertions(+), 30 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages
+++ a/Documentation/vm/unevictable-lru.txt
@@ -72,6 +72,8 @@ The unevictable list addresses the follo
 
  (*) Those mapped into VM_LOCKED [mlock()ed] VMAs.
 
+ (*) Tails owned by huge tmpfs, unevictable until team head page is evicted.
+
 The infrastructure may also be able to handle other conditions that make pages
 unevictable, either by definition or by circumstance, in the future.
 
@@ -201,6 +203,15 @@ page_evictable() also checks for mlocked
 flag, PG_mlocked (as wrapped by PageMlocked()), which is set when a page is
 faulted into a VM_LOCKED vma, or found in a vma being VM_LOCKED.
 
+page_evictable() also uses hpage_nr_pages(), to check for a huge tmpfs team
+tail page which reached the bottom of the inactive list, but could not be
+evicted at that time because its team head had not yet been evicted.  We
+must not evict any member of the team while the whole team is mapped; and
+at present we only disband the team for reclaim when its head is evicted.
+When an inactive tail is held back from eviction, putback_inactive_pages()
+shifts its "weight" of 1 page to the head, to increase pressure on the head,
+but leave the tail as unevictable, without adding to the Unevictable count.
+
 
 VMSCAN'S HANDLING OF UNEVICTABLE PAGES
 --------------------------------------
@@ -597,7 +608,9 @@ Some examples of these unevictable pages
      unevictable list in mlock_vma_page().
 
 shrink_inactive_list() also diverts any unevictable pages that it finds on the
-inactive lists to the appropriate zone's unevictable list.
+inactive lists to the appropriate zone's unevictable list, adding in those
+huge tmpfs team tails which were rejected by pageout() (shmem_writepage())
+because the team has not yet been disbanded by evicting the head.
 
 shrink_inactive_list() should only see SHM_LOCK'd pages that became SHM_LOCK'd
 after shrink_active_list() had moved them to the inactive list, or pages mapped
diff -puN include/linux/huge_mm.h~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages
+++ a/include/linux/huge_mm.h
@@ -127,10 +127,24 @@ static inline spinlock_t *pmd_trans_huge
 	else
 		return NULL;
 }
+
+/* Repeat definition from linux/pageteam.h to force error if different */
+#define TEAM_LRU_WEIGHT_MASK	((1L << (HPAGE_PMD_ORDER + 1)) - 1)
+
+/*
+ * hpage_nr_pages(page) returns the current LRU weight of the page.
+ * Beware of races when it is used: an Anon THPage might get split,
+ * so may need protection by compound lock or lruvec lock; a huge tmpfs
+ * team page might have weight 1 shifted from tail to head, or back to
+ * tail when disbanded, so may need protection by lruvec lock.
+ */
 static inline int hpage_nr_pages(struct page *page)
 {
 	if (unlikely(PageTransHuge(page)))
 		return HPAGE_PMD_NR;
+	if (PageTeam(page))
+		return atomic_long_read(&page->team_usage) &
+					TEAM_LRU_WEIGHT_MASK;
 	return 1;
 }
 
diff -puN include/linux/pageteam.h~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages include/linux/pageteam.h
--- a/include/linux/pageteam.h~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages
+++ a/include/linux/pageteam.h
@@ -30,11 +30,32 @@ static inline struct page *team_head(str
 }
 
 /*
+ * Mask for lower bits of team_usage, giving the weight 0..HPAGE_PMD_NR of the
+ * page on its LRU: normal pages have weight 1, tails held unevictable until
+ * head is evicted have weight 0, and the head gathers weight 1..HPAGE_PMD_NR.
+ */
+#define TEAM_LRU_WEIGHT_ONE	1L
+#define TEAM_LRU_WEIGHT_MASK	((1L << (HPAGE_PMD_ORDER + 1)) - 1)
+
+#define TEAM_HIGH_COUNTER	(1L << (HPAGE_PMD_ORDER + 1))
+/*
+ * Count how many pages of team are instantiated, as it is built up.
+ */
+#define TEAM_PAGE_COUNTER	TEAM_HIGH_COUNTER
+#define TEAM_COMPLETE		(TEAM_PAGE_COUNTER << HPAGE_PMD_ORDER)
+/*
+ * And when complete, count how many huge mappings (like page_mapcount): an
+ * incomplete team cannot be hugely mapped (would expose uninitialized holes).
+ */
+#define TEAM_MAPPING_COUNTER	TEAM_HIGH_COUNTER
+#define TEAM_PMD_MAPPED	(TEAM_COMPLETE + TEAM_MAPPING_COUNTER)
+
+/*
  * Returns true if this team is mapped by pmd somewhere.
  */
 static inline bool team_pmd_mapped(struct page *head)
 {
-	return atomic_long_read(&head->team_usage) > HPAGE_PMD_NR;
+	return atomic_long_read(&head->team_usage) >= TEAM_PMD_MAPPED;
 }
 
 /*
@@ -43,7 +64,8 @@ static inline bool team_pmd_mapped(struc
  */
 static inline bool inc_team_pmd_mapped(struct page *head)
 {
-	return atomic_long_inc_return(&head->team_usage) == HPAGE_PMD_NR+1;
+	return atomic_long_add_return(TEAM_MAPPING_COUNTER, &head->team_usage)
+		< TEAM_PMD_MAPPED + TEAM_MAPPING_COUNTER;
 }
 
 /*
@@ -52,7 +74,27 @@ static inline bool inc_team_pmd_mapped(s
  */
 static inline bool dec_team_pmd_mapped(struct page *head)
 {
-	return atomic_long_dec_return(&head->team_usage) == HPAGE_PMD_NR;
+	return atomic_long_sub_return(TEAM_MAPPING_COUNTER, &head->team_usage)
+		< TEAM_PMD_MAPPED;
+}
+
+static inline void inc_lru_weight(struct page *head)
+{
+	atomic_long_inc(&head->team_usage);
+	VM_BUG_ON_PAGE((atomic_long_read(&head->team_usage) &
+			TEAM_LRU_WEIGHT_MASK) > HPAGE_PMD_NR, head);
+}
+
+static inline void set_lru_weight(struct page *page)
+{
+	VM_BUG_ON_PAGE(atomic_long_read(&page->team_usage) != 0, page);
+	atomic_long_set(&page->team_usage, 1);
+}
+
+static inline void clear_lru_weight(struct page *page)
+{
+	VM_BUG_ON_PAGE(atomic_long_read(&page->team_usage) != 1, page);
+	atomic_long_set(&page->team_usage, 0);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN mm/memcontrol.c~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages mm/memcontrol.c
--- a/mm/memcontrol.c~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages
+++ a/mm/memcontrol.c
@@ -1047,6 +1047,16 @@ void mem_cgroup_update_lru_size(struct l
 		*lru_size += nr_pages;
 
 	size = *lru_size;
+	if (!size && !empty && lru == LRU_UNEVICTABLE) {
+		struct page *page;
+		/*
+		 * The unevictable list might be full of team tail pages of 0
+		 * weight: check the first, and skip the warning if that fits.
+		 */
+		page = list_first_entry(lruvec->lists + lru, struct page, lru);
+		if (hpage_nr_pages(page) == 0)
+			empty = true;
+	}
 	if (WARN_ONCE(size < 0 || empty != !size,
 		"%s(%p, %d, %d): lru_size %ld but %sempty\n",
 		__func__, lruvec, lru, nr_pages, size, empty ? "" : "not ")) {
diff -puN mm/shmem.c~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages
+++ a/mm/shmem.c
@@ -63,6 +63,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/swapops.h>
 #include <linux/pageteam.h>
 #include <linux/mempolicy.h>
+#include <linux/mm_inline.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/migrate.h>
@@ -372,7 +373,8 @@ static int shmem_freeholes(struct page *
 {
 	unsigned long nr = atomic_long_read(&head->team_usage);
 
-	return (nr >= HPAGE_PMD_NR) ? 0 : HPAGE_PMD_NR - nr;
+	return (nr >= TEAM_COMPLETE) ? 0 :
+		HPAGE_PMD_NR - (nr / TEAM_PAGE_COUNTER);
 }
 
 static void shmem_clear_tag_hugehole(struct address_space *mapping,
@@ -399,18 +401,16 @@ static void shmem_added_to_hugeteam(stru
 {
 	struct address_space *mapping = page->mapping;
 	struct page *head = team_head(page);
-	int nr;
 
 	if (hugehint == SHMEM_ALLOC_HUGE_PAGE) {
-		atomic_long_set(&head->team_usage, 1);
+		atomic_long_set(&head->team_usage,
+				TEAM_PAGE_COUNTER + TEAM_LRU_WEIGHT_ONE);
 		radix_tree_tag_set(&mapping->page_tree, page->index,
 					SHMEM_TAG_HUGEHOLE);
 		__mod_zone_page_state(zone, NR_SHMEM_FREEHOLES, HPAGE_PMD_NR-1);
 	} else {
-		/* We do not need atomic ops until huge page gets mapped */
-		nr = atomic_long_read(&head->team_usage) + 1;
-		atomic_long_set(&head->team_usage, nr);
-		if (nr == HPAGE_PMD_NR) {
+		if (atomic_long_add_return(TEAM_PAGE_COUNTER,
+				&head->team_usage) >= TEAM_COMPLETE) {
 			shmem_clear_tag_hugehole(mapping, head->index);
 			__inc_zone_state(zone, NR_SHMEM_HUGEPAGES);
 		}
@@ -456,11 +456,14 @@ static int shmem_populate_hugeteam(struc
 	return 0;
 }
 
-static int shmem_disband_hugehead(struct page *head)
+static int shmem_disband_hugehead(struct page *head, int *head_lru_weight)
 {
 	struct address_space *mapping;
+	bool lru_locked = false;
+	unsigned long flags;
 	struct zone *zone;
-	int nr = -EALREADY;	/* A racing task may have disbanded the team */
+	long team_usage;
+	long nr = -EALREADY;	/* A racing task may have disbanded the team */
 
 	/*
 	 * In most cases the head page is locked, or not yet exposed to others:
@@ -469,27 +472,54 @@ static int shmem_disband_hugehead(struct
 	 * stays safe because shmem_evict_inode must take the shrinklist_lock,
 	 * and our caller shmem_choose_hugehole is already holding that lock.
 	 */
+	*head_lru_weight = 0;
 	mapping = READ_ONCE(head->mapping);
 	if (!mapping)
 		return nr;
 
 	zone = page_zone(head);
-	spin_lock_irq(&mapping->tree_lock);
+	team_usage = atomic_long_read(&head->team_usage);
+again1:
+	if ((team_usage & TEAM_LRU_WEIGHT_MASK) != TEAM_LRU_WEIGHT_ONE) {
+		spin_lock_irq(&zone->lru_lock);
+		lru_locked = true;
+	}
+	spin_lock_irqsave(&mapping->tree_lock, flags);
 
 	if (PageTeam(head)) {
-		nr = atomic_long_read(&head->team_usage);
-		atomic_long_set(&head->team_usage, 0);
+again2:
+		nr = atomic_long_cmpxchg(&head->team_usage, team_usage,
+					 TEAM_LRU_WEIGHT_ONE);
+		if (unlikely(nr != team_usage)) {
+			team_usage = nr;
+			if (lru_locked ||
+			    (team_usage & TEAM_LRU_WEIGHT_MASK) ==
+						    TEAM_LRU_WEIGHT_ONE)
+				goto again2;
+			spin_unlock_irqrestore(&mapping->tree_lock, flags);
+			goto again1;
+		}
+		*head_lru_weight = nr & TEAM_LRU_WEIGHT_MASK;
+		nr /= TEAM_PAGE_COUNTER;
+
 		/*
-		 * Disable additions to the team.
-		 * Ensure head->private is written before PageTeam is
-		 * cleared, so shmem_writepage() cannot write swap into
-		 * head->private, then have it overwritten by that 0!
+		 * Disable additions to the team.  The cmpxchg above
+		 * ensures head->team_usage is read before PageTeam is cleared,
+		 * when shmem_writepage() might write swap into head->private.
 		 */
-		smp_mb__before_atomic();
 		ClearPageTeam(head);
+
+		/*
+		 * If head has not yet been instantiated into the cache,
+		 * reset its page->mapping now, while we have all the locks.
+		 */
 		if (!PageSwapBacked(head))
 			head->mapping = NULL;
 
+		if (PageLRU(head) && *head_lru_weight > 1)
+			update_lru_size(mem_cgroup_page_lruvec(head, zone),
+					page_lru(head), 1 - *head_lru_weight);
+
 		if (nr >= HPAGE_PMD_NR) {
 			ClearPageChecked(head);
 			__dec_zone_state(zone, NR_SHMEM_HUGEPAGES);
@@ -501,10 +531,88 @@ static int shmem_disband_hugehead(struct
 		}
 	}
 
-	spin_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irqrestore(&mapping->tree_lock, flags);
+	if (lru_locked)
+		spin_unlock_irq(&zone->lru_lock);
 	return nr;
 }
 
+static void shmem_evictify_hugetails(struct page *head, int head_lru_weight)
+{
+	struct page *page;
+	struct lruvec *lruvec = NULL;
+	struct zone *zone = page_zone(head);
+	bool lru_locked = false;
+
+	/*
+	 * The head has been sheltering the rest of its team from reclaim:
+	 * if any were moved to the unevictable list, now make them evictable.
+	 */
+again:
+	for (page = head + HPAGE_PMD_NR - 1; page > head; page--) {
+		if (!PageTeam(page))
+			continue;
+		if (atomic_long_read(&page->team_usage) == TEAM_LRU_WEIGHT_ONE)
+			continue;
+
+		/*
+		 * Delay getting lru lock until we reach a page that needs it.
+		 */
+		if (!lru_locked) {
+			spin_lock_irq(&zone->lru_lock);
+			lru_locked = true;
+		}
+		lruvec = mem_cgroup_page_lruvec(page, zone);
+
+		if (unlikely(atomic_long_read(&page->team_usage) ==
+							TEAM_LRU_WEIGHT_ONE))
+			continue;
+
+		set_lru_weight(page);
+		head_lru_weight--;
+
+		/*
+		 * Usually an Unevictable Team page just stays on its LRU;
+		 * but isolation for migration might take it off briefly.
+		 */
+		if (unlikely(!PageLRU(page)))
+			continue;
+
+		VM_BUG_ON_PAGE(!PageUnevictable(page), page);
+		VM_BUG_ON_PAGE(PageActive(page), page);
+
+		if (!page_evictable(page)) {
+			/*
+			 * This is tiresome, but page_evictable() needs weight 1
+			 * to make the right decision, whereas lru size update
+			 * needs weight 0 to avoid a bogus "not empty" warning.
+			 */
+			clear_lru_weight(page);
+			update_lru_size(lruvec, LRU_UNEVICTABLE, 1);
+			set_lru_weight(page);
+			continue;
+		}
+
+		ClearPageUnevictable(page);
+		update_lru_size(lruvec, LRU_INACTIVE_ANON, 1);
+
+		list_del(&page->lru);
+		list_add_tail(&page->lru, lruvec->lists + LRU_INACTIVE_ANON);
+	}
+
+	if (lru_locked) {
+		spin_unlock_irq(&zone->lru_lock);
+		lru_locked = false;
+	}
+
+	/*
+	 * But how can we be sure that a racing putback_inactive_pages()
+	 * did its clear_lru_weight() before we checked team_usage above?
+	 */
+	if (unlikely(head_lru_weight != TEAM_LRU_WEIGHT_ONE))
+		goto again;
+}
+
 static void shmem_disband_hugetails(struct page *head,
 				    struct list_head *list, int nr)
 {
@@ -578,6 +686,7 @@ static void shmem_disband_hugetails(stru
 static void shmem_disband_hugeteam(struct page *page)
 {
 	struct page *head = team_head(page);
+	int head_lru_weight;
 	int nr_used;
 
 	/*
@@ -623,9 +732,11 @@ static void shmem_disband_hugeteam(struc
 	 * can (splitting disband in two stages), but better not be preempted.
 	 */
 	preempt_disable();
-	nr_used = shmem_disband_hugehead(head);
+	nr_used = shmem_disband_hugehead(head, &head_lru_weight);
 	if (head != page)
 		unlock_page(head);
+	if (head_lru_weight > TEAM_LRU_WEIGHT_ONE)
+		shmem_evictify_hugetails(head, head_lru_weight);
 	if (nr_used >= 0)
 		shmem_disband_hugetails(head, NULL, 0);
 	if (head != page)
@@ -681,6 +792,7 @@ static unsigned long shmem_choose_hugeho
 	struct page *topage = NULL;
 	struct page *page;
 	pgoff_t index;
+	int head_lru_weight;
 	int fromused;
 	int toused;
 	int nid;
@@ -722,8 +834,10 @@ static unsigned long shmem_choose_hugeho
 	if (!frompage)
 		goto unlock;
 	preempt_disable();
-	fromused = shmem_disband_hugehead(frompage);
+	fromused = shmem_disband_hugehead(frompage, &head_lru_weight);
 	spin_unlock(&shmem_shrinklist_lock);
+	if (head_lru_weight > TEAM_LRU_WEIGHT_ONE)
+		shmem_evictify_hugetails(frompage, head_lru_weight);
 	if (fromused > 0)
 		shmem_disband_hugetails(frompage, fromlist, -fromused);
 	preempt_enable();
@@ -777,8 +891,10 @@ static unsigned long shmem_choose_hugeho
 	if (!topage)
 		goto unlock;
 	preempt_disable();
-	toused = shmem_disband_hugehead(topage);
+	toused = shmem_disband_hugehead(topage, &head_lru_weight);
 	spin_unlock(&shmem_shrinklist_lock);
+	if (head_lru_weight > TEAM_LRU_WEIGHT_ONE)
+		shmem_evictify_hugetails(topage, head_lru_weight);
 	if (toused > 0) {
 		if (HPAGE_PMD_NR - toused >= fromused)
 			shmem_disband_hugetails(topage, tolist, fromused);
@@ -930,7 +1046,11 @@ shmem_add_to_page_cache(struct page *pag
 		}
 		if (!PageSwapBacked(page)) {	/* huge needs special care */
 			SetPageSwapBacked(page);
-			SetPageTeam(page);
+			if (!PageTeam(page)) {
+				atomic_long_set(&page->team_usage,
+						TEAM_LRU_WEIGHT_ONE);
+				SetPageTeam(page);
+			}
 		}
 	}
 
@@ -1612,9 +1732,13 @@ static int shmem_writepage(struct page *
 		struct page *head = team_head(page);
 		/*
 		 * Only proceed if this is head, or if head is unpopulated.
+		 * Redirty any others, without setting PageActive, and then
+		 * putback_inactive_pages() will shift them to unevictable.
 		 */
-		if (page != head && PageSwapBacked(head))
+		if (page != head && PageSwapBacked(head)) {
+			wbc->for_reclaim = 0;
 			goto redirty;
+		}
 	}
 
 	swap = get_swap_page();
@@ -1762,7 +1886,8 @@ static struct page *shmem_alloc_page(gfp
 				split_page(head, HPAGE_PMD_ORDER);
 
 				/* Prepare head page for add_to_page_cache */
-				atomic_long_set(&head->team_usage, 0);
+				atomic_long_set(&head->team_usage,
+						TEAM_LRU_WEIGHT_ONE);
 				__SetPageTeam(head);
 				head->mapping = mapping;
 				head->index = round_down(index, HPAGE_PMD_NR);
diff -puN mm/swap.c~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages mm/swap.c
--- a/mm/swap.c~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages
+++ a/mm/swap.c
@@ -469,6 +469,11 @@ void lru_cache_add_active_or_unevictable
 					 struct vm_area_struct *vma)
 {
 	VM_BUG_ON_PAGE(PageLRU(page), page);
+	/*
+	 * Using hpage_nr_pages() on a huge tmpfs team page might not give the
+	 * 1 NR_MLOCK needs below; but this seems to be for anon pages only.
+	 */
+	VM_BUG_ON_PAGE(!PageAnon(page), page);
 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED)) {
 		SetPageActive(page);
diff -puN mm/vmscan.c~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages mm/vmscan.c
--- a/mm/vmscan.c~huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages
+++ a/mm/vmscan.c
@@ -19,6 +19,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/swap.h>
 #include <linux/pagemap.h>
+#include <linux/pageteam.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/vmpressure.h>
@@ -1514,6 +1515,39 @@ putback_inactive_pages(struct lruvec *lr
 			continue;
 		}
 
+		if (PageTeam(page) && !PageActive(page)) {
+			struct page *head = team_head(page);
+			struct address_space *mapping;
+			bool transferring_weight = false;
+			/*
+			 * Team tail page was ready for eviction, but has
+			 * been sent back from shmem_writepage(): transfer
+			 * its weight to head, and move tail to unevictable.
+			 */
+			mapping = READ_ONCE(page->mapping);
+			if (page != head && mapping) {
+				lruvec = mem_cgroup_page_lruvec(head, zone);
+				spin_lock(&mapping->tree_lock);
+				if (PageTeam(head)) {
+					VM_BUG_ON(head->mapping != mapping);
+					inc_lru_weight(head);
+					transferring_weight = true;
+				}
+				spin_unlock(&mapping->tree_lock);
+			}
+			if (transferring_weight) {
+				if (PageLRU(head))
+					update_lru_size(lruvec,
+							page_lru(head), 1);
+				/* Get this tail page out of the way for now */
+				SetPageUnevictable(page);
+				clear_lru_weight(page);
+			} else {
+				/* Traditional case of unswapped & redirtied */
+				SetPageActive(page);
+			}
+		}
+
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		SetPageLRU(page);
@@ -3771,11 +3805,12 @@ int zone_reclaim(struct zone *zone, gfp_
  * Reasons page might not be evictable:
  * (1) page's mapping marked unevictable
  * (2) page is part of an mlocked VMA
- *
+ * (3) page is held in memory as part of a team
  */
 int page_evictable(struct page *page)
 {
-	return !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
+	return !mapping_unevictable(page_mapping(page)) &&
+		!PageMlocked(page) && hpage_nr_pages(page);
 }
 
 #ifdef CONFIG_SHMEM
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch
huge-tmpfs-include-shmem-freeholes-in-available-memory.patch
huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge.patch
huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team.patch
huge-tmpfs-avoid-team-pages-in-a-few-places.patch
huge-tmpfs-shrinker-to-migrate-and-free-underused-holes.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page.patch
huge-tmpfs-try_to_unmap_one-use-page_check_address_transhuge.patch
huge-tmpfs-avoid-premature-exposure-of-new-pagetable.patch
huge-tmpfs-map-shmem-by-huge-page-pmd-or-by-page-team-ptes.patch
huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch
huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch
huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch

