From: akpm@linux-foundation.org
Subject: - uml-irq-locking-fixes.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:16 -0700
Message-ID: <200703292337.l2TNbGxu015084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42946 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945916AbXC2XhT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:37:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: irq locking fixes
has been removed from the -mm tree.  Its filename was
     uml-irq-locking-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: irq locking fixes
From: Jeff Dike <jdike@addtoit.com>

As the comment immediately preceding this points out, this list is changed in
irq context, so it needs to be protected with spin_lock_irqsave in process
context when it is processed.

Sometimes, gcc should just compile the comments and forget the code.

The IRQ side of this was better, in the sense that it blocked and unblocked
interrupts, but it still should have saved and restored them.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-irq-locking-fixes arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-irq-locking-fixes
+++ a/arch/um/drivers/chan_kern.c
@@ -236,11 +236,11 @@ void free_irqs(void)
 	struct chan *chan;
 	LIST_HEAD(list);
 	struct list_head *ele;
+	unsigned long flags;
 
-	spin_lock_irq(&irqs_to_free_lock);
+	spin_lock_irqsave(&irqs_to_free_lock, flags);
 	list_splice_init(&irqs_to_free, &list);
-	INIT_LIST_HEAD(&irqs_to_free);
-	spin_unlock_irq(&irqs_to_free_lock);
+	spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 
 	list_for_each(ele, &list){
 		chan = list_entry(ele, struct chan, free_list);
@@ -255,13 +255,15 @@ void free_irqs(void)
 
 static void close_one_chan(struct chan *chan, int delay_free_irq)
 {
+	unsigned long flags;
+
 	if(!chan->opened)
 		return;
 
 	if(delay_free_irq){
-		spin_lock_irq(&irqs_to_free_lock);
+		spin_lock_irqsave(&irqs_to_free_lock, flags);
 		list_add(&chan->free_list, &irqs_to_free);
-		spin_unlock_irq(&irqs_to_free_lock);
+		spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 	}
 	else {
 		if(chan->input)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-unreasonably-long-udelay.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
