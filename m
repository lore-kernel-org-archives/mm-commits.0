From: akpm@linux-foundation.org
Subject: + sgi-xp-eliminate-false-detection-of-no-heartbeat.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:09:03 -0800
Message-ID: <200901130809.n0D893CC006966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbZAMIJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:09:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, holt@sgi.com, stable@kernel.org


The patch titled
     sgi-xp: eliminate false detection of no heartbeat
has been added to the -mm tree.  Its filename is
     sgi-xp-eliminate-false-detection-of-no-heartbeat.patch

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

sgi-xp-eliminate-false-detection-of-no-heartbeat.patch

