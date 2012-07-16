From: akpm@linux-foundation.org
Subject: + mm-correct-return-value-of-migrate_pages.patch added to -mm tree
Date: Mon, 16 Jul 2012 13:12:25 -0700
Message-ID: <20120716201225.A4BA71E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:34930 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2GPUM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 16:12:26 -0400
Received: by yenl3 with SMTP id l3so594296yen.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 13:12:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, cl@linux.com, mel@csn.ul.ie, mina86@mina86.com


The patch titled
     Subject: mm: correct return value of migrate_pages()
has been added to the -mm tree.  Its filename is
     mm-correct-return-value-of-migrate_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm: correct return value of migrate_pages()

migrate_pages() should return number of pages not migrated or error code.
When unmap_and_move return -EAGAIN, outer loop is re-execution without
initialising nr_failed. This makes nr_failed over-counted.

So this patch correct it by initialising nr_failed in outer loop.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/migrate.c~mm-correct-return-value-of-migrate_pages mm/migrate.c
--- a/mm/migrate.c~mm-correct-return-value-of-migrate_pages
+++ a/mm/migrate.c
@@ -1069,6 +1069,7 @@ int migrate_pages(struct list_head *from
 
 	for(pass = 0; pass < 10 && retry; pass++) {
 		retry = 0;
+		nr_failed = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
 			cond_resched();
_
Subject: Subject: mm: correct return value of migrate_pages()

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-correct-return-value-of-migrate_pages.patch

