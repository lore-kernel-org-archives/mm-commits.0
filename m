From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix-2.patch removed from -mm tree
Date: Fri, 27 May 2016 13:00:36 -0700
Message-ID: <5748a764.7qZf6V8P4yvNrUF4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbcE0UAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, iamjoonsoo.kim@lge.com, sfr@canb.auug.org.au, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix build problems from lookup_page_ext
has been removed from the -mm tree.  Its filename was
     mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix-2.patch

This patch was dropped because it was folded into mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: fix build problems from lookup_page_ext

A patch for lookup_page_ext introduced several build errors and
warnings, e.g.

mm/page_owner.c: In function '__set_page_owner':
mm/page_owner.c:71:2: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
include/linux/page_idle.h: In function 'set_page_young':
include/linux/page_idle.h:62:3: error: expected ')' before 'return'

This fixes all of them. Please fold into the original patch.

Fixes: 38c4fffbad3c ("mm: check the return value of lookup_page_ext for all call sites")
Link: http://lkml.kernel.org/r/6285269.2CksypHdYp@wuerfel
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/page_owner.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix-2 mm/page_owner.c
--- a/mm/page_owner.c~mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix-2
+++ a/mm/page_owner.c
@@ -65,9 +65,6 @@ void __set_page_owner(struct page *page,
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
 
-	if (unlikely(!page_ext))
-		return;
-
 	struct stack_trace trace = {
 		.nr_entries = 0,
 		.max_entries = ARRAY_SIZE(page_ext->trace_entries),
@@ -75,6 +72,9 @@ void __set_page_owner(struct page *page,
 		.skip = 3,
 	};
 
+	if (unlikely(!page_ext))
+		return;
+
 	save_stack_trace(&trace);
 
 	page_ext->order = order;
@@ -111,12 +111,11 @@ void __copy_page_owner(struct page *oldp
 {
 	struct page_ext *old_ext = lookup_page_ext(oldpage);
 	struct page_ext *new_ext = lookup_page_ext(newpage);
+	int i;
 
 	if (unlikely(!old_ext || !new_ext))
 		return;
 
-	int i;
-
 	new_ext->order = old_ext->order;
 	new_ext->gfp_mask = old_ext->gfp_mask;
 	new_ext->nr_entries = old_ext->nr_entries;
@@ -204,11 +203,6 @@ err:
 void __dump_page_owner(struct page *page)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext)) {
-		pr_alert("There is not page extension available.\n");
-		return;
-	}
