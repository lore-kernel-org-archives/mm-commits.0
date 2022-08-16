Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBCDC25B0E
	for <mm-commits@archiver.kernel.org>; Tue, 16 Aug 2022 22:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiHPWzZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Aug 2022 18:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbiHPWzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2022 18:55:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8920C63F06
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 15:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79E1CCE1B14
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 22:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67B4C433D7;
        Tue, 16 Aug 2022 22:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660690517;
        bh=RFNllf0xXLofLeGveAikZ8SYbSjJmNZFoesoQ3QA0k8=;
        h=Date:To:From:Subject:From;
        b=XGwZpjgMrtF94KJrHzBWAOnMQRRd5bldAL1FPZtHeg9M9TmPtvMyWcQ46xDN3Zz2S
         gJpy7jhwKsL8xzyQnE/+SyWQFZ9aT3wxz2NsTiQ9u34ZpQqfqAdjIiOREhZYBClHxO
         9nAEvWfn68paRwBj+tx2GvlyZy7p70HAKiMPJcVc=
Date:   Tue, 16 Aug 2022 15:55:17 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch added to mm-unstable branch
Message-Id: <20220816225517.B67B4C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: add missing smp_wmb() before set_pte_at()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: hugetlb_vmemmap: add missing smp_wmb() before set_pte_at()
Date: Tue, 16 Aug 2022 21:05:51 +0800

The memory barrier smp_wmb() is needed to make sure that preceding stores
to the page contents become visible before the below set_pte_at() write.

Link: https://lkml.kernel.org/r/20220816130553.31406-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at
+++ a/mm/hugetlb_vmemmap.c
@@ -287,6 +287,11 @@ static void vmemmap_restore_pte(pte_t *p
 	copy_page(to, (void *)walk->reuse_addr);
 	reset_struct_pages(to);
 
+	/*
+	 * Makes sure that preceding stores to the page contents become visible
+	 * before the set_pte_at() write.
+	 */
+	smp_wmb();
 	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch
mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch
mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch

