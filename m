From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch added to -mm tree
Date: Tue, 11 Aug 2015 16:26:06 -0700
Message-ID: <55ca848e.aArJLgUgYxyvFEBP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbbHKX0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 19:26:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: introduce put_hwpoison_page to put refcount for memory error handling
has been added to the -mm tree.  Its filename is
     mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: introduce put_hwpoison_page to put refcount for memory error handling

Introduce put_hwpoison_page to put refcount for memory error handling.

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 +
 mm/memory-failure.c |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff -puN include/linux/mm.h~mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling include/linux/mm.h
--- a/include/linux/mm.h~mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling
+++ a/include/linux/mm.h
@@ -2146,6 +2146,7 @@ extern int memory_failure(unsigned long
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
 extern int get_hwpoison_page(struct page *page);
+extern void put_hwpoison_page(struct page *page);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
diff -puN mm/memory-failure.c~mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling
+++ a/mm/memory-failure.c
@@ -934,6 +934,27 @@ int get_hwpoison_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
+/**
+ * put_hwpoison_page() - Put refcount for memory error handling:
+ * @page:	raw error page (hit by memory error)
+ */
+void put_hwpoison_page(struct page *page)
+{
+	struct page *head = compound_head(page);
+
+	if (PageHuge(head)) {
+		put_page(head);
+		return;
+	}
+
+	if (PageTransHuge(head))
+		if (page != head)
+			put_page(head);
+
+	put_page(page);
+}
+EXPORT_SYMBOL_GPL(put_hwpoison_page);
+
 /*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
_

Patches currently in -mm which might be from wanpeng.li@hotmail.com are

mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch
mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch
mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch
mm-hwpoison-fix-pagehwpoison-test-set-race.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling-fix.patch
mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch

