From: akpm@linux-foundation.org
Subject: +
 rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch added to -mm tree
Date: Tue, 19 Dec 2017 16:05:45 -0800
Message-ID: <5a39a959.rfPVMMMgjVpe+mlA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752656AbdLTAFr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 19:05:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: delete an error message for a failed memory allocation in rio_init_mports()
has been added to the -mm tree.  Its filename is
     rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: delete an error message for a failed memory allocation in rio_init_mports()

Patch series "RapidIO: Adjustments for some function implementations".

This patch (of 7):

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/dfd6887b-2521-cbf2-af5b-e70b5fa4c33c@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rapidio/rio.c~rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports
+++ a/drivers/rapidio/rio.c
@@ -2189,7 +2189,6 @@ int rio_init_mports(void)
 
 	work = kcalloc(n, sizeof *work, GFP_KERNEL);
 	if (!work) {
-		pr_err("RIO: no memory for work struct\n");
 		destroy_workqueue(rio_wq);
 		goto no_disc;
 	}
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch
rapidio-adjust-12-checks-for-null-pointers.patch
rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch
rapidio-improve-a-size-determination-in-five-functions.patch
rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch
rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
rapidio-move-12-export_symbol_gpl-calls-to-function-implementations.patch

