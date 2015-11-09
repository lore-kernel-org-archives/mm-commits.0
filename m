From: akpm@linux-foundation.org
Subject: [merged]
 fs-make-sync_file_range2-use-wb_sync_none-writeback.patch removed from -mm
 tree
Date: Mon, 09 Nov 2015 11:44:46 -0800
Message-ID: <5640f7ae.lvy3FLmY5I5N/XWl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbbKIToq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, andres@anarazel.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/sync.c: make sync_file_range(2) use WB_SYNC_NONE writeback
has been removed from the -mm tree.  Its filename was
     fs-make-sync_file_range2-use-wb_sync_none-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.com>
Subject: fs/sync.c: make sync_file_range(2) use WB_SYNC_NONE writeback

sync_file_range(2) is documented to issue writeback only for pages that
are not currently being written.  After all the system call has been
created for userspace to be able to issue background writeout and so
waiting for in-flight IO is undesirable there.  However commit
ee53a891f474 ("mm: do_sync_mapping_range integrity fix") switched
do_sync_mapping_range() and thus sync_file_range() to issue writeback in
WB_SYNC_ALL mode since do_sync_mapping_range() was used by other code
relying on WB_SYNC_ALL semantics.

These days do_sync_mapping_range() went away and we can switch
sync_file_range(2) back to issuing WB_SYNC_NONE writeback.  That should
help PostgreSQL avoid large latency spikes when flushing data in the
background.

Andres measured a 20% increase in transactions per second on an SSD disk.

Signed-off-by: Jan Kara <jack@suse.com>
Reported-by: Andres Freund <andres@anarazel.de>
Tested-By: Andres Freund <andres@anarazel.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/sync.c~fs-make-sync_file_range2-use-wb_sync_none-writeback fs/sync.c
--- a/fs/sync.c~fs-make-sync_file_range2-use-wb_sync_none-writeback
+++ a/fs/sync.c
@@ -348,7 +348,8 @@ SYSCALL_DEFINE4(sync_file_range, int, fd
 	}
 
 	if (flags & SYNC_FILE_RANGE_WRITE) {
-		ret = filemap_fdatawrite_range(mapping, offset, endbyte);
+		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
+						 WB_SYNC_NONE);
 		if (ret < 0)
 			goto out_put;
 	}
_

Patches currently in -mm which might be from jack@suse.com are


