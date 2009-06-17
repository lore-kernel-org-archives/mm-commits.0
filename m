From: akpm@linux-foundation.org
Subject: [merged] readahead-increase-interleaved-readahead-size.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:39 -0700
Message-ID: <200906171832.n5HIWdPr031148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759989AbZFQSct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, xcf@ustc.edu.cn, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     readahead: increase interleaved readahead size
has been removed from the -mm tree.  Its filename was
     readahead-increase-interleaved-readahead-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: increase interleaved readahead size
From: Wu Fengguang <fengguang.wu@intel.com>

Make sure interleaved readahead size is larger than request size.  This
also makes the readahead window grow up more quickly.

Reported-by: Xu Chenfeng <xcf@ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/readahead.c~readahead-increase-interleaved-readahead-size mm/readahead.c
--- a/mm/readahead.c~readahead-increase-interleaved-readahead-size
+++ a/mm/readahead.c
@@ -403,6 +403,7 @@ ondemand_readahead(struct address_space 
 
 		ra->start = start;
 		ra->size = start - offset;	/* old async_size */
+		ra->size += req_size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
 		goto readit;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

