From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-expand-field_width-to-24-bits.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:15:00 -0800
Message-ID: <569e9944.YPyS/6iSnmdu4oZo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: expand field_width to 24 bits
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-expand-field_width-to-24-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: expand field_width to 24 bits

Maurizio Lombardi reported a problem [1] with the %pb extension: It
doesn't work for sufficiently large bitmaps, since the size is stashed
in the field_width field of the struct printf_spec, which is currently
an s16. Concretely, this manifested itself in
/sys/bus/pseudo/drivers/scsi_debug/map being empty, since the bitmap
printer got a size of 0, which is the 16 bit truncation of the actual
bitmap size.

We do want to keep struct printf_spec at 8 bytes so that it can
cheaply be passed by value. The qualifier field is only used for
internal bookkeeping in format_decode, so we might as well use a local
variable for that. This gives us an additional 8 bits, which we can
then use for the field width.

To stay in 8 bytes, we need to do a little rearranging and make the
type member a bitfield as well. For consistency, change all the
members to bit fields. gcc doesn't generate much worse code with these
changes (in fact, bloat-o-meter says we save 300 bytes - which I think
is a little surprising).

I didn't find a BUILD_BUG/compiletime_assertion/... which would work
outside function context, so for now I just open-coded it.

[1] http://thread.gmane.org/gmane.linux.kernel/2034835

[akpm@linux-foundation.org: avoid open-coded BUILD_BUG_ON]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Maurizio Lombardi <mlombard@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-expand-field_width-to-24-bits lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-expand-field_width-to-24-bits
+++ a/lib/vsprintf.c
@@ -383,13 +383,12 @@ enum format_type {
 };
 
 struct printf_spec {
-	u8	type;		/* format_type enum */
-	u8	flags;		/* flags to number() */
-	u8	base;		/* number base, 8, 10 or 16 only */
-	u8	qualifier;	/* number qualifier, one of 'hHlLtzZ' */
-	s16	field_width;	/* width of output field */
-	s16	precision;	/* # of digits/chars */
-};
+	unsigned int	type:8;		/* format_type enum */
+	signed int	field_width:24;	/* width of output field */
+	unsigned int	flags:8;	/* flags to number() */
+	unsigned int	base:8;		/* number base, 8, 10 or 16 only */
+	signed int	precision:16;	/* # of digits/chars */
+} __packed;
 
 static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
@@ -403,6 +402,8 @@ char *number(char *buf, char *end, unsig
 	int i;
 	bool is_zero = num == 0LL;
 
+	BUILD_BUG_ON(sizeof(struct printf_spec) != 8);
+
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
 	locase = (spec.flags & SMALL);
@@ -1670,6 +1671,7 @@ static noinline_for_stack
 int format_decode(const char *fmt, struct printf_spec *spec)
 {
 	const char *start = fmt;
+	char qualifier;
 
 	/* we finished early by reading the field width */
 	if (spec->type == FORMAT_TYPE_WIDTH) {
@@ -1752,16 +1754,16 @@ precision:
 
 qualifier:
 	/* get the conversion qualifier */
-	spec->qualifier = -1;
+	qualifier = 0;
 	if (*fmt == 'h' || _tolower(*fmt) == 'l' ||
 	    _tolower(*fmt) == 'z' || *fmt == 't') {
-		spec->qualifier = *fmt++;
-		if (unlikely(spec->qualifier == *fmt)) {
-			if (spec->qualifier == 'l') {
-				spec->qualifier = 'L';
+		qualifier = *fmt++;
+		if (unlikely(qualifier == *fmt)) {
+			if (qualifier == 'l') {
+				qualifier = 'L';
 				++fmt;
-			} else if (spec->qualifier == 'h') {
-				spec->qualifier = 'H';
+			} else if (qualifier == 'h') {
+				qualifier = 'H';
 				++fmt;
 			}
 		}
@@ -1818,19 +1820,19 @@ qualifier:
 		return fmt - start;
 	}
 
-	if (spec->qualifier == 'L')
+	if (qualifier == 'L')
 		spec->type = FORMAT_TYPE_LONG_LONG;
-	else if (spec->qualifier == 'l') {
+	else if (qualifier == 'l') {
 		BUILD_BUG_ON(FORMAT_TYPE_ULONG + SIGN != FORMAT_TYPE_LONG);
 		spec->type = FORMAT_TYPE_ULONG + (spec->flags & SIGN);
-	} else if (_tolower(spec->qualifier) == 'z') {
+	} else if (_tolower(qualifier) == 'z') {
 		spec->type = FORMAT_TYPE_SIZE_T;
-	} else if (spec->qualifier == 't') {
+	} else if (qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
-	} else if (spec->qualifier == 'H') {
+	} else if (qualifier == 'H') {
 		BUILD_BUG_ON(FORMAT_TYPE_UBYTE + SIGN != FORMAT_TYPE_BYTE);
 		spec->type = FORMAT_TYPE_UBYTE + (spec->flags & SIGN);
-	} else if (spec->qualifier == 'h') {
+	} else if (qualifier == 'h') {
 		BUILD_BUG_ON(FORMAT_TYPE_USHORT + SIGN != FORMAT_TYPE_SHORT);
 		spec->type = FORMAT_TYPE_USHORT + (spec->flags & SIGN);
 	} else {
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

