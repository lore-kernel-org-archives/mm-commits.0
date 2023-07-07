Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC74CEB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 19:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjGGTOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjGGTN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 15:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E55E128
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 12:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96A3261A1D
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 19:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB17C433C8;
        Fri,  7 Jul 2023 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688757238;
        bh=rPtSORxUVGR1MG6asOhTn/Z9r6dkLYOMA5yWzjmf3tk=;
        h=Date:To:From:Subject:From;
        b=QSEcYofOBm83d0soaoxPI1N0zbU/zGRpDF6pEuEfeYR+BaegGb4Q783ipo1oYVQs5
         /mKpbHThqLLFPrHLPEDhjUBnT8F2caHtmmt/QdYtpbGARRcNYn8fGreST1jecCI/S/
         nitf2+m2kdE3RKNT0xpU+SgwibGM/AUuG452dPpo=
Date:   Fri, 07 Jul 2023 12:13:57 -0700
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-some-kernel-doc-comments.patch added to mm-unstable branch
Message-Id: <20230707191357.EAB17C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some kernel-doc comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-some-kernel-doc-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-some-kernel-doc-comments.patch

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
@@ -5090,7 +5091,7 @@ retry_pud:
 
 /**
  * mm_account_fault - Do page fault accounting
- *
+ * @mm: mm from which memcg should be extracted. It can be NULL.
  * @regs: the pt_regs struct pointer.  When set to NULL, will skip accounting
  *        of perf event counters, but we'll still do the per-task accounting to
  *        the task who triggered this page fault.
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-fix-some-kernel-doc-comments.patch

