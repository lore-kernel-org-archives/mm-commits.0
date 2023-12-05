Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF735C4167B
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 19:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbjLET55 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 14:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbjLET5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 14:57:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E77D40
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 11:57:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F830C433C7;
        Tue,  5 Dec 2023 19:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701806279;
        bh=dxuKDTDwD9RwDH5we2vwB67vtEArTOZK8YmDjBpU+OI=;
        h=Date:To:From:Subject:From;
        b=sqj/n4bwvDLfeGJPS5lSR5ZGpPkOBpAkNWOsCcnZx13SWlkMZsZqZD6cqvN252KAE
         WnHyr+/2y4wAYfjIpJkqcMZefAzH9xgRnqPctuOgfjXkfNAgIHboXfC8G4Bkk6njwU
         U+MvD+pKP/jdcaeExToiwoJUHcgIID6gfng+vWZA=
Date:   Tue, 05 Dec 2023 11:57:58 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch added to mm-unstable branch
Message-Id: <20231205195759.5F830C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: add check of CONFIG_MEMORY_HOTPLUG back
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: add check of CONFIG_MEMORY_HOTPLUG back
Date: Tue, 5 Dec 2023 11:05:30 +0800

The compiler will optimize the code as much as possible if we add the
check of CONFIG_MEMORY_HOTPLUG back.

Link: https://lkml.kernel.org/r/20231205030530.3802-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back
+++ a/mm/hugetlb_vmemmap.c
@@ -119,7 +119,7 @@ static int vmemmap_pmd_entry(pmd_t *pmd,
 	 *   +--+ |                        |
 	 *        +------------------------+
 	 */
-	if (unlikely(!vmemmap_walk->nr_walked)) {
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG) && unlikely(!vmemmap_walk->nr_walked)) {
 		struct page *page = head ? head + pte_index(addr) :
 				    pte_page(ptep_get(pte_offset_kernel(pmd, addr)));
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-pagewalk-assert-write-mmap-lock-only-for-walking-the-user-page-tables.patch
mm-hugetlb_vmemmap-use-walk_page_range_novma-to-simplify-the-code.patch
mm-hugetlb_vmemmap-move-pagevmemmapselfhosted-check-to-split_vmemmap_huge_pmd.patch
mm-hugetlb_vmemmap-convert-page-to-folio.patch
mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch
mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch

