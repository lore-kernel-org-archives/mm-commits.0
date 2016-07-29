From: akpm@linux-foundation.org
Subject: [merged] mm-zsmalloc-use-helper-to-clear-page-flags-bit.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:56:24 -0700
Message-ID: <579ba6d8.nQLd75SBsPul+jos%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbcG2S4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: use helper to clear page->flags bit
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-use-helper-to-clear-page-flags-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: use helper to clear page->flags bit

Use ClearPagePrivate/ClearPagePrivate2 helpers to clear
PG_private/PG_private_2 in page->flags

Link: http://lkml.kernel.org/r/1467882338-4300-7-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-use-helper-to-clear-page-flags-bit mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-use-helper-to-clear-page-flags-bit
+++ a/mm/zsmalloc.c
@@ -937,8 +937,8 @@ static void unpin_tag(unsigned long hand
 static void reset_page(struct page *page)
 {
 	__ClearPageMovable(page);
-	clear_bit(PG_private, &page->flags);
-	clear_bit(PG_private_2, &page->flags);
+	ClearPagePrivate(page);
+	ClearPagePrivate2(page);
 	set_page_private(page, 0);
 	page_mapcount_reset(page);
 	ClearPageHugeObject(page);
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-zsmalloc-add-per-class-compact-trace-event.patch

