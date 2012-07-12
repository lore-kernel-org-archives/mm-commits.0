From: akpm@linux-foundation.org
Subject: [merged] sgi-xp-nested-calls-to-spin_lock_irqsave.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:14 -0700
Message-ID: <20120712193715.38CB820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:64845 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030749Ab2GLThR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:17 -0400
Received: by weyr1 with SMTP id r1so145546wey.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, holt@sgi.com, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sgi-xp: nested calls to spin_lock_irqsave()
has been removed from the -mm tree.  Its filename was
     sgi-xp-nested-calls-to-spin_lock_irqsave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: sgi-xp: nested calls to spin_lock_irqsave()

The code here has a nested spin_lock_irqsave().  It's not needed since
IRQs are already disabled and it causes a problem because it means that
IRQs won't be enabled again at the end.  The second call to
spin_lock_irqsave() will overwrite the value of irq_flags and we can't
restore the proper settings.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-nested-calls-to-spin_lock_irqsave drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-nested-calls-to-spin_lock_irqsave
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -452,9 +452,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 
 		if (msg->activate_gru_mq_desc_gpa !=
 		    part_uv->activate_gru_mq_desc_gpa) {
-			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+			spin_lock(&part_uv->flags_lock);
 			part_uv->flags &= ~XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV;
-			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+			spin_unlock(&part_uv->flags_lock);
 			part_uv->activate_gru_mq_desc_gpa =
 			    msg->activate_gru_mq_desc_gpa;
 		}
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch

