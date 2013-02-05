From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:21 -0800
Message-ID: <20130205202021.A76FC5A406B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39790 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3BEUUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:23 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so65867qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zlu@tilera.com, cmetcalf@tilera.com, dhillf@gmail.com, mhocko@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: set PTE as huge in hugetlb_change_protection and remove_migration_pte
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Lu <zlu@tilera.com>
Subject: mm/hugetlb: set PTE as huge in hugetlb_change_protection and remove_migration_pte

When setting a huge PTE, besides calling pte_mkhuge(), we also need to
call arch_make_huge_pte(), which we indeed do in make_huge_pte(), but we
forget to do in hugetlb_change_protection() and remove_migration_pte().

Signed-off-by: Zhigang Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 mm/migrate.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte
+++ a/mm/hugetlb.c
@@ -3033,6 +3033,7 @@ unsigned long hugetlb_change_protection(
 		if (!huge_pte_none(huge_ptep_get(ptep))) {
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
 			pte = pte_mkhuge(pte_modify(pte, newprot));
+			pte = arch_make_huge_pte(pte, vma, NULL, 0);
 			set_huge_pte_at(mm, address, ptep, pte);
 			pages++;
 		}
diff -puN mm/migrate.c~mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte mm/migrate.c
--- a/mm/migrate.c~mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte
+++ a/mm/migrate.c
@@ -160,8 +160,10 @@ static int remove_migration_pte(struct p
 	if (is_write_migration_entry(entry))
 		pte = pte_mkwrite(pte);
 #ifdef CONFIG_HUGETLB_PAGE
-	if (PageHuge(new))
+	if (PageHuge(new)) {
 		pte = pte_mkhuge(pte);
+		pte = arch_make_huge_pte(pte, vma, new, 0);
+	}
 #endif
 	flush_cache_page(vma, addr, pte_pfn(pte));
 	set_pte_at(mm, addr, ptep, pte);
_

Patches currently in -mm which might be from zlu@tilera.com are

origin.patch

