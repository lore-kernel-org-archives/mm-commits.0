From: akpm@linux-foundation.org
Subject: [to-be-updated] zsmalloc-remove-page_mapcount_reset.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:14:00 -0700
Message-ID: <57042a98.DLmKYIUHR5dYUTLq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977AbcDEVOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:14:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove page_mapcount_reset
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-page_mapcount_reset.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: remove page_mapcount_reset

We don't use page->_mapcount any more so no need to reset.

Signed-off-by: Minchan Kim <minchan@kernel.org>Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Russ Knize <rknize@motorola.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: YiPing Xu <xuyiping@hisilicon.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-page_mapcount_reset mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-page_mapcount_reset
+++ a/mm/zsmalloc.c
@@ -922,7 +922,6 @@ static void reset_page(struct page *page
 	set_page_private(page, 0);
 	page->mapping = NULL;
 	page->freelist = NULL;
-	page_mapcount_reset(page);
 }
 
 static void free_zspage(struct page *first_page)
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zsmalloc-squeeze-freelist-into-page-mapping.patch
zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

