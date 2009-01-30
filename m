From: akpm@linux-foundation.org
Subject: [merged] sgi-xpc-remove-null-pointer-dereference.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:36 -0800
Message-ID: <200901301913.n0UJDacs026278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663AbZA3TOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, dcn@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sgi-xpc: Remove NULL pointer dereference.
has been removed from the -mm tree.  Its filename was
     sgi-xpc-remove-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xpc: Remove NULL pointer dereference.
From: Robin Holt <holt@sgi.com>

If the bte copy fails, the attempt to retrieve payloads merely returns a
null pointer deref and not NULL as was expected.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_sn2.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-remove-null-pointer-dereference drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-remove-null-pointer-dereference
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1957,11 +1957,13 @@ xpc_get_deliverable_payload_sn2(struct x
 
 			msg = xpc_pull_remote_msg_sn2(ch, get);
 
-			DBUG_ON(msg != NULL && msg->number != get);
-			DBUG_ON(msg != NULL && (msg->flags & XPC_M_SN2_DONE));
-			DBUG_ON(msg != NULL && !(msg->flags & XPC_M_SN2_READY));
+			if (msg != NULL) {
+				DBUG_ON(msg->number != get);
+				DBUG_ON(msg->flags & XPC_M_SN2_DONE);
+				DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 
-			payload = &msg->payload;
+				payload = &msg->payload;
+			}
 			break;
 		}
 
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch

