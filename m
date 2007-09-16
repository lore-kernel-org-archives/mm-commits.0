From: akpm@linux-foundation.org
Subject: + reiserfs-fix-kernel-panic-on-corrupted-directory.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:35:27 -0700
Message-ID: <200709160535.l8G5ZRib002022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbXIPFgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ytht.net@gmail.com, chris.mason@oracle.com, jeffm@suse.com, vs@namesys.com


The patch titled
     reiserfs: fix kernel panic on corrupted directory
has been added to the -mm tree.  Its filename is
     reiserfs-fix-kernel-panic-on-corrupted-directory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: fix kernel panic on corrupted directory
From: lepton <ytht.net@gmail.com>

When reading corrupted reiserfs directory data, d_reclen could be a
negative number or a big positive number, this can lead to kernel panic or
oop.  The following patch adds a sanity check.

Signed-off-by: Lepton Wu <ytht.net@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/dir.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/reiserfs/dir.c~reiserfs-fix-kernel-panic-on-corrupted-directory fs/reiserfs/dir.c
--- a/fs/reiserfs/dir.c~reiserfs-fix-kernel-panic-on-corrupted-directory
+++ a/fs/reiserfs/dir.c
@@ -121,6 +121,16 @@ static int reiserfs_readdir(struct file 
 					continue;
 				d_reclen = entry_length(bh, ih, entry_num);
 				d_name = B_I_DEH_ENTRY_FILE_NAME(bh, ih, deh);
+
+				if (d_reclen <= 0 ||
+				    d_name + d_reclen > bh->b_data + bh->b_size) {
+					/* There is corrupted data in entry,
+					 * We'd better stop here */
+					pathrelse(&path_to_entry);
+					ret = -EIO;
+					goto out;
+				}
+
 				if (!d_name[d_reclen - 1])
 					d_reclen = strlen(d_name);
 
_

Patches currently in -mm which might be from ytht.net@gmail.com are

reiserfs-fix-kernel-panic-on-corrupted-directory.patch
