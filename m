Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98E3C4332D
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 21:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4155652B8
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 21:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCHVCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 16:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhCHVCZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 16:02:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 095876529C;
        Mon,  8 Mar 2021 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615237344;
        bh=EBKFusctrMJBMjV7YM3ep4H9Ftu80xPzGdwYEVaz/tw=;
        h=Date:From:To:Subject:From;
        b=GjFXO4LcaoUSq049WQYZToNrO1xY3SuXSjEU27NY/FpcpoH30Abtq9MgAoug5Cf7e
         WH9Y/CPvHL9vJdKYS64FchJFWXn1ODJPv3dDvVHKQdeqGemFpW/n4RKnLtYllHPgfS
         Uvw1/zPC1NSsk5MgZvcr8D5mIHVl9vrt+d+OCcwg=
Date:   Mon, 08 Mar 2021 13:02:23 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, ebru.akagunduz@gmail.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        riel@redhat.com
Subject:  +
 =?US-ASCII?Q?khugepaged-remove-unneeded-return-value-of-khugepaged=5Fco?=
 =?US-ASCII?Q?llapse=5Fpte=5Fmapped=5Fthps.patch?= added to -mm tree
Message-ID: <20210308210223.YwtlULhaF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: remove unneeded return value of khugepaged_collapse_pte_mapped_thps()
has been added to the -mm tree.  Its filename is
     khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: khugepaged: remove unneeded return value of khugepaged_collapse_pte_mapped_thps()

Patch series "Cleanup and fixup for khugepaged", v2.

This series contains cleanups to remove unneeded return value, use helper
function and so on.  And there is one fix to correct the wrong result
value for trace_mm_collapse_huge_page_isolate().


This patch (of 4):

The return value of khugepaged_collapse_pte_mapped_thps() is never checked
since it's introduced.  We should remove such unneeded return value.

Link: https://lkml.kernel.org/r/20210306032947.35921-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210306032947.35921-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps
+++ a/mm/khugepaged.c
@@ -1533,16 +1533,16 @@ abort:
 	goto drop_hpage;
 }
 
-static int khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
+static void khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
 {
 	struct mm_struct *mm = mm_slot->mm;
 	int i;
 
 	if (likely(mm_slot->nr_pte_mapped_thp == 0))
-		return 0;
+		return;
 
 	if (!mmap_write_trylock(mm))
-		return -EBUSY;
+		return;
 
 	if (unlikely(khugepaged_test_exit(mm)))
 		goto out;
@@ -1553,7 +1553,6 @@ static int khugepaged_collapse_pte_mappe
 out:
 	mm_slot->nr_pte_mapped_thp = 0;
 	mmap_write_unlock(mm);
-	return 0;
 }
 
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
@@ -2057,9 +2056,8 @@ static void khugepaged_scan_file(struct
 	BUILD_BUG();
 }
 
-static int khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
+static void khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
 {
-	return 0;
 }
 #endif
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch
khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps.patch
khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate.patch
khugepaged-use-helper-khugepaged_test_exit-in-__khugepaged_enter.patch
khugepaged-fix-wrong-result-value-for-trace_mm_collapse_huge_page_isolate.patch

