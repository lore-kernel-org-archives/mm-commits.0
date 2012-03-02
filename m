From: akpm@linux-foundation.org
Subject: + mm-dont-set-__gfp_write-on-ramfs-sysfs-writes.patch added to -mm tree
Date: Fri, 02 Mar 2012 14:14:16 -0800
Message-ID: <20120302221416.BF8E9A01CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:63528 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2CBWOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Mar 2012 17:14:18 -0500
Received: by qcsp5 with SMTP id p5so270788qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 02 Mar 2012 14:14:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, riel@redhat.com, yinghan@google.com


The patch titled
     Subject: mm: don't set __GFP_WRITE on ramfs/sysfs writes
has been added to the -mm tree.  Its filename is
     mm-dont-set-__gfp_write-on-ramfs-sysfs-writes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Minchan Kim <minchan.kim@gmail.com>
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
Subject: Subject: mm: don't set __GFP_WRITE on ramfs/sysfs writes

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-dont-set-__gfp_write-on-ramfs-sysfs-writes.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch

