From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-fix-segctor-bug-that-causes-file-system-corruption.patch removed
 from -mm tree
Date: Wed, 15 Jan 2014 12:28:40 -0800
Message-ID: <52d6ef78.+W630L5/RVxq13Gh%akpm__33959.8139551983$1389817734$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaAOU2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 15:28:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, andreas.rohner@gmx.net

Subject: [merged] nilfs2-fix-segctor-bug-that-causes-file-system-corruption.patch removed from -mm tree
To: andreas.rohner@gmx.net,konishi.ryusuke@lab.ntt.co.jp,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 12:28:40 -0800


The patch titled
     Subject: nilfs2: fix segctor bug that causes file system corruption
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-segctor-bug-that-causes-file-system-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andreas Rohner <andreas.rohner@gmx.net>
Subject: nilfs2: fix segctor bug that causes file system corruption

There is a bug in the function nilfs_segctor_collect, which results in
active data being written to a segment, that is marked as clean.  It is
possible, that this segment is selected for a later segment construction,
whereby the old data is overwritten.

The problem shows itself with the following kernel log message:

nilfs_sufile_do_cancel_free: segment 6533 must be clean

Usually a few hours later the file system gets corrupted:

NILFS: bad btree node (blocknr=8748107): level = 0, flags = 0x0,
nchildren = 0
NILFS error (device sdc1): nilfs_bmap_last_key: broken bmap
(inode number=114660)

The issue can be reproduced with a file system that is nearly full and
with the cleaner running, while some IO intensive task is running. 
Although it is quite hard to reproduce.

This is what happens:

1. The cleaner starts the segment construction
2. nilfs_segctor_collect is called
3. sc_stage is on NILFS_ST_SUFILE and segments are freed
4. sc_stage is on NILFS_ST_DAT current segment is full
5. nilfs_segctor_extend_segments is called, which
   allocates a new segment
6. The new segment is one of the segments freed in step 3
7. nilfs_sufile_cancel_freev is called and produces an error message
8. Loop around and the collection starts again
9. sc_stage is on NILFS_ST_SUFILE and segments are freed
   including the newly allocated segment, which will contain active data
   and can be allocated at a later time
10. A few hours later another segment construction allocates the segment
    and causes file system corruption

This can be prevented by simply reordering the statements.  If
nilfs_sufile_cancel_freev is called before nilfs_segctor_extend_segments
the freed segments are marked as dirty and cannot be allocated any more.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Reviewed-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/nilfs2/segment.c~nilfs2-fix-segctor-bug-that-causes-file-system-corruption fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-fix-segctor-bug-that-causes-file-system-corruption
+++ a/fs/nilfs2/segment.c
@@ -1440,17 +1440,19 @@ static int nilfs_segctor_collect(struct
 
 		nilfs_clear_logs(&sci->sc_segbufs);
 
-		err = nilfs_segctor_extend_segments(sci, nilfs, nadd);
-		if (unlikely(err))
-			return err;
