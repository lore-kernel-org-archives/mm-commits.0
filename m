From: akpm@linux-foundation.org
Subject: +
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch added to -mm tree
Date: Tue, 01 Mar 2016 11:14:05 -0800
Message-ID: <56d5e9fd.rDV2KaeHxOTprNyE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbcCATOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 14:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dan.j.williams@intel.com, js1304@gmail.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crypto/async_pq: use __free_page() instead of put_page()
has been added to the -mm tree.  Its filename is
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-compaction-introduce-kcompactd-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch
profile-hide-unused-functions-when-config_proc_fs.patch
staging-goldfish-use-6-arg-get_user_pages.patch

