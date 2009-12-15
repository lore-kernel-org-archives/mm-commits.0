From: akpm@linux-foundation.org
Subject: [merged] hfs-fix-a-potential-buffer-overflow.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:49:57 -0800
Message-ID: <200912152149.nBFLnv0M014889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760440AbZLOVvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:51:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, adobriyan@gmail.com, anderson@redhat.com, eteo@redhat.com, hch@lst.de, stable@kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, zippel@linux-m68k.


The patch titled
     hfs: fix a potential buffer overflow
has been removed from the -mm tree.  Its filename was
     hfs-fix-a-potential-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: fix a potential buffer overflow
From: Amerigo Wang <amwang@redhat.com>

A specially-crafted Hierarchical File System (HFS) filesystem could cause
a buffer overflow to occur in a process's kernel stack during a memcpy()
call within the hfs_bnode_read() function (at fs/hfs/bnode.c:24).  The
attacker can provide the source buffer and length, and the destination
buffer is a local variable of a fixed length.  This local variable (passed
as "&entry" from fs/hfs/dir.c:112 and allocated on line 60) is stored in
the stack frame of hfs_bnode_read()'s caller, which is hfs_readdir(). 
Because the hfs_readdir() function executes upon any attempt to read a
directory on the filesystem, it gets called whenever a user attempts to
inspect any filesystem contents.

[amwang@redhat.com: modify this patch and fix coding style problems]
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/catalog.c |    4 ++++
 fs/hfs/dir.c     |   11 +++++++++++
 fs/hfs/super.c   |    7 ++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff -puN fs/hfs/catalog.c~hfs-fix-a-potential-buffer-overflow fs/hfs/catalog.c
--- a/fs/hfs/catalog.c~hfs-fix-a-potential-buffer-overflow
+++ a/fs/hfs/catalog.c
@@ -289,6 +289,10 @@ int hfs_cat_move(u32 cnid, struct inode 
 	err = hfs_brec_find(&src_fd);
 	if (err)
 		goto out;
+	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
+		err = -EIO;
+		goto out;
+	}
 
 	hfs_bnode_read(src_fd.bnode, &entry, src_fd.entryoffset,
 			    src_fd.entrylength);
diff -puN fs/hfs/dir.c~hfs-fix-a-potential-buffer-overflow fs/hfs/dir.c
--- a/fs/hfs/dir.c~hfs-fix-a-potential-buffer-overflow
+++ a/fs/hfs/dir.c
@@ -79,6 +79,11 @@ static int hfs_readdir(struct file *filp
 		filp->f_pos++;
 		/* fall through */
 	case 1:
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		if (entry.type != HFS_CDR_THD) {
 			printk(KERN_ERR "hfs: bad catalog folder thread\n");
@@ -109,6 +114,12 @@ static int hfs_readdir(struct file *filp
 			err = -EIO;
 			goto out;
 		}
+
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		type = entry.type;
 		len = hfs_mac2asc(sb, strbuf, &fd.key->cat.CName);
diff -puN fs/hfs/super.c~hfs-fix-a-potential-buffer-overflow fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-fix-a-potential-buffer-overflow
+++ a/fs/hfs/super.c
@@ -409,8 +409,13 @@ static int hfs_fill_super(struct super_b
 	/* try to get the root inode */
 	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
 	res = hfs_cat_find_brec(sb, HFS_ROOT_CNID, &fd);
-	if (!res)
+	if (!res) {
+		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
+			res =  -EIO;
+			goto bail;
+		}
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset, fd.entrylength);
+	}
 	if (res) {
 		hfs_find_exit(&fd);
 		goto bail_no_root;
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
xtensa-use-generic-sys_pipe.patch
ipc-remove-unreachable-code-in-semc.patch
ipc-remove-unreachable-code-in-semc-fix.patch
ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

