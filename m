From: akpm@linux-foundation.org
Subject: [merged] fs-affs-superc-remove-unused-variable.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:30 -0700
Message-ID: <543d69aa.haCl9i84GpGK8NNk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/super.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     fs-affs-superc-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/super.c: remove unused variable

key is set in affs_fill_super but never used.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/affs/super.c~fs-affs-superc-remove-unused-variable fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-superc-remove-unused-variable
+++ a/fs/affs/super.c
@@ -308,7 +308,6 @@ static int affs_fill_super(struct super_
 	u32			 chksum;
 	int			 num_bm;
 	int			 i, j;
-	s32			 key;
 	kuid_t			 uid;
 	kgid_t			 gid;
 	int			 reserved;
@@ -367,7 +366,7 @@ static int affs_fill_super(struct super_
 		i = j = blocksize;
 		size = size / (blocksize / 512);
 	}
-	for (blocksize = i, key = 0; blocksize <= j; blocksize <<= 1, size >>= 1) {
+	for (blocksize = i; blocksize <= j; blocksize <<= 1, size >>= 1) {
 		sbi->s_root_block = root_block;
 		if (root_block < 0)
 			sbi->s_root_block = (reserved + size - 1) / 2;
@@ -399,7 +398,6 @@ static int affs_fill_super(struct super_
 			    be32_to_cpu(AFFS_ROOT_TAIL(sb, root_bh)->stype) == ST_ROOT) {
 				sbi->s_hashsize    = blocksize / 4 - 56;
 				sbi->s_root_block += num_bm;
-				key                        = 1;
 				goto got_root;
 			}
 			affs_brelse(root_bh);
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

