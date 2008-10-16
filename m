From: akpm@linux-foundation.org
Subject: + hfsplus-fix-possible-deadlock-when-handling-corrupted-extents.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:39:34 -0700
Message-ID: <200810162239.m9GMdYD3032141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbYJPWju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de, zippel@linux-m68k.org


The patch titled
     hfsplus: fix possible deadlock when handling corrupted extents
has been added to the -mm tree.  Its filename is
     hfsplus-fix-possible-deadlock-when-handling-corrupted-extents.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch
hfsplus-check-read_mapping_page-return-value.patch
hfs-fix-namelength-memory-corruption.patch
hfsplus-fix-possible-deadlock-when-handling-corrupted-extents.patch

