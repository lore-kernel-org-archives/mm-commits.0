From: akpm@linux-foundation.org
Subject: + mmhwpoison-rework-soft-offline-for-free-pages-fix.patch
 added to -mm tree
Date: Fri, 26 Jun 2020 20:49:00 -0700
Message-ID: <20200627034900.5ecAz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgF0DtB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, osalvador@suse.de, rdunlap@infradead.org


The patch titled
     Subject: mm: memory-failure: add stub for page_handle_poison()
has been added to the -mm tree.  Its filename is
     mmhwpoison-rework-soft-offline-for-free-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-rework-soft-offline-for-free-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-rework-soft-offline-for-free-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: memory-failure: add stub for page_handle_poison()

Fix a build error when no HWPOISON kconfig symbols are set/enabled
by providing a stub function for 'page_handle_poison()'.

../mm/memory-failure.c: In function `__soft_offline_page':
../mm/memory-failure.c:1827:3: error: implicit declaration of function `page_handle_poison'; did you mean `page_init_poison'? [-Werror=implicit-function-declaration]
   page_handle_poison(page, false, true);

Link: http://lkml.kernel.org/r/5bc95fd0-4c21-59c3-4629-7b6848b6a399@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memory-failure.c~mmhwpoison-rework-soft-offline-for-free-pages-fix
+++ a/mm/memory-failure.c
@@ -175,6 +175,11 @@ int hwpoison_filter(struct page *p)
 {
 	return 0;
 }
+
+static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
+{
+	return true;
+}
 #endif
 
 EXPORT_SYMBOL_GPL(hwpoison_filter);
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mmhwpoison-rework-soft-offline-for-free-pages-fix.patch
