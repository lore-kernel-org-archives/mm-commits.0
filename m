From: akpm@linux-foundation.org
Subject: [merged] fs-affs-inodec-remove-unused-variable.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:32 -0700
Message-ID: <543d69ac.iTpQW/QBVps97YZX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/inode.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     fs-affs-inodec-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

