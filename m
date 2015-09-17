From: akpm@linux-foundation.org
Subject: + mm-make-optimistic-check-for-swapin-readahead-fix.patch added
 to -mm tree
Date: Thu, 17 Sep 2015 13:05:48 -0700
Message-ID: <55fb1d1c.G03ZFkWQHRaowugS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbbIQUFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 16:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, ebru.akagunduz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: avoid usage of uninitialized variable 'isolated'
has been added to the -mm tree.  Its filename is
     mm-make-optimistic-check-for-swapin-readahead-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-optimistic-check-for-swapin-readahead-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-optimistic-check-for-swapin-readahead-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: avoid usage of uninitialized variable 'isolated'

In file included from include/trace/events/huge_memory.h:7:0,
                 from mm/huge_memory.c:62:
include/linux/tracepoint.h:141:5: warning: `isolated' may be used uninitialized in this function [-Wmaybe-uninitialized]
     ((void(*)(proto))(it_func))(args); \
     ^
mm/huge_memory.c:2327:6: note: `isolated' was declared here
  int isolated, result = 0;

We make use of isolated in error path before it get initialized.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix
+++ a/mm/huge_memory.c
@@ -2595,7 +2595,7 @@ static void collapse_huge_page(struct mm
 	pgtable_t pgtable;
 	struct page *new_page;
 	spinlock_t *pmd_ptl, *pte_ptl;
-	int isolated, result = 0;
+	int isolated = 0, result = 0;
 	unsigned long hstart, hend;
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

