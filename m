Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB923C04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 03:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiI2D7g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 23:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiI2D7e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 23:59:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1E810D0F4
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 20:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0521FB82301
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 03:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBEAC433C1;
        Thu, 29 Sep 2022 03:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664423968;
        bh=a6CFYKrzjEeFFp8ZVU0/R+ruYEZnLlwx/6qQTeAAnE4=;
        h=Date:To:From:Subject:From;
        b=Vt1Ks4QVJcxnopuJaGaO+5yttc10l2oD94IkYxCJFePQUnJCw8AlQkIOH/TPrn9Qh
         nmPldtzqZCQJIVv5VB0cmlgkgdbP22mVutfRZGRBdt++NbT7ahuTUd2oWo+vsXInY3
         zth4mIzH6DNUSrF7uo5oDTe4z4rx50LIEacshirs=
Date:   Wed, 28 Sep 2022 20:59:27 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-thp-convert-to-use-common-struct-mm_slot-fix.patch removed from -mm tree
Message-Id: <20220929035928.8FBEAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: thp: fix build error with CONFIG_SHMEM disabled
has been removed from the -mm tree.  Its filename was
     mm-thp-convert-to-use-common-struct-mm_slot-fix.patch

This patch was dropped because it was folded into mm-thp-convert-to-use-common-struct-mm_slot.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: thp: fix build error with CONFIG_SHMEM disabled
Date: Thu, 1 Sep 2022 15:44:42 +0800

Fix the following build error by changing function
parameter type from struct mm_sot * to struct khugepaged_mm_slot *:

mm/khugepaged.c: In function 'khugepaged_scan_mm_slot':
 >> mm/khugepaged.c:2056:45: error: passing argument 1 of
'khugepaged_collapse_pte_mapped_thps' from incompatible pointer type
[-Werror=incompatible-pointer-types]
     2056 |         khugepaged_collapse_pte_mapped_thps(mm_slot);
          |                                             ^~~~~~~
          |                                             |
          |                                             struct
khugepaged_mm_slot *
    mm/khugepaged.c:2023:65: note: expected 'struct mm_slot *' but
argument is of type 'struct khugepaged_mm_slot *'
     2023 | static void khugepaged_collapse_pte_mapped_thps(struct
mm_slot *mm_slot)
          |
~~~~~~~~~~~~~~~~^~~~~~~
    cc1: some warnings being treated as errors

Link: https://lkml.kernel.org/r/639fa8d5-8e5b-2333-69dc-40ed46219364@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-thp-convert-to-use-common-struct-mm_slot-fix
+++ a/mm/khugepaged.c
@@ -2017,7 +2017,7 @@ static int khugepaged_scan_file(struct m
 	BUILD_BUG();
 }
 
-static void khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
+static void khugepaged_collapse_pte_mapped_thps(struct khugepaged_mm_slot *mm_slot)
 {
 }
 #endif
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-introduce-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot.patch
ksm-remove-redundant-declarations-in-ksmh.patch
ksm-add-the-ksm-prefix-to-the-names-of-the-ksm-private-structures.patch
ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch
ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch
ksm-convert-to-use-common-struct-mm_slot.patch

