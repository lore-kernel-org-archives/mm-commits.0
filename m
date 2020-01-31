From: akpm@linux-foundation.org
Subject: [merged]
 lib-find_bitc-uninline-helper-_find_next_bit.patch removed from -mm tree
Date: Fri, 31 Jan 2020 15:20:39 -0800
Message-ID: <20200131232039.cT8mEak_I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXUm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allison@lohutok.net, joe@perches.com, mm-commits@vger.kernel.org, tglx@linutronix.de, vilhelm.gray@gmail.com, yury.norov@gmail.com


The patch titled
     Subject: lib/find_bit.c: uninline helper _find_next_bit()
has been removed from the -mm tree.  Its filename was
     lib-find_bitc-uninline-helper-_find_next_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib/find_bit.c: uninline helper _find_next_bit()

It saves 25% of .text for arm64, and more for BE architectures.

Before:
$ size lib/find_bit.o
   text    data     bss     dec     hex filename
   1012      56       0    1068     42c lib/find_bit.o

After:
$ size lib/find_bit.o
   text    data     bss     dec     hex filename
    776      56       0     832     340 lib/find_bit.o

Link: http://lkml.kernel.org/r/20200103202846.21616-3-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Allison Randal <allison@lohutok.net>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_bit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/find_bit.c~lib-find_bitc-uninline-helper-_find_next_bit
+++ a/lib/find_bit.c
@@ -27,7 +27,7 @@
  *    searching it for one bits.
  *  - The optional "addr2", which is anded with "addr1" if present.
  */
-static inline unsigned long _find_next_bit(const unsigned long *addr1,
+static unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
 		unsigned long start, unsigned long invert, unsigned long le)
 {
_

Patches currently in -mm which might be from yury.norov@gmail.com are

lib-string-add-strnchrnul.patch
bitops-more-bits_to_-macros.patch
lib-add-test-for-bitmap_parse.patch
lib-add-test-for-bitmap_parse-fix.patch
lib-make-bitmap_parse_user-a-wrapper-on-bitmap_parse.patch
lib-rework-bitmap_parse.patch
lib-new-testcases-for-bitmap_parse_user.patch
cpumask-dont-calculate-length-of-the-input-string.patch
