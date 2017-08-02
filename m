From: akpm@linux-foundation.org
Subject: + add-multibyte-memset-functions.patch added to -mm tree
Date: Wed, 02 Aug 2017 13:56:51 -0700
Message-ID: <59823c93.s2cKT/XRgZpHYrWF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdHBU5J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, minchan@kernel.org, mingo@elte.hu, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: add multibyte memset functions
has been added to the -mm tree.  Its filename is
     add-multibyte-memset-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-multibyte-memset-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-multibyte-memset-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: lib/string.c: add multibyte memset functions

Patch series "Multibyte memset variations", v4.

A relatively common idiom we're missing is a function to fill an area of
memory with a pattern which is larger than a single byte.  I first noticed
this with a zram patch which wanted to fill a page with an 'unsigned long'
value.  There turn out to be quite a few places in the kernel which can
benefit from using an optimised function rather than a loop; sometimes
text size, sometimes speed, and sometimes both.  The optimised PowerPC
version (not included here) improves performance by about 30% on POWER8 on
just the raw memset_l().

Most of the extra lines of code come from the three testcases I added.


This patch (of 8):

memset16(), memset32() and memset64() are like memset(), but allow the
caller to fill the destination with a value larger than a single byte. 
memset_l() and memset_p() allow the caller to use unsigned long and
pointer values respectively.

Link: http://lkml.kernel.org/r/20170720184539.31609-2-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |   30 +++++++++++++++++
 lib/string.c           |   66 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff -puN include/linux/string.h~add-multibyte-memset-functions include/linux/string.h
--- a/include/linux/string.h~add-multibyte-memset-functions
+++ a/include/linux/string.h
@@ -99,6 +99,36 @@ extern __kernel_size_t strcspn(const cha
 #ifndef __HAVE_ARCH_MEMSET
 extern void * memset(void *,int,__kernel_size_t);
 #endif
+
+#ifndef __HAVE_ARCH_MEMSET16
+extern void *memset16(uint16_t *, uint16_t, __kernel_size_t);
+#endif
+
+#ifndef __HAVE_ARCH_MEMSET32
+extern void *memset32(uint32_t *, uint32_t, __kernel_size_t);
+#endif
+
+#ifndef __HAVE_ARCH_MEMSET64
+extern void *memset64(uint64_t *, uint64_t, __kernel_size_t);
+#endif
+
+static inline void *memset_l(unsigned long *p, unsigned long v,
+		__kernel_size_t n)
+{
+	if (BITS_PER_LONG == 32)
+		return memset32((uint32_t *)p, v, n);
+	else
+		return memset64((uint64_t *)p, v, n);
+}
+
+static inline void *memset_p(void **p, void *v, __kernel_size_t n)
+{
+	if (BITS_PER_LONG == 32)
+		return memset32((uint32_t *)p, (uintptr_t)v, n);
+	else
+		return memset64((uint64_t *)p, (uintptr_t)v, n);
+}
+
 #ifndef __HAVE_ARCH_MEMCPY
 extern void * memcpy(void *,const void *,__kernel_size_t);
 #endif
diff -puN lib/string.c~add-multibyte-memset-functions lib/string.c
--- a/lib/string.c~add-multibyte-memset-functions
+++ a/lib/string.c
@@ -723,6 +723,72 @@ void memzero_explicit(void *s, size_t co
 }
 EXPORT_SYMBOL(memzero_explicit);
 
+#ifndef __HAVE_ARCH_MEMSET16
+/**
+ * memset16() - Fill a memory area with a uint16_t
+ * @s: Pointer to the start of the area.
+ * @v: The value to fill the area with
+ * @count: The number of values to store
+ *
+ * Differs from memset() in that it fills with a uint16_t instead
+ * of a byte.  Remember that @count is the number of uint16_ts to
+ * store, not the number of bytes.
+ */
+void *memset16(uint16_t *s, uint16_t v, size_t count)
+{
+	uint16_t *xs = s;
+
+	while (count--)
+		*xs++ = v;
+	return s;
+}
+EXPORT_SYMBOL(memset16);
+#endif
+
+#ifndef __HAVE_ARCH_MEMSET32
+/**
+ * memset32() - Fill a memory area with a uint32_t
+ * @s: Pointer to the start of the area.
+ * @v: The value to fill the area with
+ * @count: The number of values to store
+ *
+ * Differs from memset() in that it fills with a uint32_t instead
+ * of a byte.  Remember that @count is the number of uint32_ts to
+ * store, not the number of bytes.
+ */
+void *memset32(uint32_t *s, uint32_t v, size_t count)
+{
+	uint32_t *xs = s;
+
+	while (count--)
+		*xs++ = v;
+	return s;
+}
+EXPORT_SYMBOL(memset32);
+#endif
+
+#ifndef __HAVE_ARCH_MEMSET64
+/**
+ * memset64() - Fill a memory area with a uint64_t
+ * @s: Pointer to the start of the area.
+ * @v: The value to fill the area with
+ * @count: The number of values to store
+ *
+ * Differs from memset() in that it fills with a uint64_t instead
+ * of a byte.  Remember that @count is the number of uint64_ts to
+ * store, not the number of bytes.
+ */
+void *memset64(uint64_t *s, uint64_t v, size_t count)
+{
+	uint64_t *xs = s;
+
+	while (count--)
+		*xs++ = v;
+	return s;
+}
+EXPORT_SYMBOL(memset64);
+#endif
+
 #ifndef __HAVE_ARCH_MEMCPY
 /**
  * memcpy - Copy one area of memory to another
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

add-multibyte-memset-functions.patch
add-testcases-for-memset16-32-64.patch
x86-implement-memset16-memset32-memset64.patch
arm-implement-memset32-memset64.patch
alpha-add-support-for-memset16.patch
zram-convert-to-using-memset_l.patch
sym53c8xx_2-convert-to-use-memset32.patch
vga-optimise-console-scrolling.patch

