From: akpm@linux-foundation.org
Subject: + mm-add-page_check_address_transhuge-helper-fix-fix.patch added
 to -mm tree
Date: Mon, 30 Nov 2015 14:20:21 -0800
Message-ID: <565ccba5.jjfHq4CJp6I9/8ey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbK3WUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 17:20:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, sergey.senozhatsky.work@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-page_check_address_transhuge-helper-fix-fix
has been added to the -mm tree.  Its filename is
     mm-add-page_check_address_transhuge-helper-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-page_check_address_transhuge-helper-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-page_check_address_transhuge-helper-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
thp-reintroduce-split_huge_page-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
mm-add-page_check_address_transhuge-helper-fix-fix.patch

