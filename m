From: akpm@linux-foundation.org
Subject: [merged]
 swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 15:29:57 -0800
Message-ID: <56a169f5.K+K+2pVMJks5wAhZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUX36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: swap.h: move memcg related stuff to the end of the file
has been removed from the -mm tree.  Its filename was
     swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: swap.h: move memcg related stuff to the end of the file

The following patches will add more functions to the memcg section of
include/linux/swap.h.  Some of them will need values defined below the
current location of the section.  So let's move the section to the end of
the file.  No functional changes intended.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   70 ++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff -puN include/linux/swap.h~swaph-move-memcg-related-stuff-to-the-end-of-the-file include/linux/swap.h
--- a/include/linux/swap.h~swaph-move-memcg-related-stuff-to-the-end-of-the-file
+++ a/include/linux/swap.h
@@ -350,39 +350,7 @@ extern void check_move_unevictable_pages
 
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
-#ifdef CONFIG_MEMCG
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
-{
-	/* root ? */
-	if (mem_cgroup_disabled() || !memcg->css.parent)
-		return vm_swappiness;
-
-	return memcg->swappiness;
-}
 
-#else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
-{
-	return vm_swappiness;
-}
-#endif
-#ifdef CONFIG_MEMCG_SWAP
-extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
-extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
-extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
-#else
-static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
-{
-}
-static inline int mem_cgroup_try_charge_swap(struct page *page,
-					     swp_entry_t entry)
-{
-	return 0;
-}
-static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
-{
-}
-#endif
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
@@ -561,5 +529,43 @@ static inline swp_entry_t get_swap_page(
 }
 
 #endif /* CONFIG_SWAP */
+
+#ifdef CONFIG_MEMCG
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+{
+	/* root ? */
+	if (mem_cgroup_disabled() || !memcg->css.parent)
+		return vm_swappiness;
+
+	return memcg->swappiness;
+}
+
+#else
+static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
+{
+	return vm_swappiness;
+}
+#endif
+
+#ifdef CONFIG_MEMCG_SWAP
+extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
+extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
+extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
+#else
+static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
+{
+}
+
+static inline int mem_cgroup_try_charge_swap(struct page *page,
+					     swp_entry_t entry)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
+{
+}
+#endif
+
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


