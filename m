From: akpm@linux-foundation.org
Subject: [merged] fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:24 -0700
Message-ID: <201104181758.p3IHwZFu016047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123Ab1DRR7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 13:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Warns@pre-sense.de, eugeneteo@kernel.sg, harvey.harrison@gmail.com, rich@flatcap.org, warns@pre-sense.de, mm-commits@vger.kernel.org


The patch titled
     fs/partitions/ldm.c: fix oops caused by corrupted partition table
has been removed from the -mm tree.  Its filename was
     fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partitions/ldm.c: fix oops caused by corrupted partition table
From: Timo Warns <Warns@pre-sense.de>

The kernel automatically evaluates partition tables of storage devices.
The code for evaluating LDM partitions (in fs/partitions/ldm.c) contains
a bug that causes a kernel oops on certain corrupted LDM partitions.
A kernel subsystem seems to crash, because, after the oops, the kernel no
longer recognizes newly connected storage devices.

The patch validates the value of vblk_size.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Richard Russon <rich@flatcap.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/partitions/ldm.c~fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table
+++ a/fs/partitions/ldm.c
@@ -1299,6 +1299,11 @@ static bool ldm_frag_add (const u8 *data
 
 	BUG_ON (!data || !frags);
 
+	if (size < 2 * VBLK_SIZE_HEAD) {
+		ldm_error("Value of size is to small.");
+		return false;
+	}
+
 	group = get_unaligned_be32(data + 0x08);
 	rec   = get_unaligned_be16(data + 0x0C);
 	num   = get_unaligned_be16(data + 0x0E);
@@ -1306,6 +1311,10 @@ static bool ldm_frag_add (const u8 *data
 		ldm_error ("A VBLK claims to have %d parts.", num);
 		return false;
 	}
+	if (rec >= num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, num);
+		return false;
+	}
 
 	list_for_each (item, frags) {
 		f = list_entry (item, struct frag, list);
@@ -1334,10 +1343,9 @@ found:
 
 	f->map |= (1 << rec);
 
-	if (num > 0) {
-		data += VBLK_SIZE_HEAD;
-		size -= VBLK_SIZE_HEAD;
-	}
+	data += VBLK_SIZE_HEAD;
+	size -= VBLK_SIZE_HEAD;
+
 	memcpy (f->data+rec*(size-VBLK_SIZE_HEAD)+VBLK_SIZE_HEAD, data, size);
 
 	return true;
_

Patches currently in -mm which might be from Warns@pre-sense.de are

origin.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch

