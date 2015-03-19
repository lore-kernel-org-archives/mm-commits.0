From: akpm@linux-foundation.org
Subject: [merged]
 rtc-at91rm9200-double-locking-bug-in-at91_rtc_interrupt.patch removed from
 -mm tree
Date: Thu, 19 Mar 2015 12:15:49 -0700
Message-ID: <550b2065.S9UMY8nBhgFVv1Jy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbCSTPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Mar 2015 15:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, boris.brezillon@free-electrons.com, davidcdueck@googlemail.com, nicolas.ferre@atmel.com, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: double locking bug in at91_rtc_interrupt()
has been removed from the -mm tree.  Its filename was
     rtc-at91rm9200-double-locking-bug-in-at91_rtc_interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/rtc/rtc-at91rm9200.c: double locking bug in at91_rtc_interrupt()

There is a typo here so we deadlock.

Fixes: dd1f1f391dd7 ('rtc: at91rm9200: rework wakeup and interrupt handling')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Reported-by: David Dueck <davidcdueck@googlemail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-double-locking-bug-in-at91_rtc_interrupt drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-double-locking-bug-in-at91_rtc_interrupt
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -324,7 +324,7 @@ static irqreturn_t at91_rtc_interrupt(in
 
 		ret = IRQ_HANDLED;
 	}
-	spin_lock(&suspended_lock);
+	spin_unlock(&suspended_lock);
 
 	return ret;
 }
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch
posix_acl-make-posix_acl_create-safer-and-cleaner.patch
paride-fix-the-verbose-module-param.patch
hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch
memstick-mspro_block-add-missing-curly-braces.patch
linux-next.patch

