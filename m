From: akpm@linux-foundation.org
Subject: +
 hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch added to -mm tree
Date: Thu, 17 Apr 2014 13:15:50 -0700
Message-ID: <53503676.gVcjoRHkfht+7jvq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaDQUPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 16:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, sougata@tuxera.com, slava@dubeyko.com, hch@infradead.org, anton@tuxera.com, htl10@users.sourceforge.net

Subject: + hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch added to -mm tree
To: htl10@users.sourceforge.net,anton@tuxera.com,hch@infradead.org,slava@dubeyko.com,sougata@tuxera.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 13:15:50 -0700


The patch titled
     Subject: hfsplus: fix worst-case unicode to char conversion of file names and attributes
has been added to the -mm tree.  Its filename is
     hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: hfsplus: fix worst-case unicode to char conversion of file names and attributes

This is a series of 3 patches which corrects issues in HFS+ concerning the
use of non-english file names and attributes.  Names and attributes are
stored internally as UTF-16 units up to a fixed maximum size, and convert
to and from user-representation by NLS.  The code incorrectly assume that
NLS string lengths are equal to unicode lengths, which is only true for
English ascii usage.


This patch (of 3):

The HFS Plus Volume Format specification (TN1150) states that file names
are stored internally as a maximum of 255 unicode characters, as defined
by The Unicode Standard, Version 2.0 [Unicode, Inc.  ISBN 0-201-48345-9]. 
File names are converted by the NLS system on Linux before presented to
the user.

255 CJK characters converts to UTF-8 with 1 unicode character to up to 3
bytes, and to GB18030 with 1 unicode character to up to 4 bytes.  Thus,
trying in a UTF-8 locale to list files with names of more than 85 CJK
characters results in:

    $ ls /mnt
    ls: reading directory /mnt: File name too long

The receiving buffer to hfsplus_uni2asc() needs to be 255 x
NLS_MAX_CHARSET_SIZE bytes, not 255 bytes as the code has always been.

Similar consideration applies to attributes, which are stored internally
as a maximum of 127 UTF-16BE units.  See XNU source for an up-to-date
reference on attributes.

Strictly speaking, the maximum value of NLS_MAX_CHARSET_SIZE = 6 is not
attainable in the case of conversion to UTF-8, as going beyond 3 bytes
requires the use of surrogate pairs, i.e.  consuming two input units.

Thanks Anton Altaparmakov for reviewing an earlier version of this change.

This patch fixes all callers of hfsplus_uni2asc(), and also enables the
use of long non-English file names in HFS+.  The getting and setting, and
general usage of long non-English attributes requires further forthcoming
work, in the following patches of this series.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Sougata Santra <sougata@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/dir.c   |   11 +++++++++--
 fs/hfsplus/xattr.c |   14 +++++++++++---
 2 files changed, 20 insertions(+), 5 deletions(-)

diff -puN fs/hfsplus/dir.c~hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes
+++ a/fs/hfsplus/dir.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/random.h>
+#include <linux/nls.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
@@ -127,7 +128,7 @@ static int hfsplus_readdir(struct file *
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	int len, err;
-	char strbuf[HFSPLUS_MAX_STRLEN + 1];
+	char *strbuf;
 	hfsplus_cat_entry entry;
 	struct hfs_find_data fd;
 	struct hfsplus_readdir_data *rd;
@@ -139,6 +140,11 @@ static int hfsplus_readdir(struct file *
 	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
 	if (err)
 		return err;
+	strbuf = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_MAX_STRLEN + 1, GFP_KERNEL);
+	if (!strbuf) {
+		err = -ENOMEM;
+		goto out;
+	}
 	hfsplus_cat_build_key(sb, fd.search_key, inode->i_ino, NULL);
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
@@ -193,7 +199,7 @@ static int hfsplus_readdir(struct file *
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 			fd.entrylength);
 		type = be16_to_cpu(entry.type);
-		len = HFSPLUS_MAX_STRLEN;
+		len = NLS_MAX_CHARSET_SIZE * HFSPLUS_MAX_STRLEN;
 		err = hfsplus_uni2asc(sb, &fd.key->cat.name, strbuf, &len);
 		if (err)
 			goto out;
@@ -246,6 +252,7 @@ next:
 	}
 	memcpy(&rd->key, fd.key, sizeof(struct hfsplus_cat_key));
 out:
+	kfree(strbuf);
 	hfs_find_exit(&fd);
 	return err;
 }
diff -puN fs/hfsplus/xattr.c~hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes
+++ a/fs/hfsplus/xattr.c
@@ -8,6 +8,7 @@
 
 #include "hfsplus_fs.h"
 #include <linux/posix_acl_xattr.h>
+#include <linux/nls.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -645,8 +646,7 @@ ssize_t hfsplus_listxattr(struct dentry
 	struct hfs_find_data fd;
 	u16 key_len = 0;
 	struct hfsplus_attr_key attr_key;
-	char strbuf[HFSPLUS_ATTR_MAX_STRLEN +
-			XATTR_MAC_OSX_PREFIX_LEN + 1] = {0};
+	char *strbuf;
 	int xattr_name_len;
 
 	if ((!S_ISREG(inode->i_mode) &&
@@ -666,6 +666,13 @@ ssize_t hfsplus_listxattr(struct dentry
 		return err;
 	}
 
+	strbuf = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN +
+			XATTR_MAC_OSX_PREFIX_LEN + 1, GFP_KERNEL);
+	if (!strbuf) {
+		res = -ENOMEM;
+		goto out;
+	}
+
 	err = hfsplus_find_attr(inode->i_sb, inode->i_ino, NULL, &fd);
 	if (err) {
 		if (err == -ENOENT) {
@@ -692,7 +699,7 @@ ssize_t hfsplus_listxattr(struct dentry
 		if (be32_to_cpu(attr_key.cnid) != inode->i_ino)
 			goto end_listxattr;
 
-		xattr_name_len = HFSPLUS_ATTR_MAX_STRLEN;
+		xattr_name_len = NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN;
 		if (hfsplus_uni2asc(inode->i_sb,
 			(const struct hfsplus_unistr *)&fd.key->attr.key_name,
 					strbuf, &xattr_name_len)) {
@@ -718,6 +725,7 @@ ssize_t hfsplus_listxattr(struct dentry
 	}
 
 end_listxattr:
+	kfree(strbuf);
 	hfs_find_exit(&fd);
 	return res;
 }
_

Patches currently in -mm which might be from htl10@users.sourceforge.net are

hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch
hfsplus-remove-unused-routine-hfsplus_attr_build_key_uni.patch

