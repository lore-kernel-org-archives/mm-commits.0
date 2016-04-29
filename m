From: akpm@linux-foundation.org
Subject: + byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix.patch
 added to -mm tree
Date: Fri, 29 Apr 2016 11:33:49 -0700
Message-ID: <5723a90d.PPg+fCP4qdKXvJ86%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbcD2Sdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 14:33:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpoimboe@redhat.com, arnd@arndb.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix
has been added to the -mm tree.  Its filename is
     byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix

We probably need to add a (__u64) cast to the return value of
__builtin_bswap64(), like:

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/swab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix include/uapi/linux/swab.h
--- a/include/uapi/linux/swab.h~byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix
+++ a/include/uapi/linux/swab.h
@@ -123,7 +123,7 @@ static inline __attribute_const__ __u32
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP64__
-#define __swab64(x) __builtin_bswap64((__u64)(x))
+#define __swab64(x) (__u64)__builtin_bswap64((__u64)(x))
 #else
 #define __swab64(x)				\
 	(__builtin_constant_p((__u64)(x)) ?	\
_

Patches currently in -mm which might be from jpoimboe@redhat.com are

byteswap-try-to-avoid-__builtin_constant_p-gcc-bug-fix.patch

