From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-radix_tree_iter_retry-fix.patch removed
 from -mm tree
Date: Thu, 17 Mar 2016 14:01:16 -0700
Message-ID: <56eb1b1c./l/Ym4txFzQyczKU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965668AbcCQVBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 17:01:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-radix_tree_iter_retry-fix
has been removed from the -mm tree.  Its filename was
     mm-use-radix_tree_iter_retry-fix.patch

This patch was dropped because it was folded into mm-use-radix_tree_iter_retry.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-use-radix_tree_iter_retry-fix

Remove now-obsolete-and-misleading comment.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Matthwe Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/shmem.c~mm-use-radix_tree_iter_retry-fix mm/shmem.c
--- a/mm/shmem.c~mm-use-radix_tree_iter_retry-fix
+++ a/mm/shmem.c
@@ -383,11 +383,6 @@ restart:
 
 		page = radix_tree_deref_slot(slot);
 
-		/*
-		 * This should only be possible to happen at index 0, so we
-		 * don't need to reset the counter, nor do we risk infinite
-		 * restarts.
-		 */
 		if (radix_tree_deref_retry(page)) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-use-radix_tree_iter_retry.patch

