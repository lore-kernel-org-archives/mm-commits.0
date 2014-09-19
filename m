From: akpm@linux-foundation.org
Subject: + zsmalloc-simplify-init_zspage-free-obj-linking.patch added to
 -mm tree
Date: Fri, 19 Sep 2014 15:57:45 -0700
Message-ID: <541cb4e9.xKSe+mWmYxajSYdf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaISW5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 18:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: simplify init_zspage free obj linking
has been added to the -mm tree.  Its filename is
     zsmalloc-simplify-init_zspage-free-obj-linking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-simplify-init_zspage-free-obj-linking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-simplify-init_zspage-free-obj-linking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zsmalloc: simplify init_zspage free obj linking

Change zsmalloc init_zspage() logic to iterate through each object on each
of its pages, checking the offset to verify the object is on the current
page before linking it into the zspage.

The current zsmalloc init_zspage free object linking code has logic that
relies on there only being one page per zspage when PAGE_SIZE is a
multiple of class->size.  It calculates the number of objects for the
current page, and iterates through all of them plus one, to account for
the assumed partial object at the end of the page.  While this currently
works, the logic can be simplified to just link the object at each
successive offset until the offset is larger than PAGE_SIZE, which does
not rely on PAGE_SIZE being a multiple of class->size.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-simplify-init_zspage-free-obj-linking mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-simplify-init_zspage-free-obj-linking
+++ a/mm/zsmalloc.c
@@ -628,7 +628,7 @@ static void init_zspage(struct page *fir
 	while (page) {
 		struct page *next_page;
 		struct link_free *link;
-		unsigned int i, objs_on_page;
+		unsigned int i = 1;
 
 		/*
 		 * page->index stores offset of first object starting
@@ -641,14 +641,10 @@ static void init_zspage(struct page *fir
 
 		link = (struct link_free *)kmap_atomic(page) +
 						off / sizeof(*link);
-		objs_on_page = (PAGE_SIZE - off) / class->size;
 
-		for (i = 1; i <= objs_on_page; i++) {
-			off += class->size;
-			if (off < PAGE_SIZE) {
-				link->next = obj_location_to_handle(page, i);
-				link += class->size / sizeof(*link);
-			}
+		while ((off += class->size) < PAGE_SIZE) {
+			link->next = obj_location_to_handle(page, i++);
+			link += class->size / sizeof(*link);
 		}
 
 		/*
@@ -660,7 +656,7 @@ static void init_zspage(struct page *fir
 		link->next = obj_location_to_handle(next_page, 0);
 		kunmap_atomic(link);
 		page = next_page;
-		off = (off + class->size) % PAGE_SIZE;
+		off %= PAGE_SIZE;
 	}
 }
 
_

Patches currently in -mm which might be from ddstreet@ieee.org are

zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
zsmalloc-simplify-init_zspage-free-obj-linking.patch
linux-next.patch

