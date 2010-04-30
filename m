From: akpm@linux-foundation.org
Subject: + lib-introduce-common-method-to-convert-hex-digits.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:02:06 -0700
Message-ID: <201004301902.o3UJ28c2005898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934244Ab0D3TDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, duncan.sands@free.fr, ebiederm@xmission.com, gregkh@suse.de, ldm@flatcap.org, lenb@kernel.org, linville@tuxdriver.com, tilman@imap.cc


The patch titled
     lib: introduce common method to convert hex digits
has been added to the -mm tree.  Its filename is
     lib-introduce-common-method-to-convert-hex-digits.patch

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
Subject: lib: introduce common method to convert hex digits
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

hex_to_bin() is a little method which converts hex digit to its actual
value.  There are plenty of places where such functionality is needed.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Tilman Schmidt <tilman@imap.cc>
Cc: Duncan Sands <duncan.sands@free.fr>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Richard Russon (FlatCap)" <ldm@flatcap.org>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 lib/hexdump.c          |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff -puN include/linux/kernel.h~lib-introduce-common-method-to-convert-hex-digits include/linux/kernel.h
--- a/include/linux/kernel.h~lib-introduce-common-method-to-convert-hex-digits
+++ a/include/linux/kernel.h
@@ -373,6 +373,8 @@ static inline char *pack_hex_byte(char *
 	return buf;
 }
 
+extern int hex_to_bin(char ch);
+
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
diff -puN lib/hexdump.c~lib-introduce-common-method-to-convert-hex-digits lib/hexdump.c
--- a/lib/hexdump.c~lib-introduce-common-method-to-convert-hex-digits
+++ a/lib/hexdump.c
@@ -16,6 +16,25 @@ const char hex_asc[] = "0123456789abcdef
 EXPORT_SYMBOL(hex_asc);
 
 /**
+ * hex_to_bin - convert a hex digit to its real value
+ * @ch: ascii character represents hex digit
+ *
+ * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
+ * input.
+ */
+int hex_to_bin(char ch)
+{
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+EXPORT_SYMBOL(hex_to_bin);
+
+/**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
lib-introduce-common-method-to-convert-hex-digits.patch
drivers-isdn-use-new-hex_to_bin-method.patch
usb-atm-speedtch-use-new-hex_to_bin-method.patch
sysctl-dont-use-own-implementation-of-hex_to_bin.patch
staging-rt2860-use-new-hex_to_bin-method.patch
fs-ldm-dont-use-own-implementation-of-hex_to_bin.patch
drivers-wireless-use-new-hex_to_bin-method.patch
drivers-acpi-dont-use-own-implementation-of-hex_to_bin.patch

