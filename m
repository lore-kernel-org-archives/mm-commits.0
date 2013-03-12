From: akpm@linux-foundation.org
Subject: [merged] xfs-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 12 Mar 2013 12:10:04 -0700
Message-ID: <20130312191004.7A24C31C30E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51522 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab3CLTKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 15:10:05 -0400
Received: by mail-ye0-f202.google.com with SMTP id q5so22209yen.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 12:10:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, bpm@sgi.com, elder@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     xfs-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: xfs: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: <bpm@sgi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_alloc.c  |    2 +-
 fs/xfs/xfs_error.c  |    2 +-
 fs/xfs/xfs_ialloc.c |    2 +-
 fs/xfs/xfs_log.c    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/xfs/xfs_alloc.c~xfs-rename-random32-to-prandom_u32 fs/xfs/xfs_alloc.c
--- a/fs/xfs/xfs_alloc.c~xfs-rename-random32-to-prandom_u32
+++ a/fs/xfs/xfs_alloc.c
@@ -842,7 +842,7 @@ xfs_alloc_ag_vextent_near(
 	 */
 	int		dofirst;	/* set to do first algorithm */
 
-	dofirst = random32() & 1;
+	dofirst = prandom_u32() & 1;
 #endif
 
 restart:
diff -puN fs/xfs/xfs_error.c~xfs-rename-random32-to-prandom_u32 fs/xfs/xfs_error.c
--- a/fs/xfs/xfs_error.c~xfs-rename-random32-to-prandom_u32
+++ a/fs/xfs/xfs_error.c
@@ -66,7 +66,7 @@ xfs_error_test(int error_tag, int *fsidp
 	int i;
 	int64_t fsid;
 
-	if (random32() % randfactor)
+	if (prandom_u32() % randfactor)
 		return 0;
 
 	memcpy(&fsid, fsidp, sizeof(xfs_fsid_t));
diff -puN fs/xfs/xfs_ialloc.c~xfs-rename-random32-to-prandom_u32 fs/xfs/xfs_ialloc.c
--- a/fs/xfs/xfs_ialloc.c~xfs-rename-random32-to-prandom_u32
+++ a/fs/xfs/xfs_ialloc.c
@@ -369,7 +369,7 @@ xfs_ialloc_ag_alloc(
 	 * number from being easily guessable.
 	 */
 	error = xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno,
-			args.len, random32());
+			args.len, prandom_u32());
 
 	if (error)
 		return error;
diff -puN fs/xfs/xfs_log.c~xfs-rename-random32-to-prandom_u32 fs/xfs/xfs_log.c
--- a/fs/xfs/xfs_log.c~xfs-rename-random32-to-prandom_u32
+++ a/fs/xfs/xfs_log.c
@@ -3485,7 +3485,7 @@ xlog_ticket_alloc(
 	tic->t_curr_res		= unit_bytes;
 	tic->t_cnt		= cnt;
 	tic->t_ocnt		= cnt;
-	tic->t_tid		= random32();
+	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
 	tic->t_flags		= XLOG_TIC_INITED;
 	tic->t_trans_type	= 0;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

