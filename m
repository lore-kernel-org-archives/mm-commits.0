From: akpm@linux-foundation.org
Subject: [merged] kasan-print-page-description-after-stacks.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:14:16 -0700
Message-ID: <20170504191416.3vkNU6kpj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52242 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756518AbdEDTOS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:14:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: print page description after stacks
has been removed from the -mm tree.  Its filename was
     kasan-print-page-description-after-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
-
 	dump_stack();
 
 	if (page && PageSlab(page)) {
@@ -273,9 +270,14 @@ static void print_address_description(st
 		describe_object(cache, object, addr);
 	}
 
-	if (kernel_or_module_addr(addr)) {
-		if (!init_task_stack_addr(addr))
-			pr_err("Address belongs to variable %pS\n", addr);
+	if (kernel_or_module_addr(addr) && !init_task_stack_addr(addr)) {
+		pr_err("The buggy address belongs to the variable:\n");
+		pr_err(" %pS\n", addr);
+	}
+
+	if (page) {
+		pr_err("The buggy address belongs to the page:\n");
+		dump_page(page, "kasan: bad access detected");
 	}
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are


