Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDD4C64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 22:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjBZWkm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 17:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjBZWkl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 17:40:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F7EFF02
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 14:40:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D26160B5B
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 22:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E88C433D2;
        Sun, 26 Feb 2023 22:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677451239;
        bh=UgtAQjup8jQUOaJ0PkJbVkEj52BmBTzvsnaPZTLktQg=;
        h=Date:To:From:Subject:From;
        b=qDMXq5kFT/3fcLLPDKKRlGDrSjCHEr+xPZsRbFyPtWM/60rzTaddMbBgQkJl2h/mJ
         zRbNuVZFq8tFPmpEBmzQB3/7DQWC89Inv5K4fmvHEKEsLUiGdSWWZZUkdcUtQ13mui
         1tCXQyLanOGwk6oAkQkdUEGAbkz6wK+Vhg2H/s88=
Date:   Sun, 26 Feb 2023 14:40:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
        john.ogness@linutronix.de, joe@perches.com, david@redhat.com,
        andriy.shevchenko@linux.intel.com, 42.hyeyoo@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-printk-introduce-new-format-%pgt-for-page_type.patch added to mm-unstable branch
Message-Id: <20230226224038.F1E88C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, printk: introduce new format %pGt for page_type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-printk-introduce-new-format-%pgt-for-page_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-printk-introduce-new-format-%pgt-for-page_type.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff --git a/Documentation/core-api/printk-formats.rst~mm-printk-introduce-new-format-%pgt-for-page_type b/Documentation/core-api/printk-formats.rst
--- a/Documentation/core-api/printk-formats.rst~mm-printk-introduce-new-format-%pgt-for-page_type
+++ b/Documentation/core-api/printk-formats.rst
@@ -575,20 +575,26 @@ The field width is passed by value, the bitmap is passed by reference.
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
diff --git a/include/linux/page-flags.h~mm-printk-introduce-new-format-%pgt-for-page_type b/include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-printk-introduce-new-format-%pgt-for-page_type
+++ b/include/linux/page-flags.h
@@ -926,9 +926,14 @@ static inline bool is_page_hwpoison(struct page *page)
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
diff --git a/include/trace/events/mmflags.h~mm-printk-introduce-new-format-%pgt-for-page_type b/include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mm-printk-introduce-new-format-%pgt-for-page_type
+++ b/include/trace/events/mmflags.h
@@ -141,6 +141,14 @@ IF_HAVE_PG_SKIP_KASAN_POISON(skip_kasan_poison)
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
diff --git a/lib/test_printf.c~mm-printk-introduce-new-format-%pgt-for-page_type b/lib/test_printf.c
--- a/lib/test_printf.c~mm-printk-introduce-new-format-%pgt-for-page_type
+++ b/lib/test_printf.c
@@ -642,12 +642,26 @@ page_flags_test(int section, int node, int zone, int last_cpupid,
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
 
diff --git a/lib/vsprintf.c~mm-printk-introduce-new-format-%pgt-for-page_type b/lib/vsprintf.c
--- a/lib/vsprintf.c~mm-printk-introduce-new-format-%pgt-for-page_type
+++ b/lib/vsprintf.c
@@ -2052,6 +2052,25 @@ char *format_page_flags(char *buf, char *end, unsigned long flags)
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
@@ -2065,6 +2084,8 @@ char *flags_string(char *buf, char *end, void *flags_ptr,
 	switch (fmt[1]) {
 	case 'p':
 		return format_page_flags(buf, end, *(unsigned long *)flags_ptr);
+	case 't':
+		return format_page_type(buf, end, *(unsigned int *)flags_ptr);
 	case 'v':
 		flags = *(unsigned long *)flags_ptr;
 		names = vmaflag_names;
diff --git a/mm/debug.c~mm-printk-introduce-new-format-%pgt-for-page_type b/mm/debug.c
--- a/mm/debug.c~mm-printk-introduce-new-format-%pgt-for-page_type
+++ b/mm/debug.c
@@ -36,6 +36,11 @@ const struct trace_print_flags pageflag_names[] = {
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
diff --git a/mm/internal.h~mm-printk-introduce-new-format-%pgt-for-page_type b/mm/internal.h
--- a/mm/internal.h~mm-printk-introduce-new-format-%pgt-for-page_type
+++ b/mm/internal.h
@@ -823,6 +823,7 @@ static inline void flush_tlb_batched_pending(struct mm_struct *mm)
 #endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
 
 extern const struct trace_print_flags pageflag_names[];
+extern const struct trace_print_flags pagetype_names[];
 extern const struct trace_print_flags vmaflag_names[];
 extern const struct trace_print_flags gfpflag_names[];
 
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mmflagsh-use-less-error-prone-method-to-define-pageflag_names.patch
mm-printk-introduce-new-format-%pgt-for-page_type.patch
mm-debug-use-%pgt-to-display-page_type-in-dump_page.patch

