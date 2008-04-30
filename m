From: akpm@linux-foundation.org
Subject: - add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:48 -0700
Message-ID: <200804300549.m3U5nmvL030033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759342AbYD3Fwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:52:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, benh@kernel.crashing.org, bryan.wu@analog.com, chris@zankel.net, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, grundler@parisc-lin


The patch titled
     Add kbuild.h that contains common definitions for kbuild users
has been removed from the -mm tree.  Its filename was
     add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add kbuild.h that contains common definitions for kbuild users
From: Christoph Lameter <clameter@sgi.com>

The same definitions are used for the bounds logic and the asm-offsets.h
generation by kbuild.  Put them into include/linux/kbuild.h file.

Also add a new feature

	COMMENT("text")

which can be used to insert lines of ocmments into asm-offsets.h and
bounds.h.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Chris Zankel <chris@zankel.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Miles Bader <miles@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kbuild.h |   15 +++++++++++++++
 kernel/bounds.c        |    6 +-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff -puN /dev/null include/linux/kbuild.h
--- /dev/null
+++ a/include/linux/kbuild.h
@@ -0,0 +1,15 @@
+#ifndef __LINUX_KBUILD_H
+#define __LINUX_KBUILD_H
+
+#define DEFINE(sym, val) \
+        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+
+#define BLANK() asm volatile("\n->" : : )
+
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem))
+
+#define COMMENT(x) \
+	asm volatile("\n->#" x)
+
+#endif
diff -puN kernel/bounds.c~add-kbuildh-that-contains-common-definitions-for-kbuild-users kernel/bounds.c
--- a/kernel/bounds.c~add-kbuildh-that-contains-common-definitions-for-kbuild-users
+++ a/kernel/bounds.c
@@ -8,11 +8,7 @@
 /* Include headers that define the enum constants of interest */
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
-
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
+#include <linux/kbuild.h>
 
 void foo(void)
 {
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

