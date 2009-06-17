From: akpm@linux-foundation.org
Subject: [folded] lib-add-lib-gcdc-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:58:10 -0700
Message-ID: <200906172258.n5HMwAKe017518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370AbZFQXAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 19:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, florian@openwrt.org, horms@verge.net.au, joe@perches.com, juliusv@google.com, kaber@trash.net, sshtylyov@ru.mvista.com, tiwai@suse.de


The patch titled
     lib-add-lib-gcdc-fix
has been removed from the -mm tree.  Its filename was
     lib-add-lib-gcdc-fix.patch

This patch was dropped because it was folded into lib-add-lib-gcdc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-add-lib-gcdc-fix
From: Andrew Morton <akpm@linux-foundation.org>

- use swap() (pointed out by Joe)

- Just add gcd.o to lib-y, reove Kconfig changes.

Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Julius Volz <juliusv@google.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Joe Perches <joe@perches.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig  |    3 ---
 lib/Makefile |    3 +--
 lib/gcd.c    |    8 +++-----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff -puN lib/Kconfig~lib-add-lib-gcdc-fix lib/Kconfig
--- a/lib/Kconfig~lib-add-lib-gcdc-fix
+++ a/lib/Kconfig
@@ -13,9 +13,6 @@ config BITREVERSE
 config RATIONAL
 	boolean
 
-config GCD
-	bool
-
 config GENERIC_FIND_FIRST_BIT
 	bool
 
diff -puN lib/Makefile~lib-add-lib-gcdc-fix lib/Makefile
--- a/lib/Makefile~lib-add-lib-gcdc-fix
+++ a/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o gcd.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -58,7 +58,6 @@ obj-$(CONFIG_CRC_ITU_T)	+= crc-itu-t.o
 obj-$(CONFIG_CRC32)	+= crc32.o
 obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
-obj-$(CONFIG_GCD)	+= gcd.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
diff -puN lib/gcd.c~lib-add-lib-gcdc-fix lib/gcd.c
--- a/lib/gcd.c~lib-add-lib-gcdc-fix
+++ a/lib/gcd.c
@@ -1,3 +1,4 @@
+#include <linux/kernel.h>
 #include <linux/gcd.h>
 #include <linux/module.h>
 
@@ -6,11 +7,8 @@ unsigned long gcd(unsigned long a, unsig
 {
 	unsigned long r;
 
-	if (a < b) {
-		r = a;
-		a = b;
-		b = r;
-	}
+	if (a < b)
+		swap(a, b);
 	while ((r = a % b) != 0) {
 		a = b;
 		b = r;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-edac_device_alloc_index.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions.patch
lib-add-lib-gcdc.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

