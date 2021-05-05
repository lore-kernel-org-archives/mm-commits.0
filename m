Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A55C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FDA4613E4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhEEBef (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhEEBee (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4B9A613E2;
        Wed,  5 May 2021 01:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178418;
        bh=EZEVgfc1Go8NkesZcZpR8Z61Jn3FZF8laE0qordF5ps=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=awHOLNRE7ieR8m4XW3/68oVMDxnipoH4JbVI5EQyYF8uKp2HYyhl5ZBmg6JSBqylB
         VIS5r8hJkj/4okI5maKCn3iJ3lf7yIQpGqf8uXfEyhqRZQMNVWumyJ53UyM+3LoLAz
         MjTpdDK/BRoo5CdZZGGzTGt8Yw4KC/Qlii+/OFeo=
Date:   Tue, 04 May 2021 18:33:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ebru.akagunduz@gmail.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 017/143] khugepaged: remove unneeded return value
 of khugepaged_collapse_pte_mapped_thps()
Message-ID: <20210505013337.smqnNu2Hf%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
