From: akpm@linux-foundation.org
Subject: [patch 100/102] kasan: print page description after stacks
Date: Wed, 03 May 2017 14:56:44 -0700
Message-ID: <20170503215644.BzvKben__%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECV5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: print page description after stacks

Moves page description after the stacks since it's less important.

Link: http://lkml.kernel.org/r/20170302134851.101218-8-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/kasan/report.c~kasan-print-page-description-after-stacks mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-print-page-description-after-stacks
+++ a/mm/kasan/report.c
@@ -261,9 +261,6 @@ static void print_address_description(st
 	void *addr = (void *)info->access_addr;
 	struct page *page = addr_to_page(addr);
 
-	if (page)
-		dump_page(page, "kasan: bad access detected");
