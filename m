From: akpm@linux-foundation.org
Subject: + mm-add-page_check_address_transhuge-helper-fix.patch added to
 -mm tree
Date: Tue, 24 Nov 2015 14:34:24 -0800
Message-ID: <5654e5f0.uaEj1Y7+huehEkYK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbbKXWeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 17:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, kirill@shutemov.name, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-page_check_address_transhuge-helper-fix
has been added to the -mm tree.  Its filename is
     mm-add-page_check_address_transhuge-helper-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-page_check_address_transhuge-helper-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-page_check_address_transhuge-helper-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-fix-memoryhigh-target.patch
revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch
mm-add-page_check_address_transhuge-helper-fix.patch

