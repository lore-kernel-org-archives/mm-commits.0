From: akpm@linux-foundation.org
Subject: + ieee1394_transactions-needs-schedh.patch added to -mm tree
Date: Mon, 09 Apr 2007 13:48:26 -0700
Message-ID: <200704092048.l39KmQK0023088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59760 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965661AbXDIUsk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 16:48:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: just.for.lkml@googlemail.com, stefanr@s5r6.in-berlin.de


The patch titled
     ieee1394_transactions needs sched.h
has been added to the -mm tree.  Its filename is
     ieee1394_transactions-needs-schedh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ieee1394_transactions needs sched.h
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>

drivers/ieee1394/ieee1394_transactions.c fails for me if CONFIG_SMP=n

gcc complains:
  CC      drivers/ieee1394/ieee1394_transactions.o
drivers/ieee1394/ieee1394_transactions.c: In function 'hpsb_get_tlabel':
drivers/ieee1394/ieee1394_transactions.c:183: error:
'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/ieee1394/ieee1394_transactions.c:183: error: (Each undeclared
identifier is reported only once

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/ieee1394_transactions.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ieee1394/ieee1394_transactions.c~ieee1394_transactions-needs-schedh drivers/ieee1394/ieee1394_transactions.c
--- a/drivers/ieee1394/ieee1394_transactions.c~ieee1394_transactions-needs-schedh
+++ a/drivers/ieee1394/ieee1394_transactions.c
@@ -12,6 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/hardirq.h>
 #include <linux/spinlock.h>
+#include <linux/sched.h>
 #include <linux/wait.h>
 
 #include <asm/bug.h>
_

Patches currently in -mm which might be from just.for.lkml@googlemail.com are

ieee1394_transactions-needs-schedh.patch
