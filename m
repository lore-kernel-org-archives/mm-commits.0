Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9741274402
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423518; cv=none; b=O8PsaNAuPPGf71l8iWomemUOepUA0YDn8VBgSQzL1HZLI8fcR9dEALXOfxH7XNTvMmfQK8Tetck6NCovwnktdl5HN+61fOMe9g9JxP2SBNINLLYhXwKo8XMZqaNVmC6GI4TeGYRrRYztPOctZ4+cfTHuW3QVJDXeirOpui8X+/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423518; c=relaxed/simple;
	bh=URc17i7agy7+xpbfnf9Xv+29a3scr7kIU7OdF0Mbr0c=;
	h=Date:To:From:Subject:Message-Id; b=umP6cTYiCalLRkV5qoFp5TlTYeBzksejCe/xUB+evcKGgHgIqaK9zGVMa/UTuOJlVKXc94WXkNPMQ/fwuDtyjNX60u3xyvqSB4mN1AyE0iNs2qdcpswpcGbdpPtTM0HrfLRQm6+EmZTQf4QOQAR62H9uA1DxbMYQY5iX1Wre3ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jCUrPH3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jCUrPH3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D573C4CEC2;
	Wed,  4 Sep 2024 04:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423518;
	bh=URc17i7agy7+xpbfnf9Xv+29a3scr7kIU7OdF0Mbr0c=;
	h=Date:To:From:Subject:From;
	b=jCUrPH3sOxPqqy/S/plBQ+jE1Il/yU8hXjd0J+Ro6khXFZAdsmSWGhU6Q2V2iyg0c
	 IDwblMP0naD3OY7XtgGMdTwoIj5Vn8liiz+gRz2ne9e/dkD7UKCX+ZJzo8PAP7g/bI
	 pfb8mmOSC7ABRT/0EF7zhVdGnkuJussB976lhS40=
Date: Tue, 03 Sep 2024 21:18:37 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] printf-remove-%pgt-support.patch removed from -mm tree
Message-Id: <20240904041838.6D573C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: printf: remove %pGt support
has been removed from the -mm tree.  Its filename was
     printf-remove-%pgt-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: printf: remove %pGt support
Date: Wed, 21 Aug 2024 18:39:09 +0100

Patch series "Increase the number of bits available in page_type".

Kent wants more than 16 bits in page_type, so I resurrected this old patch
and expanded it a bit.  It's a bit more efficient than our current scheme
(1 4-byte insn vs 3 insns of 13 bytes total) to test a single page type.


This patch (of 4):

An upcoming patch will convert page type from being a bitfield to a
single byte, so we will not be able to use %pG to print the page type
any more.  The printing of the symbolic name will be restored in that
patch.

Link: https://lkml.kernel.org/r/20240821173914.2270383-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240821173914.2270383-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/printk-formats.rst |    4 ---
 include/trace/events/mmflags.h            |   10 -------
 lib/test_printf.c                         |   26 --------------------
 lib/vsprintf.c                            |   21 ----------------
 mm/debug.c                                |    2 -
 mm/internal.h                             |    1 
 6 files changed, 2 insertions(+), 62 deletions(-)

--- a/Documentation/core-api/printk-formats.rst~printf-remove-%pgt-support
+++ a/Documentation/core-api/printk-formats.rst
@@ -576,13 +576,12 @@ The field width is passed by value, the
 Helper macros cpumask_pr_args() and nodemask_pr_args() are available to ease
 printing cpumask and nodemask.
 
-Flags bitfields such as page flags, page_type, gfp_flags
+Flags bitfields such as page flags and gfp_flags
 --------------------------------------------------------
 
 ::
 
 	%pGp	0x17ffffc0002036(referenced|uptodate|lru|active|private|node=0|zone=2|lastcpupid=0x1fffff)
-	%pGt	0xffffff7f(buddy)
 	%pGg	GFP_USER|GFP_DMA32|GFP_NOWARN
 	%pGv	read|exec|mayread|maywrite|mayexec|denywrite
 
@@ -591,7 +590,6 @@ would construct the value. The type of f
 character. Currently supported are:
 
         - p - [p]age flags, expects value of type (``unsigned long *``)
-        - t - page [t]ype, expects value of type (``unsigned int *``)
         - v - [v]ma_flags, expects value of type (``unsigned long *``)
         - g - [g]fp_flags, expects value of type (``gfp_t *``)
 
--- a/include/trace/events/mmflags.h~printf-remove-%pgt-support
+++ a/include/trace/events/mmflags.h
@@ -130,16 +130,6 @@ IF_HAVE_PG_ARCH_X(arch_3)
 	__def_pageflag_names						\
 	) : "none"
 
-#define DEF_PAGETYPE_NAME(_name) { PG_##_name, __stringify(_name) }
-
-#define __def_pagetype_names						\
-	DEF_PAGETYPE_NAME(slab),					\
-	DEF_PAGETYPE_NAME(hugetlb),					\
-	DEF_PAGETYPE_NAME(offline),					\
-	DEF_PAGETYPE_NAME(guard),					\
-	DEF_PAGETYPE_NAME(table),					\
-	DEF_PAGETYPE_NAME(buddy)
-
 #if defined(CONFIG_X86)
 #define __VM_ARCH_SPECIFIC_1 {VM_PAT,     "pat"           }
 #elif defined(CONFIG_PPC)
--- a/lib/test_printf.c~printf-remove-%pgt-support
+++ a/lib/test_printf.c
@@ -641,26 +641,12 @@ page_flags_test(int section, int node, i
 	test(cmp_buf, "%pGp", &flags);
 }
 
-static void __init page_type_test(unsigned int page_type, const char *name,
-				  char *cmp_buf)
-{
-	unsigned long size;
-
-	size = scnprintf(cmp_buf, BUF_SIZE, "%#x(", page_type);
-	if (page_type_has_type(page_type))
-		size += scnprintf(cmp_buf + size, BUF_SIZE - size, "%s", name);
-
-	snprintf(cmp_buf + size, BUF_SIZE - size, ")");
-	test(cmp_buf, "%pGt", &page_type);
-}
-
 static void __init
 flags(void)
 {
 	unsigned long flags;
 	char *cmp_buffer;
 	gfp_t gfp;
-	unsigned int page_type;
 
 	cmp_buffer = kmalloc(BUF_SIZE, GFP_KERNEL);
 	if (!cmp_buffer)
@@ -700,18 +686,6 @@ flags(void)
 	gfp |= __GFP_HIGH;
 	test(cmp_buffer, "%pGg", &gfp);
 
-	page_type = ~0;
-	page_type_test(page_type, "", cmp_buffer);
-
-	page_type = 10;
-	page_type_test(page_type, "", cmp_buffer);
-
-	page_type = ~PG_buddy;
-	page_type_test(page_type, "buddy", cmp_buffer);
-
-	page_type = ~(PG_table | PG_buddy);
-	page_type_test(page_type, "table|buddy", cmp_buffer);
-
 	kfree(cmp_buffer);
 }
 
--- a/lib/vsprintf.c~printf-remove-%pgt-support
+++ a/lib/vsprintf.c
@@ -2054,25 +2054,6 @@ char *format_page_flags(char *buf, char
 	return buf;
 }
 
-static
-char *format_page_type(char *buf, char *end, unsigned int page_type)
-{
-	buf = number(buf, end, page_type, default_flag_spec);
-
-	if (buf < end)
-		*buf = '(';
-	buf++;
-
-	if (page_type_has_type(page_type))
-		buf = format_flags(buf, end, ~page_type, pagetype_names);
-
-	if (buf < end)
-		*buf = ')';
-	buf++;
-
-	return buf;
-}
-
 static noinline_for_stack
 char *flags_string(char *buf, char *end, void *flags_ptr,
 		   struct printf_spec spec, const char *fmt)
@@ -2086,8 +2067,6 @@ char *flags_string(char *buf, char *end,
 	switch (fmt[1]) {
 	case 'p':
 		return format_page_flags(buf, end, *(unsigned long *)flags_ptr);
-	case 't':
-		return format_page_type(buf, end, *(unsigned int *)flags_ptr);
 	case 'v':
 		flags = *(unsigned long *)flags_ptr;
 		names = vmaflag_names;
--- a/mm/debug.c~printf-remove-%pgt-support
+++ a/mm/debug.c
@@ -92,7 +92,7 @@ static void __dump_folio(struct folio *f
 	pr_warn("%sflags: %pGp%s\n", type, &folio->flags,
 		is_migrate_cma_folio(folio, pfn) ? " CMA" : "");
 	if (page_has_type(&folio->page))
-		pr_warn("page_type: %pGt\n", &folio->page.page_type);
+		pr_warn("page_type: %x\n", folio->page.page_type);
 
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
--- a/mm/internal.h~printf-remove-%pgt-support
+++ a/mm/internal.h
@@ -1144,7 +1144,6 @@ static inline void flush_tlb_batched_pen
 #endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
 
 extern const struct trace_print_flags pageflag_names[];
-extern const struct trace_print_flags pagetype_names[];
 extern const struct trace_print_flags vmaflag_names[];
 extern const struct trace_print_flags gfpflag_names[];
 
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch

