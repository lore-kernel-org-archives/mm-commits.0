Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2147C25B0E
	for <mm-commits@archiver.kernel.org>; Tue, 16 Aug 2022 22:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbiHPWzP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Aug 2022 18:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbiHPWzP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2022 18:55:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C0C61D9F
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 15:55:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 486BF612BF
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 22:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885F8C433C1;
        Tue, 16 Aug 2022 22:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660690512;
        bh=qDBnSNbX4afZ/Kyx60pPRO/ECJHd/+jfc4So5NRoMjY=;
        h=Date:To:From:Subject:From;
        b=ppQBTXplzwhZZiKbYLruP8A8Ajd9F7myLXjJoXUsxHMloGCFvNaZakUcmEhcM7tee
         t1gKeqiAgG69wfgE54luvFug/LbCNF9QNLNHDfl5DkPW3IJmG0zUzOiR3hSUmUsmEz
         Nwl2+UIOW67VDe7uIVjb0qExB9iutwIRyYEVbgFo=
Date:   Tue, 16 Aug 2022 15:55:11 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch added to mm-unstable branch
Message-Id: <20220816225512.885F8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix incorrect update of max_huge_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch

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
Subject: mm/hugetlb: fix incorrect update of max_huge_pages
Date: Tue, 16 Aug 2022 21:05:48 +0800

Patch series "A few fixup patches for hugetlb".

This series contains a few fixup patches to fix incorrect update of
max_huge_pages, fix WARN_ON(!kobj) in sysfs_create_group() and so on.
More details can be found in the respective changelogs.


This patch (of 6):

There should be pages_per_huge_page(h) /
pages_per_huge_page(target_hstate) pages incremented for
target_hstate->max_huge_pages when page is demoted.  Update max_huge_pages
accordingly for consistency.

Link: https://lkml.kernel.org/r/20220816130553.31406-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220816130553.31406-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-incorrect-update-of-max_huge_pages
+++ a/mm/hugetlb.c
@@ -3472,7 +3472,8 @@ static int demote_free_huge_page(struct
 	 * based on pool changes for the demoted page.
 	 */
 	h->max_huge_pages--;
-	target_hstate->max_huge_pages += pages_per_huge_page(h);
+	target_hstate->max_huge_pages +=
+		pages_per_huge_page(h) / pages_per_huge_page(target_hstate);
 
 	return rc;
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

