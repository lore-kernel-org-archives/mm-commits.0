Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CA6C7EE2F
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbjFGCrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240820AbjFGCrf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:47:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4F61BD6
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A102762ECB
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CEDC433D2;
        Wed,  7 Jun 2023 02:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686106051;
        bh=JMoieeYBOJ42pCjIE2ZMe9CKasup8+NWxjh1hGadHwQ=;
        h=Date:To:From:Subject:From;
        b=u9rfeIgFf+4nCrCBj7jor4jeAIH31E05J2aeXF8haQ5s51B0JHgeb2Up5bepgjt31
         mZVlELUF+eYj5PqC2WWCz9Bw2I4Qw2re0sWPoqiymZms8CWSmtFRRhL7tIwCpOGdJU
         OroY+/tNGKjTnsCjceHUIw90Yh4Kxku7yNDr6j6U=
Date:   Tue, 06 Jun 2023 19:47:30 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, sunnanyong@huawei.com,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch added to mm-unstable branch
Message-Id: <20230607024730.F2CEDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-use-a-folio-in-hugetlb_fault-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-use-a-folio-in-hugetlb_fault-fix
Date: Tue Jun  6 07:46:28 PM PDT 2023

update comment, per Sidhartha

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-a-folio-in-hugetlb_fault-fix
+++ a/mm/hugetlb.c
@@ -6179,7 +6179,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	/*
 	 * hugetlb_wp() requires page locks of pte_page(entry) and
 	 * pagecache_folio, so here we need take the former one
-	 * when page != pagecache_folio or !pagecache_folio.
+	 * when folio != pagecache_folio or !pagecache_folio.
 	 */
 	folio = page_folio(pte_page(entry));
 	if (folio != pagecache_folio)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-mm_initc-remove-reset_node_present_pages-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

