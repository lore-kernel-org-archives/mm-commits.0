From: akpm@linux-foundation.org
Subject: + mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix.patch added to -mm tree
Date: Mon, 15 Apr 2013 13:42:37 -0700
Message-ID: <20130415204237.648AB5A4266@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:44062 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3DOUmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 16:42:38 -0400
Received: by mail-qe0-f73.google.com with SMTP id 1so507698qee.4
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 13:42:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org


The patch titled
     Subject: mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix
has been added to the -mm tree.  Its filename is
     mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix

document split_huge_page_to_list

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/huge_memory.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix
+++ a/mm/huge_memory.c
@@ -1800,6 +1800,13 @@ static void __split_huge_page(struct pag
 	BUG_ON(mapcount != mapcount2);
 }
 
+/*
+ * Split a hugepage into normal pages. This doesn't change the position of head
+ * page. If @list is null, tail pages will be added to LRU list, otherwise, to
+ * @list. Both head page and tail pages will inherit mapping, flags, and so on
+ * from the hugepage.
+ * Return 0 if the hugepage is split successfully otherwise return 1.
+ */
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct anon_vma *anon_vma;
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix.patch
kernel-smpc-cleanups.patch

