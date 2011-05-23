From: akpm@linux-foundation.org
Subject: [merged] fs-partitions-ldmc-fix-buffer-overflow-again.patch removed from -mm tree
Date: Mon, 23 May 2011 12:14:20 -0700
Message-ID: <201105231913.p4NJD29F005819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393Ab1EWTN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 May 2011 15:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Warns@pre-sense.de, ben@decadent.org.uk, eugeneteo@kernel.sg, harvey.harrison@gmail.com, rich@flatcap.org, stable@kernel.org, warns@pre-sense.de, mm-commits@vger.kernel.org


The patch titled
     fs/partitions/ldm.c: fix buffer overflow again
has been removed from the -mm tree.  Its filename was
     fs-partitions-ldmc-fix-buffer-overflow-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partitions/ldm.c: fix buffer overflow again
From: Timo Warns <Warns@pre-sense.de>

c340b1d640001 ("fs/partitions/ldm.c: fix oops caused by corrupted
partition table") was incomplete and incorrect.  It does not consider that
for subsequent fragments, previously allocated memory is used.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Richard Russon <rich@flatcap.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/partitions/ldm.c~fs-partitions-ldmc-fix-buffer-overflow-again fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-partitions-ldmc-fix-buffer-overflow-again
+++ a/fs/partitions/ldm.c
@@ -1335,6 +1335,11 @@ static bool ldm_frag_add (const u8 *data
 
 	list_add_tail (&f->list, frags);
 found:
+	if (rec >= f->num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, f->num);
+		return false;
+	}
+
 	if (f->map & (1 << rec)) {
 		ldm_error ("Duplicate VBLK, part %d.", rec);
 		f->map &= 0x7F;			/* Mark the group as broken */
_

Patches currently in -mm which might be from Warns@pre-sense.de are

origin.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch

