From: akpm@linux-foundation.org
Subject: + lib-add-lib-gcdc.patch added to -mm tree
Date: Thu, 04 Jun 2009 15:37:36 -0700
Message-ID: <200906042237.n54Mba8Y010079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbZFDWiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 18:38:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org, davem@davemloft.net, horms@verge.net.au, juliusv@google.com, sshtylyov@ru.mvista.com, tiwai@suse.de


The patch titled
     lib: add lib/gcd.c
has been added to the -mm tree.  Its filename is
     lib-add-lib-gcdc.patch

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
Subject: lib: add lib/gcd.c
From: Florian Fainelli <florian@openwrt.org>

This patch adds lib/gcd.c which contains a greatest common divider
implementation taken from sound/core/pcm_timer.c

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julius Volz <juliusv@google.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gcd.h |    8 ++++++++
 lib/Kconfig         |    3 +++
 lib/Makefile        |    1 +
 lib/gcd.c           |   20 ++++++++++++++++++++
 4 files changed, 32 insertions(+)

diff -puN /dev/null include/linux/gcd.h
--- /dev/null
+++ a/include/linux/gcd.h
@@ -0,0 +1,8 @@
+#ifndef _GCD_H
+#define _GCD_H
+
+#include <linux/compiler.h>
+
+unsigned long gcd(unsigned long a, unsigned long b) __attribute_const__;
+
+#endif /* _GCD_H */
diff -puN lib/Kconfig~lib-add-lib-gcdc lib/Kconfig
--- a/lib/Kconfig~lib-add-lib-gcdc
+++ a/lib/Kconfig
@@ -10,6 +10,9 @@ menu "Library routines"
 config BITREVERSE
 	tristate
 
+config GCD
+	bool
+
 config GENERIC_FIND_FIRST_BIT
 	bool
 
diff -puN lib/Makefile~lib-add-lib-gcdc lib/Makefile
--- a/lib/Makefile~lib-add-lib-gcdc
+++ a/lib/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_CRC_ITU_T)	+= crc-itu-t.o
 obj-$(CONFIG_CRC32)	+= crc32.o
 obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
+obj-$(CONFIG_GCD)	+= gcd.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
diff -puN /dev/null lib/gcd.c
--- /dev/null
+++ a/lib/gcd.c
@@ -0,0 +1,20 @@
+#include <linux/gcd.h>
+#include <linux/module.h>
+
+/* Greatest common divisor */
+unsigned long gcd(unsigned long a, unsigned long b)
+{
+	unsigned long r;
+
+	if (a < b) {
+		r = a;
+		a = b;
+		b = r;
+	}
+	while ((r = a % b) != 0) {
+		a = b;
+		b = r;
+	}
+	return b;
+}
+EXPORT_SYMBOL_GPL(gcd);
_

Patches currently in -mm which might be from florian@openwrt.org are

linux-next.patch
lib-add-lib-gcdc.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch

