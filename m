From: akpm@linux-foundation.org
Subject: [merged] mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:33 -0700
Message-ID: <20120531191433.5ECF4A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43242 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab2EaTOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:35 -0400
Received: by wgbdt11 with SMTP id dt11so76041wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: drop page_table_lock to uncharge memcg pages
has been removed from the -mm tree.  Its filename was
     mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: drop page_table_lock to uncharge memcg pages

mm->page_table_lock is hotly contested for page fault tests and isn't
necessary to do mem_cgroup_uncharge_page() in do_huge_pmd_wp_page().

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/huge_memory.c~mm-thp-drop-page_table_lock-to-uncharge-memcg-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-drop-page_table_lock-to-uncharge-memcg-pages
+++ a/mm/huge_memory.c
@@ -973,8 +973,10 @@ int do_huge_pmd_wp_page(struct mm_struct
 	spin_lock(&mm->page_table_lock);
 	put_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
+		spin_unlock(&mm->page_table_lock);
 		mem_cgroup_uncharge_page(new_page);
 		put_page(new_page);
+		goto out;
 	} else {
 		pmd_t entry;
 		VM_BUG_ON(!PageHead(page));
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
slab-move-full-state-transition-to-an-initcall.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch

