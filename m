Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2044EB64DD
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjFXAB1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjFXAAj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1092941
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05800615DE
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57829C433CB;
        Sat, 24 Jun 2023 00:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564836;
        bh=wqvMxWqdKG4hEddp0oWsdxs0QJUA3xP6nHpH3ghN2VI=;
        h=Date:To:From:Subject:From;
        b=y25yyuGnWa0xx0kyOnISV7+QHRN4RIFkO8qPG4KBs5b9cePzHoRfousvjKzCOfQfP
         yXqIHrr56Z4YWSII8MoIsnBm9O1v5wGeTrewNX20XTwoB+uKx2HZOQgYulb2r5koLt
         sZvEsO0U/TCIpekoRBtWPp87z0sZ1Y/64VbFRM+M=
Date:   Fri, 23 Jun 2023 17:00:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vannapurve@google.com, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, gregkh@linuxfoundation.org,
        erdemaktas@google.com, dan.carpenter@linaro.org,
        ackerleytng@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-revert-use-of-page_cache_next_miss.patch removed from -mm tree
Message-Id: <20230624000036.57829C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: revert use of page_cache_next_miss()
has been removed from the -mm tree.  Its filename was
     hugetlb-revert-use-of-page_cache_next_miss.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: revert use of page_cache_next_miss()
Date: Wed, 21 Jun 2023 14:24:03 -0700

Ackerley Tng reported an issue with hugetlbfs fallocate as noted in the
Closes tag.  The issue showed up after the conversion of hugetlb page
cache lookup code to use page_cache_next_miss.  User visible effects are:

- hugetlbfs fallocate incorrectly returns -EEXIST if pages are presnet
  in the file.
- hugetlb pages will not be included in core dumps if they need to be
  brought in via GUP.
- userfaultfd UFFDIO_COPY will not notice pages already present in the
  cache.  It may try to allocate a new page and potentially return
  ENOMEM as opposed to EEXIST.

Revert the use page_cache_next_miss() in hugetlb code.

IMPORTANT NOTE FOR STABLE BACKPORTS:
This patch will apply cleanly to v6.3.  However, due to the change of
filemap_get_folio() return values, it will not function correctly.  This
patch must be modified for stable backports.

[dan.carpenter@linaro.org: fix hugetlbfs_pagecache_present()]
  Link: https://lkml.kernel.org/r/efa86091-6a2c-4064-8f55-9b44e1313015@moroto.mountain
Link: https://lkml.kernel.org/r/20230621212403.174710-2-mike.kravetz@oracle.com
Fixes: d0ce0e47b323 ("mm/hugetlb: convert hugetlb fault paths to use alloc_hugetlb_folio()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reported-by: Ackerley Tng <ackerleytng@google.com>
Closes: https://lore.kernel.org/linux-mm/cover.1683069252.git.ackerleytng@google.com
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    8 +++-----
 mm/hugetlb.c         |   12 ++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-revert-use-of-page_cache_next_miss
+++ a/fs/hugetlbfs/inode.c
@@ -821,7 +821,6 @@ static long hugetlbfs_fallocate(struct f
 		 */
 		struct folio *folio;
 		unsigned long addr;
-		bool present;
 
 		cond_resched();
 
@@ -842,10 +841,9 @@ static long hugetlbfs_fallocate(struct f
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
-		rcu_read_lock();
-		present = page_cache_next_miss(mapping, index, 1) != index;
-		rcu_read_unlock();
-		if (present) {
+		folio = filemap_get_folio(mapping, index);
+		if (!IS_ERR(folio)) {
+			folio_put(folio);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			continue;
 		}
--- a/mm/hugetlb.c~hugetlb-revert-use-of-page_cache_next_miss
+++ a/mm/hugetlb.c
@@ -5728,13 +5728,13 @@ static bool hugetlbfs_pagecache_present(
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	pgoff_t idx = vma_hugecache_offset(h, vma, address);
-	bool present;
+	struct folio *folio;
 
-	rcu_read_lock();
-	present = page_cache_next_miss(mapping, idx, 1) != idx;
-	rcu_read_unlock();
-
-	return present;
+	folio = filemap_get_folio(mapping, idx);
+	if (IS_ERR(folio))
+		return false;
+	folio_put(folio);
+	return true;
 }
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


