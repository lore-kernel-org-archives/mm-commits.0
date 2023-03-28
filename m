Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5A9C77B60
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjC1XVg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjC1XVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E021BFD
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C04CEB81EEC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A694C433EF;
        Tue, 28 Mar 2023 23:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045674;
        bh=/mtTrorO846HEUOlvKjAdrTzA6LKiuALaUggY0htLQQ=;
        h=Date:To:From:Subject:From;
        b=IfEqrLY/KGH0Wc6/hs1EgrpCbRFosHLWQiDwBvvze3/VgtjHOlPiNgOhI7+PKmPpU
         VJ3IAZVwnMQx7MmiAK1ETzn4JHSzC32AliHdomkwp4I4wjfzTDP1VuwF2/QEnlDPW8
         Td49PLgLb7eYO3yox14IxfwlDquAAH+ZUxDY8JL4=
Date:   Tue, 28 Mar 2023 16:21:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
        john.ogness@linutronix.de, joe@perches.com, david@redhat.com,
        andriy.shevchenko@linux.intel.com, 42.hyeyoo@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-printk-introduce-new-format-%pgt-for-page_type.patch removed from -mm tree
Message-Id: <20230328232114.7A694C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, printk: introduce new format %pGt for page_type
has been removed from the -mm tree.  Its filename was
     mm-printk-introduce-new-format-%pgt-for-page_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm, printk: introduce new format %pGt for page_type
Date: Mon, 30 Jan 2023 13:25:13 +0900

%pGp format is used to display 'flags' field of a struct page.  However,
some page flags (i.e.  PG_buddy, see page-flags.h for more details) are
stored in page_type field.  To display human-readable output of page_type,
introduce %pGt format.

It is important to note the meaning of bits are different in page_type. 
if page_type is 0xffffffff, no flags are set.  Setting PG_buddy
(0x00000080) flag results in a page_type of 0xffffff7f.  Clearing a bit
actually means setting a flag.  Bits in page_type are inverted when
displaying type names.

Only values for which page_type_has_type() returns true are considered as
page_type, to avoid confusion with mapcount values.  if it returns false,
only raw values are displayed and not page type names.

Link: https://lkml.kernel.org/r/20230130042514.2418-3-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>	[vsprintf part]
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/printk-formats.rst |   16 ++++++++----
 include/linux/page-flags.h                |    7 ++++-
 include/trace/events/mmflags.h            |    8 ++++++
 lib/test_printf.c                         |   26 ++++++++++++++++++++
 lib/vsprintf.c                            |   21 ++++++++++++++++
 mm/debug.c                                |    5 +++
 mm/internal.h                             |    1 
 7 files changed, 78 insertions(+), 6 deletions(-)

--- a/Documentation/core-api/printk-formats.rst~mm-printk-introduce-new-format-%pgt-for-page_type
+++ a/Documentation/core-api/printk-formats.rst
@@ -575,20 +575,26 @@ The field width is passed by value, the
 Helper macros cpumask_pr_args() and nodemask_pr_args() are available to ease
 printing cpumask and nodemask.
 
-Flags bitfields such as page flags, gfp_flags
----------------------------------------------
+Flags bitfields such as page flags, page_type, gfp_flags
+--------------------------------------------------------
 
 ::
 
 	%pGp	0x17ffffc0002036(referenced|uptodate|lru|active|private|node=0|zone=2|lastcpupid=0x1fffff)
+	%pGt	0xffffff7f(buddy)
 	%pGg	GFP_USER|GFP_DMA32|GFP_NOWARN
 	%pGv	read|exec|mayread|maywrite|mayexec|denywrite
 
 For printing flags bitfields as a collection of symbolic constants that
 would construct the value. The type of flags is given by the third
-character. Currently supported are [p]age flags, [v]ma_flags (both
-expect ``unsigned long *``) and [g]fp_flags (expects ``gfp_t *``). The flag
-names and print order depends on the particular	type.
+character. Currently supported are:
+
+        - p - [p]age flags, expects value of type (``unsigned long *``)
+        - t - page [t]ype, expects value of type (``unsigned int *``)
+        - v - [v]ma_flags, expects value of type (``unsigned long *``)
+        - g - [g]fp_flags, expects value of type (``gfp_t *``)
+
+The flag names and print order depends on the particular type.
 
 Note that this format should not be used directly in the
 :c:func:`TP_printk()` part of a tracepoint. Instead, use the show_*_flags()
--- a/include/linux/page-flags.h~mm-printk-introduce-new-format-%pgt-for-page_type
+++ a/include/linux/page-flags.h
@@ -926,9 +926,14 @@ static inline bool is_page_hwpoison(stru
 #define PageType(page, flag)						\
 	((page->page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
 
+static inline int page_type_has_type(unsigned int page_type)
+{
+	return (int)page_type < PAGE_MAPCOUNT_RESERVE;
+}
+
 static inline int page_has_type(struct page *page)
 {
-	return (int)page->page_type < PAGE_MAPCOUNT_RESERVE;
+	return page_type_has_type(page->page_type);
 }
 
 #define PAGE_TYPE_OPS(uname, lname)					\
--- a/include/trace/events/mmflags.h~mm-printk-introduce-new-format-%pgt-for-page_type
+++ a/include/trace/events/mmflags.h
@@ -141,6 +141,14 @@ IF_HAVE_PG_SKIP_KASAN_POISON(skip_kasan_
 	__def_pageflag_names						\
 	) : "none"
 
+#define DEF_PAGETYPE_NAME(_name) { PG_##_name, __stringify(_name) }
+
+#define __def_pagetype_names						\
+	DEF_PAGETYPE_NAME(offline),					\
+	DEF_PAGETYPE_NAME(guard),					\
+	DEF_PAGETYPE_NAME(table),					\
+	DEF_PAGETYPE_NAME(buddy)
+
 #if defined(CONFIG_X86)
 #define __VM_ARCH_SPECIFIC_1 {VM_PAT,     "pat"           }
 #elif defined(CONFIG_PPC)
--- a/lib/test_printf.c~mm-printk-introduce-new-format-%pgt-for-page_type
+++ a/lib/test_printf.c
@@ -642,12 +642,26 @@ page_flags_test(int section, int node, i
 	test(cmp_buf, "%pGp", &flags);
 }
 
+static void __init page_type_test(unsigned int page_type, const char *name,
+				  char *cmp_buf)
+{
+	unsigned long size;
+
+	size = scnprintf(cmp_buf, BUF_SIZE, "%#x(", page_type);
+	if (page_type_has_type(page_type))
+		size += scnprintf(cmp_buf + size, BUF_SIZE - size, "%s", name);
+
+	snprintf(cmp_buf + size, BUF_SIZE - size, ")");
+	test(cmp_buf, "%pGt", &page_type);
+}
+
 static void __init
 flags(void)
 {
 	unsigned long flags;
 	char *cmp_buffer;
 	gfp_t gfp;
+	unsigned int page_type;
 
 	cmp_buffer = kmalloc(BUF_SIZE, GFP_KERNEL);
 	if (!cmp_buffer)
@@ -687,6 +701,18 @@ flags(void)
 	gfp |= __GFP_HIGH;
 	test(cmp_buffer, "%pGg", &gfp);
 
+	page_type = ~0;
+	page_type_test(page_type, "", cmp_buffer);
+
+	page_type = 10;
+	page_type_test(page_type, "", cmp_buffer);
+
+	page_type = ~PG_buddy;
+	page_type_test(page_type, "buddy", cmp_buffer);
+
+	page_type = ~(PG_table | PG_buddy);
+	page_type_test(page_type, "table|buddy", cmp_buffer);
+
 	kfree(cmp_buffer);
 }
 
--- a/lib/vsprintf.c~mm-printk-introduce-new-format-%pgt-for-page_type
+++ a/lib/vsprintf.c
@@ -2052,6 +2052,25 @@ char *format_page_flags(char *buf, char
 	return buf;
 }
 
+static
+char *format_page_type(char *buf, char *end, unsigned int page_type)
+{
+	buf = number(buf, end, page_type, default_flag_spec);
+
+	if (buf < end)
+		*buf = '(';
+	buf++;
+
+	if (page_type_has_type(page_type))
+		buf = format_flags(buf, end, ~page_type, pagetype_names);
+
+	if (buf < end)
+		*buf = ')';
+	buf++;
+
+	return buf;
+}
+
 static noinline_for_stack
 char *flags_string(char *buf, char *end, void *flags_ptr,
 		   struct printf_spec spec, const char *fmt)
@@ -2065,6 +2084,8 @@ char *flags_string(char *buf, char *end,
 	switch (fmt[1]) {
 	case 'p':
 		return format_page_flags(buf, end, *(unsigned long *)flags_ptr);
+	case 't':
+		return format_page_type(buf, end, *(unsigned int *)flags_ptr);
 	case 'v':
 		flags = *(unsigned long *)flags_ptr;
 		names = vmaflag_names;
--- a/mm/debug.c~mm-printk-introduce-new-format-%pgt-for-page_type
+++ a/mm/debug.c
@@ -36,6 +36,11 @@ const struct trace_print_flags pageflag_
 	{0, NULL}
 };
 
+const struct trace_print_flags pagetype_names[] = {
+	__def_pagetype_names,
+	{0, NULL}
+};
+
 const struct trace_print_flags gfpflag_names[] = {
 	__def_gfpflag_names,
 	{0, NULL}
--- a/mm/internal.h~mm-printk-introduce-new-format-%pgt-for-page_type
+++ a/mm/internal.h
@@ -823,6 +823,7 @@ static inline void flush_tlb_batched_pen
 #endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
 
 extern const struct trace_print_flags pageflag_names[];
+extern const struct trace_print_flags pagetype_names[];
 extern const struct trace_print_flags vmaflag_names[];
 extern const struct trace_print_flags gfpflag_names[];
 
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


