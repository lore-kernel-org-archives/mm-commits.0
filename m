From: akpm@linux-foundation.org
Subject: + optimize-timespec_trunc.patch added to -mm tree
Date: Fri, 02 Mar 2007 16:59:39 -0800
Message-ID: <200703030059.l230xdjI024386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50391 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992825AbXCCBAq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 20:00:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     Optimize timespec_trunc()
has been added to the -mm tree.  Its filename is
     optimize-timespec_trunc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Optimize timespec_trunc()
From: Eric Dumazet <dada1@cosmosbay.com>

The first thing done by timespec_trunc() is :

  if (gran <= jiffies_to_usecs(1) * 1000)

This should really be a test against a constant known at compile time.

Alas, it isnt. jiffies_to_usec() was unilined so C compiler emits a function
call and a multiply to compute : a CONSTANT.

mov    $0x1,%edi
mov    %rbx,0xffffffffffffffe8(%rbp)
mov    %r12,0xfffffffffffffff0(%rbp)
mov    %edx,%ebx
mov    %rsi,0xffffffffffffffc8(%rbp)
mov    %rsi,%r12
callq  ffffffff80232010 <jiffies_to_usecs>
imul   $0x3e8,%eax,%eax
cmp    %ebx,%eax

This patch reorders kernel/time.c a bit so that jiffies_to_usecs() is defined
before timespec_trunc() so that compiler now generates :

cmp    $0x3d0900,%edx  (HZ=250 on my machine)

This gives a better code (timespec_trunc() becoming a leaf function), and
shorter kernel size as well.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |   60 ++++++++++++++++++++++++------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff -puN kernel/time.c~optimize-timespec_trunc kernel/time.c
--- a/kernel/time.c~optimize-timespec_trunc
+++ a/kernel/time.c
@@ -247,6 +247,36 @@ struct timespec current_fs_time(struct s
 }
 EXPORT_SYMBOL(current_fs_time);
 
+/*
+ * Convert jiffies to milliseconds and back.
+ *
+ * Avoid unnecessary multiplications/divisions in the
+ * two most common HZ cases:
+ */
+unsigned int inline jiffies_to_msecs(const unsigned long j)
+{
+#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	return (MSEC_PER_SEC / HZ) * j;
+#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
+	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
+#else
+	return (j * MSEC_PER_SEC) / HZ;
+#endif
+}
+EXPORT_SYMBOL(jiffies_to_msecs);
+
+unsigned int inline jiffies_to_usecs(const unsigned long j)
+{
+#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+	return (USEC_PER_SEC / HZ) * j;
+#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
+	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
+#else
+	return (j * USEC_PER_SEC) / HZ;
+#endif
+}
+EXPORT_SYMBOL(jiffies_to_usecs);
+
 /**
  * timespec_trunc - Truncate timespec to a granularity
  * @t: Timespec
@@ -471,36 +501,6 @@ struct timeval ns_to_timeval(const s64 n
 }
 
 /*
- * Convert jiffies to milliseconds and back.
- *
- * Avoid unnecessary multiplications/divisions in the
- * two most common HZ cases:
- */
-unsigned int jiffies_to_msecs(const unsigned long j)
-{
-#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
-	return (MSEC_PER_SEC / HZ) * j;
-#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
-	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
-#else
-	return (j * MSEC_PER_SEC) / HZ;
-#endif
-}
-EXPORT_SYMBOL(jiffies_to_msecs);
-
-unsigned int jiffies_to_usecs(const unsigned long j)
-{
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
-	return (USEC_PER_SEC / HZ) * j;
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
-#else
-	return (j * USEC_PER_SEC) / HZ;
-#endif
-}
-EXPORT_SYMBOL(jiffies_to_usecs);
-
-/*
  * When we convert to jiffies then we interpret incoming values
  * the following way:
  *
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

optimize-timespec_trunc.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
