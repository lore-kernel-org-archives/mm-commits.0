From: akpm@linux-foundation.org
Subject: - memcg-handle-swap-caches-build-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:11:09 -0800
Message-ID: <200901072311.n07NB9ZC029090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762696AbZAGXLn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:11:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: handle swap caches build fix
has been removed from the -mm tree.  Its filename was
     memcg-handle-swap-caches-build-fix.patch

This patch was dropped because it was folded into memcg-handle-swap-cac=
hes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: memcg: handle swap caches build fix
=46rom: Hugh Dickins <hugh@veritas.com>

=46ix to build error when CONFIG_SHMEM=3Dy but CONFIG_SWAP is not set:
mm/shmem.c: In function =E2=80=98shmem_unuse_inode=E2=80=99:
mm/shmem.c:927: error: implicit declaration of function =E2=80=98mem_cg=
roup_cache_charge_swapin=E2=80=99

Yes, there's a lot of code in mm/shmem.c which only comes into play whe=
n
CONFIG_SWAP=3Dy: better than this quick fix would be to restructure shm=
em.c
with all swap stuff in a separate file; that's on my mind, but now is n=
ot
the moment for it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/swap.h~memcg-handle-swap-caches-build-fix inclu=
de/linux/swap.h
--- a/include/linux/swap.h~memcg-handle-swap-caches-build-fix
+++ a/include/linux/swap.h
@@ -434,6 +434,12 @@ static inline swp_entry_t get_swap_page(
 #define has_swap_token(x) 0
 #define disable_swap_token() do { } while(0)
=20
+static inline int mem_cgroup_cache_charge_swapin(struct page *page,
+			struct mm_struct *mm, gfp_t mask, bool locked)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
