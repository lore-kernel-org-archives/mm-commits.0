From: akpm@linux-foundation.org
Subject: + lib-string_helpersc-constify-static-arrays.patch added to -mm
 tree
Date: Tue, 17 Jun 2014 15:49:22 -0700
Message-ID: <53a0c5f2.4BjZCDZuNDbf7rJ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215AbaFQWtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 18:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, James.Bottomley@HansenPartnership.com, minipli@googlemail.com


The patch titled
     Subject: lib/string_helpers.c: constify static arrays
has been added to the -mm tree.  Its filename is
     lib-string_helpersc-constify-static-arrays.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpersc-constify-static-arrays.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpersc-constify-static-arrays.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: lib/string_helpers.c: constify static arrays

Complement commit 68aecfb979 ("lib/string_helpers.c: make arrays
static") by making the arrays const -- not only pointing to const
strings. This moves them out of the data section to the r/o data
section:

   text    data     bss     dec     hex filename
   1150     176       0    1326     52e lib/string_helpers.old.o
   1326       0       0    1326     52e lib/string_helpers.new.o

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN lib/string_helpers.c~lib-string_helpersc-constify-static-arrays lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpersc-constify-static-arrays
+++ a/lib/string_helpers.c
@@ -25,12 +25,15 @@
 int string_get_size(u64 size, const enum string_size_units units,
 		    char *buf, int len)
 {
-	static const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
-				   "EB", "ZB", "YB", NULL};
-	static const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
-				 "EiB", "ZiB", "YiB", NULL };
-	static const char **units_str[] = {
-		[STRING_UNITS_10] =  units_10,
+	static const char *const units_10[] = {
+		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB", NULL
+	};
+	static const char *const units_2[] = {
+		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
+		NULL
+	};
+	static const char *const *const units_str[] = {
+		[STRING_UNITS_10] = units_10,
 		[STRING_UNITS_2] = units_2,
 	};
 	static const unsigned int divisor[] = {
_

Patches currently in -mm which might be from minipli@googlemail.com are

lib-string_helpersc-constify-static-arrays.patch
linux-next.patch

