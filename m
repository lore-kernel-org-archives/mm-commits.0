From: akpm@linux-foundation.org
Subject: + hfs-fix-oops-on-mount-with-corrupted-btree-extent-records.patch added to -mm tree
Date: Tue, 13 Oct 2009 10:54:17 -0700
Message-ID: <200910131754.n9DHsH1S021844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758894AbZJMRza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 13:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, Valdis.Kletnieks@vt.edu, rcvalle@linux.vnet.ibm.com


The patch titled
     hfs: fix oops on mount with corrupted btree extent records
has been added to the -mm tree.  Its filename is
     hfs-fix-oops-on-mount-with-corrupted-btree-extent-records.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: fix oops on mount with corrupted btree extent records
From: Jeff Mahoney <jeffm@suse.com>

A particular fsfuzzer run caused an hfs file system to crash on mount. 
This is due to a corrupted MDB extent record causing a miscalculation of
HFS_I(inode)->first_blocks for the extent tree.  If the extent records are
zereod out, it won't trigger the first_blocks special case.  Instead it
falls through to the extent code which we're still in the middle of
initializing.

This patch catches the 0 size extent records, reports the corruption, and
fails the mount.

Reported-by: Ramon de Carvalho Valle <rcvalle@linux.vnet.ibm.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/hfs/btree.c~hfs-fix-oops-on-mount-with-corrupted-btree-extent-records fs/hfs/btree.c
--- a/fs/hfs/btree.c~hfs-fix-oops-on-mount-with-corrupted-btree-extent-records
+++ a/fs/hfs/btree.c
@@ -58,6 +58,11 @@ struct hfs_btree *hfs_btree_open(struct 
 	}
 	unlock_new_inode(tree->inode);
 
+	if (!HFS_I(tree->inode)->first_blocks) {
+		printk(KERN_ERR "hfs: invalid btree extent records (0 size).\n");
+		goto free_inode;
+	}
+
 	mapping = tree->inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
 	if (IS_ERR(page))
_

Patches currently in -mm which might be from jeffm@suse.com are

linux-next.patch
hfs-fix-oops-on-mount-with-corrupted-btree-extent-records.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch

