From: akpm@linux-foundation.org
Subject: [merged] memcg-stop-warning-on-memcg_propagate_kmem.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:31 -0800
Message-ID: <20130225205531.BA92D31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:54857 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759787Ab3BYUzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:32 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so348671yhr.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, glommer@parallels.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: stop warning on memcg_propagate_kmem
has been removed from the -mm tree.  Its filename was
     memcg-stop-warning-on-memcg_propagate_kmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: stop warning on memcg_propagate_kmem

Whilst I run the risk of a flogging for disloyalty to the Lord of Sealand,
I do have CONFIG_MEMCG=y CONFIG_MEMCG_KMEM not set, and grow tired of the
"mm/memcontrol.c:4972:12: warning: `memcg_propagate_kmem' defined but not
used [-Wunused-function]" seen in 3.8-rc: move the #ifdef outwards.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-stop-warning-on-memcg_propagate_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-stop-warning-on-memcg_propagate_kmem
+++ a/mm/memcontrol.c
@@ -5025,6 +5025,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 {
 	int ret = 0;
@@ -5033,7 +5034,6 @@ static int memcg_propagate_kmem(struct m
 		goto out;
 
 	memcg->kmem_account_flags = parent->kmem_account_flags;
-#ifdef CONFIG_MEMCG_KMEM
 	/*
 	 * When that happen, we need to disable the static branch only on those
 	 * memcgs that enabled it. To achieve this, we would be forced to
@@ -5059,10 +5059,10 @@ static int memcg_propagate_kmem(struct m
 	mutex_lock(&set_limit_mutex);
 	ret = memcg_update_cache_sizes(memcg);
 	mutex_unlock(&set_limit_mutex);
-#endif
 out:
 	return ret;
 }
+#endif /* CONFIG_MEMCG_KMEM */
 
 /*
  * The user of this function is...
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

