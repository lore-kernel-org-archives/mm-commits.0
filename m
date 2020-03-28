From: akpm@linux-foundation.org
Subject: +
 hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files.patch added
 to -mm tree
Date: Sat, 28 Mar 2020 16:19:30 -0700
Message-ID: <20200328231930.Zmqx_CNQI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgC1XTb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 19:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@tuxera.com, mm-commits@vger.kernel.org, simon@tuxera.com


The patch titled
     Subject: hfsplus: fix crash and filesystem corruption when deleting files
has been added to the -mm tree.  Its filename is
     hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Simon Gander <simon@tuxera.com>
Subject: hfsplus: fix crash and filesystem corruption when deleting files

When removing files containing extended attributes, the hfsplus driver may
remove the wrong entries from the attributes b-tree, causing major
filesystem damage and in some cases even kernel crashes.

To remove a file, all its extended attributes have to be removed as well. 
The driver does this by looking up all keys in the attributes b-tree with
the cnid of the file.  Each of these entries then gets deleted using the
key used for searching, which doesn't contain the attribute's name when it
should.  Since the key doesn't contain the name, the deletion routine will
not find the correct entry and instead remove the one in front of it.  If
parent nodes have to be modified, these become corrupt as well.  This
causes invalid links and unsorted entries that not even macOS's fsck_hfs
is able to fix.

To fix this, modify the search key before an entry is deleted from the
attributes b-tree by copying the found entry's key into the search key,
therefore ensuring that the correct entry gets removed from the tree.

Link: http://lkml.kernel.org/r/20200327155541.1521-1-simon@tuxera.com
Signed-off-by: Simon Gander <simon@tuxera.com>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/attributes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/hfsplus/attributes.c~hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files
+++ a/fs/hfsplus/attributes.c
@@ -292,6 +292,10 @@ static int __hfsplus_delete_attr(struct
 		return -ENOENT;
 	}
 
+	/* Avoid btree corruption */
+	hfs_bnode_read(fd->bnode, fd->search_key,
+			fd->keyoffset, fd->keylength);
+
 	err = hfs_brec_remove(fd);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from simon@tuxera.com are

hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files.patch
