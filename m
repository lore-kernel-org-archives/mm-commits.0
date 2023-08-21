Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995BCEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjHUUkA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjHUUjk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09473183
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CFC964A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A49C433C7;
        Mon, 21 Aug 2023 20:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650368;
        bh=6LpvXtvE+jW6uG2RuIj8QsHwtxT7rWv0BLp1B8eJJrI=;
        h=Date:To:From:Subject:From;
        b=DF8zYx6428Gn7vguIrdXBmRlgs7iKDA0skOradmfqxKkGdcAEYmCWmxLfpgOjzkbJ
         U+HSMShXCOpFx90JjKnAdhLxSm8+j48d4JA4AP3nw+fFa+HUYom6VBAHJxt/wqXKBN
         jYjokoZQo/3wrLJVysaNgW6Va22TDt0oNwA9hbe8=
Date:   Mon, 21 Aug 2023 13:39:27 -0700
To:     mm-commits@vger.kernel.org, catalin.marinas@arm.com,
        apopple@nvidia.com, 21cnbao@gmail.com, yangyicong@hisilicon.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-tlbflush-add-some-comments-for-tlb-batched-flushing.patch removed from -mm tree
Message-Id: <20230821203927.F2A49C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: tlbflush: add some comments for TLB batched flushing
has been removed from the -mm tree.  Its filename was
     arm64-tlbflush-add-some-comments-for-tlb-batched-flushing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yicong Yang <yangyicong@hisilicon.com>
Subject: arm64: tlbflush: add some comments for TLB batched flushing
Date: Tue, 1 Aug 2023 20:42:03 +0800

Add comments for arch_flush_tlb_batched_pending() and
arch_tlbbatch_flush() to illustrate why only a DSB is needed.

Link: https://lkml.kernel.org/r/20230801124203.62164-1-yangyicong@huawei.com
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/tlbflush.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/arm64/include/asm/tlbflush.h~arm64-tlbflush-add-some-comments-for-tlb-batched-flushing
+++ a/arch/arm64/include/asm/tlbflush.h
@@ -304,11 +304,26 @@ static inline void arch_tlbbatch_add_pen
 	__flush_tlb_page_nosync(mm, uaddr);
 }
 
+/*
+ * If mprotect/munmap/etc occurs during TLB batched flushing, we need to
+ * synchronise all the TLBI issued with a DSB to avoid the race mentioned in
+ * flush_tlb_batched_pending().
+ */
 static inline void arch_flush_tlb_batched_pending(struct mm_struct *mm)
 {
 	dsb(ish);
 }
 
+/*
+ * To support TLB batched flush for multiple pages unmapping, we only send
+ * the TLBI for each page in arch_tlbbatch_add_pending() and wait for the
+ * completion at the end in arch_tlbbatch_flush(). Since we've already issued
+ * TLBI for each page so only a DSB is needed to synchronise its effect on the
+ * other CPUs.
+ *
+ * This will save the time waiting on DSB comparing issuing a TLBI;DSB sequence
+ * for each page.
+ */
 static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
 	dsb(ish);
_

Patches currently in -mm which might be from yangyicong@hisilicon.com are


