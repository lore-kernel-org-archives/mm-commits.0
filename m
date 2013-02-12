From: akpm@linux-foundation.org
Subject: + hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch added to -mm tree
Date: Tue, 12 Feb 2013 15:08:02 -0800
Message-ID: <20130212230803.0FB4131C200@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:34793 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab3BLXIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 18:08:04 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so71783vea.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 15:08:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de, jack@suse.cz, kalaracey@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: fix issue with unzeroed unused b-tree nodes
has been added to the -mm tree.  Its filename is
     hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attr=
ibutes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patc=
h
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree=
=2Epatch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extende=
d-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
