From: akpm@linux-foundation.org
Subject: [merged] x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:00 -0800
Message-ID: <200912162040.nBGKe0W6013574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965006AbZLPUkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     X86: uv: xpc_make_first_contact hang due to not accepting ACTIVE state
has been removed from the -mm tree.  Its filename was
     x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: X86: uv: xpc_make_first_contact hang due to not accepting ACTIVE state
From: Robin Holt <holt@sgi.com>

Many times while the initial connection is being made, the contacted
partition will send back both the ACTIVATING and the ACTIVE
remote_act_state changes in very close succescion.  The 1/4 second delay
in the make first contact loop is large enough to nearly always miss the
ACTIVATING state change.

Since either state indicates the remote partition has acknowledged our
state change, accept either.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -1024,7 +1024,8 @@ xpc_make_first_contact_uv(struct xpc_par
 	xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
 				      XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV);
 
-	while (part->sn.uv.remote_act_state != XPC_P_AS_ACTIVATING) {
+	while (!((part->sn.uv.remote_act_state == XPC_P_AS_ACTIVATING) ||
+		 (part->sn.uv.remote_act_state == XPC_P_AS_ACTIVE))) {
 
 		dev_dbg(xpc_part, "waiting to make first contact with "
 			"partition %d\n", XPC_PARTID(part));
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

