From: akpm@linux-foundation.org
Subject: + kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe.patch added to -mm tree
Date: Mon, 30 Jan 2012 15:42:52 -0800
Message-ID: <20120130234252.B1941A018F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:46286 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2A3Xmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 18:42:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jiang.liu@huawei.com, jkenisto@us.ibm.com, masami.hiramatsu.pt@hitachi.com, stable@vger.kernel.org


The patch titled
     Subject: kprobes: fix a memory leak in function pre_handler_kretprobe()
has been added to the -mm tree.  Its filename is
     kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: kprobes: fix a memory leak in function pre_handler_kretprobe()

In function pre_handler_kretprobe(), the allocated kretprobe_instance
object will get leaked if the entry_handler callback returns non-zero. 
This may cause all the preallocated kretprobe_instance objects exhausted.

This issue can be reproduced by changing
samples/kprobes/kretprobe_example.c to probe "mutex_unlock".  And the fix
is straightforward: just put the allocated kretprobe_instance object back
onto the free_instances list.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe
+++ a/kernel/kprobes.c
@@ -1673,8 +1673,12 @@ static int __kprobes pre_handler_kretpro
 		ri->rp = rp;
 		ri->task = current;
 
-		if (rp->entry_handler && rp->entry_handler(ri, regs))
+		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
+			spin_lock_irqsave(&rp->lock, flags);
+			hlist_add_head(&ri->hlist, &rp->free_instances);
+			spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
+		}
 
 		arch_prepare_kretprobe(ri, regs);
 
_
Subject: Subject: kprobes: fix a memory leak in function pre_handler_kretprobe()

Patches currently in -mm which might be from liuj97@gmail.com are

kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe.patch

