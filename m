From: akpm@linux-foundation.org
Subject: + mm-printk-introduce-new-format-string-for-flags.patch added to
 -mm tree
Date: Fri, 04 Dec 2015 15:46:14 -0800
Message-ID: <566225c6.j9YWQwc6cKHdidYW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbbLDXqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:46:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, printk: introduce new format string for flags
has been added to the -mm tree.  Its filename is
     mm-printk-introduce-new-format-string-for-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-printk-introduce-new-format-string-for-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-printk-introduce-new-format-string-for-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, printk: introduce new format string for flags

In mm we use several kinds of flags bitfields that are sometimes printed
for debugging purposes, or exported to userspace via sysfs.  To make them
easier to interpret independently on kernel version and config, we want to
dump also the symbolic flag names.  So far this has been done with
repeated calls to pr_cont(), which is unreliable on SMP, and not usable
for e.g.  sysfs export.

To get a more reliable and universal solution, this patch extends printk()
format string for pointers to handle the page flags (%pgp), gfp_flags
(%pgg) and vma flags (%pgv).  Existing users of dump_flag_names() are
converted and simplified.

It would be possible to pass flags by value instead of pointer, but the %p
format string for pointers already has extensions for various kernel
structures, so it's a good fit, and the extra indirection in a
non-critical path is negligible.

[linux@rasmusvillemoes.dk: lots of good implementation suggestions]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   14 +++
 include/linux/mmdebug.h          |    7 +
 include/linux/trace_events.h     |   10 --
 include/linux/tracepoint.h       |   10 ++
 lib/vsprintf.c                   |   75 ++++++++++++++++
 mm/debug.c                       |  135 ++++++++++-------------------
 mm/oom_kill.c                    |    5 -
 mm/page_alloc.c                  |    5 -
 mm/page_owner.c                  |    6 -
 9 files changed, 160 insertions(+), 107 deletions(-)

diff -puN Documentation/printk-formats.txt~mm-printk-introduce-new-format-string-for-flags Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~mm-printk-introduce-new-format-string-for-flags
+++ a/Documentation/printk-formats.txt
@@ -292,6 +292,20 @@ bitmap and its derivatives such as cpuma
 
 	Passed by reference.
 
+Flags bitfields such as page flags, gfp_flags:
+
+	%pgp	referenced|uptodate|lru|active|private
+	%pgg	GFP_USER|GFP_DMA32|GFP_NOWARN
+	%pgv	read|exec|mayread|maywrite|mayexec|denywrite
+
+	For printing flags bitfields as a collection of symbolic constants that
+	would construct the value. The type of flags is given by the third
+	character. Currently supported are [p]age flags, [g]fp_flags and
+	[v]ma_flags. The flag names and print order depends on the particular
+	type.
+
+	Passed by reference.
+
 Network device features:
 
 	%pNF	0x000000000000c000
diff -puN include/linux/mmdebug.h~mm-printk-introduce-new-format-string-for-flags include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-printk-introduce-new-format-string-for-flags
+++ a/include/linux/mmdebug.h
@@ -2,15 +2,20 @@
 #define LINUX_MM_DEBUG_H 1
 
 #include <linux/stringify.h>
+#include <linux/types.h>
+#include <linux/tracepoint.h>
 
 struct page;
 struct vm_area_struct;
 struct mm_struct;
 
+extern const struct trace_print_flags pageflag_names[];
+extern const struct trace_print_flags vmaflag_names[];
+extern const struct trace_print_flags gfpflag_names[];
+
 extern void dump_page(struct page *page, const char *reason);
 extern void dump_page_badflags(struct page *page, const char *reason,
 			       unsigned long badflags);
-extern void dump_gfpflag_names(unsigned long gfp_flags);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
 
diff -puN include/linux/trace_events.h~mm-printk-introduce-new-format-string-for-flags include/linux/trace_events.h
--- a/include/linux/trace_events.h~mm-printk-introduce-new-format-string-for-flags
+++ a/include/linux/trace_events.h
@@ -15,16 +15,6 @@ struct tracer;
 struct dentry;
 struct bpf_prog;
 
-struct trace_print_flags {
-	unsigned long		mask;
-	const char		*name;
-};
-
-struct trace_print_flags_u64 {
-	unsigned long long	mask;
-	const char		*name;
-};
-
 const char *trace_print_flags_seq(struct trace_seq *p, const char *delim,
 				  unsigned long flags,
 				  const struct trace_print_flags *flag_array);
diff -puN include/linux/tracepoint.h~mm-printk-introduce-new-format-string-for-flags include/linux/tracepoint.h
--- a/include/linux/tracepoint.h~mm-printk-introduce-new-format-string-for-flags
+++ a/include/linux/tracepoint.h
@@ -43,6 +43,16 @@ struct trace_enum_map {
 	unsigned long		enum_value;
 };
 
+struct trace_print_flags {
+	unsigned long		mask;
+	const char		*name;
+};
+
+struct trace_print_flags_u64 {
+	unsigned long long	mask;
+	const char		*name;
+};
+
 #define TRACEPOINT_DEFAULT_PRIO	10
 
 extern int
diff -puN lib/vsprintf.c~mm-printk-introduce-new-format-string-for-flags lib/vsprintf.c
--- a/lib/vsprintf.c~mm-printk-introduce-new-format-string-for-flags
+++ a/lib/vsprintf.c
@@ -31,6 +31,7 @@
 #include <linux/dcache.h>
 #include <linux/cred.h>
 #include <net/addrconf.h>
+#include <linux/mmdebug.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
@@ -1372,6 +1373,73 @@ char *clock(char *buf, char *end, struct
 	}
 }
 
+static
+char *format_flags(char *buf, char *end, unsigned long flags,
+					const struct trace_print_flags *names)
+{
+	unsigned long mask;
+	const struct printf_spec strspec = {
+		.field_width = -1,
+		.precision = -1,
+	};
+	const struct printf_spec numspec = {
+		.flags = SPECIAL|SMALL,
+		.field_width = -1,
+		.precision = -1,
+		.base = 16,
+	};
+
+	for ( ; flags && (names->mask || names->name); names++) {
+		mask = names->mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		buf = string(buf, end, names->name, strspec);
+
+		flags &= ~mask;
+		if (flags) {
+			if (buf < end)
+				*buf = '|';
+			buf++;
+		}
+	}
+
+	if (flags)
+		buf = number(buf, end, flags, numspec);
+
+	return buf;
+}
+
+static noinline_for_stack
+char *flags_string(char *buf, char *end, void *flags_ptr,
+			struct printf_spec spec, const char *fmt)
+{
+	unsigned long flags;
+	const struct trace_print_flags *names;
+
+	switch (fmt[1]) {
+	case 'p':
+		flags = *(unsigned long *)flags_ptr;
+		/* Remove zone id */
+		flags &= (1UL << NR_PAGEFLAGS) - 1;
+		names = pageflag_names;
+		break;
+	case 'v':
+		flags = *(unsigned long *)flags_ptr;
+		names = vmaflag_names;
+		break;
+	case 'g':
+		flags = *(gfp_t *)flags_ptr;
+		names = gfpflag_names;
+		break;
+	default:
+		WARN_ONCE(1, "Unsupported flags modifier: %c\n", fmt[1]);
+		return buf;
+	}
+
+	return format_flags(buf, end, flags, names);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1459,6 +1527,11 @@ int kptr_restrict __read_mostly;
  * - 'Cn' For a clock, it prints the name (Common Clock Framework) or address
  *        (legacy clock framework) of the clock
  * - 'Cr' For a clock, it prints the current rate of the clock
+ * - 'g' For flags to be printed as a collection of symbolic strings that would
+ *       construct the specific value. Supported flags given by option:
+ *       p page flags (see struct page) given as pointer to unsigned long
+ *       g gfp flags (GFP_* and __GFP_*) given as pointer to gfp_t
+ *       v vma flags (VM_*) given as pointer to unsigned long
  *
  * ** Please update also Documentation/printk-formats.txt when making changes **
  *
@@ -1611,6 +1684,8 @@ char *pointer(const char *fmt, char *buf
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'g':
+		return flags_string(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
diff -puN mm/debug.c~mm-printk-introduce-new-format-string-for-flags mm/debug.c
--- a/mm/debug.c~mm-printk-introduce-new-format-string-for-flags
+++ a/mm/debug.c
@@ -23,7 +23,7 @@ char *migrate_reason_names[MR_TYPES] = {
 	"cma",
 };
 
-static const struct trace_print_flags pageflag_names[] = {
+const struct trace_print_flags pageflag_names[] = {
 	{1UL << PG_locked,		"locked"	},
 	{1UL << PG_error,		"error"		},
 	{1UL << PG_referenced,		"referenced"	},
@@ -57,86 +57,10 @@ static const struct trace_print_flags pa
 	{1UL << PG_young,		"young"		},
 	{1UL << PG_idle,		"idle"		},
 #endif
+	{0,				NULL		},
 };
 
-static const struct trace_print_flags gfpflag_names[] = {
-	__def_gfpflag_names
-};
-
-static void dump_flag_names(unsigned long flags,
-			const struct trace_print_flags *names, int count)
-{
-	const char *delim = "";
-	unsigned long mask;
-	int i;
-
-	pr_cont("(");
-
-	for (i = 0; i < count && flags; i++) {
-
-		mask = names[i].mask;
-		if ((flags & mask) != mask)
-			continue;
-
-		flags &= ~mask;
-		pr_cont("%s%s", delim, names[i].name);
-		delim = "|";
-	}
-
-	/* check for left over flags */
-	if (flags)
-		pr_cont("%s%#lx", delim, flags);
-
-	pr_cont(")\n");
-}
-
-void dump_gfpflag_names(unsigned long gfp_flags)
-{
-	dump_flag_names(gfp_flags, gfpflag_names, ARRAY_SIZE(gfpflag_names));
-}
-
-void dump_page_badflags(struct page *page, const char *reason,
-		unsigned long badflags)
-{
-	unsigned long printflags = page->flags;
-
-	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx",
-		  page, atomic_read(&page->_count), page_mapcount(page),
-		  page->mapping, page->index);
-	if (PageCompound(page))
-		pr_cont(" compound_mapcount: %d", compound_mapcount(page));
-	pr_cont("\n");
-	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
-
-	pr_emerg("flags: %#lx", printflags);
-	/* remove zone id */
-	printflags &= (1UL << NR_PAGEFLAGS) - 1;
-	dump_flag_names(printflags, pageflag_names, ARRAY_SIZE(pageflag_names));
-
-	if (reason)
-		pr_alert("page dumped because: %s\n", reason);
-	if (page->flags & badflags) {
-		printflags = page->flags & badflags;
-		pr_alert("bad because of flags: %#lx:", printflags);
-		dump_flag_names(printflags, pageflag_names,
-						ARRAY_SIZE(pageflag_names));
-	}
-#ifdef CONFIG_MEMCG
-	if (page->mem_cgroup)
-		pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
-#endif
-}
-
-void dump_page(struct page *page, const char *reason)
-{
-	dump_page_badflags(page, reason, 0);
-	dump_page_owner(page);
-}
-EXPORT_SYMBOL(dump_page);
-
-#ifdef CONFIG_DEBUG_VM
-
-static const struct trace_print_flags vmaflags_names[] = {
+const struct trace_print_flags vmaflag_names[] = {
 	{VM_READ,			"read"		},
 	{VM_WRITE,			"write"		},
 	{VM_EXEC,			"exec"		},
@@ -177,22 +101,61 @@ static const struct trace_print_flags vm
 	{VM_HUGEPAGE,			"hugepage"	},
 	{VM_NOHUGEPAGE,			"nohugepage"	},
 	{VM_MERGEABLE,			"mergeable"	},
+	{0,				NULL		},
+};
+
+const struct trace_print_flags gfpflag_names[] = {
+	__def_gfpflag_names,
+	{0, NULL},
 };
 
+void dump_page_badflags(struct page *page, const char *reason,
+		unsigned long badflags)
+{
+	unsigned long printflags = page->flags;
+
+	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
+		  page, atomic_read(&page->_count), page_mapcount(page),
+		  page->mapping, page->index);
+	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
+
+	pr_emerg("flags: %#lx(%pgp)\n", printflags, &printflags);
+
+	if (reason)
+		pr_alert("page dumped because: %s\n", reason);
+	if (page->flags & badflags) {
+		printflags = page->flags & badflags;
+		pr_alert("bad because of flags: %#lx(%pgp)\n", printflags,
+								&printflags);
+	}
+#ifdef CONFIG_MEMCG
+	if (page->mem_cgroup)
+		pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
+#endif
+}
+
+void dump_page(struct page *page, const char *reason)
+{
+	dump_page_badflags(page, reason, 0);
+	dump_page_owner(page);
+}
+EXPORT_SYMBOL(dump_page);
+
+#ifdef CONFIG_DEBUG_VM
+
 void dump_vma(const struct vm_area_struct *vma)
 {
 	pr_emerg("vma %p start %p end %p\n"
 		"next %p prev %p mm %p\n"
 		"prot %lx anon_vma %p vm_ops %p\n"
-		"pgoff %lx file %p private_data %p\n",
+		"pgoff %lx file %p private_data %p\n"
+		"flags: %#lx(%pgv)\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
 		vma->vm_prev, vma->vm_mm,
 		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
-		vma->vm_file, vma->vm_private_data);
-	pr_emerg("flags: %#lx", vma->vm_flags);
-	dump_flag_names(vma->vm_flags, vmaflags_names,
-						ARRAY_SIZE(vmaflags_names));
+		vma->vm_file, vma->vm_private_data,
+		vma->vm_flags, &vma->vm_flags);
 }
 EXPORT_SYMBOL(dump_vma);
 
@@ -263,9 +226,7 @@ void dump_mm(const struct mm_struct *mm)
 		""		/* This is here to not have a comma! */
 		);
 
-	pr_emerg("def_flags: %#lx", mm->def_flags);
-	dump_flag_names(mm->def_flags, vmaflags_names,
-					ARRAY_SIZE(vmaflags_names));
+	pr_emerg("def_flags: %#lx(%pgv)\n", mm->def_flags, &mm->def_flags);
 }
 
 #endif		/* CONFIG_DEBUG_VM */
diff -puN mm/oom_kill.c~mm-printk-introduce-new-format-string-for-flags mm/oom_kill.c
--- a/mm/oom_kill.c~mm-printk-introduce-new-format-string-for-flags
+++ a/mm/oom_kill.c
@@ -387,10 +387,9 @@ static void dump_header(struct oom_contr
 			struct mem_cgroup *memcg)
 {
 	pr_warning("%s invoked oom-killer: order=%d, oom_score_adj=%hd, "
-			"gfp_mask=0x%x",
+			"gfp_mask=%#x(%pgg)\n",
 		current->comm, oc->order, current->signal->oom_score_adj,
-		oc->gfp_mask);
-	dump_gfpflag_names(oc->gfp_mask);
+		oc->gfp_mask, &oc->gfp_mask);
 
 	cpuset_print_current_mems_allowed();
 	dump_stack();
diff -puN mm/page_alloc.c~mm-printk-introduce-new-format-string-for-flags mm/page_alloc.c
--- a/mm/page_alloc.c~mm-printk-introduce-new-format-string-for-flags
+++ a/mm/page_alloc.c
@@ -2703,9 +2703,8 @@ void warn_alloc_failed(gfp_t gfp_mask, u
 		va_end(args);
 	}
 
-	pr_warn("%s: page allocation failure: order:%u, mode:0x%x",
-		current->comm, order, gfp_mask);
-	dump_gfpflag_names(gfp_mask);
+	pr_warn("%s: page allocation failure: order:%u, mode:%#x(%pgg)\n",
+		current->comm, order, gfp_mask, &gfp_mask);
 	dump_stack();
 	if (!should_suppress_show_mem())
 		show_mem(filter);
diff -puN mm/page_owner.c~mm-printk-introduce-new-format-string-for-flags mm/page_owner.c
--- a/mm/page_owner.c~mm-printk-introduce-new-format-string-for-flags
+++ a/mm/page_owner.c
@@ -208,9 +208,9 @@ void __dump_page_owner(struct page *page
 		return;
 	}
 
-	pr_alert("page allocated via order %u, migratetype %s, gfp_mask 0x%x",
-			page_ext->order, migratetype_names[mt], gfp_mask);
-	dump_gfpflag_names(gfp_mask);
+	pr_alert("page allocated via order %u, migratetype %s, "
+			"gfp_mask %#x(%pgg)\n", page_ext->order,
+			migratetype_names[mt], gfp_mask, &gfp_mask);
 	print_stack_trace(&trace, 0);
 
 	if (page_ext->last_migrate_reason != -1)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-track-and-print-last-migrate-reason-fix.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

