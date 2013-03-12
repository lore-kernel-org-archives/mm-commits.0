From: akpm@linux-foundation.org
Subject: + mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:43:42 -0700
Message-ID: <20130312214342.C6E8331C230@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:39602 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551Ab3CLVno (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:43:44 -0400
Received: by mail-vc0-f201.google.com with SMTP id n11so40256vch.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:43:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, amwang@redhat.com, arnd@arndb.de, david.daney@cavium.com, jiang.liu@huawei.com, ralf@linux-mips.org


The patch titled
     Subject: mm/MIPS: use free_highmem_page() to free highmem pages into buddy system
has been added to the -mm tree.  Its filename is
     mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

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
Subject: mm/MIPS: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/mips/mm/init.c~mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/mips/mm/init.c
@@ -393,12 +393,8 @@ void __init mem_init(void)
 			SetPageReserved(page);
 			continue;
 		}
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-		totalhigh_pages++;
+		free_highmem_page(page);
 	}
-	totalram_pages += totalhigh_pages;
 	num_physpages += totalhigh_pages;
 #endif
 
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

