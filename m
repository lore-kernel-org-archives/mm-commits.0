From: akpm@linux-foundation.org
Subject: [merged] kprobes-use-do_irq-in-lkdtm.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:06 -0700
Message-ID: <200909231952.n8NJq6Eb028480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbZIWTxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mohan@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, ankita@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kprobes: use do_IRQ() in lkdtm
has been removed from the -mm tree.  Its filename was
     kprobes-use-do_irq-in-lkdtm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: use do_IRQ() in lkdtm
From: "M. Mohan Kumar" <mohan@in.ibm.com>

Current lkdtm code puts a probe on __do_IRQ for some of the kdump test
cases.  Since __do_IRQ is deprecated, change lkdtm code to use do_IRQ
function.

Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
Cc: Ankita Garg <ankita@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/lkdtm.c~kprobes-use-do_irq-in-lkdtm drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~kprobes-use-do_irq-in-lkdtm
+++ a/drivers/misc/lkdtm.c
@@ -283,7 +283,7 @@ static int __init lkdtm_module_init(void
 
 	switch (cpoint) {
 	case INT_HARDWARE_ENTRY:
-		lkdtm.kp.symbol_name = "__do_IRQ";
+		lkdtm.kp.symbol_name = "do_IRQ";
 		lkdtm.entry = (kprobe_opcode_t*) jp_do_irq;
 		break;
 	case INT_HW_IRQ_EN:
_

Patches currently in -mm which might be from mohan@in.ibm.com are

origin.patch

