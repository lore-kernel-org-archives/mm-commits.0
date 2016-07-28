From: akpm@linux-foundation.org
Subject: [patch 070/101] mm/zsmalloc: use helper to clear page->flags bit
Date: Thu, 28 Jul 2016 15:48:00 -0700
Message-ID: <579a8ba0.k9n4ZoCHQAfh2gD8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcG1WsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz

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
