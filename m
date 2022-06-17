Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E37C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379788AbiFQCtQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFQCtP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43EB64D0B
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DC6561D19
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9ABAC3411A;
        Fri, 17 Jun 2022 02:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434153;
        bh=vH7EpjaqFOvYFULuAAm+oUy2iVIuAadrVAxBlrU5oLA=;
        h=Date:To:From:Subject:From;
        b=XlApkuaLIgwMVlyp+J/Xm/RWGIONZk2oJrsZaCR4/WXCwGH6TTjedxhx6dwT4B8sg
         BylcbjsyjrZy0Of1PwXPsp07Ls5dEsjXJ53EnIErniZanLRWNxcvA0NNhZq0VZQvOn
         E1+vKLTRio2M2Ync0KcoqEOXZQsNy0OjB6p2c80E=
Date:   Thu, 16 Jun 2022 19:49:12 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-remove-dead-code-for-hugetlbpagec.patch removed from -mm tree
Message-Id: <20220617024913.B9ABAC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/x86: remove dead code for hugetlbpage.c
has been removed from the -mm tree.  Its filename was
     mm-x86-remove-dead-code-for-hugetlbpagec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: remove dead code for hugetlbpage.c
Date: Wed, 25 May 2022 15:52:20 -0400

It seems to exist since the old times and never used once.  Remove them.

Link: https://lkml.kernel.org/r/20220525195220.10241-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   39 ------------------------------------
 1 file changed, 39 deletions(-)

--- a/arch/x86/mm/hugetlbpage.c~mm-x86-remove-dead-code-for-hugetlbpagec
+++ a/arch/x86/mm/hugetlbpage.c
@@ -19,44 +19,6 @@
 #include <asm/tlbflush.h>
 #include <asm/elf.h>
 
-#if 0	/* This is just for testing */
-struct page *
-follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
-{
-	unsigned long start = address;
-	int length = 1;
-	int nr;
-	struct page *page;
-	struct vm_area_struct *vma;
-
-	vma = find_vma(mm, addr);
-	if (!vma || !is_vm_hugetlb_page(vma))
-		return ERR_PTR(-EINVAL);
-
-	pte = huge_pte_offset(mm, address, vma_mmu_pagesize(vma));
-
-	/* hugetlb should be locked, and hence, prefaulted */
-	WARN_ON(!pte || pte_none(*pte));
-
-	page = &pte_page(*pte)[vpfn % (HPAGE_SIZE/PAGE_SIZE)];
-
-	WARN_ON(!PageHead(page));
-
-	return page;
-}
-
-int pmd_huge(pmd_t pmd)
-{
-	return 0;
-}
-
-int pud_huge(pud_t pud)
-{
-	return 0;
-}
-
-#else
-
 /*
  * pmd_huge() returns 1 if @pmd is hugetlb related entry, that is normal
  * hugetlb entry or non-present (migration or hwpoisoned) hugetlb entry.
@@ -72,7 +34,6 @@ int pud_huge(pud_t pud)
 {
 	return !!(pud_val(pud) & _PAGE_PSE);
 }
-#endif
 
 #ifdef CONFIG_HUGETLB_PAGE
 static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
_

Patches currently in -mm which might be from peterx@redhat.com are


