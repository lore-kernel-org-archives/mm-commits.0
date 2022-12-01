Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FBFC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiLAAFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiLAADn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D103B8EE55
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6910461E6C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57C8C43470;
        Thu,  1 Dec 2022 00:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852902;
        bh=nMV0r9zN4gnQL4kd3YCeMVBSE7SyA1DVZs+kzcQJdyk=;
        h=Date:To:From:Subject:From;
        b=b8NBCSt3VQh94xyrfhNTUCBJjSWaeABbt5hPF02iXfdfkkjRMYP//+BM+CvTrVwL1
         fdnh3zhY6M3I2GijcbQnRP2LypT3P8WGdtq06HTv5OuY4k/HrM1nB+1QCxR0C0ZyaH
         VUwvqxik95hMwpSQnloI2QS55CVwudQej8MQKZUo=
Date:   Wed, 30 Nov 2022 16:01:41 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        haiyue.wang@intel.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch removed from -mm tree
Message-Id: <20221201000142.A57C8C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: migration: fix the FOLL_GET failure on following huge page"
has been removed from the -mm tree.  Its filename was
     revert-mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Revert "mm: migration: fix the FOLL_GET failure on following huge page"
Date: Wed, 9 Nov 2022 16:40:27 +0800

Revert commit 831568214883 ("mm: migration: fix the FOLL_GET failure on
following huge page"), since after commit 1a6baaa0db73 ("s390/hugetlb:
switch to generic version of follow_huge_pud()") and commit 57a196a58421
("hugetlb: simplify hugetlb handling in follow_page_mask") were merged,
now all the following huge page routines can support FOLL_GET operation.

Link: https://lkml.kernel.org/r/496786039852aba90ffa68f10d0df3f4236a990b.1667983080.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Haiyue Wang <haiyue.wang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/migrate.c~revert-mm-migration-fix-the-foll_get-failure-on-following-huge-page
+++ a/mm/migrate.c
@@ -1899,7 +1899,6 @@ static void do_pages_stat_array(struct m
 
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long addr = (unsigned long)(*pages);
-		unsigned int foll_flags = FOLL_DUMP;
 		struct vm_area_struct *vma;
 		struct page *page;
 		int err = -EFAULT;
@@ -1908,12 +1907,8 @@ static void do_pages_stat_array(struct m
 		if (!vma)
 			goto set_status;
 
-		/* Not all huge page follow APIs support 'FOLL_GET' */
-		if (!is_vm_hugetlb_page(vma))
-			foll_flags |= FOLL_GET;
-
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, addr, foll_flags);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
@@ -1926,8 +1921,7 @@ static void do_pages_stat_array(struct m
 		if (!is_zone_device_page(page))
 			err = page_to_nid(page);
 
-		if (foll_flags & FOLL_GET)
-			put_page(page);
+		put_page(page);
 set_status:
 		*status = err;
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


