From: akpm@linux-foundation.org
Subject: [patch 05/15] include/uapi/linux/swab.h: fix userspace
 breakage, use __BITS_PER_LONG for swap
Date: Thu, 20 Feb 2020 20:04:03 -0800
Message-ID: <20200221040403.L0V_T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgBUEEG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yury.norov@gmail.com, vilhelm.gray@gmail.com, torsten.hilbrich@secunet.com, tglx@linutronix.de, joe@perches.com, allison@lohutok.net, borntraeger@de.ibm.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org

From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap

QEMU has a funny new build error message when I use the upstream kernel
headers:

  CC      block/file-posix.o
In file included from /home/cborntra/REPOS/qemu/include/qemu/timer.h:4,
                 from /home/cborntra/REPOS/qemu/include/qemu/timed-average.h:29,
                 from /home/cborntra/REPOS/qemu/include/block/accounting.h:28,
                 from /home/cborntra/REPOS/qemu/include/block/block_int.h:27,
                 from /home/cborntra/REPOS/qemu/block/file-posix.c:30:
/usr/include/linux/swab.h: In function `__swab':
/home/cborntra/REPOS/qemu/include/qemu/bitops.h:20:34: error: "sizeof" is not defined, evaluates to 0 [-Werror=undef]
   20 | #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PER_BYTE)
      |                                  ^~~~~~
/home/cborntra/REPOS/qemu/include/qemu/bitops.h:20:41: error: missing binary operator before token "("
   20 | #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PER_BYTE)
      |                                         ^
cc1: all warnings being treated as errors
make: *** [/home/cborntra/REPOS/qemu/rules.mak:69: block/file-posix.o] Error 1
rm tests/qemu-iotests/socket_scm_helper.o

This was triggered by commit d5767057c9a ("uapi: rename ext2_swab() to swab() and share globally in swab.h")
This patch is doing
+#include <asm/bitsperlong.h>
but it uses BITS_PER_LONG.

The kernel file asm/bitsperlong.h provide only __BITS_PER_LONG.

Let us use the __ variant in swap.h

Link: http://lkml.kernel.org/r/20200213142147.17604-1-borntraeger@de.ibm.com
Fixes: d5767057c9a ("uapi: rename ext2_swab() to swab() and share globally in swab.h")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/swab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/swab.h~uapi-fix-userspace-breakage-use-__bits_per_long-for-swap
+++ a/include/uapi/linux/swab.h
@@ -135,9 +135,9 @@ static inline __attribute_const__ __u32
 
 static __always_inline unsigned long __swab(const unsigned long y)
 {
-#if BITS_PER_LONG == 64
+#if __BITS_PER_LONG == 64
 	return __swab64(y);
-#else /* BITS_PER_LONG == 32 */
+#else /* __BITS_PER_LONG == 32 */
 	return __swab32(y);
 #endif
 }
_
