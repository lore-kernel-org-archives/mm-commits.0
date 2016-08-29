From: akpm@linux-foundation.org
Subject: [merged] byteswap-dont-use-__builtin_bswap-with-sparse.patch
 removed from -mm tree
Date: Mon, 29 Aug 2016 12:51:11 -0700
Message-ID: <57c4922f.EqLNAFMZLmr39QOr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754029AbcH2TvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 15:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes.berg@intel.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: byteswap: don't use __builtin_bswap*() with sparse
has been removed from the -mm tree.  Its filename was
     byteswap-dont-use-__builtin_bswap-with-sparse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: byteswap: don't use __builtin_bswap*() with sparse

Although sparse declares __builtin_bswap*(), it can't actually do constant
folding inside them (yet).  As such, things like

  switch (protocol) {
  case htons(ETH_P_IP):
          break;
  }

which we do all over the place cause sparse to warn that it expects a
constant instead of a function call.

Disable __HAVE_BUILTIN_BSWAP*__ if __CHECKER__ is defined to
avoid this.

Fixes: 7322dd755e7d ("byteswap: try to avoid __builtin_constant_p gcc bug")
Link: http://lkml.kernel.org/r/1470914102-26389-1-git-send-email-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/compiler-gcc.h~byteswap-dont-use-__builtin_bswap-with-sparse include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~byteswap-dont-use-__builtin_bswap-with-sparse
+++ a/include/linux/compiler-gcc.h
@@ -242,7 +242,11 @@
  */
 #define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
 
-#ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
+/*
+ * sparse (__CHECKER__) pretends to be gcc, but can't do constant
+ * folding in __builtin_bswap*() (yet), so don't set these for it.
+ */
+#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP) && !defined(__CHECKER__)
 #if GCC_VERSION >= 40400
 #define __HAVE_BUILTIN_BSWAP32__
 #define __HAVE_BUILTIN_BSWAP64__
@@ -250,7 +254,7 @@
 #if GCC_VERSION >= 40800
 #define __HAVE_BUILTIN_BSWAP16__
 #endif
-#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP && !__CHECKER__ */
 
 #if GCC_VERSION >= 50000
 #define KASAN_ABI_VERSION 4
_

Patches currently in -mm which might be from johannes.berg@intel.com are

min-max-remove-sparse-warnings-when-theyre-nested.patch

