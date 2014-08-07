From: akpm@linux-foundation.org
Subject: [merged] lib-string_helpersc-constify-static-arrays.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:47 -0700
Message-ID: <53e3dc93.Pm4KlhCpVzhcVJC3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44392 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaHGUHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:48 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so609513qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers.c: constify static arrays
has been removed from the -mm tree.  Its filename was
     lib-string_helpersc-constify-static-arrays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

