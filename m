Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D865C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D4122D6E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgLOWWV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727841AbgLOWWO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 17:22:14 -0500
Date:   Tue, 15 Dec 2020 14:21:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608070892;
        bh=1sj45ioq6+GBql/T8PI+jt0AUBEdEAXEXYa2uX3VwIQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=SFYuDPusNnPpdbLHZGuO6xuT2q99a4cGGAra6p2lTGIy2V57nCejm7X3YnqHEbywH
         BkT3/u5+JmuYn1va0jnBFOOz+LiDV/O4Z79lt7MO/7h5E/x+R48IogNGxHHZQg7H10
         TOIQKTg/ipcKz/Uw51XUnPpaCt/qls0lSZQ99d9E=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        alex.shi@linux.alibaba.com, alexander.duyck@gmail.com,
        aryabinin@virtuozzo.com, daniel.m.jordan@oracle.com,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, khlebnikov@yandex-team.ru,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mhocko@suse.com, mika.penttila@nextfour.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        rong.a.chen@intel.com, shakeelb@google.com, tglx@linutronix.de,
        tj@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
Subject:  [patch 19/19] mm/lru: revise the comments of lru_lock
Message-ID: <20201215222131.Un95p7p-j%akpm@linux-foundation.org>
In-Reply-To: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Hugh Dickins <hughd@google.com>
Subject: mm/lru: revise the comments of lru_lock

Since we changed the pgdat->lru_lock to lruvec->lru_lock, it's time to fix
the incorrect comments in code.  Also fixed some zone->lru_lock comment
error from ancient time.  etc.

I struggled to understand the comment above move_pages_to_lru() (surely
it never calls page_referenced()), and eventually realized that most of
it had got separated from shrink_active_list(): move that comment back.

Link: https://lkml.kernel.org/r/1604566549-62481-20-git-send-email-alex.shi=
@linux.alibaba.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memcg_test.rst |   15 ----
 Documentation/admin-guide/cgroup-v1/memory.rst     |   23 ++----
 Documentation/trace/events-kmem.rst                |    2=20
 Documentation/vm/unevictable-lru.rst               |   22 ++---
 include/linux/mm_types.h                           |    2=20
 include/linux/mmzone.h                             |    3=20
 mm/filemap.c                                       |    4 -
 mm/rmap.c                                          |    4 -
 mm/vmscan.c                                        |   41 ++++++-----
 9 files changed, 51 insertions(+), 65 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst~mm-lru-revise-the-=
comments-of-lru_lock
+++ a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -133,18 +133,9 @@ Under below explanation, we assume CONFI
=20
 8. LRU
 =3D=3D=3D=3D=3D=3D
-        Each memcg has its own private LRU. Now, its handling is under glo=
bal
-	VM's control (means that it's handled under global pgdat->lru_lock).
-	Almost all routines around memcg's LRU is called by global LRU's
-	list management functions under pgdat->lru_lock.
-
-	A special function is mem_cgroup_isolate_pages(). This scans
-	memcg's private LRU and call __isolate_lru_page() to extract a page
-	from LRU.
-
-	(By __isolate_lru_page(), the page is removed from both of global and
-	private LRU.)
-
+	Each memcg has its own vector of LRUs (inactive anon, active anon,
+	inactive file, active file, unevictable) of pages from each node,
+	each LRU handled under a single lru_lock for that memcg and node.
=20
 9. Typical Tests.
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-lru-revise-the-comm=
ents-of-lru_lock
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -287,20 +287,17 @@ When oom event notifier is registered, e
 2.6 Locking
 -----------
=20
-   lock_page_cgroup()/unlock_page_cgroup() should not be called under
-   the i_pages lock.
+Lock order is as follows:
=20
-   Other lock order is following:
-
-   PG_locked.
-     mm->page_table_lock
-         pgdat->lru_lock
-	   lock_page_cgroup.
-
-  In many cases, just lock_page_cgroup() is called.
-
-  per-zone-per-cgroup LRU (cgroup's private LRU) is just guarded by
-  pgdat->lru_lock, it has no lock of its own.
+  Page lock (PG_locked bit of page->flags)
+    mm->page_table_lock or split pte_lock
+      lock_page_memcg (memcg->move_lock)
+        mapping->i_pages lock
+          lruvec->lru_lock.
+
+Per-node-per-memcgroup LRU (cgroup's private LRU) is guarded by
+lruvec->lru_lock; PG_lru bit of page->flags is cleared before
+isolating a page from its LRU under lruvec->lru_lock.
=20
 2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
 -----------------------------------------------
--- a/Documentation/trace/events-kmem.rst~mm-lru-revise-the-comments-of-lru=
_lock
+++ a/Documentation/trace/events-kmem.rst
@@ -69,7 +69,7 @@ When pages are freed in batch, the also
 Broadly speaking, pages are taken off the LRU lock in bulk and
 freed in batch with a page list. Significant amounts of activity here could
 indicate that the system is under memory pressure and can also indicate
-contention on the zone->lru_lock.
+contention on the lruvec->lru_lock.
=20
 4. Per-CPU Allocator Activity
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
--- a/Documentation/vm/unevictable-lru.rst~mm-lru-revise-the-comments-of-lr=
u_lock
+++ a/Documentation/vm/unevictable-lru.rst
@@ -33,7 +33,7 @@ reclaim in Linux.  The problems have bee
 memory x86_64 systems.
=20
 To illustrate this with an example, a non-NUMA x86_64 platform with 128GB =
of
-main memory will have over 32 million 4k pages in a single zone.  When a l=
arge
+main memory will have over 32 million 4k pages in a single node.  When a l=
arge
 fraction of these pages are not evictable for any reason [see below], vmsc=
an
 will spend a lot of time scanning the LRU lists looking for the small frac=
tion
 of pages that are evictable.  This can result in a situation where all CPU=
s are
@@ -55,7 +55,7 @@ unevictable, either by definition or by
 The Unevictable Page List
 -------------------------
=20
-The Unevictable LRU infrastructure consists of an additional, per-zone, LR=
U list
+The Unevictable LRU infrastructure consists of an additional, per-node, LR=
U list
 called the "unevictable" list and an associated page flag, PG_unevictable,=
 to
 indicate that the page is being managed on the unevictable list.
=20
@@ -84,15 +84,9 @@ The unevictable list does not differenti
 swap-backed pages.  This differentiation is only important while the pages=
 are,
 in fact, evictable.
=20
-The unevictable list benefits from the "arrayification" of the per-zone LRU
+The unevictable list benefits from the "arrayification" of the per-node LRU
 lists and statistics originally proposed and posted by Christoph Lameter.
=20
-The unevictable list does not use the LRU pagevec mechanism. Rather,
-unevictable pages are placed directly on the page's zone's unevictable list
-under the zone lru_lock.  This allows us to prevent the stranding of pages=
 on
-the unevictable list when one task has the page isolated from the LRU and =
other
-tasks are changing the "evictability" state of the page.
-
=20
 Memory Control Group Interaction
 --------------------------------
@@ -101,8 +95,8 @@ The unevictable LRU facility interacts w
 memory controller; see Documentation/admin-guide/cgroup-v1/memory.rst] by =
extending the
 lru_list enum.
=20
-The memory controller data structure automatically gets a per-zone unevict=
able
-list as a result of the "arrayification" of the per-zone LRU lists (one per
+The memory controller data structure automatically gets a per-node unevict=
able
+list as a result of the "arrayification" of the per-node LRU lists (one per
 lru_list enum element).  The memory controller tracks the movement of page=
s to
 and from the unevictable list.
=20
@@ -196,7 +190,7 @@ for the sake of expediency, to leave a u
 active/inactive LRU lists for vmscan to deal with.  vmscan checks for such
 pages in all of the shrink_{active|inactive|page}_list() functions and will
 "cull" such pages that it encounters: that is, it diverts those pages to t=
he
-unevictable list for the zone being scanned.
+unevictable list for the node being scanned.
=20
 There may be situations where a page is mapped into a VM_LOCKED VMA, but t=
he
 page is not marked as PG_mlocked.  Such pages will make it all the way to
@@ -328,7 +322,7 @@ If the page was NOT already mlocked, mlo
 page from the LRU, as it is likely on the appropriate active or inactive l=
ist
 at that time.  If the isolate_lru_page() succeeds, mlock_vma_page() will p=
ut
 back the page - by calling putback_lru_page() - which will notice that the=
 page
-is now mlocked and divert the page to the zone's unevictable list.  If
+is now mlocked and divert the page to the node's unevictable list.  If
 mlock_vma_page() is unable to isolate the page from the LRU, vmscan will h=
andle
 it later if and when it attempts to reclaim the page.
=20
@@ -603,7 +597,7 @@ Some examples of these unevictable pages
      unevictable list in mlock_vma_page().
=20
 shrink_inactive_list() also diverts any unevictable pages that it finds on=
 the
-inactive lists to the appropriate zone's unevictable list.
+inactive lists to the appropriate node's unevictable list.
=20
 shrink_inactive_list() should only see SHM_LOCK'd pages that became SHM_LO=
CK'd
 after shrink_active_list() had moved them to the inactive list, or pages m=
apped
--- a/include/linux/mm_types.h~mm-lru-revise-the-comments-of-lru_lock
+++ a/include/linux/mm_types.h
@@ -79,7 +79,7 @@ struct page {
 		struct {	/* Page cache and anonymous pages */
 			/**
 			 * @lru: Pageout list, eg. active_list protected by
-			 * pgdat->lru_lock.  Sometimes used as a generic list
+			 * lruvec->lru_lock.  Sometimes used as a generic list
 			 * by the page owner.
 			 */
 			struct list_head lru;
--- a/include/linux/mmzone.h~mm-lru-revise-the-comments-of-lru_lock
+++ a/include/linux/mmzone.h
@@ -113,8 +113,7 @@ static inline bool free_area_empty(struc
 struct pglist_data;
=20
 /*
- * zone->lock and the zone lru_lock are two of the hottest locks in the ke=
rnel.
- * So add a wild amount of padding here to ensure that they fall into sepa=
rate
+ * Add a wild amount of padding here to ensure datas fall into separate
  * cachelines.  There are very few zone structures in the machine, so space
  * consumption is not a concern here.
  */
--- a/mm/filemap.c~mm-lru-revise-the-comments-of-lru_lock
+++ a/mm/filemap.c
@@ -102,8 +102,8 @@
  *    ->swap_lock		(try_to_unmap_one)
  *    ->private_lock		(try_to_unmap_one)
  *    ->i_pages lock		(try_to_unmap_one)
- *    ->pgdat->lru_lock		(follow_page->mark_page_accessed)
- *    ->pgdat->lru_lock		(check_pte_range->isolate_lru_page)
+ *    ->lruvec->lru_lock	(follow_page->mark_page_accessed)
+ *    ->lruvec->lru_lock	(check_pte_range->isolate_lru_page)
  *    ->private_lock		(page_remove_rmap->set_page_dirty)
  *    ->i_pages lock		(page_remove_rmap->set_page_dirty)
  *    bdi.wb->list_lock		(page_remove_rmap->set_page_dirty)
--- a/mm/rmap.c~mm-lru-revise-the-comments-of-lru_lock
+++ a/mm/rmap.c
@@ -28,12 +28,12 @@
  *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
  *           anon_vma->rwsem
  *             mm->page_table_lock or pte_lock
- *               pgdat->lru_lock (in mark_page_accessed, isolate_lru_page)
  *               swap_lock (in swap_duplicate, swap_info_get)
  *                 mmlist_lock (in mmput, drain_mmlist and others)
  *                 mapping->private_lock (in __set_page_dirty_buffers)
- *                   mem_cgroup_{begin,end}_page_stat (memcg->move_lock)
+ *                   lock_page_memcg move_lock (in __set_page_dirty_buffer=
s)
  *                     i_pages lock (widely used)
+ *                       lruvec->lru_lock (in lock_page_lruvec_irq)
  *                 inode->i_lock (in set_page_dirty's __mark_inode_dirty)
  *                 bdi.wb->list_lock (in set_page_dirty's __mark_inode_dir=
ty)
  *                   sb_lock (within inode_lock in fs/fs-writeback.c)
--- a/mm/vmscan.c~mm-lru-revise-the-comments-of-lru_lock
+++ a/mm/vmscan.c
@@ -1613,14 +1613,16 @@ static __always_inline void update_lru_s
 }
=20
 /**
- * pgdat->lru_lock is heavily contended.  Some of the functions that
+ * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
+ *
+ * lruvec->lru_lock is heavily contended.  Some of the functions that
  * shrink the lists perform better by taking out a batch of pages
  * and working on them outside the LRU lock.
  *
  * For pagecache intensive workloads, this function is the hottest
  * spot in the kernel (apart from copy_*_user functions).
  *
- * Appropriate locks must be held before calling this function.
+ * Lru_lock must be held before calling this function.
  *
  * @nr_to_scan:	The number of eligible pages to look through on the list.
  * @lruvec:	The LRU vector to pull pages from.
@@ -1814,25 +1816,11 @@ static int too_many_isolated(struct pgli
 }
=20
 /*
- * This moves pages from @list to corresponding LRU list.
- *
- * We move them the other way if the page is referenced by one or more
- * processes, from rmap.
- *
- * If the pages are mostly unmapped, the processing is fast and it is
- * appropriate to hold zone_lru_lock across the whole operation.  But if
- * the pages are mapped, the processing is slow (page_referenced()) so we
- * should drop zone_lru_lock around each page.  It's impossible to balance
- * this, so instead we remove the pages from the LRU while processing them.
- * It is safe to rely on PG_active against the non-LRU pages in here becau=
se
- * nobody will play with that bit on a non-LRU page.
- *
- * The downside is that we have to touch page->_refcount against each page.
- * But we had to alter page->flags anyway.
+ * move_pages_to_lru() moves pages from private @list to appropriate LRU l=
ist.
+ * On return, @list is reused as a list of pages to be freed by the caller.
  *
  * Returns the number of pages moved to the given lruvec.
  */
-
 static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 						     struct list_head *list)
 {
@@ -2010,6 +1998,23 @@ shrink_inactive_list(unsigned long nr_to
 	return nr_reclaimed;
 }
=20
+/*
+ * shrink_active_list() moves pages from the active LRU to the inactive LR=
U.
+ *
+ * We move them the other way if the page is referenced by one or more
+ * processes.
+ *
+ * If the pages are mostly unmapped, the processing is fast and it is
+ * appropriate to hold lru_lock across the whole operation.  But if
+ * the pages are mapped, the processing is slow (page_referenced()), so
+ * we should drop lru_lock around each page.  It's impossible to balance
+ * this, so instead we remove the pages from the LRU while processing them.
+ * It is safe to rely on PG_active against the non-LRU pages in here becau=
se
+ * nobody will play with that bit on a non-LRU page.
+ *
+ * The downside is that we have to touch page->_refcount against each page.
+ * But we had to alter page->flags anyway.
+ */
 static void shrink_active_list(unsigned long nr_to_scan,
 			       struct lruvec *lruvec,
 			       struct scan_control *sc,
_
