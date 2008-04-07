From: akpm@linux-foundation.org
Subject: + jffs2-summary-allocation-dont-use-vmalloc.patch added to -mm tree
Date: Mon, 07 Apr 2008 16:39:32 -0700
Message-ID: <200804072339.m37NdW18030867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbYDGXkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 19:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trimarchimichael@yahoo.it, david-b@pacbell.net, dwmw2@infradead.org, jwboyer@gmail.com, rmk@arm.linux.org.uk


The patch titled
     jffs2 summary allocation: don't use vmalloc()
has been added to the -mm tree.  Its filename is
     jffs2-summary-allocation-dont-use-vmalloc.patch

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
Subject: jffs2 summary allocation: don't use vmalloc()
From: Michael Trimarchi <trimarchimichael@yahoo.it>

arm:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
stopped custom tracer.
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.24-rc5-rt1 #37)
PC is at dma_cache_maint+0x40/0x80
LR is at atmel_spi_transfer+0x94/0x178

This is because the SPI layer is using DMA transfers to support jffs2 I/O, and
apparently jffs2 isn't used to having DMA done against this buffer.  DMA
against vmalloced memory plain isn't allowed.

This patch will probably break all sorts of things because that buffer is
&*large*: up to half a meg.

So this patch isn't mergeable.  I'll hang onto it to bug dmwm2 with when he
reincarnates.

Cc: David Brownell <david-b@pacbell.net>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/summary.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/jffs2/summary.c~jffs2-summary-allocation-dont-use-vmalloc fs/jffs2/summary.c
--- a/fs/jffs2/summary.c~jffs2-summary-allocation-dont-use-vmalloc
+++ a/fs/jffs2/summary.c
@@ -17,7 +17,6 @@
 #include <linux/pagemap.h>
 #include <linux/crc32.h>
 #include <linux/compiler.h>
-#include <linux/vmalloc.h>
 #include "nodelist.h"
 #include "debug.h"
 
@@ -30,7 +29,7 @@ int jffs2_sum_init(struct jffs2_sb_info 
 		return -ENOMEM;
 	}
 
-	c->summary->sum_buf = vmalloc(c->sector_size);
+	c->summary->sum_buf = kmalloc(c->sector_size, GFP_KERNEL);
 
 	if (!c->summary->sum_buf) {
 		JFFS2_WARNING("Can't allocate buffer for writing out summary information!\n");
@@ -49,7 +48,7 @@ void jffs2_sum_exit(struct jffs2_sb_info
 
 	jffs2_sum_disable_collecting(c->summary);
 
-	vfree(c->summary->sum_buf);
+	kfree(c->summary->sum_buf);
 	c->summary->sum_buf = NULL;
 
 	kfree(c->summary);
_

Patches currently in -mm which might be from trimarchimichael@yahoo.it are

origin.patch
jffs2-add-write-verify-on-dataflash.patch
jffs2-summary-allocation-dont-use-vmalloc.patch

