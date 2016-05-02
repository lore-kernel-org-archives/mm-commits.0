From: akpm@linux-foundation.org
Subject: + byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2.patch
 added to -mm tree
Date: Mon, 02 May 2016 15:13:54 -0700
Message-ID: <5727d122.lH1p/HGfNOzrVz2v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbcEBWN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 May 2016 18:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, James.Bottomley@hansenpartnership.com, dvlasenk@redhat.com, himanshu.madhani@qlogic.com, hubicka@ucw.cz, jpoimboe@redhat.com, martin.petersen@oracle.com, mingo@kernel.org, mjambor@suse.cz, peterz@infradead.org, quinn.tran@qlogic.com, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: byteswap: try to avoid __builtin_constant_p gcc bug
has been added to the -mm tree.  Its filename is
     byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2.patch

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

The regression got introduced due to the combination of two separate
workarounds (e3bde9568d99 ("include/linux/unaligned: force inlining of
byteswap operations") and ef3fb2422ffe ("scsi: fc: use get/put_unaligned64
for wwn access")) that each try to sidestep distinct problems with gcc
behavior (code growth and increased stack usage).  Unfortunately after
both have been applied, a more series gcc bug has been uncovered, leading
to incorrect object code that discards part of a function and causes
undefined behavior.

As part of this problem is how __builtin_constant_p gets evaluated on an
argument passed by reference into an inline function, this avoids the use
of __builtin_constant_p() for all architectures that set
CONFIG_ARCH_USE_BUILTIN_BSWAP.  Most architectures do not set
ARCH_SUPPORTS_OPTIMIZED_INLINING, which means they probably do not suffer
from the problem in the qla2xxx driver, but they might still run into it
elsewhere.

Both of the original workarounds were only merged in the 4.6 kernel, and
the bug that is fixed by this patch should only appear if both are there,
so we probably don't need to backport the fix.  On the other hand, it
works by simplifying the code path and should not have any negative
effects.

Link: https://lkml.org/lkml/headers/2016/4/12/1103
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70232
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646
Fixes: e3bde9568d99 ("include/linux/unaligned: force inlining of byteswap operations")
Fixes: ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")
Link: http://lkml.kernel.org/r/1780465.XdtPJpi8Tt@wuerfel
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Josh Poimboeuf <jpoimboe@redhat.com> # on gcc-5.3
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

diff -puN include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2 include/uapi/linux/swab.h
--- a/include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2
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
+#define __swab64(x) (__u64)__builtin_bswap64((__u64)(x))
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

byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-v2.patch
kernel-padata-hide-unused-functions.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable-fix.patch

