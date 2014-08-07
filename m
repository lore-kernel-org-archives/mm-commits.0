From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch removed from -mm tree
Date: Thu, 07 Aug 2014 15:37:06 -0700
Message-ID: <53e3ff92.tNLNCFY3DKC1EFCZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:37785 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaHGWhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 18:37:08 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so27788igd.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 15:37:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use page lists for uncharge batching fix - hugetlb page->lru
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch

This patch was dropped because it was folded into mm-memcontrol-use-page-lists-for-uncharge-batching.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use page lists for uncharge batching fix - hugetlb page->lru

Naoya-san reports that page->lru of hugetlb pages gets corrupted when they
hit the uncharge path from put_page().

Add a preliminary check for whether the page is even a valid memcg page
before messing with it's ->lru list.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru
+++ a/mm/memcontrol.c
@@ -6583,9 +6583,16 @@ static void uncharge_list(struct list_he
  */
 void mem_cgroup_uncharge(struct page *page)
 {
+	struct page_cgroup *pc;
+
 	if (mem_cgroup_disabled())
 		return;
 
+	/* Don't touch page->lru of any random page, pre-check: */
+	pc = lookup_page_cgroup(page);
+	if (!PageCgroupUsed(pc))
+		return;
+
 	INIT_LIST_HEAD(&page->lru);
 	uncharge_list(&page->lru);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

