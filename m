From: akpm@linux-foundation.org
Subject: + bitops-avoid-clang-shift-count-overflow-warnings.patch
 added to -mm tree
Date: Tue, 05 May 2020 12:13:04 -0700
Message-ID: <20200505191304.K2_iaQ7cy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEETNG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 15:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, christian.brauner@ubuntu.com, jpoimboe@redhat.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, ndesaulniers@google.com


The patch titled
     Subject: include/linux/bitops.h: avoid clang shift-count-overflow warnings
has been added to the -mm tree.  Its filename is
     bitops-avoid-clang-shift-count-overflow-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitops-avoid-clang-shift-count-overflow-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitops-avoid-clang-shift-count-overflow-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: include/linux/bitops.h: avoid clang shift-count-overflow warnings

Clang normally does not warn about certain issues in inline functions when
it only happens in an eliminated code path. However if something else
goes wrong, it does tend to complain about the definition of hweight_long()
on 32-bit targets:

include/linux/bitops.h:75:41: error: shift count >= width of type [-Werror,-Wshift-count-overflow]
        return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
                                               ^~~~~~~~~~~~
include/asm-generic/bitops/const_hweight.h:29:49: note: expanded from macro 'hweight64'
 define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
                                                ^~~~~~~~~~~~~~~~~~~~
include/asm-generic/bitops/const_hweight.h:21:76: note: expanded from macro '__const_hweight64'
 define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
                                                                           ^  ~~
include/asm-generic/bitops/const_hweight.h:20:49: note: expanded from macro '__const_hweight32'
 define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
                                                ^
include/asm-generic/bitops/const_hweight.h:19:72: note: expanded from macro '__const_hweight16'
 define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
                                                                       ^
include/asm-generic/bitops/const_hweight.h:12:9: note: expanded from macro '__const_hweight8'
          (!!((w) & (1ULL << 2))) +     \

Adding an explicit cast to __u64 avoids that warning and makes it easier
to read other output.

Link: http://lkml.kernel.org/r/20200505135513.65265-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/bitops.h~bitops-avoid-clang-shift-count-overflow-warnings
+++ a/include/linux/bitops.h
@@ -72,7 +72,7 @@ static inline int get_bitmask_order(unsi
 
 static __always_inline unsigned long hweight_long(unsigned long w)
 {
-	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+	return sizeof(w) == 4 ? hweight32(w) : hweight64((__u64)w);
 }
 
 /**
_

Patches currently in -mm which might be from arnd@arndb.de are

arm64-add-support-for-folded-p4d-page-tables-fix.patch
bitops-avoid-clang-shift-count-overflow-warnings.patch
ubsan-fix-gcc-10-warnings.patch
initramfs-fix-another-section-mismatch.patch
sysctl-fix-unused-function-warning.patch
