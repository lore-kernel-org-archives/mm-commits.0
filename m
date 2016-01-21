From: akpm@linux-foundation.org
Subject: + lib-string_helpers-export-string_units_210-for-others.patch
 added to -mm tree
Date: Thu, 21 Jan 2016 14:37:57 -0800
Message-ID: <56a15dc5.Y28XnepCv0oUoSOG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbcAUWh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:37:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, elliott@hpe.com, hpa@zytor.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: export string_units_{2,10} for others
has been added to the -mm tree.  Its filename is
     lib-string_helpers-export-string_units_210-for-others.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-export-string_units_210-for-others.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-export-string_units_210-for-others.patch

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
Subject: lib/string_helpers: export string_units_{2,10} for others

There is one user coming which would like to use those string arrays. It might
be useful for any other user in the future.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Robert Elliott <elliott@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    6 ++++++
 lib/string_helpers.c           |   21 ++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff -puN include/linux/string_helpers.h~lib-string_helpers-export-string_units_210-for-others include/linux/string_helpers.h
--- a/include/linux/string_helpers.h~lib-string_helpers-export-string_units_210-for-others
+++ a/include/linux/string_helpers.h
@@ -10,6 +10,12 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
+#define STRING_UNITS_10_NUM	9
+#define STRING_UNITS_2_NUM	9
+
+extern const char *const string_units_10[STRING_UNITS_10_NUM];
+extern const char *const string_units_2[STRING_UNITS_2_NUM];
+
 void string_get_size(u64 size, u64 blk_size, enum string_size_units units,
 		     char *buf, int len);
 
diff -puN lib/string_helpers.c~lib-string_helpers-export-string_units_210-for-others lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpers-export-string_units_210-for-others
+++ a/lib/string_helpers.c
@@ -13,6 +13,15 @@
 #include <linux/string.h>
 #include <linux/string_helpers.h>
 
+const char * const string_units_10[STRING_UNITS_10_NUM] = {
+	"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB",
+};
+EXPORT_SYMBOL(string_units_10);
+const char * const string_units_2[STRING_UNITS_2_NUM] = {
+	"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
+};
+EXPORT_SYMBOL(string_units_2);
+
 /**
  * string_get_size - get the size in the specified units
  * @size:	The size to be converted in blocks
@@ -29,15 +38,9 @@
 void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
 		     char *buf, int len)
 {
-	static const char *const units_10[] = {
-		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
-	};
-	static const char *const units_2[] = {
-		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"
-	};
 	static const char *const *const units_str[] = {
-		[STRING_UNITS_10] = units_10,
-		[STRING_UNITS_2] = units_2,
+		[STRING_UNITS_10] = string_units_10,
+		[STRING_UNITS_2] = string_units_2,
 	};
 	static const unsigned int divisor[] = {
 		[STRING_UNITS_10] = 1000,
@@ -115,7 +118,7 @@ void string_get_size(u64 size, u64 blk_s
 	}
 
  out:
-	if (i >= ARRAY_SIZE(units_2))
+	if (i >= STRING_UNITS_2_NUM)
 		unit = "UNK";
 	else
 		unit = units_str[units][i];
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

