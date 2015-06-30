From: akpm@linux-foundation.org
Subject: [folded-merged] mm-meminit-inline-some-helper-functions-fix.patch removed from -mm tree
Date: Tue, 30 Jun 2015 14:47:50 -0700
Message-ID: <55930e86.L6JFREnyEafNEcWp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbF3Vrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:47:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-meminit-inline-some-helper-functions-fix
has been removed from the -mm tree.  Its filename was
     mm-meminit-inline-some-helper-functions-fix.patch

This patch was dropped because it was folded into mm-meminit-inline-some-helper-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-meminit-inline-some-helper-functions-fix

mm/page_alloc.c: In function 'memmap_init_zone':
mm/page_alloc.c:4287: error: implicit declaration of function 'early_pfn_in_nid'

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/page_alloc.c~mm-meminit-inline-some-helper-functions-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-inline-some-helper-functions-fix
+++ a/mm/page_alloc.c
@@ -936,8 +936,16 @@ static inline bool __meminit early_pfn_i
 {
 	return meminit_pfn_in_nid(pfn, node, &early_pfnnid_cache);
 }
+
+#else
+
+static inline bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
+{
+	return true;
+}
 #endif
 
+
 #ifdef CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void __init init_cma_reserved_pageblock(struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

