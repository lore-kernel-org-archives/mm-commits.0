From: akpm@linux-foundation.org
Subject: [merged] readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:34 -0700
Message-ID: <200906171832.n5HIWYY1031128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758357AbZFQScm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:32:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, npiggin@suse.de, torvalds@linux-foundation.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     readahead: apply max_sane_readahead() limit in ondemand_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: apply max_sane_readahead() limit in ondemand_readahead()
From: Wu Fengguang <fengguang.wu@intel.com>

Just in case someone aggressively sets a huge readahead size.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-apply-max_sane_readahead-limit-in-ondemand_readahead mm/readahead.c
--- a/mm/readahead.c~readahead-apply-max_sane_readahead-limit-in-ondemand_readahead
+++ a/mm/readahead.c
@@ -357,7 +357,7 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	int	max = ra->ra_pages;	/* max readahead pages */
+	unsigned long max = max_sane_readahead(ra->ra_pages);
 	pgoff_t prev_offset;
 	int	sequential;
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

