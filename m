From: akpm@linux-foundation.org
Subject: + ubsan-run-time-undefined-behavior-sanity-checker.patch added to -mm tree
Date: Fri, 04 Dec 2015 16:40:33 -0800
Message-ID: <56623281.EUxnKgMhTtmj+K45%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbbLEAkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 19:40:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, corbet@lwn.net, dvyukov@google.com, hpa@zytor.com, johannes@sipsolutions.net, kcc@google.com, koct9i@gmail.com, linux@rasmusvillemoes.dk, mingo@redhat.com, mmarek@suse.cz, peterz@infradead.org, rdunlap@infradead.org, sasha.levin@oracle.com, tglx@linutronix.de, y.gribov@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: UBSAN: run-time undefined behavior sanity checker
has been added to the -mm tree.  Its filename is
     ubsan-run-time-undefined-behavior-sanity-checker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-run-time-undefined-behavior-sanity-checker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-run-time-undefined-behavior-sanity-checker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: UBSAN: run-time undefined behavior sanity checker

UBSAN uses compile-time instrumentation to catch undefined behavior (UB). 
Compiler inserts code that perform certain kinds of checks before
operations that could cause UB.  If check fails (i.e.  UB detected)
__ubsan_handle_* function called to print error message.

So the most of the work is done by compiler.  This patch just implements
ubsan handlers printing errors.

GCC has this capability since 4.9.x [1] (see -fsanitize=undefined
option and its suboptions).
However GCC 5.x has more checkers implemented [2].
Article [3] has a bit more details about UBSAN in the GCC.

[1] - https://gcc.gnu.org/onlinedocs/gcc-4.9.0/gcc/Debugging-Options.html
[2] - https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
[3] - http://developerblog.redhat.com/2014/10/16/gcc-undefined-behavior-sanitizer-ubsan/

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yury Gribov <y.gribov@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ubsan.txt               |   84 ++++
 Makefile                              |    3 
 arch/x86/Kconfig                      |    1 
 arch/x86/boot/Makefile                |    1 
 arch/x86/boot/compressed/Makefile     |    1 
 arch/x86/entry/vdso/Makefile          |    1 
 arch/x86/realmode/rm/Makefile         |    1 
 drivers/firmware/efi/libstub/Makefile |    1 
 include/linux/sched.h                 |    3 
 lib/Kconfig.debug                     |    1 
 lib/Kconfig.ubsan                     |   29 +
 lib/Makefile                          |    3 
 lib/ubsan.c                           |  456 ++++++++++++++++++++++++
 lib/ubsan.h                           |   84 ++++
 mm/kasan/Makefile                     |    1 
 scripts/Makefile.lib                  |    6 
 scripts/Makefile.ubsan                |   18 
 17 files changed, 693 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/ubsan.txt
--- /dev/null
+++ a/Documentation/ubsan.txt
@@ -0,0 +1,84 @@
+Undefined Behavior Sanitizer - UBSAN
+
+Overview
+--------
+
+UBSAN is a runtime undefined behaviour checker.
+
+UBSAN uses compile-time instrumentation to catch undefined behavior (UB).
+Compiler inserts code that perform certain kinds of checks before operations
+that may cause UB. If check fails (i.e. UB detected) __ubsan_handle_*
+function called to print error message.
+
+GCC has that feature since 4.9.x [1] (see -fsanitize=undefined option and
+its suboptions). GCC 5.x has more checkers implemented [2].
+
+Report example
+---------------
+
+	 ================================================================================
+	 UBSAN: Undefined behaviour in ../include/linux/bitops.h:110:33
+	 shift exponent 32 is to large for 32-bit type 'unsigned int'
+	 CPU: 0 PID: 0 Comm: swapper Not tainted 4.4.0-rc1+ #26
+	  0000000000000000 ffffffff82403cc8 ffffffff815e6cd6 0000000000000001
+	  ffffffff82403cf8 ffffffff82403ce0 ffffffff8163a5ed 0000000000000020
+	  ffffffff82403d78 ffffffff8163ac2b ffffffff815f0001 0000000000000002
+	 Call Trace:
+	  [<ffffffff815e6cd6>] dump_stack+0x45/0x5f
+	  [<ffffffff8163a5ed>] ubsan_epilogue+0xd/0x40
+	  [<ffffffff8163ac2b>] __ubsan_handle_shift_out_of_bounds+0xeb/0x130
+	  [<ffffffff815f0001>] ? radix_tree_gang_lookup_slot+0x51/0x150
+	  [<ffffffff8173c586>] _mix_pool_bytes+0x1e6/0x480
+	  [<ffffffff83105653>] ? dmi_walk_early+0x48/0x5c
+	  [<ffffffff8173c881>] add_device_randomness+0x61/0x130
+	  [<ffffffff83105b35>] ? dmi_save_one_device+0xaa/0xaa
+	  [<ffffffff83105653>] dmi_walk_early+0x48/0x5c
+	  [<ffffffff831066ae>] dmi_scan_machine+0x278/0x4b4
+	  [<ffffffff8111d58a>] ? vprintk_default+0x1a/0x20
+	  [<ffffffff830ad120>] ? early_idt_handler_array+0x120/0x120
+	  [<ffffffff830b2240>] setup_arch+0x405/0xc2c
+	  [<ffffffff830ad120>] ? early_idt_handler_array+0x120/0x120
+	  [<ffffffff830ae053>] start_kernel+0x83/0x49a
+	  [<ffffffff830ad120>] ? early_idt_handler_array+0x120/0x120
+	  [<ffffffff830ad386>] x86_64_start_reservations+0x2a/0x2c
+	  [<ffffffff830ad4f3>] x86_64_start_kernel+0x16b/0x17a
+	 ================================================================================
+
+Usage
+-----
+
+To enable UBSAN configure kernel with:
+
+	CONFIG_UBSAN=y
+
+and to check the entire kernel:
+
+        CONFIG_UBSAN_SANITIZE_ALL=y
+
+To enable instrumentation for specific files or directories, add a line
+similar to the following to the respective kernel Makefile:
+
+        For a single file (e.g. main.o):
+                UBSAN_SANITIZE_main.o := y
+
+        For all files in one directory:
+                UBSAN_SANITIZE := y
+
+To exclude files from being instrumented even if
+CONFIG_UBSAN_SANITIZE_ALL=y, use:
+
+                UBSAN_SANITIZE_main.o := n
+        and:
+                UBSAN_SANITIZE := n
+
+Detection of unaligned accesses controlled through the separate option -
+CONFIG_UBSAN_ALIGNMENT. It's off by default on architectures that support
+unaligned accesses (CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y). One could
+still enable it in config, just note that it will produce a lot of UBSAN
+reports.
+
+References
+----------
+
+[1] - https://gcc.gnu.org/onlinedocs/gcc-4.9.0/gcc/Debugging-Options.html
+[2] - https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
diff -puN Makefile~ubsan-run-time-undefined-behavior-sanity-checker Makefile
--- a/Makefile~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/Makefile
@@ -411,7 +411,7 @@ export MAKE AWK GENKSYMS INSTALLKERNEL P
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
-export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV CFLAGS_KASAN
+export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV CFLAGS_KASAN CFLAGS_UBSAN
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
@@ -778,6 +778,7 @@ endif
 
 include scripts/Makefile.kasan
 include scripts/Makefile.extrawarn
+include scripts/Makefile.ubsan
 
 # Add any arch overrides and user supplied CPPFLAGS, AFLAGS and CFLAGS as the
 # last assignments
diff -puN arch/x86/Kconfig~ubsan-run-time-undefined-behavior-sanity-checker arch/x86/Kconfig
--- a/arch/x86/Kconfig~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/arch/x86/Kconfig
@@ -30,6 +30,7 @@ config X86
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_SG_CHAIN
+	select ARCH_HAS_UBSAN_SANTIZE_ALL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
 	select ARCH_MIGHT_HAVE_PC_PARPORT
diff -puN arch/x86/boot/Makefile~ubsan-run-time-undefined-behavior-sanity-checker arch/x86/boot/Makefile
--- a/arch/x86/boot/Makefile~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/arch/x86/boot/Makefile
@@ -60,6 +60,7 @@ clean-files += cpustr.h
 KBUILD_CFLAGS	:= $(USERINCLUDE) $(REALMODE_CFLAGS) -D_SETUP
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
 
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
diff -puN arch/x86/boot/compressed/Makefile~ubsan-run-time-undefined-behavior-sanity-checker arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/arch/x86/boot/compressed/Makefile
@@ -33,6 +33,7 @@ KBUILD_CFLAGS += $(call cc-option,-fno-s
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
+UBSAN_SANITIZE :=n
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
diff -puN arch/x86/entry/vdso/Makefile~ubsan-run-time-undefined-behavior-sanity-checker arch/x86/entry/vdso/Makefile
--- a/arch/x86/entry/vdso/Makefile~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/arch/x86/entry/vdso/Makefile
@@ -4,6 +4,7 @@
 
 KBUILD_CFLAGS += $(DISABLE_LTO)
 KASAN_SANITIZE := n
+UBSAN_SANITIZE := n
 
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
diff -puN arch/x86/realmode/rm/Makefile~ubsan-run-time-undefined-behavior-sanity-checker arch/x86/realmode/rm/Makefile
--- a/arch/x86/realmode/rm/Makefile~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/arch/x86/realmode/rm/Makefile
@@ -70,3 +70,4 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) $(REALM
 		   -I$(srctree)/arch/x86/boot
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
diff -puN drivers/firmware/efi/libstub/Makefile~ubsan-run-time-undefined-behavior-sanity-checker drivers/firmware/efi/libstub/Makefile
--- a/drivers/firmware/efi/libstub/Makefile~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/drivers/firmware/efi/libstub/Makefile
@@ -22,6 +22,7 @@ KBUILD_CFLAGS			:= $(cflags-y) \
 
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
+UBSAN_SANITIZE			:= n
 
 lib-y				:= efi-stub-helper.o
 
diff -puN include/linux/sched.h~ubsan-run-time-undefined-behavior-sanity-checker include/linux/sched.h
--- a/include/linux/sched.h~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/include/linux/sched.h
@@ -1629,6 +1629,9 @@ struct task_struct {
 	struct held_lock held_locks[MAX_LOCK_DEPTH];
 	gfp_t lockdep_reclaim_gfp;
 #endif
+#ifdef CONFIG_UBSAN
+	unsigned int in_ubsan;
+#endif
 
 /* journalling filesystem info */
 	void *journal_info;
diff -puN lib/Kconfig.debug~ubsan-run-time-undefined-behavior-sanity-checker lib/Kconfig.debug
--- a/lib/Kconfig.debug~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/lib/Kconfig.debug
@@ -1860,3 +1860,4 @@ source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
 
+source "lib/Kconfig.ubsan"
diff -puN /dev/null lib/Kconfig.ubsan
--- /dev/null
+++ a/lib/Kconfig.ubsan
@@ -0,0 +1,29 @@
+config ARCH_HAS_UBSAN_SANTIZE_ALL
+	bool
+
+config UBSAN
+	bool "Undefined behaviour sanity checker"
+	help
+	  This option enables undefined behaviour sanity checker
+	  Compile-time instrumentation is used to detect various undefined
+	  behaviours in runtime. Various types of checks may be enabled
+	  via boot parameter ubsan_handle (see: Documentation/ubsan.txt).
+
+config UBSAN_SANITIZE_ALL
+	bool "Enable instrumentation for the entire kernel"
+	depends on UBSAN
+	depends on ARCH_HAS_UBSAN_SANTIZE_ALL
+	default y
+	help
+	  This option activates instrumentation for the entire kernel.
+	  If you don't enable this option, you have to explicitly specify
+	  UBSAN_SANITIZE := y for the files/directories you want to check for UB.
+
+config UBSAN_ALIGNMENT
+	bool "Enable checking of pointers alignment"
+	depends on UBSAN
+	default y if !HAVE_EFFICIENT_UNALIGNED_ACCESS
+	help
+	  This option enables detection of unaligned memory accesses.
+	  Enabling this option on architectures that support unalligned
+	  accesses may produce a lot of false positives.
diff -puN lib/Makefile~ubsan-run-time-undefined-behavior-sanity-checker lib/Makefile
--- a/lib/Makefile~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/lib/Makefile
@@ -209,3 +209,6 @@ quiet_cmd_build_OID_registry = GEN     $
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+obj-$(CONFIG_UBSAN) += ubsan.o
+
+UBSAN_SANITIZE_ubsan.o := n
diff -puN /dev/null lib/ubsan.c
--- /dev/null
+++ a/lib/ubsan.c
@@ -0,0 +1,456 @@
+/*
+ * UBSAN error reporting functions
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Andrey Ryabinin <ryabinin.a.a@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/bug.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+
+#include "ubsan.h"
+
+const char *type_check_kinds[] = {
+	"load of",
+	"store to",
+	"reference binding to",
+	"member access within",
+	"member call on",
+	"constructor call on",
+	"downcast of",
+	"downcast of"
+};
+
+#define REPORTED_BIT 31
+
+#if (BITS_PER_LONG == 64) && defined(__BIG_ENDIAN)
+#define COLUMN_MASK (~(1U << REPORTED_BIT))
+#define LINE_MASK   (~0U)
+#else
+#define COLUMN_MASK   (~0U)
+#define LINE_MASK (~(1U << REPORTED_BIT))
+#endif
+
+#define VALUE_LENGTH 40
+
+static bool was_reported(struct source_location *location)
+{
+	return test_and_set_bit(REPORTED_BIT, &location->reported);
+}
+
+static void print_source_location(const char *prefix,
+				struct source_location *loc)
+{
+	pr_err("%s %s:%d:%d\n", prefix, loc->file_name,
+		loc->line & LINE_MASK, loc->column & COLUMN_MASK);
+}
+
+static bool suppress_report(struct source_location *loc)
+{
+	return current->in_ubsan || was_reported(loc);
+}
+
+static bool type_is_int(struct type_descriptor *type)
+{
+	return type->type_kind == type_kind_int;
+}
+
+static bool type_is_signed(struct type_descriptor *type)
+{
+	WARN_ON(!type_is_int(type));
+	return  type->type_info & 1;
+}
+
+static unsigned type_bit_width(struct type_descriptor *type)
+{
+	return 1 << (type->type_info >> 1);
+}
+
+static bool is_inline_int(struct type_descriptor *type)
+{
+	unsigned inline_bits = sizeof(unsigned long)*8;
+	unsigned bits = type_bit_width(type);
+
+	WARN_ON(!type_is_int(type));
+
+	return bits <= inline_bits;
+}
+
+static s_max get_signed_val(struct type_descriptor *type, unsigned long val)
+{
+	if (is_inline_int(type)) {
+		unsigned extra_bits = sizeof(s_max)*8 - type_bit_width(type);
+		return ((s_max)val) << extra_bits >> extra_bits;
+	}
+
+	if (type_bit_width(type) == 64)
+		return *(s64 *)val;
+
+	return *(s_max *)val;
+}
+
+static bool val_is_negative(struct type_descriptor *type, unsigned long val)
+{
+	return type_is_signed(type) && get_signed_val(type, val) < 0;
+}
+
+static u_max get_unsigned_val(struct type_descriptor *type, unsigned long val)
+{
+	if (is_inline_int(type))
+		return val;
+
+	if (type_bit_width(type) == 64)
+		return *(u64 *)val;
+
+	return *(u_max *)val;
+}
+
+static void val_to_string(char *str, size_t size, struct type_descriptor *type,
+	unsigned long value)
+{
+	u_max val = get_unsigned_val(type, value);
+
+	if (type_is_int(type)) {
+		if (type_bit_width(type) == 128) {
+#ifdef CONFIG_ARCH_SUPPORTS_INT128
+			scnprintf(str, size, "0x%08x%08x%08x%08x",
+				(u32)(val >> 96),
+				(u32)(val >> 64),
+				(u32)(val >> 32),
+				(u32)(val));
+#else
+			WARN_ON(1);
+#endif
+		} else if (type_is_signed(type)) {
+			scnprintf(str, size, "%lld",
+				(s64)get_signed_val(type, value));
+		} else {
+			scnprintf(str, size, "%llu",
+				(u64)get_unsigned_val(type, value));
+		}
+	}
+}
+
+static bool location_is_valid(struct source_location *loc)
+{
+	return loc->file_name != NULL;
+}
+
+static DEFINE_SPINLOCK(report_lock);
+
+static void ubsan_prologue(struct source_location *location,
+			unsigned long *flags)
+{
+	current->in_ubsan++;
+	spin_lock_irqsave(&report_lock, *flags);
+
+	pr_err("========================================"
+		"========================================\n");
+	print_source_location("UBSAN: Undefined behaviour in", location);
+}
+
+static void ubsan_epilogue(unsigned long *flags)
+{
+	dump_stack();
+	pr_err("========================================"
+		"========================================\n");
+	spin_unlock_irqrestore(&report_lock, *flags);
+	current->in_ubsan--;
+}
+
+static void handle_overflow(struct overflow_data *data, unsigned long lhs,
+			unsigned long rhs, char op)
+{
+
+	struct type_descriptor *type = data->type;
+	unsigned long flags;
+	char lhs_val_str[VALUE_LENGTH];
+	char rhs_val_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
+	val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
+	pr_err("%s integer overflow:\n",
+		type_is_signed(type) ? "signed" : "unsigned");
+	pr_err("%s %c %s cannot be represented in type %s\n",
+		lhs_val_str,
+		op,
+		rhs_val_str,
+		type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+
+void __ubsan_handle_add_overflow(struct overflow_data *data,
+				unsigned long lhs,
+				unsigned long rhs)
+{
+
+	handle_overflow(data, lhs, rhs, '+');
+}
+EXPORT_SYMBOL(__ubsan_handle_add_overflow);
+
+void __ubsan_handle_sub_overflow(struct overflow_data *data,
+				unsigned long lhs,
+				unsigned long rhs)
+{
+	handle_overflow(data, lhs, rhs, '-');
+}
+EXPORT_SYMBOL(__ubsan_handle_sub_overflow);
+
+void __ubsan_handle_mul_overflow(struct overflow_data *data,
+				unsigned long lhs,
+				unsigned long rhs)
+{
+	handle_overflow(data, lhs, rhs, '*');
+}
+EXPORT_SYMBOL(__ubsan_handle_mul_overflow);
+
+void __ubsan_handle_negate_overflow(struct overflow_data *data,
+				unsigned long old_val)
+{
+	unsigned long flags;
+	char old_val_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
+
+	pr_err("negation of %s cannot be represented in type %s:\n",
+		old_val_str, data->type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
+
+
+void __ubsan_handle_divrem_overflow(struct overflow_data *data,
+				unsigned long lhs,
+				unsigned long rhs)
+{
+	unsigned long flags;
+	char rhs_val_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(rhs_val_str, sizeof(rhs_val_str), data->type, rhs);
+
+	if (type_is_signed(data->type) && get_signed_val(data->type, rhs) == -1)
+		pr_err("division of %s by -1 cannot be represented in type %s\n",
+			rhs_val_str, data->type->type_name);
+	else
+		pr_err("division by zero\n");
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_divrem_overflow);
+
+static void handle_null_ptr_deref(struct type_mismatch_data *data)
+{
+	unsigned long flags;
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	pr_err("%s null pointer of type %s\n",
+		type_check_kinds[data->type_check_kind],
+		data->type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+
+static void handle_missaligned_access(struct type_mismatch_data *data,
+				unsigned long ptr)
+{
+	unsigned long flags;
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	pr_err("%s misaligned address %p for type %s\n",
+		type_check_kinds[data->type_check_kind],
+		(void *)ptr, data->type->type_name);
+	pr_err("which requires %ld byte alignment\n", data->alignment);
+
+	ubsan_epilogue(&flags);
+}
+
+static void handle_object_size_mismatch(struct type_mismatch_data *data,
+					unsigned long ptr)
+{
+	unsigned long flags;
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+	pr_err("%s address %pk with insufficient space\n",
+		type_check_kinds[data->type_check_kind],
+		(void *) ptr);
+	pr_err("for an object of type %s\n", data->type->type_name);
+	ubsan_epilogue(&flags);
+}
+
+void __ubsan_handle_type_mismatch(struct type_mismatch_data *data,
+				unsigned long ptr)
+{
+
+	if (!ptr)
+		handle_null_ptr_deref(data);
+	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment))
+		handle_missaligned_access(data, ptr);
+	else
+		handle_object_size_mismatch(data, ptr);
+}
+EXPORT_SYMBOL(__ubsan_handle_type_mismatch);
+
+void __ubsan_handle_nonnull_return(struct nonnull_return_data *data)
+{
+	unsigned long flags;
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	pr_err("null pointer returned from function declared to never return null\n");
+
+	if (location_is_valid(&data->attr_location))
+		print_source_location("returns_nonnull attribute specified in",
+				&data->attr_location);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_nonnull_return);
+
+void __ubsan_handle_vla_bound_not_positive(struct vla_bound_data *data,
+					unsigned long bound)
+{
+	unsigned long flags;
+	char bound_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(bound_str, sizeof(bound_str), data->type, bound);
+	pr_err("variable length array bound value %s <= 0\n", bound_str);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_vla_bound_not_positive);
+
+void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data,
+				unsigned long index)
+{
+	unsigned long flags;
+	char index_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(index_str, sizeof(index_str), data->index_type, index);
+	pr_err("index %s is out of range for type %s\n", index_str,
+		data->array_type->type_name);
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_out_of_bounds);
+
+void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
+					unsigned long lhs, unsigned long rhs)
+{
+	unsigned long flags;
+	struct type_descriptor *rhs_type = data->rhs_type;
+	struct type_descriptor *lhs_type = data->lhs_type;
+	char rhs_str[VALUE_LENGTH];
+	char lhs_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(rhs_str, sizeof(rhs_str), rhs_type, rhs);
+	val_to_string(lhs_str, sizeof(lhs_str), lhs_type, lhs);
+
+	if (val_is_negative(rhs_type, rhs))
+		pr_err("shift exponent %s is negative\n", rhs_str);
+
+	else if (get_unsigned_val(rhs_type, rhs) >=
+		type_bit_width(lhs_type))
+		pr_err("shift exponent %s is too large for %u-bit type %s\n",
+			rhs_str,
+			type_bit_width(lhs_type),
+			lhs_type->type_name);
+	else if (val_is_negative(lhs_type, lhs))
+		pr_err("left shift of negative value %s\n",
+			lhs_str);
+	else
+		pr_err("left shift of %s by %s places cannot be"
+			" represented in type %s\n",
+			lhs_str, rhs_str,
+			lhs_type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
+
+void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
+{
+	unsigned long flags;
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+	pr_err("calling __builtin_unreachable()\n");
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_builtin_unreachable);
+
+void __ubsan_handle_load_invalid_value(struct invalid_value_data *data,
+				unsigned long val)
+{
+	unsigned long flags;
+	char val_str[VALUE_LENGTH];
+
+	if (suppress_report(&data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(val_str, sizeof(val_str), data->type, val);
+
+	pr_err("load of value %s is not a valid value for type %s\n",
+		val_str, data->type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_load_invalid_value);
diff -puN /dev/null lib/ubsan.h
--- /dev/null
+++ a/lib/ubsan.h
@@ -0,0 +1,84 @@
+#ifndef _LIB_UBSAN_H
+#define _LIB_UBSAN_H
+
+enum {
+	type_kind_int = 0,
+	type_kind_float = 1,
+	type_unknown = 0xffff
+};
+
+struct type_descriptor {
+	u16 type_kind;
+	u16 type_info;
+	char type_name[1];
+};
+
+struct source_location {
+	const char *file_name;
+	union {
+		unsigned long reported;
+		struct {
+			u32 line;
+			u32 column;
+		};
+	};
+};
+
+struct overflow_data {
+	struct source_location location;
+	struct type_descriptor *type;
+};
+
+struct type_mismatch_data {
+	struct source_location location;
+	struct type_descriptor *type;
+	unsigned long alignment;
+	unsigned char type_check_kind;
+};
+
+struct nonnull_arg_data {
+	struct source_location location;
+	struct source_location attr_location;
+	int arg_index;
+};
+
+struct nonnull_return_data {
+	struct source_location location;
+	struct source_location attr_location;
+};
+
+struct vla_bound_data {
+	struct source_location location;
+	struct type_descriptor *type;
+};
+
+struct out_of_bounds_data {
+	struct source_location location;
+	struct type_descriptor *array_type;
+	struct type_descriptor *index_type;
+};
+
+struct shift_out_of_bounds_data {
+	struct source_location location;
+	struct type_descriptor *lhs_type;
+	struct type_descriptor *rhs_type;
+};
+
+struct unreachable_data {
+	struct source_location location;
+};
+
+struct invalid_value_data {
+	struct source_location location;
+	struct type_descriptor *type;
+};
+
+#ifdef CONFIG_ARCH_SUPPORTS_INT128
+typedef __int128 s_max;
+typedef unsigned __int128 u_max;
+#else
+typedef s64 s_max;
+typedef u64 u_max;
+#endif
+
+#endif
diff -puN mm/kasan/Makefile~ubsan-run-time-undefined-behavior-sanity-checker mm/kasan/Makefile
--- a/mm/kasan/Makefile~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/mm/kasan/Makefile
@@ -1,4 +1,5 @@
 KASAN_SANITIZE := n
+UBSAN_SANITIZE_kasan.o := n
 
 CFLAGS_REMOVE_kasan.o = -pg
 # Function splitter causes unnecessary splits in __asan_load1/__asan_store1
diff -puN scripts/Makefile.lib~ubsan-run-time-undefined-behavior-sanity-checker scripts/Makefile.lib
--- a/scripts/Makefile.lib~ubsan-run-time-undefined-behavior-sanity-checker
+++ a/scripts/Makefile.lib
@@ -129,6 +129,12 @@ _c_flags += $(if $(patsubst n%,, \
 		$(CFLAGS_KASAN))
 endif
 
+ifeq ($(CONFIG_UBSAN),y)
+_c_flags += $(if $(patsubst n%,, \
+		$(UBSAN_SANITIZE_$(basetarget).o)$(UBSAN_SANITIZE)$(CONFIG_UBSAN_SANITIZE_ALL)), \
+		$(CFLAGS_UBSAN))
+endif
+
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
 
diff -puN /dev/null scripts/Makefile.ubsan
--- /dev/null
+++ a/scripts/Makefile.ubsan
@@ -0,0 +1,18 @@
+ifdef CONFIG_UBSAN
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=shift)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=integer-divide-by-zero)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=unreachable)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=vla-bound)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=null)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=signed-integer-overflow)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds-strict)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=object-size)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=returns-nonnull-attribute)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=enum)
+
+ifdef CONFIG_UBSAN_ALIGNMENT
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
+endif
+endif
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

kernel-printk-specify-alignment-for-struct-printk_log.patch
mac80211-prevent-build-failure-with-config_ubsan=y.patch
ubsan-run-time-undefined-behavior-sanity-checker.patch

