From: akpm@linux-foundation.org
Subject: + byteswap-try-to-avoid-__builtin_constant_p-gcc-bug.patch added
 to -mm tree
Date: Thu, 28 Apr 2016 15:19:46 -0700
Message-ID: <57228c82.1TTeoshHFayyObDd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcD1WTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2016 18:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, James.Bottomley@hansenpartnership.com, dvlasenk@redhat.com, himanshu.madhani@qlogic.com, hubicka@ucw.cz, jpoimboe@redhat.com, martin.petersen@oracle.com, mingo@kernel.org, mjambor@suse.cz, peterz@infradead.org, quinn.tran@qlogic.com, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: byteswap: try to avoid __builtin_constant_p gcc bug
has been added to the -mm tree.  Its filename is
     byteswap-try-to-avoid-__builtin_constant_p-gcc-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/byteswap-try-to-avoid-__builtin_constant_p-gcc-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/byteswap-try-to-avoid-__builtin_constant_p-gcc-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: byteswap: try to avoid __builtin_constant_p gcc bug

This is another attempt to avoid a regression in wwn_to_u64() after that
started using get_unaligned_be64(), which in turn ran into a bug on
gcc-4.9 through 6.1.

As part of the problem is how __builtin_constant_p gets evaluated on an
argument passed by reference into an inline function, this avoids the use
of __builtin_constant_p() for all architectures that set
CONFIG_ARCH_USE_BUILTIN_BSWAP.  Most architectures do not set
ARCH_SUPPORTS_OPTIMIZED_INLINING, which means they probably do not suffer
from the problem in the qla2xxx driver, but they might still run into it
elsewhere.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Quinn Tran <quinn.tran@qlogic.com>
Cc: Martin Jambor <mjambor@suse.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Jan Hubicka <hubicka@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/swab.h |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug include/uapi/linux/swab.h
--- a/include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug
+++ a/include/uapi/linux/swab.h
@@ -45,9 +45,7 @@
 
 static inline __attribute_const__ __u16 __fswab16(__u16 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP16__
-	return __builtin_bswap16(val);
-#elif defined (__arch_swab16)
+#if defined (__arch_swab16)
 	return __arch_swab16(val);
 #else
 	return ___constant_swab16(val);
@@ -56,9 +54,7 @@ static inline __attribute_const__ __u16
 
 static inline __attribute_const__ __u32 __fswab32(__u32 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP32__
-	return __builtin_bswap32(val);
-#elif defined(__arch_swab32)
+#if defined(__arch_swab32)
 	return __arch_swab32(val);
 #else
 	return ___constant_swab32(val);
@@ -67,9 +63,7 @@ static inline __attribute_const__ __u32
 
 static inline __attribute_const__ __u64 __fswab64(__u64 val)
 {
-#ifdef __HAVE_BUILTIN_BSWAP64__
-	return __builtin_bswap64(val);
-#elif defined (__arch_swab64)
+#if defined (__arch_swab64)
 	return __arch_swab64(val);
 #elif defined(__SWAB_64_THRU_32__)
 	__u32 h = val >> 32;
@@ -102,28 +96,40 @@ static inline __attribute_const__ __u32
  * __swab16 - return a byteswapped 16-bit value
  * @x: value to byteswap
  */
+#ifdef __HAVE_BUILTIN_BSWAP16__
+#define __swab16(x) __builtin_bswap16((__u16)(x))
+#else
 #define __swab16(x)				\
 	(__builtin_constant_p((__u16)(x)) ?	\
 	___constant_swab16(x) :			\
 	__fswab16(x))
+#endif
 
 /**
  * __swab32 - return a byteswapped 32-bit value
  * @x: value to byteswap
  */
+#ifdef __HAVE_BUILTIN_BSWAP32__
+#define __swab32(x) __builtin_bswap32((__u32)(x))
+#else
 #define __swab32(x)				\
 	(__builtin_constant_p((__u32)(x)) ?	\
 	___constant_swab32(x) :			\
 	__fswab32(x))
+#endif
 
 /**
  * __swab64 - return a byteswapped 64-bit value
  * @x: value to byteswap
  */
+#ifdef __HAVE_BUILTIN_BSWAP64__
+#define __swab64(x) __builtin_bswap64((__u64)(x))
+#else
 #define __swab64(x)				\
 	(__builtin_constant_p((__u64)(x)) ?	\
 	___constant_swab64(x) :			\
 	__fswab64(x))
+#endif
 
 /**
  * __swahw32 - return a word-swapped 32-bit value
_

Patches currently in -mm which might be from arnd@arndb.de are

byteswap-try-to-avoid-__builtin_constant_p-gcc-bug.patch
kernel-padata-hide-unused-functions.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix.patch

