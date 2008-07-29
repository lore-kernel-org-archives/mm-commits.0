From: akpm@linux-foundation.org
Subject: + omfs-sparse-annotations.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:56:05 -0700
Message-ID: <200807292256.m6TMu6fX026305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbYG2W4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, me@bobcopeland.com


The patch titled
     omfs: sparse annotations
has been added to the -mm tree.  Its filename is
     omfs-sparse-annotations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/dir.c  |    2 +-
 fs/omfs/file.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

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

omfs-sparse-annotations.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

