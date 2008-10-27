From: akpm@linux-foundation.org
Subject: + sparc-use-the-new-byteorder-headers.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:48:31 -0700
Message-ID: <200810272048.m9RKmVcY022676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbYJ0Usv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, davem@davemloft.net


The patch titled
     sparc: use the new byteorder headers
has been added to the -mm tree.  Its filename is
     sparc-use-the-new-byteorder-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/byteorder.h |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN arch/sparc/include/asm/byteorder.h~sparc-use-the-new-byteorder-headers arch/sparc/include/asm/byteorder.h
--- a/arch/sparc/include/asm/byteorder.h~sparc-use-the-new-byteorder-headers
+++ a/arch/sparc/include/asm/byteorder.h
@@ -4,15 +4,14 @@
 #include <asm/types.h>
 #include <asm/asi.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
 
 #ifdef CONFIG_SPARC32
 #define __SWAB_64_THRU_32__
 #endif
 
 #ifdef CONFIG_SPARC64
-
-static inline __u16 ___arch__swab16p(const __u16 *addr)
+static inline __u16 __arch_swab16p(const __u16 *addr)
 {
 	__u16 ret;
 
@@ -21,8 +20,9 @@ static inline __u16 ___arch__swab16p(con
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define __arch_swab16p __arch_swab16p
 
-static inline __u32 ___arch__swab32p(const __u32 *addr)
+static inline __u32 __arch_swab32p(const __u32 *addr)
 {
 	__u32 ret;
 
@@ -31,8 +31,9 @@ static inline __u32 ___arch__swab32p(con
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define __arch_swab32p __arch_swab32p
 
-static inline __u64 ___arch__swab64p(const __u64 *addr)
+static inline __u64 __arch_swab64p(const __u64 *addr)
 {
 	__u64 ret;
 
@@ -41,17 +42,10 @@ static inline __u64 ___arch__swab64p(con
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
-
-#define __arch__swab16p(x) ___arch__swab16p(x)
-#define __arch__swab32p(x) ___arch__swab32p(x)
-#define __arch__swab64p(x) ___arch__swab64p(x)
+#define __arch_swab64p __arch_swab64p
 
 #endif /* CONFIG_SPARC64 */
 
-#define __BYTEORDER_HAS_U64__
-
-#endif
