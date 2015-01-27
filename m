From: akpm@linux-foundation.org
Subject: + mm-page_ext-remove-unnecessary-stack_trace-field.patch added to -mm tree
Date: Tue, 27 Jan 2015 14:43:57 -0800
Message-ID: <54c814ad.OfFqZsO1ErGSuMRZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbbA0Wn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 17:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rogachevsergei@gmail.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: remove unnecessary stack_trace field
has been added to the -mm tree.  Its filename is
     mm-page_ext-remove-unnecessary-stack_trace-field.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ext-remove-unnecessary-stack_trace-field.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ext-remove-unnecessary-stack_trace-field.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Rogachev <rogachevsergei@gmail.com>
Subject: mm/page_owner.c: remove unnecessary stack_trace field

Page owner uses the page_ext structure to keep meta-information for every
page in the system.  The structure also contains a field of type 'struct
stack_trace', page owner uses this field during invocation of the function
save_stack_trace.  It is easy to notice that keeping a copy of this
structure for every page in the system is very inefficiently in terms of
memory.

The patch removes this unnecessary field of page_ext and forces page owner
to use a stack_trace structure allocated on the stack.

Signed-off-by: Sergei Rogachev <rogachevsergei@gmail.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    2 +-
 mm/page_owner.c          |   21 ++++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff -puN include/linux/page_ext.h~mm-page_ext-remove-unnecessary-stack_trace-field include/linux/page_ext.h
--- a/include/linux/page_ext.h~mm-page_ext-remove-unnecessary-stack_trace-field
+++ a/include/linux/page_ext.h
@@ -40,7 +40,7 @@ struct page_ext {
 #ifdef CONFIG_PAGE_OWNER
 	unsigned int order;
 	gfp_t gfp_mask;
-	struct stack_trace trace;
+	unsigned int nr_entries;
 	unsigned long trace_entries[8];
 #endif
 };
diff -puN mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field mm/page_owner.c
--- a/mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field
+++ a/mm/page_owner.c
@@ -60,19 +60,19 @@ void __reset_page_owner(struct page *pag
 void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
 {
 	struct page_ext *page_ext;
-	struct stack_trace *trace;
+	struct stack_trace trace;
 
 	page_ext = lookup_page_ext(page);
 
-	trace = &page_ext->trace;
-	trace->nr_entries = 0;
-	trace->max_entries = ARRAY_SIZE(page_ext->trace_entries);
-	trace->entries = &page_ext->trace_entries[0];
-	trace->skip = 3;
-	save_stack_trace(&page_ext->trace);
+	trace.nr_entries = 0;
+	trace.max_entries = ARRAY_SIZE(page_ext->trace_entries);
+	trace.entries = &page_ext->trace_entries[0];
+	trace.skip = 3;
+	save_stack_trace(&trace);
 
 	page_ext->order = order;
 	page_ext->gfp_mask = gfp_mask;
+	page_ext->nr_entries = trace.nr_entries;
 
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 }
@@ -83,6 +83,7 @@ print_page_owner(char __user *buf, size_
 {
 	int ret;
 	int pageblock_mt, page_mt;
+	struct stack_trace trace;
 	char *kbuf;
 
 	kbuf = kmalloc(count, GFP_KERNEL);
@@ -121,8 +122,10 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	ret += snprint_stack_trace(kbuf + ret, count - ret,
-					&page_ext->trace, 0);
+	trace.nr_entries = page_ext->nr_entries;
+	trace.entries = &page_ext->trace_entries[0];
+
+	ret += snprint_stack_trace(kbuf + ret, count - ret, &trace, 0);
 	if (ret >= count)
 		goto err;
 
_

Patches currently in -mm which might be from rogachevsergei@gmail.com are

mm-page_ext-remove-unnecessary-stack_trace-field.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch

