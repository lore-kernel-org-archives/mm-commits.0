From: akpm@linux-foundation.org
Subject: + add-testcases-for-memset16-32-64.patch added to -mm tree
Date: Wed, 02 Aug 2017 13:56:54 -0700
Message-ID: <59823c96.9/ogwkNmCX8Awyu7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdHBU5N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, minchan@kernel.org, mingo@elte.hu, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: add testcases for memset16/32/64
has been added to the -mm tree.  Its filename is
     add-testcases-for-memset16-32-64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-testcases-for-memset16-32-64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-testcases-for-memset16-32-64.patch

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
Subject: lib/string.c: add testcases for memset16/32/64

Link: http://lkml.kernel.org/r/20170720184539.31609-3-willy@infradead.org
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

 lib/Kconfig  |    3 +
 lib/string.c |  130 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)

diff -puN lib/Kconfig~add-testcases-for-memset16-32-64 lib/Kconfig
--- a/lib/Kconfig~add-testcases-for-memset16-32-64
+++ a/lib/Kconfig
@@ -575,4 +575,7 @@ config PARMAN
 config PRIME_NUMBERS
 	tristate
 
+config STRING_SELFTEST
+	bool "Test string functions"
+
 endmenu
diff -puN lib/string.c~add-testcases-for-memset16-32-64 lib/string.c
--- a/lib/string.c~add-testcases-for-memset16-32-64
+++ a/lib/string.c
@@ -1050,3 +1050,133 @@ void fortify_overflow(const char *name)
 	WARN(1, "detected buffer overflow in %s\n", name);
 }
 EXPORT_SYMBOL(fortify_overflow);
+
+#ifdef CONFIG_STRING_SELFTEST
+#include <linux/slab.h>
+#include <linux/module.h>
+
+static __init int memset16_selftest(void)
+{
+	unsigned i, j, k;
+	u16 v, *p = kmalloc(256 * 2 * 2, GFP_KERNEL);
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 256; j++) {
+			memset(p, 0xa1, 256 * 2 * sizeof(v));
+			memset16(p + i, 0xb1b2, j);
+			for (k = 0; k < 512; k++) {
+				v = p[k];
+				if (k < i) {
+					if (v != 0xa1a1)
+						goto fail;
+				} else if (k < i + j) {
+					if (v != 0xb1b2)
+						goto fail;
+				} else {
+					if (v != 0xa1a1)
+						goto fail;
+				}
+			}
+		}
+	}
+
+fail:
+	kfree(p);
+	if (i < 256)
+		return (i << 24) | (j << 16) | k;
+	return 0;
+}
+
+static __init int memset32_selftest(void)
+{
+	unsigned i, j, k;
+	u32 v, *p = kmalloc(256 * 2 * 4, GFP_KERNEL);
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 256; j++) {
+			memset(p, 0xa1, 256 * 2 * sizeof(v));
+			memset32(p + i, 0xb1b2b3b4, j);
+			for (k = 0; k < 512; k++) {
+				v = p[k];
+				if (k < i) {
+					if (v != 0xa1a1a1a1)
+						goto fail;
+				} else if (k < i + j) {
+					if (v != 0xb1b2b3b4)
+						goto fail;
+				} else {
+					if (v != 0xa1a1a1a1)
+						goto fail;
+				}
+			}
+		}
+	}
+
+fail:
+	kfree(p);
+	if (i < 256)
+		return (i << 24) | (j << 16) | k;
+	return 0;
+}
+
+static __init int memset64_selftest(void)
+{
+	unsigned i, j, k;
+	u64 v, *p = kmalloc(256 * 2 * 8, GFP_KERNEL);
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 256; j++) {
+			memset(p, 0xa1, 256 * 2 * sizeof(v));
+			memset64(p + i, 0xb1b2b3b4b5b6b7b8ULL, j);
+			for (k = 0; k < 512; k++) {
+				v = p[k];
+				if (k < i) {
+					if (v != 0xa1a1a1a1a1a1a1a1ULL)
+						goto fail;
+				} else if (k < i + j) {
+					if (v != 0xb1b2b3b4b5b6b7b8ULL)
+						goto fail;
+				} else {
+					if (v != 0xa1a1a1a1a1a1a1a1ULL)
+						goto fail;
+				}
+			}
+		}
+	}
+
+fail:
+	kfree(p);
+	if (i < 256)
+		return (i << 24) | (j << 16) | k;
+	return 0;
+	return 0;
+}
+
+static __init int string_selftest_init(void)
+{
+	int test, subtest;
+
+	test = 1;
+	subtest = memset16_selftest();
+	if (subtest)
+		goto fail;
+
+	test = 2;
+	subtest = memset32_selftest();
+	if (subtest)
+		goto fail;
+
+	test = 3;
+	subtest = memset64_selftest();
+	if (subtest)
+		goto fail;
+
+	pr_info("String selftests succeeded\n");
+	return 0;
+fail:
+	pr_crit("String selftest failure %d.%08x\n", test, subtest);
+	return 0;
+}
+
+module_init(string_selftest_init);
+#endif
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

