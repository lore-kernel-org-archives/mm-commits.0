From: akpm@linux-foundation.org
Subject: [patch 088/162] lib/vsprintf: simplify UUID printing
Date: Fri, 20 May 2016 17:00:54 -0700
Message-ID: <573fa536.rulUtZseLV9aWy6G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcEUAA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, arnd@arndb.de, axboe@kernel.dk, dmitry.kasatkin@gmail.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, viro@zeniv.linux.org.uk, zohar@linux.vnet.ibm.com

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/vsprintf: simplify UUID printing

There are few functions here and there along with type definitions that
provide UUID API.  This series consolidates everything under one hood and
converts current users.

This has been tested for a while internally, however it doesn't mean we
covered all possible cases (especially accuracy of UUID constants after
conversion).  So, please test this as much as you can and provide your
tag.  We appreciate the effort.

The ACPI conversion is postponed for now to sort more generic things out
first.



This patch (of 9):

Since we have hex_byte_pack_upper() we may use it directly and avoid
second loop.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-simplify-uuid-printing lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-simplify-uuid-printing
+++ a/lib/vsprintf.c
@@ -1324,7 +1324,10 @@ char *uuid_string(char *buf, char *end,
 	}
 
 	for (i = 0; i < 16; i++) {
-		p = hex_byte_pack(p, addr[index[i]]);
+		if (uc)
+			p = hex_byte_pack_upper(p, addr[index[i]]);
+		else
+			p = hex_byte_pack(p, addr[index[i]]);
 		switch (i) {
 		case 3:
 		case 5:
@@ -1337,13 +1340,6 @@ char *uuid_string(char *buf, char *end,
 
 	*p = 0;
 
-	if (uc) {
-		p = uuid;
-		do {
-			*p = toupper(*p);
-		} while (*(++p));
-	}
