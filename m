From: akpm@linux-foundation.org
Subject: +
 sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq.patch added to -mm tree
Date: Tue, 16 May 2017 12:50:23 -0700
Message-ID: <591b57ff.69qsYEqMn//2UGX7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbdEPTuY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 15:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/sh/intc/virq.c: delete an error message for a failed memory allocation in add_virq_to_pirq()
has been added to the -mm tree.  Its filename is
     sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from elfring@users.sourceforge.net are

sh-intc-delete-an-error-message-for-a-failed-memory-allocation-in-add_virq_to_pirq.patch

