From: akpm@linux-foundation.org
Subject: + lib-vsprintf-add-%pe-format-specifier.patch added to -mm tree
Date: Thu, 28 Aug 2014 14:09:09 -0700
Message-ID: <53ff9a75.gmsHb+kdYsWWe48C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45878 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaH1Vpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 17:45:53 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so269962qaq.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 14:45:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: add %*pE[achnops] format specifier
has been added to the -mm tree.  Its filename is
     lib-vsprintf-add-%pe-format-specifier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-add-%pe-format-specifier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-add-%pe-format-specifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/vsprintf: add %*pE[achnops] format specifier

This allows user to print a given buffer as an escaped string.  The rules
are applied according to an optional mix of flags provided by additional
format letters.

For example, if the given buffer is:

	1b 62 20 5c 43 07 22 90 0d 5d

The result strings would be:
	%*pE            "\eb \C\a"\220\r]"
	%*pEhp          "\x1bb \C\x07"\x90\x0d]"
	%*pEa           "\e\142\040\\\103\a\042\220\r\135"

Please, read Documentation/printk-formats.txt and lib/string_helpers.c
kernel documentation to get further information.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Joe Perches <joe@perches.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   32 ++++++++++++
 lib/vsprintf.c                   |   72 +++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff -puN Documentation/printk-formats.txt~lib-vsprintf-add-%pe-format-specifier Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-vsprintf-add-%pe-format-specifier
+++ a/Documentation/printk-formats.txt
@@ -70,6 +70,38 @@ DMA addresses types dma_addr_t:
 	For printing a dma_addr_t type which can vary based on build options,
 	regardless of the width of the CPU data path. Passed by reference.
 
+Raw buffer as an escaped string:
+
+	%*pE[achnops]
+
+	For printing raw buffer as an escaped string. For the following buffer
+
+		1b 62 20 5c 43 07 22 90 0d 5d
+
+	few examples show how the conversion would be done (the result string
+	without surrounding quotes):
+
+		%*pE		"\eb \C\a"\220\r]"
+		%*pEhp		"\x1bb \C\x07"\x90\x0d]"
+		%*pEa		"\e\142\040\\\103\a\042\220\r\135"
+
+	The conversion rules are applied according to an optional combination
+	of flags (see string_escape_mem() kernel documentation for the
+	details):
+		a - ESCAPE_ANY
+		c - ESCAPE_SPECIAL
+		h - ESCAPE_HEX
+		n - ESCAPE_NULL
+		o - ESCAPE_OCTAL
+		p - ESCAPE_NP
+		s - ESCAPE_SPACE
+	By default ESCAPE_ANY_NP is used.
+
+	ESCAPE_ANY_NP is the sane choice for many cases, in particularly for
+	printing SSIDs.
+
+	If field width is omitted the 1 byte only will be escaped.
+
 Raw buffer as a hex string:
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
diff -puN lib/vsprintf.c~lib-vsprintf-add-%pe-format-specifier lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-add-%pe-format-specifier
+++ a/lib/vsprintf.c
@@ -33,6 +33,7 @@
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
 
+#include <linux/string_helpers.h>
 #include "kstrtox.h"
 
 /**
@@ -1101,6 +1102,63 @@ char *ip4_addr_string_sa(char *buf, char
 }
 
 static noinline_for_stack
+char *escaped_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
+		     const char *fmt)
+{
+	bool found = true;
+	int count = 1;
+	unsigned int flags = 0;
+	int len;
+
+	if (spec.field_width == 0)
+		/* nothing to print */
+		return buf;
+
+	if (ZERO_OR_NULL_PTR(addr))
+		/* NULL pointer */
+		return string(buf, end, NULL, spec);
+
+	do {
+		switch (fmt[count++]) {
+		case 'a':
+			flags |= ESCAPE_ANY;
+			break;
+		case 'c':
+			flags |= ESCAPE_SPECIAL;
+			break;
+		case 'h':
+			flags |= ESCAPE_HEX;
+			break;
+		case 'n':
+			flags |= ESCAPE_NULL;
+			break;
+		case 'o':
+			flags |= ESCAPE_OCTAL;
+			break;
+		case 'p':
+			flags |= ESCAPE_NP;
+			break;
+		case 's':
+			flags |= ESCAPE_SPACE;
+			break;
+		default:
+			found = false;
+			break;
+		}
+	} while (found);
+
+	if (!flags)
+		flags = ESCAPE_ANY_NP;
+
+	len = spec.field_width < 0 ? 1 : spec.field_width;
+
+	/* Ignore the error. We print as many characters as we can */
+	string_escape_mem(addr, len, &buf, end - buf, flags, NULL);
+
+	return buf;
+}
+
+static noinline_for_stack
 char *uuid_string(char *buf, char *end, const u8 *addr,
 		  struct printf_spec spec, const char *fmt)
 {
@@ -1236,6 +1294,17 @@ int kptr_restrict __read_mostly;
  * - '[Ii][4S][hnbl]' IPv4 addresses in host, network, big or little endian order
  * - 'I[6S]c' for IPv6 addresses printed as specified by
  *       http://tools.ietf.org/html/rfc5952
+ * - 'E[achnops]' For an escaped buffer, where rules are defined by combination
+ *                of the following flags (see string_escape_mem() for the
+ *                details):
+ *                  a - ESCAPE_ANY
+ *                  c - ESCAPE_SPECIAL
+ *                  h - ESCAPE_HEX
+ *                  n - ESCAPE_NULL
+ *                  o - ESCAPE_OCTAL
+ *                  p - ESCAPE_NP
+ *                  s - ESCAPE_SPACE
+ *                By default ESCAPE_ANY_NP is used.
  * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
  *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  *       Options for %pU are:
@@ -1337,6 +1406,8 @@ char *pointer(const char *fmt, char *buf
 			}}
 		}
 		break;
+	case 'E':
+		return escaped_string(buf, end, ptr, spec, fmt);
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
 	case 'V':
@@ -1651,6 +1722,7 @@ qualifier:
  * %piS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %*pE[achnops] print an escaped buffer
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
  * %n is ignored
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch
linux-next.patch

