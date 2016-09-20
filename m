From: akpm@linux-foundation.org
Subject: [merged] rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context.patch
 removed from -mm tree
Date: Tue, 20 Sep 2016 12:31:06 -0700
Message-ID: <57e18e7a.EUQwS7Jy9/Y0Eehh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48733 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753714AbcITTbH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 15:31:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, khoroshilov@ispras.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rio_cm: avoid GFP_KERNEL in atomic context
has been removed from the -mm tree.  Its filename was
     rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rio_cm: avoid GFP_KERNEL in atomic context

As reported by Alexey Khoroshilov (https://lkml.org/lkml/2016/9/9/737):
riocm_send_close() is called from rio_cm_shutdown() under
spin_lock_bh(idr_lock), but riocm_send_close() uses a GFP_KERNEL
allocation.

Fix by taking riocm_send_close() outside of spinlock protected code.

[akpm@linux-foundation.org: remove unneeded `if (!list_empty())']
Link: http://lkml.kernel.org/r/20160915175402.10122-1-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio_cm.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/rapidio/rio_cm.c~rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context drivers/rapidio/rio_cm.c
--- a/drivers/rapidio/rio_cm.c~rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context
+++ a/drivers/rapidio/rio_cm.c
@@ -2247,17 +2247,30 @@ static int rio_cm_shutdown(struct notifi
 {
 	struct rio_channel *ch;
 	unsigned int i;
+	LIST_HEAD(list);
 
 	riocm_debug(EXIT, ".");
 
+	/*
+	 * If there are any channels left in connected state send
+	 * close notification to the connection partner.
+	 * First build a list of channels that require a closing
+	 * notification because function riocm_send_close() should
+	 * be called outside of spinlock protected code.
+	 */
 	spin_lock_bh(&idr_lock);
 	idr_for_each_entry(&ch_idr, ch, i) {
-		riocm_debug(EXIT, "close ch %d", ch->id);
-		if (ch->state == RIO_CM_CONNECTED)
-			riocm_send_close(ch);
+		if (ch->state == RIO_CM_CONNECTED) {
+			riocm_debug(EXIT, "close ch %d", ch->id);
+			idr_remove(&ch_idr, ch->id);
+			list_add(&ch->ch_node, &list);
+		}
 	}
 	spin_unlock_bh(&idr_lock);
 
+	list_for_each_entry(ch, &list, ch_node)
+		riocm_send_close(ch);
+
 	return NOTIFY_DONE;
 }
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code.patch

