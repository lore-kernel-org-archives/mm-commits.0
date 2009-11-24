From: akpm@linux-foundation.org
Subject: + x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:41:42 -0800
Message-ID: <200911241941.nAOJfhmE010753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758067AbZKXTlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:41:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, akpm@linux-foundation.org, mingo@elte.hu, steiner@sgi.com


The patch titled
     X86: uv: xpc_make_first_contact hang due to not accepting ACTIVE state
has been added to the -mm tree.  Its filename is
     x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch

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
Subject: X86: uv: xpc_make_first_contact hang due to not accepting ACTIVE state
From: Robin Holt <holt@sgi.com>

Many times while the initial connection is being made, the contacted
partition will send back both the ACTIVATING and the ACTIVE
remote_act_state changes in very close succescion.  The 1/4 second delay
in the make first contact loop is large enough to nearly always miss the
ACTIVATING state change.

Since either state indicates the remote partition has acknowledged our
state change, accept either.

To: Andrew Morton <akpm@linux-foundation.org>
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

x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch

