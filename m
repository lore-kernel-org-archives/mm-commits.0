Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CF6C6379F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjBMXz2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjBMXzW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6674617144
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 029A46135D
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5861BC433EF;
        Mon, 13 Feb 2023 23:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332519;
        bh=Awpj24ph7ecpVs+gsqIEF/ZGh3hqnKBbpdDuMaT6ZMo=;
        h=Date:To:From:Subject:From;
        b=uWSRmPnW90DaJtNNPzVQ07IXrwkkTVVnujJ0OfUfc5vc+UW2ApSvwOYTqcUtx4LYa
         G5xv7zcnwfMdmVlydH1bAsxEw/rCeKc9vlESSosHzV1QU3yV62lvLWx6xurRdQbAZc
         vr94c129jXXaSq8AvQhfUWWbKU5eY6s+vufh+oKg=
Date:   Mon, 13 Feb 2023 15:55:18 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com, lkp@intel.com,
        jhubbard@nvidia.com, gerald.schaefer@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch removed from -mm tree
Message-Id: <20230213235519.5861BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert hugetlbfs_pagecache_present() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlbfs_pagecache_present() to folios
Date: Wed, 25 Jan 2023 09:05:31 -0800

Refactor hugetlbfs_pagecache_present() to avoid getting and dropping a
refcount on a page.  Use RCU and page_cache_next_miss() instead.

Link: https://lkml.kernel.org/r/20230125170537.96973-3-sidhartha.kumar@oracle.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios
+++ a/mm/hugetlb.c
@@ -5651,17 +5651,15 @@ out_release_old:
 static bool hugetlbfs_pagecache_present(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address)
 {
-	struct address_space *mapping;
-	pgoff_t idx;
-	struct page *page;
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	pgoff_t idx = vma_hugecache_offset(h, vma, address);
+	bool present;
 
-	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, address);
+	rcu_read_lock();
+	present = page_cache_next_miss(mapping, idx, 1) != idx;
+	rcu_read_unlock();
 
-	page = find_get_page(mapping, idx);
-	if (page)
-		put_page(page);
-	return page != NULL;
+	return present;
 }
 
 int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


