From: akpm@linux-foundation.org
Subject: - check_partition-fix-error-check.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:23 -0800
Message-ID: <200703152156.l2FLuNqk027552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42279 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbXCOV4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     check_partition(): fix error check
has been removed from the -mm tree.  Its filename was
     check_partition-fix-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: check_partition(): fix error check
From: suzuki <suzuki@in.ibm.com>

Fix inverted check introduced in 57881dd9df40b76dc7fc6a0d13fd75f337accb32 "Fix
check_partition routines".

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/check.c~check_partition-fix-error-check fs/partitions/check.c
--- a/fs/partitions/check.c~check_partition-fix-error-check
+++ a/fs/partitions/check.c
@@ -180,7 +180,7 @@ check_partition(struct gendisk *hd, stru
 	}
 	if (res > 0)
 		return state;
-	if (!err)
+	if (err)
 	/* The partition is unrecognized. So report I/O errors if there were any */
 		res = err;
 	if (!res)
_

Patches currently in -mm which might be from suzuki@in.ibm.com are

origin.patch
fix-rescan_partitions-to-return-errors-properly.patch
