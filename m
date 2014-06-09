From: akpm@linux-foundation.org
Subject: [merged] hfsplus-emit-proper-file-type-from-readdir.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:52 -0700
Message-ID: <53960ba8.6VPXWTcOLHd6+YVT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFITbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, slava@dubeyko.com, htl10@users.sourceforge.net, hch@infradead.org, aia21@cam.ac.uk, saproj@gmail.com

Subject: [merged] hfsplus-emit-proper-file-type-from-readdir.patch removed from -mm tree
To: saproj@gmail.com,aia21@cam.ac.uk,hch@infradead.org,htl10@users.sourceforge.net,slava@dubeyko.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:52 -0700


The patch titled
     Subject: hfsplus: emit proper file type from readdir
has been removed from the -mm tree.  Its filename was
     hfsplus-emit-proper-file-type-from-readdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Antonov <saproj@gmail.com>
Subject: hfsplus: emit proper file type from readdir

hfsplus_readdir() incorrectly returned DT_REG for symbolic links and
special files.  Return DT_REG, DT_LNK, DT_FIFO, DT_CHR, DT_BLK, DT_SOCK,
or DT_UNKNOWN according to mode field in catalog record.  Programs relying
on information from readdir will now work correctly with HFS+.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/dir.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/dir.c~hfsplus-emit-proper-file-type-from-readdir fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-emit-proper-file-type-from-readdir
+++ a/fs/hfsplus/dir.c
@@ -218,13 +218,31 @@ static int hfsplus_readdir(struct file *
 				    be32_to_cpu(entry.folder.id), DT_DIR))
 				break;
 		} else if (type == HFSPLUS_FILE) {
+			u16 mode;
+			unsigned type = DT_UNKNOWN;
+
 			if (fd.entrylength < sizeof(struct hfsplus_cat_file)) {
 				pr_err("small file entry\n");
 				err = -EIO;
 				goto out;
 			}
+
+			mode = be16_to_cpu(entry.file.permissions.mode);
+			if (S_ISREG(mode))
+				type = DT_REG;
+			else if (S_ISLNK(mode))
+				type = DT_LNK;
+			else if (S_ISFIFO(mode))
+				type = DT_FIFO;
+			else if (S_ISCHR(mode))
+				type = DT_CHR;
+			else if (S_ISBLK(mode))
+				type = DT_BLK;
+			else if (S_ISSOCK(mode))
+				type = DT_SOCK;
+
 			if (!dir_emit(ctx, strbuf, len,
-				    be32_to_cpu(entry.file.id), DT_REG))
+				      be32_to_cpu(entry.file.id), type))
 				break;
 		} else {
 			pr_err("bad catalog entry type\n");
_

Patches currently in -mm which might be from saproj@gmail.com are

origin.patch

