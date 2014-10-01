From: akpm@linux-foundation.org
Subject: + fs-affs-inodec-remove-unused-variable.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:34:40 -0700
Message-ID: <542c7370.kJYc+jjTNMUXNXwi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaJAVek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:34:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/inode.c: remove unused variable
has been added to the -mm tree.  Its filename is
     fs-affs-inodec-remove-unused-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-inodec-remove-unused-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-inodec-remove-unused-variable.patch

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
Subject: fs/affs/inode.c: remove unused variable

head is set to AFFS_HEAD(bh) but never used.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/inode.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/affs/inode.c~fs-affs-inodec-remove-unused-variable fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-inodec-remove-unused-variable
+++ a/fs/affs/inode.c
@@ -20,7 +20,6 @@ struct inode *affs_iget(struct super_blo
 {
 	struct affs_sb_info	*sbi = AFFS_SB(sb);
 	struct buffer_head	*bh;
-	struct affs_head	*head;
 	struct affs_tail	*tail;
 	struct inode		*inode;
 	u32			 block;
@@ -49,7 +48,6 @@ struct inode *affs_iget(struct super_blo
 		goto bad_inode;
 	}
 
-	head = AFFS_HEAD(bh);
 	tail = AFFS_TAIL(sb, bh);
 	prot = be32_to_cpu(tail->protect);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
fs-affs-superc-remove-unused-variable.patch
fs-affs-inodec-remove-unused-variable.patch
linux-next.patch

