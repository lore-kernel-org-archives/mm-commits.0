From: akpm@linux-foundation.org
Subject: +
 lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch added
 to -mm tree
Date: Tue, 01 Dec 2015 15:39:18 -0800
Message-ID: <565e2fa6.BffFjr9m72E88cte%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbbLAXjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 18:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: warn about too large precisions and field widths
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: warn about too large precisions and field widths

The field width is overloaded to pass some extra information for some %p
extensions (e.g.  #bits for %pb).  But we might silently truncate the
passed value when we stash it in struct printf_spec (see e.g. 
"lib/vsprintf.c: expand field_width to 24 bits").  Hopefully 23 value bits
should now be enough for everybody, but if not, let's make some noise.

Do the same for the precision.  In both cases, clamping seems more
sensible than truncating.  A negative precision is the same as 0, so use
that as lower bound.  For the field width, the smallest representable
value is actually -(1<<23), but a negative field width means 'set the LEFT
flag and use the absolute value', so we want the absolute value to fit.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-warn-about-too-large-precisions-and-field-widths lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-warn-about-too-large-precisions-and-field-widths
+++ a/lib/vsprintf.c
@@ -386,6 +386,8 @@ struct printf_spec {
 	unsigned int	base:8;		/* number base, 8, 10 or 16 only */
 	signed int	precision:16;	/* # of digits/chars */
 };
+#define FIELD_WIDTH_MAX ((1 << 23) - 1)
+#define PRECISION_MAX ((1 << 15) - 1)
 extern char __check_printf_spec[1-2*(sizeof(struct printf_spec) != 8)];
 
 static noinline_for_stack
@@ -1815,6 +1817,24 @@ qualifier:
 	return ++fmt - start;
 }
 
+static inline void
+set_field_width(struct printf_spec *spec, int width)
+{
+	spec->field_width = width;
+	if (WARN_ONCE(spec->field_width != width, "field width %d too large", width)) {
+		spec->field_width = clamp(width, -FIELD_WIDTH_MAX, FIELD_WIDTH_MAX);
+	}
+}
+
+static inline void
+set_precision(struct printf_spec *spec, int prec)
+{
+	spec->precision = prec;
+	if (WARN_ONCE(spec->precision != prec, "precision %d too large", prec)) {
+		spec->precision = clamp(prec, 0, PRECISION_MAX);
+	}
+}
+
 /**
  * vsnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
@@ -1882,11 +1902,11 @@ int vsnprintf(char *buf, size_t size, co
 		}
 
 		case FORMAT_TYPE_WIDTH:
-			spec.field_width = va_arg(args, int);
+			set_field_width(&spec, va_arg(args, int));
 			break;
 
 		case FORMAT_TYPE_PRECISION:
-			spec.precision = va_arg(args, int);
+			set_precision(&spec, va_arg(args, int));
 			break;
 
 		case FORMAT_TYPE_CHAR: {
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch
lib-vsprintfc-move-string-below-widen_string.patch
lib-vsprintfc-eliminate-potential-race-in-string.patch
lib-vsprintfc-expand-field_width-to-24-bits.patch
lib-vsprintfc-help-gcc-make-number-smaller.patch
lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch
lib-test_printfc-dont-bug.patch
lib-test_printfc-check-for-out-of-bound-writes.patch
lib-test_printfc-add-a-few-string-tests.patch
lib-test_printfc-account-for-kvasprintf-tests.patch
lib-test_printfc-add-test-for-large-bitmaps.patch
lib-test_printfc-test-dentry-printing.patch
lib-kasprintfc-add-sanity-check-to-kvasprintf.patch
powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

