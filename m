Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3D1C6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiILDdr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiILDcE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3601C920
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D4ABB80C7E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028E7C433C1;
        Mon, 12 Sep 2022 03:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953395;
        bh=23fSkKaWtiOo+O144L+la+xUpUFwkQMxbHtdpFq/L1g=;
        h=Date:To:From:Subject:From;
        b=lVeIM6eeun7XLt1akveyT70h6WtjG1ugn9sjm0A8gfkA6hydGDvknF/PoXZWa6Sug
         Gm1IAFZW439byJOHFdcdmDRnZ2pPpIVTFCbZHJaCiaU52udA7bmpwgu8hFZdU8ZNIa
         1V7oLhTfeDjmVfmI/sDNGqLVfmNoL5yC9RhGX+FQ=
Date:   Sun, 11 Sep 2022 20:29:54 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, linmiaohe@huawei.com,
        haiyue.wang@intel.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, gerald.schaefer@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-hugetlb-switch-to-generic-version-of-follow_huge_pud.patch removed from -mm tree
Message-Id: <20220912032955.028E7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390/hugetlb: switch to generic version of follow_huge_pud()
has been removed from the -mm tree.  Its filename was
     s390-hugetlb-switch-to-generic-version-of-follow_huge_pud.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: s390/hugetlb: switch to generic version of follow_huge_pud()

When pud-sized hugepages were introduced for s390, the generic version of
follow_huge_pud() was using pte_page() instead of pud_page().  This would
be wrong for s390, see also commit 97534127012f ("mm/hugetlb: use
pmd_page() in follow_huge_pmd()").  Therefore, and probably because not
all archs were supporting pud_page() at that time, a private version of
follow_huge_pud() was added for s390, correctly using pud_page().

Since commit 3a194f3f8ad01 ("mm/hugetlb: make pud_huge() and
follow_huge_pud() aware of non-present pud entry"), the generic version of
follow_huge_pud() is now also using pud_page(), and in general behaves
similar to follow_huge_pmd().

Therefore we can now switch to the generic version and get rid of the
s390-specific follow_huge_pud().

Link: https://lkml.kernel.org/r/20220818135717.609eef8a@thinkpad
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Haiyue Wang <haiyue.wang@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/hugetlbpage.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/arch/s390/mm/hugetlbpage.c~s390-hugetlb-switch-to-generic-version-of-follow_huge_pud
+++ a/arch/s390/mm/hugetlbpage.c
@@ -237,16 +237,6 @@ int pud_huge(pud_t pud)
 	return pud_large(pud);
 }
 
-struct page *
-follow_huge_pud(struct mm_struct *mm, unsigned long address,
-		pud_t *pud, int flags)
-{
-	if (flags & FOLL_GET)
-		return NULL;
-
-	return pud_page(*pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
-}
-
 bool __init arch_hugetlb_valid_size(unsigned long size)
 {
 	if (MACHINE_HAS_EDAT1 && size == PMD_SIZE)
_

Patches currently in -mm which might be from gerald.schaefer@linux.ibm.com are


