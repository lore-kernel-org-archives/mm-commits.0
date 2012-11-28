From: akpm@linux-foundation.org
Subject: + hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch added to -mm tree
Date: Wed, 28 Nov 2012 15:21:42 -0800
Message-ID: <20121128232143.307F920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:48758 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2K1XV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 18:21:57 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so497545wib.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 15:21:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, fengguang.wu@intel.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix
has been added to the -mm tree.  Its filename is
     hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix

Fix warning in [next:akpm 357/436] fs/hfsplus/xattr.c:363:23: sparse: cast to restricted __be32.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/hfsplus/xattr.c~hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix
+++ a/fs/hfsplus/xattr.c
@@ -310,6 +310,7 @@ ssize_t hfsplus_getxattr(struct dentry *
 	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
 	hfsplus_attr_entry *entry;
+	__be32 xattr_record_type;
 	u32 record_type;
 	u16 record_length = 0;
 	ssize_t res = 0;
@@ -358,9 +359,9 @@ ssize_t hfsplus_getxattr(struct dentry *
 		goto out;
 	}
 
-	hfs_bnode_read(fd.bnode, &record_type,
-			fd.entryoffset, sizeof(record_type));
-	record_type = be32_to_cpu(record_type);
+	hfs_bnode_read(fd.bnode, &xattr_record_type,
+			fd.entryoffset, sizeof(xattr_record_type));
+	record_type = be32_to_cpu(xattr_record_type);
 	if (record_type == HFSPLUS_ATTR_INLINE_DATA) {
 		record_length = hfs_bnode_read_u16(fd.bnode,
 				fd.entryoffset +
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-rework-processing-errors-in-hfsplus_free_extents.patch

