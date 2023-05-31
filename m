Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F042C77B73
	for <mm-commits@archiver.kernel.org>; Wed, 31 May 2023 22:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjEaWHO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 May 2023 18:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjEaWHO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2023 18:07:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3691B124
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 15:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AD7363D08
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 22:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE65C433EF;
        Wed, 31 May 2023 22:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685570830;
        bh=ue+FjHs9iJnsI7YfEfD21JjwNXqpA3ONLU5YDzxkxQI=;
        h=Date:To:From:Subject:From;
        b=BKGmxuqJOYqGaHLc7X21xZ6+0bEz/S2ci+G3ZP7Cdx0WdXkIxIsg1RXomRN9wuYSW
         zQiatZcEPMcOU8rfE9qKuj1FjU+xRFGkOx1JgdoER2QI/sEm6A9HKMbh8OkYaYQqWx
         BcUs3B0aNDQiwBBpGdDsjJtTz7KqP0+8Ycjd56D0=
Date:   Wed, 31 May 2023 15:07:10 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        xhao@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-avoid-pointless-allocation-for-struct-mm_slot.patch added to mm-unstable branch
Message-Id: <20230531220710.CEE65C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: avoid pointless allocation for "struct mm_slot"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-avoid-pointless-allocation-for-struct-mm_slot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-avoid-pointless-allocation-for-struct-mm_slot.patch

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

mm-khugepaged-avoid-pointless-allocation-for-struct-mm_slot.patch

