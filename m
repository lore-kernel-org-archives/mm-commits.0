Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843EBC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiGRARI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiGRAQs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE0DFD39
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD365B80EEA
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7524AC3411E;
        Mon, 18 Jul 2022 00:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103402;
        bh=L5nSc7ASfzvQzxAwOPOI0dKRnobygfgm5tEod/x2LnY=;
        h=Date:To:From:Subject:From;
        b=fDOyloNYZjfKK/6e/CmfYKfPZvwF8m+TyShwUITomc9079z+YwzxyjUtQZ4Hk1qo1
         u8KJEUTrHueufsf7AWdWXowPp9wbN/hH+CGQUCyJw+SYXYxOW6LqNpFlmj0+63S9Rq
         sBCkB1UasF/1IS/bnTrafseIT/A3h/cec80f/Skc=
Date:   Sun, 17 Jul 2022 17:16:41 -0700
To:     mm-commits@vger.kernel.org, zhengbin13@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk,
        riteshh@linux.ibm.com, rgoldwyn@suse.de, rgoldwyn@suse.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, jane.chu@oracle.com,
        hch@lst.de, djwong@kernel.org, david@fromorbit.com,
        dan.j.williams@intel.com, dan.j.wiliams@intel.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-factor-helpers-for-memory_failure_dev_pagemap.patch removed from -mm tree
Message-Id: <20220718001642.7524AC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: factor helpers for memory_failure_dev_pagemap
has been removed from the -mm tree.  Its filename was
     mm-factor-helpers-for-memory_failure_dev_pagemap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: mm: factor helpers for memory_failure_dev_pagemap
Date: Fri, 3 Jun 2022 13:37:26 +0800

memory_failure_dev_pagemap code is a bit complex before introduce RMAP
feature for fsdax.  So it is needed to factor some helper functions to
simplify these code.

[akpm@linux-foundation.org: fix CONFIG_HUGETLB_PAGE=n build]
[zhengbin13@huawei.com: fix redefinition of mf_generic_kill_procs]
  Link: https://lkml.kernel.org/r/20220628112143.1170473-1-zhengbin13@huawei.com
Link: https://lkml.kernel.org/r/20220603053738.1218681-3-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.wiliams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  171 +++++++++++++++++++++++-------------------
 1 file changed, 95 insertions(+), 76 deletions(-)

--- a/mm/memory-failure.c~mm-factor-helpers-for-memory_failure_dev_pagemap
+++ a/mm/memory-failure.c
@@ -1499,6 +1499,95 @@ static int try_to_split_thp_page(struct
 	return 0;
 }
 
+static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
+		struct address_space *mapping, pgoff_t index, int flags)
+{
+	struct to_kill *tk;
+	unsigned long size = 0;
+
+	list_for_each_entry(tk, to_kill, nd)
+		if (tk->size_shift)
+			size = max(size, 1UL << tk->size_shift);
+
+	if (size) {
+		/*
+		 * Unmap the largest mapping to avoid breaking up device-dax
+		 * mappings which are constant size. The actual size of the
+		 * mapping being torn down is communicated in siginfo, see
+		 * kill_proc()
+		 */
+		loff_t start = (index << PAGE_SHIFT) & ~(size - 1);
+
+		unmap_mapping_range(mapping, start, size, 0);
+	}
+
+	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
+}
+
+static int mf_generic_kill_procs(unsigned long long pfn, int flags,
+		struct dev_pagemap *pgmap)
+{
+	struct page *page = pfn_to_page(pfn);
+	LIST_HEAD(to_kill);
+	dax_entry_t cookie;
+	int rc = 0;
+
+	/*
+	 * Pages instantiated by device-dax (not filesystem-dax)
+	 * may be compound pages.
+	 */
+	page = compound_head(page);
+
+	/*
+	 * Prevent the inode from being freed while we are interrogating
+	 * the address_space, typically this would be handled by
+	 * lock_page(), but dax pages do not use the page lock. This
+	 * also prevents changes to the mapping of this pfn until
+	 * poison signaling is complete.
+	 */
+	cookie = dax_lock_page(page);
+	if (!cookie)
+		return -EBUSY;
+
+	if (hwpoison_filter(page)) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+		/*
+		 * TODO: Handle device pages which may need coordination
+		 * with device-side memory.
+		 */
+		rc = -ENXIO;
+		goto unlock;
+	default:
+		break;
+	}
+
+	/*
+	 * Use this flag as an indication that the dax page has been
+	 * remapped UC to prevent speculative consumption of poison.
+	 */
+	SetPageHWPoison(page);
+
+	/*
+	 * Unlike System-RAM there is no possibility to swap in a
+	 * different physical page at a given virtual address, so all
+	 * userspace consumption of ZONE_DEVICE memory necessitates
+	 * SIGBUS (i.e. MF_MUST_KILL)
+	 */
+	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
+	collect_procs(page, &to_kill, true);
+
+	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
+unlock:
+	dax_unlock_page(page, cookie);
+	return rc;
+}
+
 /*
  * Called from hugetlb code with hugetlb_lock held.
  *
@@ -1634,23 +1723,20 @@ out:
 	unlock_page(head);
 	return res;
 }
+
 #else
 static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 {
 	return 0;
 }
-#endif
+
+#endif	/* CONFIG_HUGETLB_PAGE */
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
 	struct page *page = pfn_to_page(pfn);
-	unsigned long size = 0;
-	struct to_kill *tk;
-	LIST_HEAD(tokill);
-	int rc = -EBUSY;
-	loff_t start;
-	dax_entry_t cookie;
+	int rc = -ENXIO;
 
 	if (flags & MF_COUNT_INCREASED)
 		/*
@@ -1659,77 +1745,10 @@ static int memory_failure_dev_pagemap(un
 		put_page(page);
 
 	/* device metadata space is not recoverable */
-	if (!pgmap_pfn_valid(pgmap, pfn)) {
-		rc = -ENXIO;
-		goto out;
-	}
-
-	/*
-	 * Pages instantiated by device-dax (not filesystem-dax)
-	 * may be compound pages.
-	 */
-	page = compound_head(page);
-
-	/*
-	 * Prevent the inode from being freed while we are interrogating
-	 * the address_space, typically this would be handled by
-	 * lock_page(), but dax pages do not use the page lock. This
-	 * also prevents changes to the mapping of this pfn until
-	 * poison signaling is complete.
-	 */
-	cookie = dax_lock_page(page);
-	if (!cookie)
+	if (!pgmap_pfn_valid(pgmap, pfn))
 		goto out;
 
-	if (hwpoison_filter(page)) {
-		rc = -EOPNOTSUPP;
-		goto unlock;
-	}
-
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-		/*
-		 * TODO: Handle device pages which may need coordination
-		 * with device-side memory.
-		 */
-		goto unlock;
-	default:
-		break;
-	}
-
-	/*
-	 * Use this flag as an indication that the dax page has been
-	 * remapped UC to prevent speculative consumption of poison.
-	 */
-	SetPageHWPoison(page);
-
-	/*
-	 * Unlike System-RAM there is no possibility to swap in a
-	 * different physical page at a given virtual address, so all
-	 * userspace consumption of ZONE_DEVICE memory necessitates
-	 * SIGBUS (i.e. MF_MUST_KILL)
-	 */
-	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(page, &tokill, true);
-
-	list_for_each_entry(tk, &tokill, nd)
-		if (tk->size_shift)
-			size = max(size, 1UL << tk->size_shift);
-	if (size) {
-		/*
-		 * Unmap the largest mapping to avoid breaking up
-		 * device-dax mappings which are constant size. The
-		 * actual size of the mapping being torn down is
-		 * communicated in siginfo, see kill_proc()
-		 */
-		start = (page->index << PAGE_SHIFT) & ~(size - 1);
-		unmap_mapping_range(page->mapping, start, size, 0);
-	}
-	kill_procs(&tokill, true, false, pfn, flags);
-	rc = 0;
-unlock:
-	dax_unlock_page(page, cookie);
+	rc = mf_generic_kill_procs(pfn, flags, pgmap);
 out:
 	/* drop pgmap ref acquired in caller */
 	put_dev_pagemap(pgmap);
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


