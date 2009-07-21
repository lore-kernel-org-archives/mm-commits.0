From: akpm@linux-foundation.org
Subject: + kprobes-use-do_irq-in-lkdtm.patch added to -mm tree
Date: Tue, 21 Jul 2009 15:27:07 -0700
Message-ID: <200907212227.n6LMR7UT009455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898AbZGUW2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 18:28:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mohan@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, ankita@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com, mingo@elte.hu


The patch titled
     kprobes: use do_IRQ() in lkdtm
has been added to the -mm tree.  Its filename is
     kprobes-use-do_irq-in-lkdtm.patch

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

kprobes-use-do_irq-in-lkdtm.patch

