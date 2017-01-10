From: akpm@linux-foundation.org
Subject: + tracing-add-__print_flags_u64.patch added to -mm tree
Date: Tue, 10 Jan 2017 14:51:25 -0800
Message-ID: <5875656d.yGIrA1mPNGIV072l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756039AbdAJWv1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 17:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dave.jiang@intel.com, david@fromorbit.com, jack@suse.cz, mawilcox@microsoft.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: add __print_flags_u64()
has been added to the -mm tree.  Its filename is
     tracing-add-__print_flags_u64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracing-add-__print_flags_u64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracing-add-__print_flags_u64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: tracing: add __print_flags_u64()

Patch series "DAX tracepoints, mm argument simplification", v4.

This contains both my DAX tracepoint code and Dave Jiang's MM argument
simplifications.  Dave's code was written with my tracepoint code as a
baseline, so it seemed simplest to keep them together in a single series.


This patch (of 7):

Add __print_flags_u64() and the helper trace_print_flags_seq_u64() in the
same spirit as __print_symbolic_u64() and trace_print_symbols_seq_u64(). 
These functions allow us to print symbols associated with flags that are
64 bits wide even on 32 bit machines.

These will be used by the DAX code so that we can print the flags set in a
pfn_t such as PFN_SG_CHAIN, PFN_SG_LAST, PFN_DEV and PFN_MAP.

Without this new function I was getting errors like the following when
compiling for i386:

./include/linux/pfn_t.h:13:22: warning: large integer implicitly truncated
to unsigned type [-Woverflow]
 #define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
  ^

Link: http://lkml.kernel.org/r/1484085142-2297-2-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/trace_events.h |    4 +++
 include/trace/trace_events.h |   11 +++++++++
 kernel/trace/trace_output.c  |   38 +++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff -puN include/linux/trace_events.h~tracing-add-__print_flags_u64 include/linux/trace_events.h
--- a/include/linux/trace_events.h~tracing-add-__print_flags_u64
+++ a/include/linux/trace_events.h
@@ -23,6 +23,10 @@ const char *trace_print_symbols_seq(stru
 				    const struct trace_print_flags *symbol_array);
 
 #if BITS_PER_LONG == 32
+const char *trace_print_flags_seq_u64(struct trace_seq *p, const char *delim,
+		      unsigned long long flags,
+		      const struct trace_print_flags_u64 *flag_array);
+
 const char *trace_print_symbols_seq_u64(struct trace_seq *p,
 					unsigned long long val,
 					const struct trace_print_flags_u64
diff -puN include/trace/trace_events.h~tracing-add-__print_flags_u64 include/trace/trace_events.h
--- a/include/trace/trace_events.h~tracing-add-__print_flags_u64
+++ a/include/trace/trace_events.h
@@ -283,8 +283,16 @@ TRACE_MAKE_SYSTEM_STR();
 		trace_print_symbols_seq(p, value, symbols);		\
 	})
 
+#undef __print_flags_u64
 #undef __print_symbolic_u64
 #if BITS_PER_LONG == 32
+#define __print_flags_u64(flag, delim, flag_array...)			\
+	({								\
+		static const struct trace_print_flags_u64 __flags[] =	\
+			{ flag_array, { -1, NULL } };			\
+		trace_print_flags_seq_u64(p, delim, flag, __flags);	\
+	})
+
 #define __print_symbolic_u64(value, symbol_array...)			\
 	({								\
 		static const struct trace_print_flags_u64 symbols[] =	\
@@ -292,6 +300,9 @@ TRACE_MAKE_SYSTEM_STR();
 		trace_print_symbols_seq_u64(p, value, symbols);	\
 	})
 #else
+#define __print_flags_u64(flag, delim, flag_array...)			\
+			__print_flags(flag, delim, flag_array)
+
 #define __print_symbolic_u64(value, symbol_array...)			\
 			__print_symbolic(value, symbol_array)
 #endif
diff -puN kernel/trace/trace_output.c~tracing-add-__print_flags_u64 kernel/trace/trace_output.c
--- a/kernel/trace/trace_output.c~tracing-add-__print_flags_u64
+++ a/kernel/trace/trace_output.c
@@ -124,6 +124,44 @@ EXPORT_SYMBOL(trace_print_symbols_seq);
 
 #if BITS_PER_LONG == 32
 const char *
+trace_print_flags_seq_u64(struct trace_seq *p, const char *delim,
+		      unsigned long long flags,
+		      const struct trace_print_flags_u64 *flag_array)
+{
+	unsigned long long mask;
+	const char *str;
+	const char *ret = trace_seq_buffer_ptr(p);
+	int i, first = 1;
+
+	for (i = 0;  flag_array[i].name && flags; i++) {
+
+		mask = flag_array[i].mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		str = flag_array[i].name;
+		flags &= ~mask;
+		if (!first && delim)
+			trace_seq_puts(p, delim);
+		else
+			first = 0;
+		trace_seq_puts(p, str);
+	}
+
+	/* check for left over flags */
+	if (flags) {
+		if (!first && delim)
+			trace_seq_puts(p, delim);
+		trace_seq_printf(p, "0x%llx", flags);
+	}
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(trace_print_flags_seq_u64);
+
+const char *
 trace_print_symbols_seq_u64(struct trace_seq *p, unsigned long long val,
 			 const struct trace_print_flags_u64 *symbol_array)
 {
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-deadlock-with-dax-4k-holes.patch
mm-add-follow_pte_pmd.patch
dax-wrprotect-pmd_t-in-dax_mapping_entry_mkclean.patch
dax-fix-build-warnings-with-fs_dax-and-fs_iomap.patch
tracing-add-__print_flags_u64.patch
dax-add-tracepoint-infrastructure-pmd-tracing.patch
dax-update-maintainers-entries-for-fs-dax.patch
dax-add-tracepoints-to-dax_pmd_load_hole.patch
dax-add-tracepoints-to-dax_pmd_insert_mapping.patch

