Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF50C83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjFIXdi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbjFIXcx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DD73AAE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A127460D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32DAC433EF;
        Fri,  9 Jun 2023 23:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353402;
        bh=vWBYZf1/AU9BaaZsQ7l/rD7R746kWjdPA8K5y7WzVNM=;
        h=Date:To:From:Subject:From;
        b=qVfbTzQI6JxEg2RVBe3fPOxQ1zYsMc1Q3uP4PHvWgtQva3PnSAg4EQcWBeJF4tRs5
         FNES8HgoMLtgoCgaV+QE0TAF80bW/mwV5kwza+WBnpNkfwNuLAPPpb74sZzlpeuU07
         Qc+966+JSGuaH12Vpv+Hfq2JIqd6A96rpt/Wzn0I=
Date:   Fri, 09 Jun 2023 16:30:01 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        xhao@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-avoid-pointless-allocation-for-struct-mm_slot.patch removed from -mm tree
Message-Id: <20230609233001.F32DAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: khugepaged: avoid pointless allocation for "struct mm_slot"
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-avoid-pointless-allocation-for-struct-mm_slot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm: khugepaged: avoid pointless allocation for "struct mm_slot"
Date: Wed, 31 May 2023 17:58:17 +0800

In __khugepaged_enter(), if "mm->flags" with MMF_VM_HUGEPAGE bit is set,
the "mm_slot" will be released and return, so we can call mm_slot_alloc()
after test_and_set_bit().

Link: https://lkml.kernel.org/r/20230531095817.11012-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-avoid-pointless-allocation-for-struct-mm_slot
+++ a/mm/khugepaged.c
@@ -422,19 +422,17 @@ void __khugepaged_enter(struct mm_struct
 	struct mm_slot *slot;
 	int wakeup;
 
+	/* __khugepaged_exit() must not run from under us */
+	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
+	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags)))
+		return;
+
 	mm_slot = mm_slot_alloc(mm_slot_cache);
 	if (!mm_slot)
 		return;
 
 	slot = &mm_slot->slot;
 
-	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
-	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
-		mm_slot_free(mm_slot_cache, mm_slot);
-		return;
-	}
-
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are


