From: akpm@linux-foundation.org
Subject: + mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:43:50 -0700
Message-ID: <20130312214350.E6CFB5A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55070 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619Ab3CLVnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:43:52 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so40320yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:43:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, amwang@redhat.com, attilio.rao@citrix.com, hpa@zytor.com, jiang.liu@huawei.com, konrad.wilk@oracle.com, mingo@redhat.com, penberg@kernel.org, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     Subject: mm/x86: use free_highmem_page() to free highmem pages into buddy system
has been added to the -mm tree.  Its filename is
     mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/x86: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Attilio Rao <attilio.rao@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/highmem_32.c |    1 -
 arch/x86/mm/init_32.c    |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/x86/mm/highmem_32.c~mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/x86/mm/highmem_32.c
@@ -137,5 +137,4 @@ void __init set_highmem_pages_init(void)
 		add_highpages_with_active_regions(nid, zone_start_pfn,
 				 zone_end_pfn);
 	}
-	totalram_pages += totalhigh_pages;
 }
diff -puN arch/x86/mm/init_32.c~mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/x86/mm/init_32.c
@@ -427,14 +427,6 @@ static void __init permanent_kmaps_init(
 	pkmap_page_table = pte;
 }
 
-static void __init add_one_highpage_init(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalhigh_pages++;
-}
-
 void __init add_highpages_with_active_regions(int nid,
 			 unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -448,7 +440,7 @@ void __init add_highpages_with_active_re
 					      start_pfn, end_pfn);
 		for ( ; pfn < e_pfn; pfn++)
 			if (pfn_valid(pfn))
-				add_one_highpage_init(pfn_to_page(pfn));
+				free_highmem_page(pfn_to_page(pfn));
 	}
 }
 #else
_

Patches currently in -mm which might be from liuj97@gmail.com are

mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-alpha-use-common-help-functions-to-free-reserved-pages.patch
mm-arm-use-common-help-functions-to-free-reserved-pages.patch
mm-avr32-use-common-help-functions-to-free-reserved-pages.patch
mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch
mm-c6x-use-common-help-functions-to-free-reserved-pages.patch
mm-cris-use-common-help-functions-to-free-reserved-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-h8300-use-common-help-functions-to-free-reserved-pages.patch
mm-ia64-use-common-help-functions-to-free-reserved-pages.patch
mm-m32r-use-common-help-functions-to-free-reserved-pages.patch
mm-m68k-use-common-help-functions-to-free-reserved-pages.patch
mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch
mm-mips-use-common-help-functions-to-free-reserved-pages.patch
mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch
mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch
mm-parisc-use-common-help-functions-to-free-reserved-pages.patch
mm-ppc-use-common-help-functions-to-free-reserved-pages.patch
mm-s390-use-common-help-functions-to-free-reserved-pages.patch
mm-score-use-common-help-functions-to-free-reserved-pages.patch
mm-sh-use-common-help-functions-to-free-reserved-pages.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch
mm-um-use-common-help-functions-to-free-reserved-pages.patch
mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch
mm-x86-use-common-help-functions-to-free-reserved-pages.patch
mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch
mm-arc-use-common-help-functions-to-free-reserved-pages.patch
mm-metag-use-common-help-functions-to-free-reserved-pages.patch
mmkexec-use-common-help-functions-to-free-reserved-pages.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-microblaze-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-ppc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-sparc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

