From: akpm@linux-foundation.org
Subject: + lib-move-find_last_bit-to-lib-find_next_bitc.patch added to -mm tree
Date: Mon, 23 Feb 2015 16:40:46 -0800
Message-ID: <54ebc88e.dfxDMS2rZ0ZHFfsa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbBXAks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 19:40:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yury.norov@gmail.com, chris@chris-wilson.co.uk, davem@davemloft.net, dborkman@redhat.com, hannes@stressinduktion.org, klimov.linux@gmail.com, laijs@cn.fujitsu.com, linux@horizon.com, linux@rasmusvillemoes.dk, msalter@redhat.com, takahiro.akashi@linaro.org, tgraf@suug.ch, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: move find_last_bit to lib/find_next_bit.c
has been added to the -mm tree.  Its filename is
     lib-move-find_last_bit-to-lib-find_next_bitc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-move-find_last_bit-to-lib-find_next_bitc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-move-find_last_bit-to-lib-find_next_bitc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: move find_last_bit to lib/find_next_bit.c

Currently all 'find_*_bit' family is located in lib/find_next_bit.c,
except 'find_last_bit', which is in lib/find_last_bit.c. It seems,
there's no major benefit to have it separated.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: George Spelvin <linux@horizon.com>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile        |    2 +-
 lib/find_next_bit.c |   27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff -puN lib/Makefile~lib-move-find_last_bit-to-lib-find_next_bitc lib/Makefile
--- a/lib/Makefile~lib-move-find_last_bit-to-lib-find_next_bitc
+++ a/lib/Makefile
@@ -25,7 +25,7 @@ obj-y	+= lockref.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o clz_ctz.o \
-	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
+	 bsearch.o find_next_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o percpu_ida.o rhashtable.o reciprocal_div.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
diff -puN lib/find_next_bit.c~lib-move-find_last_bit-to-lib-find_next_bitc lib/find_next_bit.c
--- a/lib/find_next_bit.c~lib-move-find_last_bit-to-lib-find_next_bitc
+++ a/lib/find_next_bit.c
@@ -1,8 +1,12 @@
-/* find_next_bit.c: fallback find next bit implementation
+/* bit search implementation
  *
  * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
+ * Copyright (C) 2008 IBM Corporation
+ * 'find_last_bit' is written by Rusty Russell <rusty@rustcorp.com.au>
+ * (Inspired by David Howell's find_next_bit implementation)
+ *
  * Rewritten by Yury Norov <yury.norov@gmail.com> to decrease
  * size and improve performance, 2015.
  *
@@ -13,6 +17,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 
@@ -106,6 +111,26 @@ unsigned long find_first_zero_bit(const
 EXPORT_SYMBOL(find_first_zero_bit);
 #endif
 
+#ifndef find_last_bit
+unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
+{
+	if (size) {
+		unsigned long val = BITMAP_LAST_WORD_MASK(size);
+		unsigned long idx = (size-1) / BITS_PER_LONG;
+
+		do {
+			val &= addr[idx];
+			if (val)
+				return idx * BITS_PER_LONG + __fls(val);
+
+			val = ~0ul;
+		} while (idx--);
+	}
+	return size;
+}
+EXPORT_SYMBOL(find_last_bit);
+#endif
+
 #ifdef __BIG_ENDIAN
 
 /* include/linux/byteorder does not support "unsigned long" type */
_

Patches currently in -mm which might be from yury.norov@gmail.com are

linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch

