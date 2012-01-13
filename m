From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:58 -0800
Message-ID: <20120113203459.2A7AF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2AMUfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:01 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: use synchronous compaction for /proc/sys/vm/compact_memory
has been removed from the -mm tree.  Its filename was
     mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: use synchronous compaction for /proc/sys/vm/compact_memory

When asynchronous compaction was introduced, the
/proc/sys/vm/compact_memory handler should have been updated to always use
synchronous compaction.  This did not happen so this patch addresses it. 
The assumption is if a user writes to /proc/sys/vm/compact_memory, they
are willing for that process to stall.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/compaction.c~mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory mm/compaction.c
--- a/mm/compaction.c~mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory
+++ a/mm/compaction.c
@@ -668,6 +668,7 @@ static int compact_node(int nid)
 			.nr_freepages = 0,
 			.nr_migratepages = 0,
 			.order = -1,
+			.sync = true,
 		};
 
 		zone = &pgdat->node_zones[zoneid];
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch

