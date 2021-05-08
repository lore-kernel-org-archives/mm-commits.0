Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B34C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A07FF61415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhEHWrl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWrk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97E3D613E8;
        Sat,  8 May 2021 22:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513998;
        bh=AERxJdj20eRDhDZAjoDiMSjat2/iU0gJ1SRC4dRUygQ=;
        h=Date:From:To:Subject:From;
        b=oSf4g3cGo11HLtDi7naMuaRYDsl+c6Wcn/GJ4yw0Vq7+ioarCIQ3cQI3lq2N7TDKu
         6iCQ9CbXkdZ+xGKMKFzpnFyTWwxyRWKfCrDTqQ9vkdFM0ow7bXhMD4EqwOIuPHoETb
         VyR+cJzDyAtpwLpkPRXuEef/qE85XhG9BeiuJzwg=
Date:   Sat, 08 May 2021 15:46:38 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, ebru.akagunduz@gmail.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        riel@redhat.com
Subject:  [merged]
 =?US-ASCII?Q?khugepaged-remove-unneeded-return-value-of-khugepaged=5Fco?=
 =?US-ASCII?Q?llapse=5Fpte=5Fmapped=5Fthps.patch?= removed from -mm tree
Message-ID: <20210508224638.kKtcJ-dni%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: remove unneeded return value of khugepaged_collapse_pte_mapped_thps()
has been removed from the -mm tree.  Its filename was
     khugepaged-remove-unneeded-return-value-of-khugepaged_collapse_pte_mapped_thps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


