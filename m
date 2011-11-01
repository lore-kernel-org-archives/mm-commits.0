From: akpm@linux-foundation.org
Subject: [merged] ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:17 -0700
Message-ID: <201111012109.pA1L9I2A015021@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29015 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, min


The patch titled
     Subject: ext4: warn if direct reclaim tries to writeback pages
has been removed from the -mm tree.  Its filename was
     ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: ext4: warn if direct reclaim tries to writeback pages

Direct reclaim should never writeback pages.  Warn if an attempt is made.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/ext4/inode.c~ext4-warn-if-direct-reclaim-tries-to-writeback-pages fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-warn-if-direct-reclaim-tries-to-writeback-pages
+++ a/fs/ext4/inode.c
@@ -1811,8 +1811,12 @@ static int ext4_writepage(struct page *p
 		 * We don't want to do block allocation, so redirty
 		 * the page and return.  We may reach here when we do
 		 * a journal commit via journal_submit_inode_data_buffers.
-		 * We can also reach here via shrink_page_list
+		 * We can also reach here via shrink_page_list but it
+		 * should never be for direct reclaim so warn if that
+		 * happens
 		 */
+		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+								PF_MEMALLOC);
 		goto redirty_page;
 	}
 	if (commit_write)
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch

