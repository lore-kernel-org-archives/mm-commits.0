From: akpm@linux-foundation.org
Subject: + vsprintfc-use-noinline_for_stack.patch added to -mm tree
Date: Fri, 12 Mar 2010 16:26:07 -0800
Message-ID: <201003130026.o2D0Q70O016707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935231Ab0CMA0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 19:26:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, torvalds@linux-foundation.org


The patch titled
     vsprintf.c: use noinline_for_stack
has been added to the -mm tree.  Its filename is
     vsprintfc-use-noinline_for_stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vsprintf.c: use noinline_for_stack
From: Joe Perches <joe@perches.com>

Mark static functions with noinline_for_stack

Before:

akpm:/usr/src/25> objdump -d lib/vsprintf.o | perl scripts/checkstack.pl
0x00000e82 pointer [vsprintf.o]:                        344
0x0000198c pointer [vsprintf.o]:                        344
0x000025d6 scnprintf [vsprintf.o]:                      216
0x00002648 scnprintf [vsprintf.o]:                      216
0x00002565 snprintf [vsprintf.o]:                       208
0x0000267c sprintf [vsprintf.o]:                        208
0x000030a3 bprintf [vsprintf.o]:                        208
0x00003b1e sscanf [vsprintf.o]:                         208
0x00000608 number [vsprintf.o]:                         136
0x00000937 number [vsprintf.o]:                         136

After:

akpm:/usr/src/25> objdump -d lib/vsprintf.o | perl scripts/checkstack.pl  
0x00000a7c symbol_string [vsprintf.o]:                  248
0x00000ae8 symbol_string [vsprintf.o]:                  248
0x00002310 scnprintf [vsprintf.o]:                      216
0x00002382 scnprintf [vsprintf.o]:                      216
0x0000229f snprintf [vsprintf.o]:                       208
0x000023b6 sprintf [vsprintf.o]:                        208
0x00002ddd bprintf [vsprintf.o]:                        208
0x00003858 sscanf [vsprintf.o]:                         208
0x00000625 number [vsprintf.o]:                         136
0x00000954 number [vsprintf.o]:                         136

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   67 +++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff -puN lib/vsprintf.c~vsprintfc-use-noinline_for_stack lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintfc-use-noinline_for_stack
+++ a/lib/vsprintf.c
@@ -266,7 +266,8 @@ int strict_strtoll(const char *cp, unsig
 }
 EXPORT_SYMBOL(strict_strtoll);
 
-static int skip_atoi(const char **s)
+static noinline_for_stack
+int skip_atoi(const char **s)
 {
 	int i = 0;
 
@@ -286,7 +287,8 @@ static int skip_atoi(const char **s)
 /* Formats correctly any integer in [0,99999].
  * Outputs from one to five digits depending on input.
  * On i386 gcc 4.1.2 -O2: ~250 bytes of code. */
-static char *put_dec_trunc(char *buf, unsigned q)
+static noinline_for_stack
+char *put_dec_trunc(char *buf, unsigned q)
 {
 	unsigned d3, d2, d1, d0;
 	d1 = (q>>4) & 0xf;
@@ -323,7 +325,8 @@ static char *put_dec_trunc(char *buf, un
 	return buf;
 }
 /* Same with if's removed. Always emits five digits */
-static char *put_dec_full(char *buf, unsigned q)
+static noinline_for_stack
+char *put_dec_full(char *buf, unsigned q)
 {
 	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
 	/* but anyway, gcc produces better code with full-sized ints */
@@ -365,7 +368,8 @@ static char *put_dec_full(char *buf, uns
 	return buf;
 }
 /* No inlining helps gcc to use registers better */
-static noinline char *put_dec(char *buf, unsigned long long num)
+static noinline_for_stack
+char *put_dec(char *buf, unsigned long long num)
 {
 	while (1) {
 		unsigned rem;
@@ -416,8 +420,9 @@ struct printf_spec {
 	u8	qualifier;
 };
 
-static char *number(char *buf, char *end, unsigned long long num,
-			struct printf_spec spec)
+static noinline_for_stack
+char *number(char *buf, char *end, unsigned long long num,
+	     struct printf_spec spec)
 {
 	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
 	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
@@ -536,7 +541,8 @@ static char *number(char *buf, char *end
 	return buf;
 }
 
-static char *string(char *buf, char *end, const char *s, struct printf_spec spec)
+static noinline_for_stack
+char *string(char *buf, char *end, const char *s, struct printf_spec spec)
 {
 	int len, i;
 
@@ -566,8 +572,9 @@ static char *string(char *buf, char *end
 	return buf;
 }
 
-static char *symbol_string(char *buf, char *end, void *ptr,
-				struct printf_spec spec, char ext)
+static noinline_for_stack
+char *symbol_string(char *buf, char *end, void *ptr,
+		    struct printf_spec spec, char ext)
 {
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
@@ -587,8 +594,9 @@ static char *symbol_string(char *buf, ch
 #endif
 }
 
-static char *resource_string(char *buf, char *end, struct resource *res,
-				struct printf_spec spec, const char *fmt)
+static noinline_for_stack
+char *resource_string(char *buf, char *end, struct resource *res,
+		      struct printf_spec spec, const char *fmt)
 {
 #ifndef IO_RSRC_PRINTK_SIZE
 #define IO_RSRC_PRINTK_SIZE	6
@@ -689,8 +697,9 @@ static char *resource_string(char *buf, 
 	return string(buf, end, sym, spec);
 }
 
-static char *mac_address_string(char *buf, char *end, u8 *addr,
-				struct printf_spec spec, const char *fmt)
+static noinline_for_stack
+char *mac_address_string(char *buf, char *end, u8 *addr,
+			 struct printf_spec spec, const char *fmt)
 {
 	char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
 	char *p = mac_addr;
@@ -713,7 +722,8 @@ static char *mac_address_string(char *bu
 	return string(buf, end, mac_addr, spec);
 }
 
-static char *ip4_string(char *p, const u8 *addr, const char *fmt)
+static noinline_for_stack
+char *ip4_string(char *p, const u8 *addr, const char *fmt)
 {
 	int i;
 	bool leading_zeros = (fmt[0] == 'i');
@@ -762,7 +772,8 @@ static char *ip4_string(char *p, const u
 	return p;
 }
 
-static char *ip6_compressed_string(char *p, const char *addr)
+static noinline_for_stack
+char *ip6_compressed_string(char *p, const char *addr)
 {
 	int i, j, range;
 	unsigned char zerolength[8];
@@ -842,7 +853,8 @@ static char *ip6_compressed_string(char 
 	return p;
 }
 
-static char *ip6_string(char *p, const char *addr, const char *fmt)
+static noinline_for_stack
+char *ip6_string(char *p, const char *addr, const char *fmt)
 {
 	int i;
 
@@ -857,8 +869,9 @@ static char *ip6_string(char *p, const c
 	return p;
 }
 
-static char *ip6_addr_string(char *buf, char *end, const u8 *addr,
-			     struct printf_spec spec, const char *fmt)
+static noinline_for_stack
+char *ip6_addr_string(char *buf, char *end, const u8 *addr,
+		      struct printf_spec spec, const char *fmt)
 {
 	char ip6_addr[sizeof("xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:255.255.255.255")];
 
@@ -870,8 +883,9 @@ static char *ip6_addr_string(char *buf, 
 	return string(buf, end, ip6_addr, spec);
 }
 
-static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
-			     struct printf_spec spec, const char *fmt)
+static noinline_for_stack
+char *ip4_addr_string(char *buf, char *end, const u8 *addr,
+		      struct printf_spec spec, const char *fmt)
 {
 	char ip4_addr[sizeof("255.255.255.255")];
 
@@ -880,8 +894,9 @@ static char *ip4_addr_string(char *buf, 
 	return string(buf, end, ip4_addr, spec);
 }
 
-static char *uuid_string(char *buf, char *end, const u8 *addr,
-			 struct printf_spec spec, const char *fmt)
+static noinline_for_stack
+char *uuid_string(char *buf, char *end, const u8 *addr,
+		  struct printf_spec spec, const char *fmt)
 {
 	char uuid[sizeof("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")];
 	char *p = uuid;
@@ -969,8 +984,9 @@ static char *uuid_string(char *buf, char
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
  */
-static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
-			struct printf_spec spec)
+static noinline_for_stack
+char *pointer(const char *fmt, char *buf, char *end, void *ptr,
+	      struct printf_spec spec)
 {
 	if (!ptr)
 		return string(buf, end, "(null)", spec);
@@ -1039,7 +1055,8 @@ static char *pointer(const char *fmt, ch
  * @precision: precision of a number
  * @qualifier: qualifier of a number (long, size_t, ...)
  */
-static int format_decode(const char *fmt, struct printf_spec *spec)
+static noinline_for_stack
+int format_decode(const char *fmt, struct printf_spec *spec)
 {
 	const char *start = fmt;
 
_

Patches currently in -mm which might be from joe@perches.com are

fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
drivers-video-via-fix-continuation-line-formats.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

