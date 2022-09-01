Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE4FECAAD3
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 22:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiIAWnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 18:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiIAWnd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 18:43:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3950C67CBE
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 15:43:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C9D62031
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 22:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B25C433D7;
        Thu,  1 Sep 2022 22:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662072211;
        bh=v3Iuyag5T1vAm0oCEkLQRPnz4wVBJc0R0lxy2KMGHgs=;
        h=Date:To:From:Subject:From;
        b=OCxyMCI5DvjdoVBDjSWDr4g3RRiPQLLoYmaXzSn7e7XmQJv/VHxht2OQnVdrwj5CF
         sfgmZ/6YAhpTXqJdyRzQ5uPnB0QjAxUO6XqvKjKgcElV+fa/PY4uo7wmuo3aqLSwmS
         Az498JVId2u1d/DpTBvO764mXeY84JW/VJ0dTAXc=
Date:   Thu, 01 Sep 2022 15:43:30 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-convert-to-use-common-struct-mm_slot-fix.patch added to mm-unstable branch
Message-Id: <20220901224331.27B25C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix build error with CONFIG_SHMEM disabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-convert-to-use-common-struct-mm_slot-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-convert-to-use-common-struct-mm_slot-fix.patch

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
@@ -2020,7 +2020,7 @@ static int khugepaged_scan_file(struct m
 	BUILD_BUG();
 }
 
-static void khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
+static void khugepaged_collapse_pte_mapped_thps(struct khugepaged_mm_slot *mm_slot)
 {
 }
 #endif
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch
mm-introduce-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot-fix.patch
ksm-remove-redundant-declarations-in-ksmh.patch
ksm-add-the-ksm-prefix-to-the-names-of-the-ksm-private-structures.patch
ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch
ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch
ksm-convert-to-use-common-struct-mm_slot.patch

