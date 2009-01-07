From: akpm@linux-foundation.org
Subject: - mm-do_sync_mapping_range-integrity-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:45 -0800
Message-ID: <200901072211.n07MBjiN012033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbZAGWLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     mm: do_sync_mapping_range integrity fix
has been removed from the -mm tree.  Its filename was
     mm-do_sync_mapping_range-integrity-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: do_sync_mapping_range integrity fix
From: Nick Piggin <npiggin@suse.de>

Chris Mason notices do_sync_mapping_range didn't actually ask for data
integrity writeout.  Unfortunately, it is advertised as being usable for
data integrity operations.

This is a data integrity bug.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sync.c~mm-do_sync_mapping_range-integrity-fix fs/sync.c
--- a/fs/sync.c~mm-do_sync_mapping_range-integrity-fix
+++ a/fs/sync.c
@@ -295,7 +295,7 @@ int do_sync_mapping_range(struct address
 
 	if (flags & SYNC_FILE_RANGE_WRITE) {
 		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
-						WB_SYNC_NONE);
+						WB_SYNC_ALL);
 		if (ret < 0)
 			goto out;
 	}
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

