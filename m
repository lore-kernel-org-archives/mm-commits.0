From: akpm@linux-foundation.org
Subject: [merged] readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:01 -0700
Message-ID: <200906171833.n5HIX1TH031601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759554AbZFQSdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     readahead: remove redundant test in shrink_readahead_size_eio()
has been removed from the -mm tree.  Its filename was
     readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: remove redundant test in shrink_readahead_size_eio()
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/filemap.c~readahead-remove-redundant-test-in-shrink_readahead_size_eio mm/filemap.c
--- a/mm/filemap.c~readahead-remove-redundant-test-in-shrink_readahead_size_eio
+++ a/mm/filemap.c
@@ -1004,9 +1004,6 @@ EXPORT_SYMBOL(grab_cache_page_nowait);
 static void shrink_readahead_size_eio(struct file *filp,
 					struct file_ra_state *ra)
 {
-	if (!ra->ra_pages)
-		return;
