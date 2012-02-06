From: akpm@linux-foundation.org
Subject: [merged] kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:31 -0800
Message-ID: <20120206203131.7E85AA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:36504 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2BFUbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jiang.liu@huawei.com, jkenisto@us.ibm.com, masami.hiramatsu.pt@hitachi.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: fix a memory leak in function pre_handler_kretprobe()
has been removed from the -mm tree.  Its filename was
     kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

[akpm@linux-foundation.org: use raw_spin_lock/unlock]
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
+			raw_spin_lock_irqsave(&rp->lock, flags);
+			hlist_add_head(&ri->hlist, &rp->free_instances);
+			raw_spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
+		}
 
 		arch_prepare_kretprobe(ri, regs);
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch

