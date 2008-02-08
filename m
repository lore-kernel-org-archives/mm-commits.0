From: akpm@linux-foundation.org
Subject: + lib-scatterlisto-needed-by-a-module-only-link-it-in-unconditionally.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:10:12 -0800
Message-ID: <200802082110.m18LACwf013377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193AbYBHVKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@pengutronix.de, jens.axboe@oracle.com


The patch titled
     lib/scatterlist.o needed by a module only - link it in unconditionally
has been added to the -mm tree.  Its filename is
     lib-scatterlisto-needed-by-a-module-only-link-it-in-unconditionally.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
lib-scatterlisto-needed-by-a-module-only-link-it-in-unconditionally.patch
git-dvb.patch
