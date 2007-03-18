From: akpm@linux-foundation.org
Subject: - fix-rescan_partitions-to-return-errors-properly.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:48 -0800
Message-ID: <200703180909.l2I99mNG020039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60450 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXCRJJz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:09:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix rescan_partitions to return errors properly
has been removed from the -mm tree.  Its filename was
     fix-rescan_partitions-to-return-errors-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix rescan_partitions to return errors properly
From: suzuki <suzuki@in.ibm.com>

The only error code which comes from the partition checkers is -1, when they
finds an EIO.  As per the discussion, ENOMEM values were ignored, as they
might scare the users.

So, with the current code, we end up returning -1 and not EIO for the ioctl()
calls.  Which doesn't give any clue to the user of what went wrong.

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/check.c~fix-rescan_partitions-to-return-errors-properly fs/partitions/check.c
--- a/fs/partitions/check.c~fix-rescan_partitions-to-return-errors-properly
+++ a/fs/partitions/check.c
@@ -541,7 +541,7 @@ int rescan_partitions(struct gendisk *di
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state))	/* I/O error reading the partition table */
-		return PTR_ERR(state);
+		return -EIO;
 	for (p = 1; p < state->limit; p++) {
 		sector_t size = state->parts[p].size;
 		sector_t from = state->parts[p].from;
_

Patches currently in -mm which might be from suzuki@in.ibm.com are

origin.patch
