Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D1EEB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 22:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjFUWUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 18:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjFUWUn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 18:20:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B1519B4
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 15:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44023616FB
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 22:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9785BC433C0;
        Wed, 21 Jun 2023 22:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687386040;
        bh=KpUBaEGx5715IONEXcvpKuGMV1/Y4wIkm4KVzvDxNR4=;
        h=Date:To:From:Subject:From;
        b=zg7BOHTcqK8IiU9gJGNfOfQ9MGExK2oZMyqdCt5Vp3W4xCNDPIOGxk7B7ukeyn3Gp
         b1w9pDyLYc0MGYm4KUhgmH3cxiZiFtqcNVCv96uqy0tjfyLMbtu9kg+fB2SWRk2kD4
         ZDT6/6Sk95uBcs6LF1DUP6PJCG6fKLNH9MPTCXGM=
Date:   Wed, 21 Jun 2023 15:20:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vannapurve@google.com, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, oliver.sang@intel.com,
        gregkh@linuxfoundation.org, erdemaktas@google.com,
        ackerleytng@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-revert-use-of-page_cache_next_miss.patch added to mm-unstable branch
Message-Id: <20230621222040.9785BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: revert use of page_cache_next_miss()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-revert-use-of-page_cache_next_miss.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-revert-use-of-page_cache_next_miss.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20230621212403.174710-2-mike.kravetz@oracle.com
Fixes: d0ce0e47b323 ("mm/hugetlb: convert hugetlb fault paths to use alloc_hugetlb_folio()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Ackerley Tng <ackerleytng@google.com>
Closes: https://lore.kernel.org/linux-mm/cover.1683069252.git.ackerleytng@google.com
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Reviewed-by Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    8 +++-----
 mm/hugetlb.c         |   11 +++++------
 2 files changed, 8 insertions(+), 11 deletions(-)

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
@@ -5728,13 +5728,12 @@ static bool hugetlbfs_pagecache_present(
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
+	if (!IS_ERR(folio))
+		folio_put(folio);
+	return folio != NULL;
 }
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

revert-page-cache-fix-page_cache_next-prev_miss-off-by-one.patch
hugetlb-revert-use-of-page_cache_next_miss.patch

