From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-page_check_address_transhuge-helper-fix-fix.patch removed from -mm
 tree
Date: Thu, 14 Jan 2016 14:44:38 -0800
Message-ID: <569824d6.OrHfbAlNpqGN+qn/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbcANWoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:44:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, sergey.senozhatsky.work@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-page_check_address_transhuge-helper-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-add-page_check_address_transhuge-helper-fix-fix.patch

This patch was dropped because it was folded into mm-add-page_check_address_transhuge-helper.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-add-page_check_address_transhuge-helper-fix-fix

mm/built-in.o: In function `page_referenced_one':
rmap.c:(.text+0x32070): undefined reference to `pmdp_clear_flush_young'

Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    6 +++++-
 mm/rmap.c      |    5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/page_idle.c~mm-add-page_check_address_transhuge-helper-fix-fix mm/page_idle.c
--- a/mm/page_idle.c~mm-add-page_check_address_transhuge-helper-fix-fix
+++ a/mm/page_idle.c
@@ -66,8 +66,12 @@ static int page_idle_clear_pte_refs_one(
 	if (pte) {
 		referenced = ptep_clear_young_notify(vma, addr, pte);
 		pte_unmap(pte);
-	} else
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		referenced = pmdp_clear_young_notify(vma, addr, pmd);
+	} else {
+		/* unexpected pmd-mapped page? */
+		WARN_ON_ONCE(1);
+	}
 
 	spin_unlock(ptl);
 
diff -puN mm/rmap.c~mm-add-page_check_address_transhuge-helper-fix-fix mm/rmap.c
--- a/mm/rmap.c~mm-add-page_check_address_transhuge-helper-fix-fix
+++ a/mm/rmap.c
@@ -931,9 +931,12 @@ static int page_referenced_one(struct pa
 				referenced++;
 		}
 		pte_unmap(pte);
-	} else {
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
+	} else {
+		/* unexpected pmd-mapped page? */
+		WARN_ON_ONCE(1);
 	}
 	spin_unlock(ptl);
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-add-page_check_address_transhuge-helper.patch

