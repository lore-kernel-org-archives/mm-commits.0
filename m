From: akpm@linux-foundation.org
Subject: + lib-bitmapc-use-hex_to_bin.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:12:38 -0700
Message-ID: <201009072212.o87MCcWh009401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872Ab0IGWNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com


The patch titled
     lib/bitmap.c: use hex_to_bin()
has been added to the -mm tree.  Its filename is
     lib-bitmapc-use-hex_to_bin.patch

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
Subject: lib/bitmap.c: use hex_to_bin()
From: Andy Shevchenko <andy.shevchenko@gmail.com>

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-use-hex_to_bin lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-use-hex_to_bin
+++ a/lib/bitmap.c
@@ -359,7 +359,6 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area
 
 #define CHUNKSZ				32
 #define nbits_to_hold_value(val)	fls(val)
-#define unhex(c)			(isdigit(c) ? (c - '0') : (toupper(c) - 'A' + 10))
 #define BASEDEC 10		/* fancier cpuset lists input in decimal */
 
 /**
@@ -466,7 +465,7 @@ int __bitmap_parse(const char *buf, unsi
 			if (chunk & ~((1UL << (CHUNKSZ - 4)) - 1))
 				return -EOVERFLOW;
 
-			chunk = (chunk << 4) | unhex(c);
+			chunk = (chunk << 4) | hex_to_bin(c);
 			ndigits++; totaldigits++;
 		}
 		if (ndigits == 0)
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
lib-bitmapc-use-hex_to_bin.patch
mmc-make-dev_to_mmc_card-macro-public.patch
mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card.patch

