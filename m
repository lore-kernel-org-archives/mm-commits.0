From: akpm@linux-foundation.org
Subject: + mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte.patch added to -mm tree
Date: Wed, 23 Jan 2013 12:31:32 -0800
Message-ID: <20130123203132.BF1BB5A4102@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:52906 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3AWUbd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 15:31:33 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so532904ggn.4
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 12:31:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zlu@tilera.com, cmetcalf@tilera.com, dhillf@gmail.com, mhocko@suse.cz, stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: set PTE as huge in hugetlb_change_protection and remove_migration_pte
has been added to the -mm tree.  Its filename is
     mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-set-pte-as-huge-in-hugetlb_change_protection-and-remove_migration_pte.patch

