From: akpm@linux-foundation.org
Subject: [merged] sgi-xp-eliminate-false-detection-of-no-heartbeat.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:44 -0800
Message-ID: <200901161916.n0GJGiUD025251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758122AbZAPTYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:24:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, holt@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: eliminate false detection of no heartbeat
has been removed from the -mm tree.  Its filename was
     sgi-xp-eliminate-false-detection-of-no-heartbeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: eliminate false detection of no heartbeat
From: Dean Nelson <dcn@sgi.com>

After XPC has been up and running on multiple partitions for any length of
time, if XPC on one of the partitions is stopped and restarted (either by
a rmmod/insmod or a system restart), it is possible for the XPCs running
on the other partitions to falsely detect a lack of heartbeat from the XPC
that was just restarted.  This false detection will occur if the restarted
XPC comes up within the five-seconds preceding one of the other XPC's
heartbeat check (which occurs once every twenty seconds).

The detection of no heartbeat results in the detecting XPC deactivating
from the just restarted XPC.  The only remedy is to restart one of the
XPCs and hope that one doesn't hit this five-second window on any of the
other partitions.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_sn2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-eliminate-false-detection-of-no-heartbeat drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-eliminate-false-detection-of-no-heartbeat
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -899,7 +899,7 @@ xpc_update_partition_info_sn2(struct xpc
 	dev_dbg(xpc_part, "  remote_vars_pa = 0x%016lx\n",
 		part_sn2->remote_vars_pa);
 
-	part->last_heartbeat = remote_vars->heartbeat;
+	part->last_heartbeat = remote_vars->heartbeat - 1;
 	dev_dbg(xpc_part, "  last_heartbeat = 0x%016lx\n",
 		part->last_heartbeat);
 
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch
linux-next.patch

