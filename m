From: akpm@linux-foundation.org
Subject: + hfs-add-basic-export-support.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:54:42 -0800
Message-ID: <200812070754.mB77sgV6009682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYLGHzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:55:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: flameeyes@gmail.com, hch@lst.de, neilb@suse.de, zippel@linux-m68k.org


The patch titled
     hfs+: add basic export support
has been added to the -mm tree.  Its filename is
     hfs-add-basic-export-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hfs+: add basic export support
=46rom: "Diego Elio 'Flameeyes' Petten=F2" <flameeyes@gmail.com>

The function's skeleton is taken from ext2/super.c and seems to work fi=
ne
for R/W access to HFS+ non-journaled case-sensitive filesystems.

It's probably slow and has a lot of space for improvement but it's stil=
l
better than having no hope to export HFS+ filesystems.

Signed-off-by: "Diego Elio 'Flameeyes' Petten=F2"  <flameeyes@gmail.com=
>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |   49 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff -puN fs/hfsplus/super.c~hfs-add-basic-export-support fs/hfsplus/su=
per.c
--- a/fs/hfsplus/super.c~hfs-add-basic-export-support
+++ a/fs/hfsplus/super.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/fs.h>
+#include <linux/exportfs.h>
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/nls.h>
@@ -287,6 +288,53 @@ static const struct super_operations hfs
 	.show_options	=3D hfsplus_show_options,
 };
=20
+static struct inode *hfsplus_export_get_inode(struct super_block *sb,
+					      u64 ino, u32 generation)
+{
+	struct inode *inode;
+
+	if (ino < HFSPLUS_FIRSTUSER_CNID && ino !=3D HFSPLUS_ROOT_CNID)
+		return ERR_PTR(-ESTALE);
+
+	/* iget isn't really right if the inode is currently unallocated!!
+	 */
+	inode =3D hfsplus_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation !=3D generation) {
+		/* we didn't find the right inode.. */
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+	return inode;
+}
+
+static struct dentry *hfsplus_fh_to_dentry(struct super_block *sb, str=
uct fid *fid,
+					   int fh_len, int fh_type)
+
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    hfsplus_export_get_inode);
+}
+
+static struct dentry *hfsplus_fh_to_parent(struct super_block *sb, str=
uct fid *fid,
+					   int fh_len, int fh_type)
+
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    hfsplus_export_get_inode);
+}
+
+/* Yes, most of these are left as NULL!!
+ * A NULL value implies the default, which (hopefully) works with
+ * hfs+-like file systems, but can be improved upon.
+ * Currently only fh_to_dentry is required.
+ */
+static const struct export_operations hfsplus_export_ops =3D {
+	.fh_to_dentry =3D hfsplus_fh_to_dentry,
+	.fh_to_parent =3D hfsplus_fh_to_parent,
+};
+
 static int hfsplus_fill_super(struct super_block *sb, void *data, int =
silent)
 {
 	struct hfsplus_vh *vhdr;
@@ -351,6 +399,7 @@ static int hfsplus_fill_super(struct sup
=20
 	/* Set up operations so we can load metadata */
 	sb->s_op =3D &hfsplus_sops;
+	sb->s_export_op =3D &hfsplus_export_ops;
 	sb->s_maxbytes =3D MAX_LFS_FILESIZE;
=20
 	if (!(vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_UNMNT))) {
_

Patches currently in -mm which might be from flameeyes@gmail.com are

hfs-add-basic-export-support.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
