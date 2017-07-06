From: akpm@linux-foundation.org
Subject: [patch 014/108] drivers/sh/intc/virq.c: delete an error
 message for a failed memory allocation in add_virq_to_pirq()
Date: Thu, 06 Jul 2017 15:36:04 -0700
Message-ID: <20170706223604.anfM20yHY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbdGFWgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: drivers/sh/intc/virq.c: delete an error message for a failed memory allocation in add_virq_to_pirq()

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Link: http://lkml.kernel.org/r/54e30d61-5183-9911-cf35-1410fb78da5a@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sh/intc/virq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/sh/intc/virq.c~sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq drivers/sh/intc/virq.c
--- a/drivers/sh/intc/virq.c~sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq
+++ a/drivers/sh/intc/virq.c
@@ -94,10 +94,8 @@ static int add_virq_to_pirq(unsigned int
 	}
 
 	entry = kzalloc(sizeof(struct intc_virq_list), GFP_ATOMIC);
-	if (!entry) {
-		pr_err("can't allocate VIRQ mapping for %d\n", virq);
+	if (!entry)
 		return -ENOMEM;
-	}
 
 	entry->irq = virq;
 
_
