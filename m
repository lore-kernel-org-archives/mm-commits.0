From: akpm@linux-foundation.org
Subject: + fs-affs-filec-replace-if-bug-by-bug_on.patch added to -mm tree
Date: Fri, 02 Jan 2015 15:48:17 -0800
Message-ID: <54a72e41.mHSEcQ0QwUzw3u1u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbbABXsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 18:48:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: replace if/BUG by BUG_ON
has been added to the -mm tree.  Its filename is
     fs-affs-filec-replace-if-bug-by-bug_on.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-replace-if-bug-by-bug_on.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-replace-if-bug-by-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: replace if/BUG by BUG_ON

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-replace-if-bug-by-bug_on fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-replace-if-bug-by-bug_on
+++ a/fs/affs/file.c
@@ -180,8 +180,7 @@ affs_get_extblock_slow(struct inode *ino
 		ext_key = be32_to_cpu(AFFS_TAIL(sb, bh)->extension);
 		if (ext < AFFS_I(inode)->i_extcnt)
 			goto read_ext;
-		if (ext > AFFS_I(inode)->i_extcnt)
-			BUG();
+		BUG_ON(ext > AFFS_I(inode)->i_extcnt);
 		bh = affs_alloc_extblock(inode, bh, ext);
 		if (IS_ERR(bh))
 			return bh;
@@ -198,8 +197,7 @@ affs_get_extblock_slow(struct inode *ino
 		struct buffer_head *prev_bh;
 
 		/* allocate a new extended block */
-		if (ext > AFFS_I(inode)->i_extcnt)
-			BUG();
+		BUG_ON(ext > AFFS_I(inode)->i_extcnt);
 
 		/* get previous extended block */
 		prev_bh = affs_get_extblock(inode, ext - 1);
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
fs-ufs-superc-remove-unnecessary-casting.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
fs-affs-filec-replace-if-bug-by-bug_on.patch
linux-next.patch

