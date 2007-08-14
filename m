From: akpm@linux-foundation.org
Subject: - direct-io-fix-error-path-crashes.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:29 -0700
Message-ID: <200708140502.l7E52Taf031979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40295 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761736AbXHNFDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, gurudas.pai@oracle.com, joe.jin@oracle.com, stable@kernel.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     direct-io: fix error-path crashes
has been removed from the -mm tree.  Its filename was
     direct-io-fix-error-path-crashes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: direct-io: fix error-path crashes
From: Badari Pulavarty <pbadari@us.ibm.com>

Need to initialize map_bh.b_state to zero.  Otherwise, in case of a faulty
user-buffer its possible to go into dio_zero_block() and submit a page by
mistake - since it checks for buffer_new().

http://marc.info/?l=linux-kernel&m=118551339032528&w=2

akpm: Linus had a (better) patch to just do a kzalloc() in there, but it got
lost.  Probably this version is better for -stable anwyay.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Joe Jin <joe.jin@oracle.com>
Acked-by: Zach Brown <zach.brown@oracle.com>
Cc: gurudas pai <gurudas.pai@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/direct-io.c~direct-io-fix-error-path-crashes fs/direct-io.c
--- a/fs/direct-io.c~direct-io-fix-error-path-crashes
+++ a/fs/direct-io.c
@@ -974,6 +974,7 @@ direct_io_worker(int rw, struct kiocb *i
 	dio->get_block = get_block;
 	dio->end_io = end_io;
 	dio->map_bh.b_private = NULL;
+	dio->map_bh.b_state = 0;
 	dio->final_block_in_bio = -1;
 	dio->next_block_for_io = -1;
 
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
fix-for-ext2-reservation.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
