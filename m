From: akpm@linux-foundation.org
Subject: + mm-hwpoison-inject-fix-refcounting-in-no-injection-case.patch
 added to -mm tree
Date: Wed, 22 Apr 2015 16:01:22 -0700
Message-ID: <55382842.g+vriJ1rPzYFiDaz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbDVXBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 19:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, dnelson@redhat.com, seto.hidetoshi@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison-inject: fix refcounting in no-injection case
has been added to the -mm tree.  Its filename is
     mm-hwpoison-inject-fix-refcounting-in-no-injection-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-inject-fix-refcounting-in-no-injection-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-inject-fix-refcounting-in-no-injection-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hwpoison-inject: fix refcounting in no-injection case

Hwpoison injection via debugfs:hwpoison/corrupt-pfn takes a refcount of
the target page.  But current code doesn't release it if the target page
is not supposed to be injected, which results in memory leak.  This patch
simply adds the refcount releasing code.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Dean Nelson <dnelson@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/hwpoison-inject.c~mm-hwpoison-inject-fix-refcounting-in-no-injection-case mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-hwpoison-inject-fix-refcounting-in-no-injection-case
+++ a/mm/hwpoison-inject.c
@@ -40,7 +40,7 @@ static int hwpoison_inject(void *data, u
 	 * This implies unable to support non-LRU pages.
 	 */
 	if (!PageLRU(p) && !PageHuge(p))
-		return 0;
+		goto put_out;
 
 	/*
 	 * do a racy check with elevated page count, to make sure PG_hwpoison
@@ -52,11 +52,14 @@ static int hwpoison_inject(void *data, u
 	err = hwpoison_filter(hpage);
 	unlock_page(hpage);
 	if (err)
-		return 0;
+		goto put_out;
 
 inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
 	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
+put_out:
+	put_page(hpage);
+	return 0;
 }
 
 static int hwpoison_unpoison(void *data, u64 val)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-memory-failure-call-shake_page-when-error-hits-thp-tail-page.patch
mm-soft-offline-fix-num_poisoned_pages-counting-on-concurrent-events.patch
mm-hwpoison-inject-fix-refcounting-in-no-injection-case.patch
mm-hwpoison-inject-check-pagelru-of-hpage.patch
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
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
do_shared_fault-check-that-mmap_sem-is-held.patch

