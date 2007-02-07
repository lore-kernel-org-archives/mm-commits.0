From: akpm@linux-foundation.org
Subject: + fs-speedup-rw_verify_area.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:16:05 -0800
Message-ID: <200702072316.l17NG5RX030837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422847AbXBGXRR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com


The patch titled
     FS: speed up rw_verify_area()
has been added to the -mm tree.  Its filename is
     fs-speedup-rw_verify_area.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FS: speed up rw_verify_area()
From: Eric Dumazet <dada1@cosmosbay.com>

oprofile hunting showed a stall in rw_verify_area(), because of triple
indirection and potential cache misses. 
(file->f_path.dentry->d_inode->i_flock)

By moving initialization of 'struct inode' pointer before the pos/count
sanity tests, we allow the compiler and processor to perform two loads by
anticipation, reducing stall, without prefetch() hints.  Even x86 arch has
enough registers to not use temporary variables and not increase text size.

I validated this patch running a bench and studied oprofile changes, and
absolute perf of the test program.

Results of my epoll_pipe_bench (source available on request) on a Pentium-M
1.6 GHz machine

Before :
# ./epoll_pipe_bench -l 30 -t 20
Avg: 436089 evts/sec read_count=8843037 write_count=8843040 21.218390 samples
per call
(best value out of 10 runs)

After :
# ./epoll_pipe_bench -l 30 -t 20
Avg: 470980 evts/sec read_count=9549871 write_count=9549894 21.216694 samples
per call
(best value out of 10 runs)

oprofile CPU_CLK_UNHALTED events gave a reduction from 5.3401 % to 2.5851 %
for the rw_verify_area() function.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/read_write.c~fs-speedup-rw_verify_area fs/read_write.c
--- a/fs/read_write.c~fs-speedup-rw_verify_area
+++ a/fs/read_write.c
@@ -197,13 +197,13 @@ int rw_verify_area(int read_write, struc
 	struct inode *inode;
 	loff_t pos;
 
+	inode = file->f_path.dentry->d_inode;
 	if (unlikely((ssize_t) count < 0))
 		goto Einval;
 	pos = *ppos;
 	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
 		goto Einval;
 
-	inode = file->f_path.dentry->d_inode;
 	if (unlikely(inode->i_flock && MANDATORY_LOCK(inode))) {
 		int retval = locks_mandatory_area(
 			read_write == READ ? FLOCK_VERIFY_READ : FLOCK_VERIFY_WRITE,
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patch
avoid-one-conditional-branch-in-touch_atime.patch
fs-speedup-rw_verify_area.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
