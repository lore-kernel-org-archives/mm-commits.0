From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-memcontrol-drop-unused-try-commit-cancel-charge-api-fix.patch removed
 from -mm tree
Date: Wed, 03 Jun 2020 15:18:28 -0700
Message-ID: <20200603221828.GC_hgobfj%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgFCWS3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:18:29 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix an unused-function warning
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-unused-try-commit-cancel-charge-api-fix.patch

This patch was dropped because it was folded into mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: memcontrol: fix an unused-function warning

On NOMMU kernels without CONFIG_MEMCG_KMEM, we now get a harmless
warning about an unused function:

mm/memcontrol.c:2595:13: error: unused function 'cancel_charge' [-Werror,-Wunused-function]

Hide this function in a matching #ifdef.

Link: http://lkml.kernel.org/r/20200528095640.151454-1-arnd@arndb.de
Fixes: 5bd144bf764c ("mm: memcontrol: drop unused try/commit/cancel charge API")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~mm-memcontrol-drop-unused-try-commit-cancel-charge-api-fix
+++ a/mm/memcontrol.c
@@ -2641,6 +2641,7 @@ done_restock:
 	return 0;
 }
 
+#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
 static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (mem_cgroup_is_root(memcg))
@@ -2652,6 +2653,7 @@ static void cancel_charge(struct mem_cgr
 
 	css_put_many(&memcg->css, nr_pages);
 }
+#endif
 
 static void lock_page_lru(struct page *page, int *isolated)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
drm-remove-drm-specific-kmap_atomic-code-fix.patch
bitops-avoid-clang-shift-count-overflow-warnings.patch
ubsan-fix-gcc-10-warnings.patch
arm64-add-support-for-folded-p4d-page-tables-fix.patch
