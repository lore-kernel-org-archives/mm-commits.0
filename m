From: akpm@linux-foundation.org
Subject: + sh-remove-dead-config-symbol-from-sh-code.patch added to -mm tree
Date: Thu, 08 Nov 2007 09:59:23 -0800
Message-ID: <200711081759.lA8HxNnd007215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177AbXKHR71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 12:59:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, lethal@linux-sh.org


The patch titled
     sh: remove dead config symbol from SH code
has been added to the -mm tree.  Its filename is
     sh-remove-dead-config-symbol-from-sh-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sh: remove dead config symbol from SH code
From: Jiri Olsa <olsajiri@gmail.com>

Remove dead config symbols from SH code.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sh/cpu-sh3/timer.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN include/asm-sh/cpu-sh3/timer.h~sh-remove-dead-config-symbol-from-sh-code include/asm-sh/cpu-sh3/timer.h
--- a/include/asm-sh/cpu-sh3/timer.h~sh-remove-dead-config-symbol-from-sh-code
+++ a/include/asm-sh/cpu-sh3/timer.h
@@ -23,8 +23,7 @@
  * ---------------------------------------------------------------------------
  */
 
-#if  !defined(CONFIG_CPU_SUBTYPE_SH7720) && \
-     !defined(CONFIG_CPU_SUBTYPE_SH7727)
+#if  !defined(CONFIG_CPU_SUBTYPE_SH7720)
 #define TMU_TOCR	0xfffffe90	/* Byte access */
 #endif
 
@@ -58,8 +57,7 @@
 #define TMU2_TCOR	0xfffffeac	/* Long access */
 #define TMU2_TCNT	0xfffffeb0	/* Long access */
 #define TMU2_TCR	0xfffffeb4	/* Word access */
-#if !defined(CONFIG_CPU_SUBTYPE_SH7720) && \
-    !defined(CONFIG_CPU_SUBTYPE_SH7727)
+#if !defined(CONFIG_CPU_SUBTYPE_SH7720)
 #define TMU2_TCPR2	0xfffffeb8	/* Long access */
 #endif
 #endif
_

Patches currently in -mm which might be from olsajiri@gmail.com are

drivers-serial-s3c2410c-remove-dead-config-symbols.patch
sh-remove-dead-config-symbol-from-sh-code.patch
blackfin-remove-dead-config-symbol-from-blackfin-code.patch
