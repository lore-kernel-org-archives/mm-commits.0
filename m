From: akpm@linux-foundation.org
Subject: [patch 089/114] genirq: remove unneeded kallsyms include
Date: Tue, 06 Feb 2018 15:41:13 -0800
Message-ID: <20180206234113.56-anikSQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753346AbeBFXlQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, tglx@linutronix.de, torvalds@linux-foundation.org

From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: genirq: remove unneeded kallsyms include

The file was converted from print_symbol() to %pf some time ago in
ef26f20cd117eb3c18 ("genirq: Print threaded handler in spurious debug
output").  kallsyms does not seem to be needed anymore.

Link: http://lkml.kernel.org/r/20171208025616.16267-10-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/spurious.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/irq/spurious.c~genirq-remove-unneeded-kallsyms-include kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~genirq-remove-unneeded-kallsyms-include
+++ a/kernel/irq/spurious.c
@@ -10,7 +10,6 @@
 #include <linux/jiffies.h>
 #include <linux/irq.h>
 #include <linux/module.h>
-#include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/timer.h>
_
