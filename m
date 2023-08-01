Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631D5C0015E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjHASdk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjHASdj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:33:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8F31FC6
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD886166E
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2DEC433C8;
        Tue,  1 Aug 2023 18:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690914817;
        bh=SIYATO7uDJeTwwCNSf3xpVqf1TI2j9goic+eN+0rPvA=;
        h=Date:To:From:Subject:From;
        b=K5CYnJmWvXGhXCQ8BsrINumYqh0w9MJASWpVwGi/jMAMg76k5UhcKKmW1gustzevK
         VdDeJoj4jwELH05fhiRXeB2DMypPj9NreE4sRD0BhzjCA/O0h2Da1awOwfe7cWgU+m
         K4x47y4ZCdzApLyWWfvWWzFuXcy5ZEol5EgbCji0=
Date:   Tue, 01 Aug 2023 11:33:36 -0700
To:     mm-commits@vger.kernel.org, catalin.marinas@arm.com,
        apopple@nvidia.com, 21cnbao@gmail.com, yangyicong@hisilicon.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-tlbflush-add-some-comments-for-tlb-batched-flushing.patch added to mm-unstable branch
Message-Id: <20230801183337.6E2DEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: tlbflush: add some comments for TLB batched flushing
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-tlbflush-add-some-comments-for-tlb-batched-flushing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-tlbflush-add-some-comments-for-tlb-batched-flushing.patch

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

mm-tlbbatch-introduce-arch_flush_tlb_batched_pending.patch
arm64-tlbflush-add-some-comments-for-tlb-batched-flushing.patch

