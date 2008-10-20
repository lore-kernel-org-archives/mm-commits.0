From: akpm@linux-foundation.org
Subject: - hfsplus-fix-possible-deadlock-when-handling-corrupted-extents.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:11 -0700
Message-ID: <200810202036.m9KKaBGf011319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795AbYJTUg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snakebyte@gmx.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfsplus: fix possible deadlock when handling corrupted extents
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-possible-deadlock-when-handling-corrupted-extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: fix possible deadlock when handling corrupted extents
From: Eric Sesterhenn <snakebyte@gmx.de>

A corrupted extent for the extent file itself may try to get an impossible
extent, causing a deadlock if I see it correctly.

Check the inode number after the first_blocks checks and fail if it's the
extent file, as according to the spec the extent file should have no
extent for itself.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/hfsplus/extents.c~hfsplus-fix-possible-deadlock-when-handling-corrupted-extents fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-possible-deadlock-when-handling-corrupted-extents
+++ a/fs/hfsplus/extents.c
@@ -199,6 +199,9 @@ int hfsplus_get_block(struct inode *inod
 		goto done;
 	}
 
+	if (inode->i_ino == HFSPLUS_EXT_CNID)
+		return -EIO;
+
 	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	res = hfsplus_ext_read_extent(inode, ablock);
 	if (!res) {
_

Patches currently in -mm which might be from snakebyte@gmx.de are

origin.patch
linux-next.patch

