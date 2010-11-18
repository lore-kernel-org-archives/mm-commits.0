From: akpm@linux-foundation.org
Subject: - xpc-fails-to-discover-partitions-with-all-nasids-above-128.patch removed from -mm tree
Date: Thu, 18 Nov 2010 12:41:14 -0800
Message-ID: <201011182041.oAIKfFiu003909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757513Ab0KRUlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Nov 2010 15:41:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sgi-xpc: XPC fails to discover partitions with all nasids above 128
has been removed from the -mm tree.  Its filename was
     xpc-fails-to-discover-partitions-with-all-nasids-above-128.patch

This patch was dropped because you already sent that

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xpc: XPC fails to discover partitions with all nasids above 128
From: Robin Holt <holt@sgi.com>

UV hardware defines 256 memory protection regions versus the baseline 64
with increasing size for the SN2 ia64.  This was overlooked when XPC was
modified to accomodate both UV and SN2.

Without this patch, a user could reconfigure their existing system and
suddenly disable cross-partition communications with no indication of what
has gone wrong.  It also prevents larger configurations from using
cross-partition communication.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_partition.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_partition.c~xpc-fails-to-discover-partitions-with-all-nasids-above-128 drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~xpc-fails-to-discover-partitions-with-all-nasids-above-128
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -439,18 +439,23 @@ xpc_discovery(void)
 	 * nodes that can comprise an access protection grouping. The access
 	 * protection is in regards to memory, IOI and IPI.
 	 */
-	max_regions = 64;
 	region_size = xp_region_size;
 
-	switch (region_size) {
-	case 128:
-		max_regions *= 2;
-	case 64:
-		max_regions *= 2;
-	case 32:
-		max_regions *= 2;
-		region_size = 16;
-		DBUG_ON(!is_shub2());
+	if (is_uv())
+		max_regions = 256;
+	else {
+		max_regions = 64;
+
+		switch (region_size) {
+		case 128:
+			max_regions *= 2;
+		case 64:
+			max_regions *= 2;
+		case 32:
+			max_regions *= 2;
+			region_size = 16;
+			DBUG_ON(!is_shub2());
+		}
 	}
 
 	for (region = 0; region < max_regions; region++) {
_

Patches currently in -mm which might be from holt@sgi.com are

sgi-xpc-xpc-fails-to-discover-partitions-with-all-nasids-above-128.patch
epoll-convert-max_user_watches-to-long.patch

