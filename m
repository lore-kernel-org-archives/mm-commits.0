From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch removed from -mm tree
Date: Thu, 17 Mar 2016 13:58:03 -0700
Message-ID: <56eb1a5b.BKvuO2mTqLEkhdQD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbcCQU6E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:58:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dan.j.williams@intel.com, js1304@gmail.com, vbabka@suse.cz, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crypto/async_pq: use __free_page() instead of put_page()
has been removed from the -mm tree.  Its filename was
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch

This patch was dropped because it was folded into mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: crypto/async_pq: use __free_page() instead of put_page()

The addition of tracepoints to the page reference tracking had an
unfortunate side-effect in at least one driver that calls put_page from
its exit function, resulting in a link error:

`.exit.text' referenced in section `__jump_table' of crypto/built-in.o: defined in discarded section `.exit.text' of crypto/built-in.o

From a cursory look at that this driver, it seems that it may be
doing the wrong thing here anyway, as the page gets allocated
using 'alloc_page()', and should be freed using '__free_page()'
rather than 'put_page()'.

With this patch, I no longer get any other build errors from the page_ref
patch, so hopefully we can assume that it's always wrong to call any of
those functions from __exit code, and that no other driver does it.

Fixes: 0f80830dd044 ("mm/page_ref: add tracepoint to track down page reference manipulation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/async_pq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN crypto/async_tx/async_pq.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2 crypto/async_tx/async_pq.c
--- a/crypto/async_tx/async_pq.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2
+++ a/crypto/async_tx/async_pq.c
@@ -444,7 +444,7 @@ static int __init async_pq_init(void)
 
 static void __exit async_pq_exit(void)
 {
-	put_page(pq_scribble_page);
+	__free_page(pq_scribble_page);
 }
 
 module_init(async_pq_init);
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

