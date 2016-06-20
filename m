From: akpm@linux-foundation.org
Subject: + printk-do-not-include-interrupth.patch added to -mm tree
Date: Mon, 20 Jun 2016 16:43:36 -0700
Message-ID: <57687fa8.rOQwfWIa7myjlMKP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbcFTXpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jun 2016 19:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: do not include interrupt.h
has been added to the -mm tree.  Its filename is
     printk-do-not-include-interrupth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-do-not-include-interrupth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-do-not-include-interrupth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: printk: do not include interrupt.h

A trivial cosmetic change: interrupt.h header is redundant since
'commit 6b898c07cb1d ("console: use might_sleep in console_lock")'.

Link: http://lkml.kernel.org/r/20160620132847.21930-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-do-not-include-interrupth kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-do-not-include-interrupth
+++ a/kernel/printk/printk.c
@@ -26,7 +26,6 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/interrupt.h>			/* For in_interrupt() */
 #include <linux/delay.h>
 #include <linux/smp.h>
 #include <linux/security.h>
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-zstrm-find-release-functions.patch
zram-switch-to-crypto-compress-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-use-crypto-api-to-check-alg-availability-v3.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-delete-custom-lzo-lz4-v3.patch
zram-add-more-compression-algorithms.patch
zram-add-more-compression-algorithms-v3.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch
printk-do-not-include-interrupth.patch

