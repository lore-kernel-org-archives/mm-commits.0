From: akpm@osdl.org
Subject: + uml-lock-the-irqs_to_free-list.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:32:00 -0800
Message-ID: <200701022132.l02LW0rr030395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34305 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991AbXABVfT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:35:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: lock the irqs_to_free list
has been added to the -mm tree.  Its filename is
     uml-lock-the-irqs_to_free-list.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: lock the irqs_to_free list
From: Jeff Dike <jdike@addtoit.com>

Fix (i.e. add some) the locking around the irqs_to_free list.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/chan_kern.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
