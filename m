From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch removed from -mm tree
Date: Wed, 11 Feb 2015 15:19:38 -0800
Message-ID: <54dbe38a.w4I/9sa8MS6RTaJU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbbBKXTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:19:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rogachevsergei@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_ext-remove-unnecessary-stack_trace-field-fix
has been removed from the -mm tree.  Its filename was
     mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch

This patch was dropped because it was folded into mm-page_ext-remove-unnecessary-stack_trace-field.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_ext-remove-unnecessary-stack_trace-field-fix

use struct initializers

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergei Rogachev <rogachevsergei@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field-fix mm/page_owner.c
--- a/mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field-fix
+++ a/mm/page_owner.c
@@ -59,15 +59,14 @@ void __reset_page_owner(struct page *pag
 
 void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
 {
-	struct page_ext *page_ext;
-	struct stack_trace trace;
+	struct page_ext *page_ext = lookup_page_ext(page);
+	struct stack_trace trace = {
+		.nr_entries = 0,
+		.max_entries = ARRAY_SIZE(page_ext->trace_entries),
+		.entries = &page_ext->trace_entries[0],
+		.skip = 3,
+	};
 
-	page_ext = lookup_page_ext(page);
-
-	trace.nr_entries = 0;
-	trace.max_entries = ARRAY_SIZE(page_ext->trace_entries);
-	trace.entries = &page_ext->trace_entries[0];
-	trace.skip = 3;
 	save_stack_trace(&trace);
 
 	page_ext->order = order;
@@ -83,8 +82,11 @@ print_page_owner(char __user *buf, size_
 {
 	int ret;
 	int pageblock_mt, page_mt;
-	struct stack_trace trace;
 	char *kbuf;
+	struct stack_trace trace = {
+		.nr_entries = page_ext->nr_entries,
+		.entries = &page_ext->trace_entries[0],
+	};
 
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -122,9 +124,6 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	trace.nr_entries = page_ext->nr_entries;
-	trace.entries = &page_ext->trace_entries[0];
