From: akpm@linux-foundation.org
Subject: + mm-rename-and-move-get-set_freepage_migratetype-v2.patch added
 to -mm tree
Date: Wed, 22 Jul 2015 16:12:04 -0700
Message-ID: <55b02344.JPbnfjbe6yC8A56Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbbGVXMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 19:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-and-move-get-set_freepage_migratetype-v2
has been added to the -mm tree.  Its filename is
     mm-rename-and-move-get-set_freepage_migratetype-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-and-move-get-set_freepage_migratetype-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-and-move-get-set_freepage_migratetype-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-rename-and-move-get-set_freepage_migratetype-v2

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-rename-and-move-get-set_freepage_migratetype-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-and-move-get-set_freepage_migratetype-v2
+++ a/mm/page_alloc.c
@@ -974,7 +974,6 @@ static void __free_pages_ok(struct page
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	set_pcppage_migratetype(page, migratetype);
 	free_one_page(page_zone(page), page, pfn, order, migratetype);
 	local_irq_restore(flags);
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
mm-gup-add-mm_lock_present.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v4.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-rename-and-move-get-set_freepage_migratetype-v2.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch
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

