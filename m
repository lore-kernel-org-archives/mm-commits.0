From: akpm@linux-foundation.org
Subject: [merged] lib-add-lib-gcdc.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:49:21 -0700
Message-ID: <200906182249.n5IMnL8P008477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbZFRWun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, davem@davemloft.net, horms@verge.net.au, juliusv@google.com, kaber@trash.net, sshtylyov@ru.mvista.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     lib: add lib/gcd.c
has been removed from the -mm tree.  Its filename was
     lib-add-lib-gcdc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: add lib/gcd.c
From: Florian Fainelli <florian@openwrt.org>

This patch adds lib/gcd.c which contains a greatest common divider
implementation taken from sound/core/pcm_timer.c

Several usages of this new library function will be sent to subsystem
maintainers.

[akpm@linux-foundation.org: use swap() (pointed out by Joe)]
[akpm@linux-foundation.org: just add gcd.o to obj-y, remove Kconfig changes]
Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julius Volz <juliusv@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gcd.h |    8 ++++++++
 lib/Makefile        |    2 +-
 lib/gcd.c           |   18 ++++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

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
diff -puN lib/Makefile~lib-add-lib-gcdc lib/Makefile
--- a/lib/Makefile~lib-add-lib-gcdc
+++ a/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o
+	 string_helpers.o gcd.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN /dev/null lib/gcd.c
--- /dev/null
+++ a/lib/gcd.c
@@ -0,0 +1,18 @@
+#include <linux/kernel.h>
+#include <linux/gcd.h>
+#include <linux/module.h>
+
+/* Greatest common divisor */
+unsigned long gcd(unsigned long a, unsigned long b)
+{
+	unsigned long r;
+
+	if (a < b)
+		swap(a, b);
+	while ((r = a % b) != 0) {
+		a = b;
+		b = r;
+	}
+	return b;
+}
+EXPORT_SYMBOL_GPL(gcd);
_

Patches currently in -mm which might be from florian@openwrt.org are

origin.patch
linux-next.patch
watchdog-add-bcm47xx-driver.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch

