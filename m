Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A850C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbjHKXAn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188D635A0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A26316492A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09396C433C7;
        Fri, 11 Aug 2023 22:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794775;
        bh=lRA/WRnd5jKf5IZBc6xhL/X9UMBCaNm6Piui6vzaEXs=;
        h=Date:To:From:Subject:From;
        b=Krd7T6M4R7FAjTdvqJIw6j2GRhMMvo7IlMdAFuM1Rlw7LRWsYeKfd8Ngn1dQz9Bd4
         Rjw5G1gGgkhr4zIxigFE/ooP22xUWe/2O7k+4YJH/HhoWCHHusGEDTB1u//E8qKuXf
         1HJg1tuwakP/6VWSX9BR6dqH8lMy4Pyhw2a0/LEs=
Date:   Fri, 11 Aug 2023 15:59:34 -0700
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-some-kernel-doc-comments.patch removed from -mm tree
Message-Id: <20230811225935.09396C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix some kernel-doc comments
has been removed from the -mm tree.  Its filename was
     mm-fix-some-kernel-doc-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm: fix some kernel-doc comments
Date: Fri, 7 Jul 2023 17:00:34 +0800

Add description of @mm_wr_locked and @mm.
to silence the warnings:

mm/memory.c:1716: warning: Function parameter or member 'mm_wr_locked' not described in 'unmap_vmas'
mm/memory.c:5110: warning: Function parameter or member 'mm' not described in 'mm_account_fault'

Link: https://lkml.kernel.org/r/20230707090034.125511-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-some-kernel-doc-comments
+++ a/mm/memory.c
@@ -1697,6 +1697,7 @@ static void unmap_single_vma(struct mmu_
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
+ * @mm_wr_locked: lock flag
  *
  * Unmap all pages in the vma list.
  *
@@ -5084,7 +5085,7 @@ retry_pud:
 
 /**
  * mm_account_fault - Do page fault accounting
- *
+ * @mm: mm from which memcg should be extracted. It can be NULL.
  * @regs: the pt_regs struct pointer.  When set to NULL, will skip accounting
  *        of perf event counters, but we'll still do the per-task accounting to
  *        the task who triggered this page fault.
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-memoryc-fix-some-kernel-doc-comments.patch

