Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9DDC2BB41
	for <mm-commits@archiver.kernel.org>; Tue, 16 Aug 2022 22:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbiHPWzR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Aug 2022 18:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbiHPWzQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2022 18:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CF861DB4
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 15:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4390961297
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 22:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91685C433D6;
        Tue, 16 Aug 2022 22:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660690514;
        bh=gxsbQ9AwgroSutDUsEx8nRl36joS9RQ3GFm6L5RItYA=;
        h=Date:To:From:Subject:From;
        b=veP2Fu9O4bzjRVkftwH/2HmjxJUBb6TcjD5mc6fbHIXTRcpOTEq+Axh9959IbOXwL
         kb6FZN2nx+Jyf3E7pMfeKYGOtyb3jAF3v5W4Os2UnSPolPRwJdKfkBES1mfAifaAOu
         SoyLRH1UlIHiCBuW9RELBHgNf8bjzkTym/J1zoRA=
Date:   Tue, 16 Aug 2022 15:55:13 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch added to mm-unstable branch
Message-Id: <20220816225514.91685C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix WARN_ON(!kobj) in sysfs_create_group()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch

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
Subject: mm/hugetlb: fix WARN_ON(!kobj) in sysfs_create_group()
Date: Tue, 16 Aug 2022 21:05:49 +0800

If sysfs_create_group() fails with hstate_attr_group, hstate_kobjs[hi]
will be set to NULL.  Then it will be passed to sysfs_create_group() if
h->demote_order != 0 thus triggering WARN_ON(!kobj) check.  Fix this by
making sure hstate_kobjs[hi] != NULL when calling sysfs_create_group.

Link: https://lkml.kernel.org/r/20220816130553.31406-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group
+++ a/mm/hugetlb.c
@@ -3846,6 +3846,7 @@ static int hugetlb_sysfs_add_hstate(stru
 	if (retval) {
 		kobject_put(hstate_kobjs[hi]);
 		hstate_kobjs[hi] = NULL;
+		return retval;
 	}
 
 	if (h->demote_order) {
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

