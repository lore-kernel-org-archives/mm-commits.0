From: akpm@linux-foundation.org
Subject: [merged] sscanf-implement-basic-character-sets.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:42:43 -0700
Message-ID: <56f040a3.XDQcNTJ3jnb6gAaR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937AbcCUTVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeyu@redhat.com, andriy.shevchenko@linux.intel.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: sscanf: implement basic character sets
has been removed from the -mm tree.  Its filename was
     sscanf-implement-basic-character-sets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jessica Yu <jeyu@redhat.com>
Subject: sscanf: implement basic character sets

Implement basic character sets for the '%[' conversion specifier.

The '%[' conversion specifier matches a nonempty sequence of characters
from the specified set of accepted (or with '^', rejected) characters
between the brackets.  The substring matched is to be made up of
characters in (or not in) the set.  This is useful for matching substrings
that are delimited by something other than spaces.

This implementation differs from its glibc counterpart in the following ways:
(1) No support for character ranges (e.g., 'a-z' or '0-9')
(2) The hyphen '-' is not a special character
(3) The closing bracket ']' cannot be matched
(4) No support (yet) for discarding matching input ('%*[')

The bitmap code is largely based upon sample code which was provided by
Rasmus.


The motivation for adding character set support to sscanf originally
stemmed from the kernel livepatching project.  An ongoing patchset
utilizes new livepatch Elf symbol and section names to store important
metadata livepatch needs to properly apply its patches.  Such metadata
is stored in these section and symbol names as substrings delimited by
periods '.' and commas ','.  For example, a livepatch symbol name might
look like this:

.klp.sym.vmlinux.printk,0

However, sscanf currently can only extract "substrings" delimited by
whitespace using the "%s" specifier.  Thus for the above symbol name,
one cannot not use sscanf() to extract substrings "vmlinux" or
"printk", for example.  A number of discussions on the livepatch
mailing list dealing with string parsing code for extracting these '.'
and ',' delimited substrings eventually led to the conclusion that such
code would be completely unnecessary if the kernel sscanf() supported
character sets.  Thus only a single sscanf() call would be necessary to
extract these substrings.  In addition, such an addition to sscanf()
could benefit other areas of the kernel that might have a similar need
in the future.

[akpm@linux-foundation.org: 80-col tweaks]
Signed-off-by: Jessica Yu <jeyu@redhat.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff -puN lib/vsprintf.c~sscanf-implement-basic-character-sets lib/vsprintf.c
--- a/lib/vsprintf.c~sscanf-implement-basic-character-sets
+++ a/lib/vsprintf.c
@@ -2640,8 +2640,12 @@ int vsscanf(const char *buf, const char
 		if (*fmt == '*') {
 			if (!*str)
 				break;
-			while (!isspace(*fmt) && *fmt != '%' && *fmt)
+			while (!isspace(*fmt) && *fmt != '%' && *fmt) {
+				/* '%*[' not yet supported, invalid format */
+				if (*fmt == '[')
+					return num;
 				fmt++;
+			}
 			while (!isspace(*str) && *str)
 				str++;
 			continue;
@@ -2714,6 +2718,59 @@ int vsscanf(const char *buf, const char
 			num++;
 		}
 		continue;
+		/*
+		 * Warning: This implementation of the '[' conversion specifier
+		 * deviates from its glibc counterpart in the following ways:
+		 * (1) It does NOT support ranges i.e. '-' is NOT a special
+		 *     character
+		 * (2) It cannot match the closing bracket ']' itself
+		 * (3) A field width is required
+		 * (4) '%*[' (discard matching input) is currently not supported
+		 *
+		 * Example usage:
+		 * ret = sscanf("00:0a:95","%2[^:]:%2[^:]:%2[^:]",
+		 *		buf1, buf2, buf3);
+		 * if (ret < 3)
+		 *    // etc..
+		 */
+		case '[':
+		{
+			char *s = (char *)va_arg(args, char *);
+			DECLARE_BITMAP(set, 256) = {0};
+			unsigned int len = 0;
+			bool negate = (*fmt == '^');
+
+			/* field width is required */
+			if (field_width == -1)
+				return num;
+
+			if (negate)
+				++fmt;
+
+			for ( ; *fmt && *fmt != ']'; ++fmt, ++len)
+				set_bit((u8)*fmt, set);
+
+			/* no ']' or no character set found */
+			if (!*fmt || !len)
+				return num;
+			++fmt;
+
+			if (negate) {
+				bitmap_complement(set, set, 256);
+				/* exclude null '\0' byte */
+				clear_bit(0, set);
+			}
+
+			/* match must be non-empty */
+			if (!test_bit((u8)*str, set))
+				return num;
+
+			while (test_bit((u8)*str, set) && field_width--)
+				*s++ = *str++;
+			*s = '\0';
+			++num;
+		}
+		continue;
 		case 'o':
 			base = 8;
 			break;
_

Patches currently in -mm which might be from jeyu@redhat.com are


