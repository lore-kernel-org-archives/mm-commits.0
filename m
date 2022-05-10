Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A48CC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiEJEQg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiEJEPu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5547101161
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720F661738
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D82C385C5;
        Tue, 10 May 2022 04:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155900;
        bh=E9pKlp8LpAru+/5NPfTew3hsnsxKsGVrvAY6xn0gQLI=;
        h=Date:To:From:Subject:From;
        b=UZ1KWkJl8NDLlr6jmTIxlqCbOuKjyjUCT2ItV2+KNjqzs3+IQ3ozz5D9SzZ4Ra5A+
         w4/YEn2AVo366bOAUMwTB+qy5t2FAN6AeFip5O7cDpTfptuoNOnCvKWAqgNFRAQVWd
         GeW8K3t3QVTQLaajbWXdy5M5sTZ2FnnDgV7uT6DY=
Date:   Mon, 09 May 2022 21:11:40 -0700
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        xiyuyang19@fudan.edu.cn, willy@infradead.org,
        viro@zeniv.linux.org.uk, shy828301@gmail.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, duanxiongchun@bytedance.com, dan.j.williams@intel.com,
        apopple@nvidia.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pvmw-add-support-for-walking-devmap-pages.patch removed from -mm tree
Message-Id: <20220510041140.C6D82C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pvmw: add support for walking devmap pages
has been removed from the -mm tree.  Its filename was
     mm-pvmw-add-support-for-walking-devmap-pages.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: pvmw: add support for walking devmap pages

The devmap pages can not use page_vma_mapped_walk() to check if a huge
devmap page is mapped into a vma.  Add support for walking huge devmap
pages so that DAX can use it in the next patch.

Link: https://lkml.kernel.org/r/20220403053957.10770-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/page_vma_mapped.c~mm-pvmw-add-support-for-walking-devmap-pages
+++ a/mm/page_vma_mapped.c
@@ -210,16 +210,10 @@ restart:
 		 */
 		pmde = READ_ONCE(*pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde) ||
+		    (pmd_present(pmde) && pmd_devmap(pmde))) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
-			if (likely(pmd_trans_huge(pmde))) {
-				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
-				if (!check_pmd(pmd_pfn(pmde), pvmw))
-					return not_found(pvmw);
-				return true;
-			}
 			if (!pmd_present(pmde)) {
 				swp_entry_t entry;
 
@@ -232,6 +226,13 @@ restart:
 					return not_found(pvmw);
 				return true;
 			}
+			if (likely(pmd_trans_huge(pmde) || pmd_devmap(pmde))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (!check_pmd(pmd_pfn(pmde), pvmw))
+					return not_found(pvmw);
+				return true;
+			}
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

