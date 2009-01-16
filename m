From: akpm@linux-foundation.org
Subject: + sgi-xpc-ensure-flags-are-updated-before-bte_copy.patch added to -mm tree
Date: Fri, 16 Jan 2009 12:33:37 -0800
Message-ID: <200901162033.n0GKXbCO002679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758183AbZAPUeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 15:34:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, dcn@sgi.com, stable@kernel.org


The patch titled
     sgi-xpc: ensure flags are updated before bte_copy
has been added to the -mm tree.  Its filename is
     sgi-xpc-ensure-flags-are-updated-before-bte_copy.patch

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
Subject: sgi-xpc: ensure flags are updated before bte_copy
From: Robin Holt <holt@sgi.com>

The clearing of the msg->flags needs a barrier between it and the notify
of the channel threads that the messages are cleaned and ready for use.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_sn2.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-ensure-flags-are-updated-before-bte_copy drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-ensure-flags-are-updated-before-bte_copy
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1836,6 +1836,7 @@ xpc_process_msg_chctl_flags_sn2(struct x
 		 */
 		xpc_clear_remote_msgqueue_flags_sn2(ch);
 
+		wmb();	/* ensure flags have been cleared before bte_copy */
 		ch_sn2->w_remote_GP.put = ch_sn2->remote_GP.put;
 
 		dev_dbg(xpc_chan, "w_remote_GP.put changed to %ld, partid=%d, "
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
sgi-xpc-ensure-flags-are-updated-before-bte_copy.patch
sgi-xpc-remove-null-pointer-dereference.patch
sgi-xpc-fixup-stale-dbug_on-statements.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch

