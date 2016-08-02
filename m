From: akpm@linux-foundation.org
Subject: [patch 036/111] printk: do not include interrupt.h
Date: Tue, 02 Aug 2016 14:03:50 -0700
Message-ID: <57a10ab6.8OsJQmf1fJZrTS5T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbcHBVRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sergey.senozhatsky@gmail.com

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
