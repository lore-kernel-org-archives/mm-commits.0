From: akpm@linux-foundation.org
Subject: + fs-make-sync_file_range2-use-wb_sync_none-writeback.patch added to -mm tree
Date: Thu, 05 Nov 2015 16:13:02 -0800
Message-ID: <563bf08e.rJcAi9xhgJ5aLWsc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965889AbbKFAND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 19:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, andres@anarazel.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/sync.c: make sync_file_range(2) use WB_SYNC_NONE writeback
has been added to the -mm tree.  Its filename is
     fs-make-sync_file_range2-use-wb_sync_none-writeback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-make-sync_file_range2-use-wb_sync_none-writeback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-make-sync_file_range2-use-wb_sync_none-writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.com>
Subject: fs/sync.c: make sync_file_range(2) use WB_SYNC_NONE writeback

sync_file_range(2) is documented to issue writeback only for pages that
are not currently being written.  After all the system call has been
created for userspace to be able to issue background writeout and so
waiting for in-flight IO is undesirable there.  However commit
ee53a891f474 (mm: do_sync_mapping_range integrity fix) switched
do_sync_mapping_range() and thus sync_file_range() to issue writeback in
WB_SYNC_ALL mode since do_sync_mapping_range() was used by other code
relying on WB_SYNC_ALL semantics.

These days do_sync_mapping_range() went away and we can switch
sync_file_range(2) back to issuing WB_SYNC_NONE writeback.  That should
help PostgreSQL avoid large latency spikes when flushing data in the
background.

Signed-off-by: Jan Kara <jack@suse.com>
Reported-by: Andres Freund <andres@anarazel.de>
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

fs-make-sync_file_range2-use-wb_sync_none-writeback.patch

