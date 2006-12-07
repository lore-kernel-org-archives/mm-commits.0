From: akpm@osdl.org
Subject: - hpfs-fix-printk-format-warnings.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:46 -0800
Message-ID: <200612072303.kB7N3kYj029991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163843AbWLGXEa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hpfs: fix printk format warnings
has been removed from the -mm tree.  Its filename was
     hpfs-fix-printk-format-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hpfs: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix hpfs printk warnings:

fs/hpfs/dir.c:87: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
fs/hpfs/dir.c:147: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'long int'
fs/hpfs/dir.c:148: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'long int'
fs/hpfs/dnode.c:537: warning: format '%08x' expects type 'unsigned int', but argument 5 has type 'long unsigned int'
fs/hpfs/dnode.c:854: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'loff_t'
fs/hpfs/ea.c:247: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
fs/hpfs/inode.c:254: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
fs/hpfs/map.c:129: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'ino_t'
fs/hpfs/map.c:135: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'ino_t'
fs/hpfs/map.c:140: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'ino_t'
fs/hpfs/map.c:147: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'ino_t'
fs/hpfs/map.c:154: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'ino_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/hpfs/dir.c   |   10 +++++++---
 fs/hpfs/dnode.c |   13 +++++++++----
 fs/hpfs/ea.c    |    5 +++--
 fs/hpfs/inode.c |    5 ++++-
 fs/hpfs/map.c   |   20 ++++++++++++++------
 5 files changed, 37 insertions(+), 16 deletions(-)

diff -puN fs/hpfs/dir.c~hpfs-fix-printk-format-warnings fs/hpfs/dir.c
--- a/fs/hpfs/dir.c~hpfs-fix-printk-format-warnings
+++ a/fs/hpfs/dir.c
@@ -84,7 +84,8 @@ static int hpfs_readdir(struct file *fil
 		}
 		if (!fno->dirflag) {
 			e = 1;
-			hpfs_error(inode->i_sb, "not a directory, fnode %08x",inode->i_ino);
+			hpfs_error(inode->i_sb, "not a directory, fnode %08lx",
+					(unsigned long)inode->i_ino);
 		}
 		if (hpfs_inode->i_dno != fno->u.external[0].disk_secno) {
 			e = 1;
@@ -144,8 +145,11 @@ static int hpfs_readdir(struct file *fil
 		}
 		if (de->first || de->last) {
 			if (hpfs_sb(inode->i_sb)->sb_chk) {
-				if (de->first && !de->last && (de->namelen != 2 || de ->name[0] != 1 || de->name[1] != 1)) hpfs_error(inode->i_sb, "hpfs_readdir: bad ^A^A entry; pos = %08x", old_pos);
-				if (de->last && (de->namelen != 1 || de ->name[0] != 255)) hpfs_error(inode->i_sb, "hpfs_readdir: bad \\377 entry; pos = %08x", old_pos);
+				if (de->first && !de->last && (de->namelen != 2
+				    || de ->name[0] != 1 || de->name[1] != 1))
+					hpfs_error(inode->i_sb, "hpfs_readdir: bad ^A^A entry; pos = %08lx", old_pos);
+				if (de->last && (de->namelen != 1 || de ->name[0] != 255))
+					hpfs_error(inode->i_sb, "hpfs_readdir: bad \\377 entry; pos = %08lx", old_pos);
 			}
 			hpfs_brelse4(&qbh);
 			goto again;
diff -puN fs/hpfs/dnode.c~hpfs-fix-printk-format-warnings fs/hpfs/dnode.c
--- a/fs/hpfs/dnode.c~hpfs-fix-printk-format-warnings
+++ a/fs/hpfs/dnode.c
@@ -533,10 +533,13 @@ static void delete_empty_dnode(struct in
 			struct buffer_head *bh;
 			struct dnode *d1;
 			struct quad_buffer_head qbh1;
-			if (hpfs_sb(i->i_sb)->sb_chk) if (up != i->i_ino) {
-				hpfs_error(i->i_sb, "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08x", dno, up, i->i_ino);
+			if (hpfs_sb(i->i_sb)->sb_chk)
+			    if (up != i->i_ino) {
+				hpfs_error(i->i_sb,
+					"bad pointer to fnode, dnode %08x, pointing to %08x, should be %08lx",
+					dno, up, (unsigned long)i->i_ino);
 				return;
-			}
+			    }
 			if ((d1 = hpfs_map_dnode(i->i_sb, down, &qbh1))) {
 				d1->up = up;
 				d1->root_dnode = 1;
@@ -851,7 +854,9 @@ struct hpfs_dirent *map_pos_dirent(struc
 	/* Going to the next dirent */
 	if ((d = de_next_de(de)) < dnode_end_de(dnode)) {
 		if (!(++*posp & 077)) {
-			hpfs_error(inode->i_sb, "map_pos_dirent: pos crossed dnode boundary; pos = %08x", *posp);
+			hpfs_error(inode->i_sb,
+				"map_pos_dirent: pos crossed dnode boundary; pos = %08llx",
+				(unsigned long long)*posp);
 			goto bail;
 		}
 		/* We're going down the tree */
diff -puN fs/hpfs/ea.c~hpfs-fix-printk-format-warnings fs/hpfs/ea.c
--- a/fs/hpfs/ea.c~hpfs-fix-printk-format-warnings
+++ a/fs/hpfs/ea.c
@@ -243,8 +243,9 @@ void hpfs_set_ea(struct inode *inode, st
 		fnode->ea_offs = 0xc4;
 	}
 	if (fnode->ea_offs < 0xc4 || fnode->ea_offs + fnode->acl_size_s + fnode->ea_size_s > 0x200) {
-		hpfs_error(s, "fnode %08x: ea_offs == %03x, ea_size_s == %03x",
-			inode->i_ino, fnode->ea_offs, fnode->ea_size_s);
+		hpfs_error(s, "fnode %08lx: ea_offs == %03x, ea_size_s == %03x",
+			(unsigned long)inode->i_ino,
+			fnode->ea_offs, fnode->ea_size_s);
 		return;
 	}
 	if ((fnode->ea_size_s || !fnode->ea_size_l) &&
diff -puN fs/hpfs/inode.c~hpfs-fix-printk-format-warnings fs/hpfs/inode.c
--- a/fs/hpfs/inode.c~hpfs-fix-printk-format-warnings
+++ a/fs/hpfs/inode.c
@@ -251,7 +251,10 @@ void hpfs_write_inode_nolock(struct inod
 			de->file_size = 0;
 			hpfs_mark_4buffers_dirty(&qbh);
 			hpfs_brelse4(&qbh);
-		} else hpfs_error(i->i_sb, "directory %08x doesn't have '.' entry", i->i_ino);
+		} else
+			hpfs_error(i->i_sb,
+				"directory %08lx doesn't have '.' entry",
+				(unsigned long)i->i_ino);
 	}
 	mark_buffer_dirty(bh);
 	brelse(bh);
diff -puN fs/hpfs/map.c~hpfs-fix-printk-format-warnings fs/hpfs/map.c
--- a/fs/hpfs/map.c~hpfs-fix-printk-format-warnings
+++ a/fs/hpfs/map.c
@@ -126,32 +126,40 @@ struct fnode *hpfs_map_fnode(struct supe
 			struct extended_attribute *ea;
 			struct extended_attribute *ea_end;
 			if (fnode->magic != FNODE_MAGIC) {
-				hpfs_error(s, "bad magic on fnode %08x", ino);
+				hpfs_error(s, "bad magic on fnode %08lx",
+					(unsigned long)ino);
 				goto bail;
 			}
 			if (!fnode->dirflag) {
 				if ((unsigned)fnode->btree.n_used_nodes + (unsigned)fnode->btree.n_free_nodes !=
 				    (fnode->btree.internal ? 12 : 8)) {
-					hpfs_error(s, "bad number of nodes in fnode %08x", ino);
+					hpfs_error(s,
+					   "bad number of nodes in fnode %08lx",
+					    (unsigned long)ino);
 					goto bail;
 				}
 				if (fnode->btree.first_free !=
 				    8 + fnode->btree.n_used_nodes * (fnode->btree.internal ? 8 : 12)) {
-					hpfs_error(s, "bad first_free pointer in fnode %08x", ino);
+					hpfs_error(s,
+					    "bad first_free pointer in fnode %08lx",
+					    (unsigned long)ino);
 					goto bail;
 				}
 			}
 			if (fnode->ea_size_s && ((signed int)fnode->ea_offs < 0xc4 ||
 			   (signed int)fnode->ea_offs + fnode->acl_size_s + fnode->ea_size_s > 0x200)) {
-				hpfs_error(s, "bad EA info in fnode %08x: ea_offs == %04x ea_size_s == %04x",
-					ino, fnode->ea_offs, fnode->ea_size_s);
+				hpfs_error(s,
+					"bad EA info in fnode %08lx: ea_offs == %04x ea_size_s == %04x",
+					(unsigned long)ino,
+					fnode->ea_offs, fnode->ea_size_s);
 				goto bail;
 			}
 			ea = fnode_ea(fnode);
 			ea_end = fnode_end_ea(fnode);
 			while (ea != ea_end) {
 				if (ea > ea_end) {
-					hpfs_error(s, "bad EA in fnode %08x", ino);
+					hpfs_error(s, "bad EA in fnode %08lx",
+						(unsigned long)ino);
 					goto bail;
 				}
 				ea = next_ea(ea);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

