From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-printk-introduce-new-format-string-for-flags.patch removed from -mm tree
Date: Thu, 07 Jan 2016 16:27:13 -0800
Message-ID: <568f0261.DjBGBA2JfUAvAwhl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbcAHA1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 19:27:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, james.hogan@imgtec.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, printk: introduce new format string for flags
has been removed from the -mm tree.  Its filename was
     mm-printk-introduce-new-format-string-for-flags.patch

This patch was dropped because an updated version will be merged

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
Tested-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   14 +++++
 include/linux/mmdebug.h          |    6 ++
 include/linux/tracepoint.h       |   10 +++
 lib/vsprintf.c                   |   75 +++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+)

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
@@ -3,11 +3,17 @@
 
 #include <linux/bug.h>
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
diff -puN include/linux/trace_events.h~mm-printk-introduce-new-format-string-for-flags include/linux/trace_events.h
diff -puN include/linux/tracepoint.h~mm-printk-introduce-new-format-string-for-flags include/linux/tracepoint.h
--- a/include/linux/tracepoint.h~mm-printk-introduce-new-format-string-for-flags
+++ a/include/linux/tracepoint.h
@@ -29,6 +29,16 @@ struct trace_enum_map {
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
@@ -1384,6 +1385,73 @@ char *clock(char *buf, char *end, struct
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
@@ -1471,6 +1539,11 @@ int kptr_restrict __read_mostly;
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
@@ -1619,6 +1692,8 @@ char *pointer(const char *fmt, char *buf
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'g':
+		return flags_string(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
diff -puN mm/debug.c~mm-printk-introduce-new-format-string-for-flags mm/debug.c
diff -puN mm/oom_kill.c~mm-printk-introduce-new-format-string-for-flags mm/oom_kill.c
diff -puN mm/page_alloc.c~mm-printk-introduce-new-format-string-for-flags mm/page_alloc.c
diff -puN mm/page_owner.c~mm-printk-introduce-new-format-string-for-flags mm/page_owner.c
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

