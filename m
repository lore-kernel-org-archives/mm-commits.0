From: akpm@linux-foundation.org
Subject: [folded] vsprintf-further-optimize-decimal-conversion-v2.patch removed from -mm tree
Date: Thu, 31 May 2012 16:14:20 -0700
Message-ID: <20120531231420.C0EA7A009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47505 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab2EaXOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:14:22 -0400
Received: by wibhn6 with SMTP id hn6so2789wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:14:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jones@cs.uiowa.edu, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf-further-optimize-decimal-conversion-v2
has been removed from the -mm tree.  Its filename was
     vsprintf-further-optimize-decimal-conversion-v2.patch

This patch was dropped because it was folded into vsprintf-further-optimize-decimal-conversion.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: vsprintf-further-optimize-decimal-conversion-v2

Here is a new version. I also plugged a hole in num_to_str() -
it was assuming it's safe to call put_dec() for num=0.
(We never tripped over it before because the single caller
of num_to_str() takes care of that case).

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Douglas W Jones <jones@cs.uiowa.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitsperlong.h |    4 ++++
 lib/vsprintf.c                    |   15 +++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/bitsperlong.h~vsprintf-further-optimize-decimal-conversion-v2 include/asm-generic/bitsperlong.h
--- a/include/asm-generic/bitsperlong.h~vsprintf-further-optimize-decimal-conversion-v2
+++ a/include/asm-generic/bitsperlong.h
@@ -28,5 +28,9 @@
 #error Inconsistent word size. Check asm/bitsperlong.h
 #endif
 
+#ifndef BITS_PER_LONG_LONG
+#define BITS_PER_LONG_LONG 64
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_BITS_PER_LONG */
diff -puN lib/vsprintf.c~vsprintf-further-optimize-decimal-conversion-v2 lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-further-optimize-decimal-conversion-v2
+++ a/lib/vsprintf.c
@@ -116,7 +116,7 @@ int skip_atoi(const char **s)
  * (with permission from the author, Douglas W. Jones).
  */
 
-#if BITS_PER_LONG != 32 || (~(0ULL)>>1) != ((1ULL<<63)-1)
+#if BITS_PER_LONG != 32 || BITS_PER_LONG_LONG != 64
 /* Formats correctly any integer in [0, 999999999] */
 static noinline_for_stack
 char *put_dec_full9(char *buf, unsigned q)
@@ -215,7 +215,7 @@ char *put_dec_trunc8(char *buf, unsigned
  * Else (if long is 32 bits and long long is 64 bits) we use second one.
  */
 
-#if BITS_PER_LONG != 32 || ((~0ULL)>>1) != ((1ULL<<63)-1)
+#if BITS_PER_LONG != 32 || BITS_PER_LONG_LONG != 64
 
 /* First algorithm: generic */
 
@@ -233,7 +233,7 @@ char *put_dec(char *buf, unsigned long l
 
 #else
 
-/* Second algorithm: valid only for 32-bit longs, 64-bit long longs */
+/* Second algorithm: valid only for 64-bit long longs */
 
 static noinline_for_stack
 char *put_dec_full4(char *buf, unsigned q)
@@ -296,6 +296,7 @@ char *put_dec(char *buf, unsigned long l
 }
 
 #endif
+
 /*
  * Convert passed number to decimal string.
  * Returns the length of string.  On buffer overflow, returns 0.
@@ -307,7 +308,13 @@ int num_to_str(char *buf, int size, unsi
 	char tmp[sizeof(num) * 3];
 	int idx, len;
 
-	len = put_dec(tmp, num) - tmp;
+	/* put_dec() may work incorrectly for num = 0 (generate "", not "0") */
+	if (num <= 9) {
+		tmp[0] = '0' + num;
+		len = 1;
+	} else {
+		len = put_dec(tmp, num) - tmp;
+	}
 
 	if (len > size)
 		return 0;
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
vsprintf-further-optimize-decimal-conversion.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch

