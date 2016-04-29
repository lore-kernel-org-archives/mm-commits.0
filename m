From: akpm@linux-foundation.org
Subject: + nilfs2-remove-space-before-comma.patch added to -mm tree
Date: Fri, 29 Apr 2016 13:40:17 -0700
Message-ID: <5723c6b1.ZFA2icLi2lXtjEtg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbcD2UkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 16:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove space before comma
has been added to the -mm tree.  Its filename is
     nilfs2-remove-space-before-comma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-remove-space-before-comma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-remove-space-before-comma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-fix-white-space-issue-in-nilfs_mount.patch
nilfs2-remove-space-before-comma.patch
nilfs2-remove-fsf-mailing-address-from-gpl-notices.patch
nilfs2-clean-up-old-e-mail-addresses.patch
maintainers-add-web-link-for-nilfs-project.patch
nilfs2-clarify-permission-to-replicate-the-design.patch
nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch
nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines.patch
nilfs2-replace-__attribute__packed-with-__packed.patch
nilfs2-add-missing-line-spacing.patch
nilfs2-clean-trailing-semicolons-in-macros.patch

