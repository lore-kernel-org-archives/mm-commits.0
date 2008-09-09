From: akpm@linux-foundation.org
Subject: + hfs-fix-namelength-memory-corruption.patch added to -mm tree
Date: Mon, 08 Sep 2008 17:15:31 -0700
Message-ID: <200809090015.m890FWG7017388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbYIIAPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 20:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de, zippel@linux-m68k.org


The patch titled
     hfs: fix namelength memory corruption
has been added to the -mm tree.  Its filename is
     hfs-fix-namelength-memory-corruption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: fix namelength memory corruption
From: Eric Sesterhenn <snakebyte@gmx.de>

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

bfs-lockdep-warning.patch
linux-next.patch
hfs-fix-namelength-memory-corruption.patch
hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch
hfsplus-check-read_mapping_page-return-value.patch
hfsplus-fix-another-bug-when-reading-a-corrupted-image.patch
hfsplus-check-hfs_bnode_find-return-value.patch

