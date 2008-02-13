From: akpm@linux-foundation.org
Subject: - lib-scatterlisto-needed-by-a-module-only-link-it-in-unconditionally.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:14:51 -0800
Message-ID: <200802132014.m1DKEpuk011254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44526 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257AbYBMUPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@pengutronix.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lib/scatterlist.o needed by a module only - link it in unconditionally
has been removed from the -mm tree.  Its filename was
     lib-scatterlisto-needed-by-a-module-only-link-it-in-unconditionally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/scatterlist.o needed by a module only - link it in unconditionally
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

lib/scatterlist.c is needed by drivers/media/video/videobuf-dma-sg.c, and
we would like to be able to use the latter without PCI too, for example, on
PXA270 ARM CPU.  It is then possible to create a configuration with
CONFIG_BLOCK=n, where only module code will need scatterlist.c.  Therefore
it must be in obj-y.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/Makefile~lib-scatterlisto-needed-by-a-module-only-link-it-in-unconditionally lib/Makefile
--- a/lib/Makefile~lib-scatterlisto-needed-by-a-module-only-link-it-in-unconditionally
+++ a/lib/Makefile
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o scatterlist.o
+	 proportions.o prio_heap.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -14,7 +14,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o
+	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

git-dvb.patch
gpiolib-better-rmmod-infrastructure.patch
gpiolib-i2c-spi-drivers-handle-rmmod-better.patch
gpio-define-gpio_is_valid.patch
