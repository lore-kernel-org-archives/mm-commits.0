From: akpm@linux-foundation.org
Subject: - omfs-sparse-annotations.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:27 -0700
Message-ID: <200807301915.m6UJFRRX011025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbYG3TYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, me@bobcopeland.com, mm-commits@vger.kernel.org


The patch titled
     omfs: sparse annotations
has been removed from the -mm tree.  Its filename was
     omfs-sparse-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omfs: sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>

Missing cpu_to_be64 on some constant assignments.
fs/omfs/dir.c:107:16: warning: incorrect type in assignment (different base types)
fs/omfs/dir.c:107:16:    expected restricted __be64 [usertype] i_sibling
fs/omfs/dir.c:107:16:    got unsigned long long
fs/omfs/file.c:33:13: warning: incorrect type in assignment (different base types)
fs/omfs/file.c:33:13:    expected restricted __be64 [usertype] e_next
fs/omfs/file.c:33:13:    got unsigned long long
fs/omfs/file.c:36:24: warning: incorrect type in assignment (different base types)
fs/omfs/file.c:36:24:    expected restricted __be64 [usertype] e_cluster
fs/omfs/file.c:36:24:    got unsigned long long
fs/omfs/file.c:37:23: warning: incorrect type in assignment (different base types)
fs/omfs/file.c:37:23:    expected restricted __be64 [usertype] e_blocks
fs/omfs/file.c:37:23:    got unsigned long long

fs/omfs/bitmap.c:74:18: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:74:18:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:74:18:    got long *<noident>
fs/omfs/bitmap.c:77:20: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:77:20:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:77:20:    got long *<noident>
fs/omfs/bitmap.c:112:17: warning: incorrect type in argument 2 (different signedness)
fs/omfs/bitmap.c:112:17:    expected unsigned long volatile *addr
fs/omfs/bitmap.c:112:17:    got long *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/bitmap.c |    6 +++---
 fs/omfs/dir.c    |    2 +-
 fs/omfs/file.c   |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/omfs/bitmap.c~omfs-sparse-annotations fs/omfs/bitmap.c
--- a/fs/omfs/bitmap.c~omfs-sparse-annotations
+++ a/fs/omfs/bitmap.c
@@ -71,10 +71,10 @@ static int set_run(struct super_block *s
 		}
 		if (set) {
 			set_bit(bit, sbi->s_imap[map]);
-			set_bit(bit, (long *) bh->b_data);
+			set_bit(bit, (unsigned long *)bh->b_data);
 		} else {
 			clear_bit(bit, sbi->s_imap[map]);
-			clear_bit(bit, (long *) bh->b_data);
+			clear_bit(bit, (unsigned long *)bh->b_data);
 		}
 	}
 	mark_buffer_dirty(bh);
@@ -109,7 +109,7 @@ int omfs_allocate_block(struct super_blo
 		if (!bh)
 			goto out;
 
-		set_bit(bit, (long *) bh->b_data);
+		set_bit(bit, (unsigned long *)bh->b_data);
 		mark_buffer_dirty(bh);
 		brelse(bh);
 	}
diff -puN fs/omfs/dir.c~omfs-sparse-annotations fs/omfs/dir.c
--- a/fs/omfs/dir.c~omfs-sparse-annotations
+++ a/fs/omfs/dir.c
@@ -104,7 +104,7 @@ int omfs_make_empty(struct inode *inode,
 
 	oi = (struct omfs_inode *) bh->b_data;
 	oi->i_head.h_self = cpu_to_be64(inode->i_ino);
-	oi->i_sibling = ~0ULL;
+	oi->i_sibling = ~cpu_to_be64(0ULL);
 
 	mark_buffer_dirty(bh);
 	brelse(bh);
diff -puN fs/omfs/file.c~omfs-sparse-annotations fs/omfs/file.c
--- a/fs/omfs/file.c~omfs-sparse-annotations
+++ a/fs/omfs/file.c
@@ -30,11 +30,11 @@ void omfs_make_empty_table(struct buffer
 {
 	struct omfs_extent *oe = (struct omfs_extent *) &bh->b_data[offset];
 
-	oe->e_next = ~0ULL;
+	oe->e_next = ~cpu_to_be64(0ULL);
 	oe->e_extent_count = cpu_to_be32(1),
 	oe->e_fill = cpu_to_be32(0x22),
-	oe->e_entry.e_cluster = ~0ULL;
-	oe->e_entry.e_blocks = ~0ULL;
+	oe->e_entry.e_cluster = ~cpu_to_be64(0ULL);
+	oe->e_entry.e_blocks = ~cpu_to_be64(0ULL);
 }
 
 int omfs_shrink_inode(struct inode *inode)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
powerpc-replace-__function__-with-__func__.patch
powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
irda-replace-__function__-with-__func__.patch
isdn-use-the-common-ascii-hex-helpers.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

