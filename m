From: akpm@linux-foundation.org
Subject: + fix-compilation-of-drivers-with-o0.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:32 -0800
Message-ID: <200702272058.l1RKwamT028394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbXB0U6y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:58:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xschmi00@stud.feec.vutbr.cz, mschmidt@redhat.com


The patch titled
     Fix compilation of drivers with -O0
has been added to the -mm tree.  Its filename is
     fix-compilation-of-drivers-with-o0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix compilation of drivers with -O0
From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>

It is sometimes useful to compile individual drivers with optimization
disabled for easier debugging.  Currently drivers which use htonl() and
similar functions don't compile with -O0.  This patch fixes it.  It also
removes obsolete and misleading comments.  This header is not for
userspace, so we don't have to care about strange programs these comments
mention.

(akpm: -O0 probably isn't a good idea, but this code looks pretty crufty and
unuseful)

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/generic.h |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN include/linux/byteorder/generic.h~fix-compilation-of-drivers-with-o0 include/linux/byteorder/generic.h
--- a/include/linux/byteorder/generic.h~fix-compilation-of-drivers-with-o0
+++ a/include/linux/byteorder/generic.h
@@ -124,19 +124,8 @@
 #define be32_to_cpus __be32_to_cpus
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
-#endif
 
-
-#if defined(__KERNEL__)
 /*
- * Handle ntohl and suches. These have various compatibility
- * issues - like we want to give the prototype even though we
- * also have a macro for them in case some strange program
- * wants to take the address of the thing or something..
- *
- * Note that these used to return a "long" in libc5, even though
- * long is often 64-bit these days.. Thus the casts.
- *
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
  * it is no longer constant according to gcc..
@@ -147,17 +136,6 @@
 #undef htonl
 #undef htons
 
-/*
- * Do the prototypes. Somebody might want to take the
- * address or some such sick thing..
- */
-extern __u32			ntohl(__be32);
-extern __be32			htonl(__u32);
-extern __u16			ntohs(__be16);
-extern __be16			htons(__u16);
-
-#if defined(__GNUC__) && defined(__OPTIMIZE__)
-
 #define ___htonl(x) __cpu_to_be32(x)
 #define ___htons(x) __cpu_to_be16(x)
 #define ___ntohl(x) __be32_to_cpu(x)
@@ -168,9 +146,6 @@ extern __be16			htons(__u16);
 #define htons(x) ___htons(x)
 #define ntohs(x) ___ntohs(x)
 
-#endif /* OPTIMIZE */
-
 #endif /* KERNEL */
 
-
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
_

Patches currently in -mm which might be from xschmi00@stud.feec.vutbr.cz are

fix-compilation-of-drivers-with-o0.patch
