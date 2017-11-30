From: akpm@linux-foundation.org
Subject: [merged] printk-hash-addresses-printed-with-%p.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:19:40 -0800
Message-ID: <20171130201940.KIwEcVM6P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52738 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdK3UTm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, cfries@google.com, danielmicay@gmail.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, Golden_Miller83@protonmail.ch, gregkh@linuxfoundation.org, ijc@hellion.org.uk, Jason@zx2c4.com, joe@perches.com, keescook@chromium.org, me@tobin.cc, mm-commits@vger.kernel.org, olorin@google.com, pbonzini@redhat.com, pmladek@suse.com, rkrcmar@redhat.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, sfr@canb.auug.org.au, tixxdz@gmail.com, tj@kernel.org, tycho@tycho.ws, tytso@mit.edu, will.deacon@arm.com, william.c.roberts@intel.com


The patch titled
     Subject: printk: hash addresses printed with %p
has been removed from the -mm tree.  Its filename was
     printk-hash-addresses-printed-with-%p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Tobin C. Harding" <me@tobin.cc>
Subject: printk: hash addresses printed with %p

Currently there exist approximately 14 000 places in the kernel where
addresses are being printed using an unadorned %p.  This potentially leaks
sensitive information regarding the Kernel layout in memory.  Many of
these calls are stale, instead of fixing every call lets hash the address
by default before printing.  This will of course break some users, forcing
code printing needed addresses to be updated.

Code that _really_ needs the address will soon be able to use the new
printk specifier %px to print the address.

For what it's worth, usage of unadorned %p can be broken down as
follows (thanks to Joe Perches).

$ git grep -E '%p[^A-Za-z0-9]' | cut -f1 -d"/" | sort | uniq -c
   1084 arch
     20 block
     10 crypto
     32 Documentation
   8121 drivers
   1221 fs
    143 include
    101 kernel
     69 lib
    100 mm
   1510 net
     40 samples
      7 scripts
     11 security
    166 sound
    152 tools
      2 virt

Add function ptr_to_id() to map an address to a 32 bit unique identifier. 
Hash any unadorned usage of specifier %p and any malformed specifiers.

Link: http://lkml.kernel.org/r/1511921105-3647-4-git-send-email-me@tobin.cc
Signed-off-by: Tobin C. Harding <me@tobin.cc>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Fries <cfries@google.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Dave Weinstein <olorin@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Djalal Harouni <tixxdz@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Ian Campbell <ijc@hellion.org.uk>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   12 ++-
 lib/test_printf.c                |  108 ++++++++++++++++++-----------
 lib/vsprintf.c                   |   81 +++++++++++++++++++--
 3 files changed, 155 insertions(+), 46 deletions(-)

diff -puN Documentation/printk-formats.txt~printk-hash-addresses-printed-with-%p Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~printk-hash-addresses-printed-with-%p
+++ a/Documentation/printk-formats.txt
@@ -5,7 +5,6 @@ How to get printk format specifiers righ
 :Author: Randy Dunlap <rdunlap@infradead.org>
 :Author: Andrew Murray <amurray@mpc-data.co.uk>
 
-
 Integer types
 =============
 
@@ -45,6 +44,17 @@ return from vsnprintf.
 Raw pointer value SHOULD be printed with %p. The kernel supports
 the following extended format specifiers for pointer types:
 
+Pointer Types
+=============
+
+Pointers printed without a specifier extension (i.e unadorned %p) are
+hashed to give a unique identifier without leaking kernel addresses to user
+space. On 64 bit machines the first 32 bits are zeroed.
+
+::
+
+	%p	abcdef12 or 00000000abcdef12
+
 Symbols/Function Pointers
 =========================
 
diff -puN lib/test_printf.c~printk-hash-addresses-printed-with-%p lib/test_printf.c
--- a/lib/test_printf.c~printk-hash-addresses-printed-with-%p
+++ a/lib/test_printf.c
@@ -24,24 +24,6 @@
 #define PAD_SIZE 16
 #define FILL_CHAR '$'
 
-#define PTR1 ((void*)0x01234567)
-#define PTR2 ((void*)(long)(int)0xfedcba98)
-
-#if BITS_PER_LONG == 64
-#define PTR1_ZEROES "000000000"
-#define PTR1_SPACES "         "
-#define PTR1_STR "1234567"
-#define PTR2_STR "fffffffffedcba98"
-#define PTR_WIDTH 16
-#else
-#define PTR1_ZEROES "0"
-#define PTR1_SPACES " "
-#define PTR1_STR "1234567"
-#define PTR2_STR "fedcba98"
-#define PTR_WIDTH 8
-#endif
-#define PTR_WIDTH_STR stringify(PTR_WIDTH)
-
 static unsigned total_tests __initdata;
 static unsigned failed_tests __initdata;
 static char *test_buffer __initdata;
@@ -217,30 +199,79 @@ test_string(void)
 	test("a  |   |   ", "%-3.s|%-3.0s|%-3.*s", "a", "b", 0, "c");
 }
 
+#define PLAIN_BUF_SIZE 64	/* leave some space so we don't oops */
+
+#if BITS_PER_LONG == 64
+
+#define PTR_WIDTH 16
+#define PTR ((void *)0xffff0123456789ab)
+#define PTR_STR "ffff0123456789ab"
+#define ZEROS "00000000"	/* hex 32 zero bits */
+
+static int __init
+plain_format(void)
+{
+	char buf[PLAIN_BUF_SIZE];
+	int nchars;
+
+	nchars = snprintf(buf, PLAIN_BUF_SIZE, "%p", PTR);
+
+	if (nchars != PTR_WIDTH || strncmp(buf, ZEROS, strlen(ZEROS)) != 0)
+		return -1;
+
+	return 0;
+}
+
+#else
+
+#define PTR_WIDTH 8
+#define PTR ((void *)0x456789ab)
+#define PTR_STR "456789ab"
+
+static int __init
+plain_format(void)
+{
+	/* Format is implicitly tested for 32 bit machines by plain_hash() */
+	return 0;
+}
+
+#endif	/* BITS_PER_LONG == 64 */
+
+static int __init
+plain_hash(void)
+{
+	char buf[PLAIN_BUF_SIZE];
+	int nchars;
+
+	nchars = snprintf(buf, PLAIN_BUF_SIZE, "%p", PTR);
+
+	if (nchars != PTR_WIDTH || strncmp(buf, PTR_STR, PTR_WIDTH) == 0)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * We can't use test() to test %p because we don't know what output to expect
+ * after an address is hashed.
+ */
 static void __init
 plain(void)
 {
-	test(PTR1_ZEROES PTR1_STR " " PTR2_STR, "%p %p", PTR1, PTR2);
-	/*
-	 * The field width is overloaded for some %p extensions to
-	 * pass another piece of information. For plain pointers, the
-	 * behaviour is slightly odd: One cannot pass either the 0
-	 * flag nor a precision to %p without gcc complaining, and if
-	 * one explicitly gives a field width, the number is no longer
-	 * zero-padded.
-	 */
-	test("|" PTR1_STR PTR1_SPACES "  |  " PTR1_SPACES PTR1_STR "|",
-	     "|%-*p|%*p|", PTR_WIDTH+2, PTR1, PTR_WIDTH+2, PTR1);
-	test("|" PTR2_STR "  |  " PTR2_STR "|",
-	     "|%-*p|%*p|", PTR_WIDTH+2, PTR2, PTR_WIDTH+2, PTR2);
+	int err;
 
-	/*
-	 * Unrecognized %p extensions are treated as plain %p, but the
-	 * alphanumeric suffix is ignored (that is, does not occur in
-	 * the output.)
-	 */
-	test("|"PTR1_ZEROES PTR1_STR"|", "|%p0y|", PTR1);
-	test("|"PTR2_STR"|", "|%p0y|", PTR2);
+	err = plain_hash();
+	if (err) {
+		pr_warn("plain 'p' does not appear to be hashed\n");
+		failed_tests++;
+		return;
+	}
+
+	err = plain_format();
+	if (err) {
+		pr_warn("hashing plain 'p' has unexpected format\n");
+		failed_tests++;
+	}
 }
 
 static void __init
@@ -251,6 +282,7 @@ symbol_ptr(void)
 static void __init
 kernel_ptr(void)
 {
+	/* We can't test this without access to kptr_restrict. */
 }
 
 static void __init
diff -puN lib/vsprintf.c~printk-hash-addresses-printed-with-%p lib/vsprintf.c
--- a/lib/vsprintf.c~printk-hash-addresses-printed-with-%p
+++ a/lib/vsprintf.c
@@ -33,6 +33,8 @@
 #include <linux/uuid.h>
 #include <linux/of.h>
 #include <net/addrconf.h>
+#include <linux/siphash.h>
+#include <linux/compiler.h>
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
 #endif
@@ -1644,6 +1646,73 @@ char *device_node_string(char *buf, char
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+static bool have_filled_random_ptr_key __read_mostly;
+static siphash_key_t ptr_key __read_mostly;
+
+static void fill_random_ptr_key(struct random_ready_callback *unused)
+{
+	get_random_bytes(&ptr_key, sizeof(ptr_key));
+	/*
+	 * have_filled_random_ptr_key==true is dependent on get_random_bytes().
+	 * ptr_to_id() needs to see have_filled_random_ptr_key==true
+	 * after get_random_bytes() returns.
+	 */
+	smp_mb();
+	WRITE_ONCE(have_filled_random_ptr_key, true);
+}
+
+static struct random_ready_callback random_ready = {
+	.func = fill_random_ptr_key
+};
+
+static int __init initialize_ptr_random(void)
+{
+	int ret = add_random_ready_callback(&random_ready);
+
+	if (!ret) {
+		return 0;
+	} else if (ret == -EALREADY) {
+		fill_random_ptr_key(&random_ready);
+		return 0;
+	}
+
+	return ret;
+}
+early_initcall(initialize_ptr_random);
+
+/* Maps a pointer to a 32 bit unique identifier. */
+static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
+{
+	unsigned long hashval;
+	const int default_width = 2 * sizeof(ptr);
+
+	if (unlikely(!have_filled_random_ptr_key)) {
+		spec.field_width = default_width;
+		/* string length must be less than default_width */
+		return string(buf, end, "(ptrval)", spec);
+	}
+
+#ifdef CONFIG_64BIT
+	hashval = (unsigned long)siphash_1u64((u64)ptr, &ptr_key);
+	/*
+	 * Mask off the first 32 bits, this makes explicit that we have
+	 * modified the address (and 32 bits is plenty for a unique ID).
+	 */
+	hashval = hashval & 0xffffffff;
+#else
+	hashval = (unsigned long)siphash_1u32((u32)ptr, &ptr_key);
+#endif
+
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = default_width;
+		spec.flags |= ZEROPAD;
+	}
+	spec.base = 16;
+
+	return number(buf, end, hashval, spec);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -1754,6 +1823,9 @@ char *device_node_string(char *buf, char
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Note: The default behaviour (unadorned %p) is to hash the address,
+ * rendering it useful as a unique identifier.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1869,14 +1941,9 @@ char *pointer(const char *fmt, char *buf
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
 	}
-	spec.flags |= SMALL;
-	if (spec.field_width == -1) {
-		spec.field_width = default_width;
-		spec.flags |= ZEROPAD;
-	}
-	spec.base = 16;
 
-	return number(buf, end, (unsigned long) ptr, spec);
+	/* default is to _not_ leak addresses, hash before printing */
+	return ptr_to_id(buf, end, ptr, spec);
 }
 
 /*
_

Patches currently in -mm which might be from me@tobin.cc are


