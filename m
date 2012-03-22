From: akpm@linux-foundation.org
Subject: [merged] mm-dont-set-__gfp_write-on-ramfs-sysfs-writes.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:45 -0700
Message-ID: <20120322201845.7DD33A06FD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:46452 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759079Ab2CVUSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:47 -0400
Received: by wibhj13 with SMTP id hj13so59596wib.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, riel@redhat.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't set __GFP_WRITE on ramfs/sysfs writes
has been removed from the -mm tree.  Its filename was
     mm-dont-set-__gfp_write-on-ramfs-sysfs-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: mm: don't set __GFP_WRITE on ramfs/sysfs writes

There is not much point in skipping zones during allocation based on the
dirty usage which they'll never contribute to.  And we'd like to avoid
page reclaim waits when writing to ramfs/sysfs etc.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-dont-set-__gfp_write-on-ramfs-sysfs-writes mm/filemap.c
--- a/mm/filemap.c~mm-dont-set-__gfp_write-on-ramfs-sysfs-writes
+++ a/mm/filemap.c
@@ -2341,7 +2341,9 @@ struct page *grab_cache_page_write_begin
 	struct page *page;
 	gfp_t gfp_notmask = 0;
 
-	gfp_mask = mapping_gfp_mask(mapping) | __GFP_WRITE;
+	gfp_mask = mapping_gfp_mask(mapping);
+	if (mapping_cap_account_dirty(mapping))
+		gfp_mask |= __GFP_WRITE;
 	if (flags & AOP_FLAG_NOFS)
 		gfp_notmask = __GFP_FS;
 repeat:
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch

