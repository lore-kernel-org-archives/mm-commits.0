From: akpm@linux-foundation.org
Subject: + twl4030-fix-warning.patch added to -mm tree
Date: Fri, 20 Nov 2009 13:22:10 -0800
Message-ID: <200911202122.nAKLMAth020823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307AbZKTVWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 16:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, sameo@linux.intel.com


The patch titled
     twl4030: fix warning
has been added to the -mm tree.  Its filename is
     twl4030-fix-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: twl4030: fix warning
From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/twl4030-irq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/twl4030-irq.c~twl4030-fix-warning drivers/mfd/twl4030-irq.c
--- a/drivers/mfd/twl4030-irq.c~twl4030-fix-warning
+++ a/drivers/mfd/twl4030-irq.c
@@ -728,7 +728,8 @@ int twl_init_irq(int irq_num, unsigned i
 		goto fail_rqirq;
 	}
 
-	task = kthread_run(twl4030_irq_thread, (void *)irq_num, "twl4030-irq");
+	task = kthread_run(twl4030_irq_thread, (void *)(long)irq_num,
+								"twl4030-irq");
 	if (IS_ERR(task)) {
 		pr_err("twl4030: could not create irq %d thread!\n", irq_num);
 		status = PTR_ERR(task);
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
drivers-char-cycladesc-fix-used-uninitialised-bug.patch
twl4030-fix-warning.patch
8250-add-serial-transmitter-fully-empty-test.patch
i810fb-fix-stack-exploding.patch
parport_pcc-use-correct-length-in-strncmp.patch

