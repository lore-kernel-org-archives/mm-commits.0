From: akpm@linux-foundation.org
Subject: [to-be-updated] lib-vsprintf-simplify-uuid-printing.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:57:03 -0700
Message-ID: <570434af.wYr9ojqzkfbmz0PP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760506AbcDEV5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:57:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: simplify UUID printing
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-simplify-uuid-printing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/vsprintf: simplify UUID printing

There are few functions here and there along with type definitions that
provide UUID API.  This series consolidates everything under one hood and
converts two current users.


This patch (of 8):

Since we have hex_byte_pack_upper() we may use it directly and avoid second
loop.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
