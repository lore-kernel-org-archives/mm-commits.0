From: akpm@linux-foundation.org
Subject: + swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
 added to -mm tree
Date: Thu, 17 Dec 2015 13:59:51 -0800
Message-ID: <56733057.lFL5XBdTGEepgl8V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbbLQV7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 16:59:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: swap.h: move memcg related stuff to the end of the file
has been added to the -mm tree.  Its filename is
     swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -351,39 +351,7 @@ extern void check_move_unevictable_pages
 
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
@@ -562,5 +530,43 @@ static inline swp_entry_t get_swap_page(
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

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch
mm-add-page_check_address_transhuge-helper-fix.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

