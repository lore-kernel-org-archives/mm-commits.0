From: akpm@linux-foundation.org
Subject: [merged] hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:17 -0800
Message-ID: <20130228201118.6234131C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:64832 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:19 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246091yhz.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, kalaracey@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: fix issue with unzeroed unused b-tree nodes
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: fix issue with unzeroed unused b-tree nodes

The fsck_hfs (under MacOS X) complains about unzeroed unused b-tree nod=
es
after deletion of folders' tree under Linux.

SYMPTOMS:
Running Disk Utiltiy's "Verify Disk" on "test" gives the following:
Verifying volume =E2=80=9CTest=E2=80=9D
Checking file systemChecking Journaled HFS Plus volume.
Checking extents overflow file.
Checking catalog file.
Unused node is not erased (node =3D 3111)
Checking multi-linked files.
Checking catalog hierarchy.
Checking extended attributes file.
Checking volume bitmap.
Checking volume information.
The volume Test was found corrupt and needs to be repaired.
Error: This disk needs to be repaired. Click Repair Disk.

REPRODUCING PATH:

1. Prepare HFS+ (non-case sensitive) partition (for example, 5GB)
   under MacOS X.
2. Copy linux kernel source tree (for example, 3.7-rc6 version) on
   this partition under MacOS X.
3. Then switch to Linux and mount this prepared partition.
4. Execute `sudo rm -r` under prepared directory with linux kernel
   source tree.
5. Unmount and boot back into OS X.
6. Open up Disk Utility and verify partition.

REPRODUCIBILITY: 100%

=46IX:

It is added code of node clearing in hfs_bnode_put() method for the cas=
e
when node has flag HFS_BNODE_DELETED.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Kyle Laracey <kalaracey@gmail.com>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bnode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hfsplus/bnode.c~hfsplus-fix-issue-with-unzeroed-unused-b-t=
ree-nodes fs/hfsplus/bnode.c
--- a/fs/hfsplus/bnode.c~hfsplus-fix-issue-with-unzeroed-unused-b-tree-=
nodes
+++ a/fs/hfsplus/bnode.c
@@ -648,6 +648,8 @@ void hfs_bnode_put(struct hfs_bnode *nod
 		if (test_bit(HFS_BNODE_DELETED, &node->flags)) {
 			hfs_bnode_unhash(node);
 			spin_unlock(&tree->hash_lock);
+			hfs_bnode_clear(node, 0,
+				PAGE_CACHE_SIZE * tree->pages_per_bnode);
 			hfs_bmap_free(node);
 			hfs_bnode_free(node);
 			return;
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch
hfsplus-add-all-necessary-declarations-for-acls-support.patch
hfsplus-add-implementation-of-the-acls-support.patch
hfsplus-integrate-of-implemented-acls-support-into-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
