From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 uapi-fix-userspace-breakage-use-__bits_per_long-for-swap.patch added to -mm
 tree
Date: Thu, 13 Feb 2020 21:12:41 -0800
Message-ID: <20200214051241.S7QTuFYCo%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgBNFMm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:12:42 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allison@lohutok.net, borntraeger@de.ibm.com, joe@perches.com, mm-commits@vger.kernel.org, tglx@linutronix.de, torsten.hilbrich@secunet.com, vilhelm.gray@gmail.com, yury.norov@gmail.com


The patch titled
     Subject: include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap
has been added to the -mm tree.  Its filename is
     uapi-fix-userspace-breakage-use-__bits_per_long-for-swap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uapi-fix-userspace-breakage-use-__bits_per_long-for-swap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uapi-fix-userspace-breakage-use-__bits_per_long-for-swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from borntraeger@de.ibm.com are

uapi-fix-userspace-breakage-use-__bits_per_long-for-swap.patch
