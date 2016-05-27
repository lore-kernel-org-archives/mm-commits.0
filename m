From: akpm@linux-foundation.org
Subject: [merged] nilfs2-remove-space-before-comma.patch removed from -mm
 tree
Date: Fri, 27 May 2016 11:42:42 -0700
Message-ID: <57489522.bubXeDdcu8X5mwTx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbcE0Smn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove space before comma
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-space-before-comma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: remove space before comma

Fix checkpatch.pl error "ERROR: space prohibited before that ','
(ctx:WxW)" at nilfs_sufile_set_suinfo().

This also fixes checkpatch.pl warning "WARNING: Prefer 'unsigned int'
to bare use of 'unsigned'" at nilfs_sufile_set_suinfo() and
nilfs_sufile_get_suinfo().

Link: http://lkml.kernel.org/r/1461935747-10380-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    4 ++--
 fs/nilfs2/sufile.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/nilfs2/sufile.c~nilfs2-remove-space-before-comma fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-remove-space-before-comma
+++ a/fs/nilfs2/sufile.c
@@ -819,7 +819,7 @@ out:
  * %-ENOMEM - Insufficient amount of memory available.
  */
 ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
-				unsigned sisz, size_t nsi)
+				unsigned int sisz, size_t nsi)
 {
 	struct buffer_head *su_bh;
 	struct nilfs_segment_usage *su;
@@ -897,7 +897,7 @@ ssize_t nilfs_sufile_get_suinfo(struct i
  * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
  */
 ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
-				unsigned supsz, size_t nsup)
+				unsigned int supsz, size_t nsup)
 {
 	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
 	struct buffer_head *header_bh, *bh;
diff -puN fs/nilfs2/sufile.h~nilfs2-remove-space-before-comma fs/nilfs2/sufile.h
--- a/fs/nilfs2/sufile.h~nilfs2-remove-space-before-comma
+++ a/fs/nilfs2/sufile.h
@@ -42,9 +42,9 @@ int nilfs_sufile_mark_dirty(struct inode
 int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 				   unsigned long nblocks, time_t modtime);
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
-ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
+ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned int,
 				size_t);
-ssize_t nilfs_sufile_set_suinfo(struct inode *, void *, unsigned , size_t);
+ssize_t nilfs_sufile_set_suinfo(struct inode *, void *, unsigned int, size_t);
 
 int nilfs_sufile_updatev(struct inode *, __u64 *, size_t, int, size_t *,
 			 void (*dofunc)(struct inode *, __u64,
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


