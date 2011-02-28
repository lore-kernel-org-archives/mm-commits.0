From: akpm@linux-foundation.org
Subject: [merged] ldm-corrupted-partition-table-can-cause-kernel-oops.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:10:44 -0800
Message-ID: <201102282110.p1SLAi4a029328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab1B1VOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:14:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Warns@pre-sense.de, eugeneteo@kernel.sg, harvey.harrison@gmail.com, ldm@flatcap.org, stable@kernel.org, warns@pre-sense.de, mm-commits@vger.kernel.org


The patch titled
     ldm: corrupted partition table can cause kernel oops
has been removed from the -mm tree.  Its filename was
     ldm-corrupted-partition-table-can-cause-kernel-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ldm: corrupted partition table can cause kernel oops
From: Timo Warns <Warns@pre-sense.de>

The kernel automatically evaluates partition tables of storage devices. 
The code for evaluating LDM partitions (in fs/partitions/ldm.c) contains a
bug that causes a kernel oops on certain corrupted LDM partitions.  A
kernel subsystem seems to crash, because, after the oops, the kernel no
longer recognizes newly connected storage devices.

The patch changes ldm_parse_vmdb() to Validate the value of vblk_size.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Acked-by: Richard Russon <ldm@flatcap.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/partitions/ldm.c~ldm-corrupted-partition-table-can-cause-kernel-oops fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~ldm-corrupted-partition-table-can-cause-kernel-oops
+++ a/fs/partitions/ldm.c
@@ -251,6 +251,11 @@ static bool ldm_parse_vmdb (const u8 *da
 	}
 
 	vm->vblk_size     = get_unaligned_be32(data + 0x08);
+	if (vm->vblk_size == 0) {
+		ldm_error ("Illegal VBLK size");
+		return false;
+	}
+
 	vm->vblk_offset   = get_unaligned_be32(data + 0x0C);
 	vm->last_vblk_seq = get_unaligned_be32(data + 0x04);
 
_

Patches currently in -mm which might be from Warns@pre-sense.de are

origin.patch

