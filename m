From: akpm@linux-foundation.org
Subject: - uml-lock-the-irqs_to_free-list.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:21 -0800
Message-ID: <200702112248.l1BMmLjo015618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656AbXBKWsX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: lock the irqs_to_free list
has been removed from the -mm tree.  Its filename was
     uml-lock-the-irqs_to_free-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: lock the irqs_to_free list
From: Jeff Dike <jdike@addtoit.com>

Fix (i.e. add some) the locking around the irqs_to_free list.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-lock-the-irqs_to_free-list arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-lock-the-irqs_to_free-list
+++ a/arch/um/drivers/chan_kern.c
@@ -222,15 +222,28 @@ void enable_chan(struct line *line)
 	}
 }
 
+/* Items are added in IRQ context, when free_irq can't be called, and
+ * removed in process context, when it can.
+ * This handles interrupt sources which disappear, and which need to
+ * be permanently disabled.  This is discovered in IRQ context, but
+ * the freeing of the IRQ must be done later.
+ */
+static DEFINE_SPINLOCK(irqs_to_free_lock);
 static LIST_HEAD(irqs_to_free);
 
 void free_irqs(void)
 {
 	struct chan *chan;
+	LIST_HEAD(list);
+	struct list_head *ele;
+
+	spin_lock_irq(&irqs_to_free_lock);
+	list_splice_init(&irqs_to_free, &list);
+	INIT_LIST_HEAD(&irqs_to_free);
+	spin_unlock_irq(&irqs_to_free_lock);
 
-	while(!list_empty(&irqs_to_free)){
-		chan = list_entry(irqs_to_free.next, struct chan, free_list);
-		list_del(&chan->free_list);
+	list_for_each(ele, &list){
+		chan = list_entry(ele, struct chan, free_list);
 
 		if(chan->input)
 			free_irq(chan->line->driver->read_irq, chan);
@@ -246,7 +259,9 @@ static void close_one_chan(struct chan *
 		return;
 
 	if(delay_free_irq){
+		spin_lock_irq(&irqs_to_free_lock);
 		list_add(&chan->free_list, &irqs_to_free);
+		spin_unlock_irq(&irqs_to_free_lock);
 	}
 	else {
 		if(chan->input)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
