From: akpm@linux-foundation.org
Subject: + sgi-xp-nested-calls-to-spin_lock_irqsave.patch added to -mm tree
Date: Thu, 28 Jun 2012 15:03:52 -0700
Message-ID: <20120628220352.BE073A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36251 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2F1WDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 18:03:54 -0400
Received: by ggeh3 with SMTP id h3so262756gge.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 15:03:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, dan.carpenter@oracle.com, steiner@sgi.com


The patch titled
     Subject: sgi-xp: nested calls to spin_lock_irqsave()
has been added to the -mm tree.  Its filename is
     sgi-xp-nested-calls-to-spin_lock_irqsave.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
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
Subject: Subject: sgi-xp: nested calls to spin_lock_irqsave()

Patches currently in -mm which might be from holt@sgi.com are

sgi-xp-nested-calls-to-spin_lock_irqsave.patch

