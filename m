From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-correct-return-value-of-migrate_pages.patch removed from -mm tree
Date: Mon, 16 Jul 2012 13:14:00 -0700
Message-ID: <20120716201400.74912100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:64013 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2GPUOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 16:14:01 -0400
Received: by ghbz15 with SMTP id z15so594028ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 13:14:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, cl@linux.com, mel@csn.ul.ie, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: correct return value of migrate_pages()
has been removed from the -mm tree.  Its filename was
     mm-correct-return-value-of-migrate_pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm: correct return value of migrate_pages()

migrate_pages() should return number of pages not migrated or error code.
When unmap_and_move return -EAGAIN, outer loop is re-execution without
initialising nr_failed. This makes nr_failed over-counted.

So this patch correct it by initialising nr_failed in outer loop.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
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

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch

