From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-page_check_address_transhuge-helper-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:44:35 -0800
Message-ID: <569824d3.YcDfvtoCurzrRa9G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbcANWog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, kirill@shutemov.name, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-page_check_address_transhuge-helper-fix
has been removed from the -mm tree.  Its filename was
     mm-add-page_check_address_transhuge-helper-fix.patch

This patch was dropped because it was folded into mm-add-page_check_address_transhuge-helper.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm-add-page_check_address_transhuge-helper-fix

mm/built-in.o: In function `page_referenced_one':
rmap.c:(.text+0x32070): undefined reference to `pmdp_clear_flush_young'

Tested-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   11 +++++++++++
 mm/rmap.c            |    2 ++
 2 files changed, 13 insertions(+)

diff -puN include/linux/rmap.h~mm-add-page_check_address_transhuge-helper-fix include/linux/rmap.h
--- a/include/linux/rmap.h~mm-add-page_check_address_transhuge-helper-fix
+++ a/include/linux/rmap.h
@@ -219,9 +219,20 @@ static inline pte_t *page_check_address(
  * Used by idle page tracking to check if a page was referenced via page
  * tables.
  */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool page_check_address_transhuge(struct page *page, struct mm_struct *mm,
 				  unsigned long address, pmd_t **pmdp,
 				  pte_t **ptep, spinlock_t **ptlp);
+#else
+static inline bool page_check_address_transhuge(struct page *page,
+				struct mm_struct *mm, unsigned long address,
+				pmd_t **pmdp, pte_t **ptep, spinlock_t **ptlp)
+{
+	*ptep = page_check_address(page, mm, address, ptlp, 0);
+	*pmdp = NULL;
+	return !!*ptep;
+}
+#endif
 
 /*
  * Used by swapoff to help locate where page is expected in vma.
diff -puN mm/rmap.c~mm-add-page_check_address_transhuge-helper-fix mm/rmap.c
--- a/mm/rmap.c~mm-add-page_check_address_transhuge-helper-fix
+++ a/mm/rmap.c
@@ -798,6 +798,7 @@ int page_mapped_in_vma(struct page *page
 	return 1;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * Check that @page is mapped at @address into @mm. In contrast to
  * page_check_address(), this function can handle transparent huge pages.
@@ -885,6 +886,7 @@ found:
 	*ptlp = ptl;
 	return true;
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 struct page_referenced_arg {
 	int mapcount;
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch

