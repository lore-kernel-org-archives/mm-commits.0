From: akpm@linux-foundation.org
Subject: [merged]
 compiler-gcc-require-gcc-48-for-powerpc-__builtin_bswap16.patch removed
 from -mm tree
Date: Tue, 10 May 2016 10:30:52 -0700
Message-ID: <57321acc.aGSEOE7nTf1sQtYg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcEJRax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 13:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpoimboe@redhat.com, arnd@arndb.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc: require gcc 4.8 for powerpc __builtin_bswap16()
has been removed from the -mm tree.  Its filename was
     compiler-gcc-require-gcc-48-for-powerpc-__builtin_bswap16.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: compiler-gcc: require gcc 4.8 for powerpc __builtin_bswap16()

gcc support for __builtin_bswap16() was supposedly added for powerpc in
gcc 4.6, and was then later added for other architectures in gcc 4.8.

However, Stephen Rothwell reported that attempting to use it on powerpc in
gcc 4.6 fails with:

lib/vsprintf.c:160:2: error: initializer element is not constant
lib/vsprintf.c:160:2: error: (near initialization for 'decpair[0]')
lib/vsprintf.c:160:2: error: initializer element is not constant
lib/vsprintf.c:160:2: error: (near initialization for 'decpair[1]')
lib/vsprintf.c:160:2: error: initializer element is not constant
lib/vsprintf.c:160:2: error: (near initialization for 'decpair[2]')
lib/vsprintf.c:160:2: error: initializer element is not constant
lib/vsprintf.c:160:2: error: (near initialization for 'decpair[3]')
lib/vsprintf.c:160:2: error: initializer element is not constant

I'm not entirely sure what those errors mean, but I don't see them on gcc
4.8.  So let's consider gcc 4.8 to be the official starting point for
__builtin_bswap16().

Arnd Bergmann adds:

"I found the commit in gcc-4.8 that replaced the powerpc-specific
implementation of __builtin_bswap16 with an architecture-independent one. 
Apparently the powerpc version (gcc-4.6 and 4.7) just mapped to the
lhbrx/sthbrx instructions, so it ended up not being a constant, though the
intent of the patch was mainly to add support for the builtin to x86.

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52624 has the patch that went
into gcc-4.8 and more information."

Fixes: 7322dd755e7d ("byteswap: try to avoid __builtin_constant_p gcc bug")
Link: http://lkml.kernel.org/r/20160509203616.2c5a6ebc@canb.auug.org.au
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~compiler-gcc-require-gcc-48-for-powerpc-__builtin_bswap16 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcc-require-gcc-48-for-powerpc-__builtin_bswap16
+++ a/include/linux/compiler-gcc.h
@@ -246,7 +246,7 @@
 #define __HAVE_BUILTIN_BSWAP32__
 #define __HAVE_BUILTIN_BSWAP64__
 #endif
-#if GCC_VERSION >= 40800 || (defined(__powerpc__) && GCC_VERSION >= 40600)
+#if GCC_VERSION >= 40800
 #define __HAVE_BUILTIN_BSWAP16__
 #endif
 #endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
_

Patches currently in -mm which might be from jpoimboe@redhat.com are


