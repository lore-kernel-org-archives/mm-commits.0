From: akpm@linux-foundation.org
Subject: - hfs-fix-namelength-memory-corruption.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:39 -0700
Message-ID: <200810182318.m9INId1G029317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbYJRXSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snakebyte@gmx.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs: fix namelength memory corruption
has been removed from the -mm tree.  Its filename was
     hfs-fix-namelength-memory-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: fix namelength memory corruption
From: Eric Sesterhenn <snakebyte@gmx.de>

Fix a stack corruption caused by a corrupted hfs filesystem.  If the
catalog name length is corrupted the memcpy overwrites the catalog btree
structure.  Since the field is limited to HFS_NAMELEN bytes in the
structure and the file format, we throw an error if it is too long.

Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/catalog.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/hfs/catalog.c~hfs-fix-namelength-memory-corruption fs/hfs/catalog.c
--- a/fs/hfs/catalog.c~hfs-fix-namelength-memory-corruption
+++ a/fs/hfs/catalog.c
@@ -190,6 +190,10 @@ int hfs_cat_find_brec(struct super_block
 
 	fd->search_key->cat.ParID = rec.thread.ParID;
 	len = fd->search_key->cat.CName.len = rec.thread.CName.len;
+	if (len > HFS_NAMELEN) {
+		printk(KERN_ERR "hfs: bad catalog namelength\n");
+		return -EIO;
+	}
 	memcpy(fd->search_key->cat.CName.name, rec.thread.CName.name, len);
 	return hfs_brec_find(fd);
 }
_

Patches currently in -mm which might be from snakebyte@gmx.de are

origin.patch
hfsplus-fix-possible-deadlock-when-handling-corrupted-extents.patch

