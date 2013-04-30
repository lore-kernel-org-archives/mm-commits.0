From: akpm@linux-foundation.org
Subject: [merged] direct-io-fix-boundary-block-handling.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:43 -0700
Message-ID: <20130430184443.7DE0231C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60874 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab3D3Soo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:44 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so86087qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, k-mio@sx.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: direct-io: fix boundary block handling
has been removed from the -mm tree.  Its filename was
     direct-io-fix-boundary-block-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: direct-io: fix boundary block handling

When we read/write a file sequentially, we will read/write not only the
data blocks but also the indirect blocks that may not be physically
adjacent to the data blocks.  So filesystems set the BH_Boundary flag to
submit the previous I/O before reading/writing an indirect block.

However the generic direct IO code mishandles buffer_boundary(), setting
sdio->boundary before each submit_page_section() call which results in
sending only one page bios as underlying code thinks this page is the last
in the contiguous extent.  So fix the problem by setting sdio->boundary
only if the current page is really the last one in the mapped extent.

With this patch and "direct-io: submit bio after boundary buffer is added
to it" I've measured about 10% throughput improvement of direct IO reads
on ext3 with SATA harddrive (from 90 MB/s to 100 MB/s).  With ramdisk, the
improvement was about 3-fold (from 350 MB/s to 1.2 GB/s).  For other
filesystems (such as ext4), the improvements won't be as visible because
the frequency of BH_Boundary flag being set is much smaller.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Tested-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/direct-io.c~direct-io-fix-boundary-block-handling fs/direct-io.c
--- a/fs/direct-io.c~direct-io-fix-boundary-block-handling
+++ a/fs/direct-io.c
@@ -969,7 +969,8 @@ do_holes:
 			this_chunk_bytes = this_chunk_blocks << blkbits;
 			BUG_ON(this_chunk_bytes == 0);
 
-			sdio->boundary = buffer_boundary(map_bh);
+			if (this_chunk_blocks == sdio->blocks_available)
+				sdio->boundary = buffer_boundary(map_bh);
 			ret = submit_page_section(dio, sdio, page,
 						  offset_in_page,
 						  this_chunk_bytes,
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
kthread-implement-probe_kthread_data.patch
workqueue-include-workqueue-info-when-printing-debug-dump-of-a-worker-task.patch
writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch

