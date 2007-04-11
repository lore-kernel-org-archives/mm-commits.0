From: akpm@linux-foundation.org
Subject: - ieee1394_transactions-needs-schedh.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:20:58 -0700
Message-ID: <200704112320.l3BNKw6Y017533@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbXDKXVN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: just.for.lkml@googlemail.com, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     ieee1394_transactions needs sched.h
has been removed from the -mm tree.  Its filename was
     ieee1394_transactions-needs-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-ieee1394.patch
