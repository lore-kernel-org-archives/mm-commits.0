Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28569C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 26 May 2022 18:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348486AbiEZSTM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 14:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348953AbiEZSTL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 14:19:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FB5B0404
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 11:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4808617B1
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 18:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFAEC34116;
        Thu, 26 May 2022 18:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653589150;
        bh=HIWLcTgEwTesnmR0baeEKdbrVb6SPHqyqMrSEWgo2dU=;
        h=Date:To:From:Subject:From;
        b=p+LEi+aR9CAqII/LdQyDRexWuc9KOwbVvhpNfXrJAvp+IwXRHt/N/RiVJllr5c0Xm
         8BXtjEcsdU8DP1ES4RAdWOShe5mnJorP/DZDOWNbMUOPPfIMxWChUUMk9EgYpHtaUy
         vzzxe6QxDSF0DnMRH1W4upfG3PcKEGyeXWQKww/M=
Date:   Thu, 26 May 2022 11:19:09 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        bh1scw@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-page_aligned-instead-of-is_aligned.patch added to mm-unstable branch
Message-Id: <20220526181910.5BFAEC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use PAGE_ALIGNED instead of IS_ALIGNED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-page_aligned-instead-of-is_aligned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-page_aligned-instead-of-is_aligned.patch

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
From: Fanjun Kong <bh1scw@gmail.com>
Subject: mm: use PAGE_ALIGNED instead of IS_ALIGNED
Date: Thu, 26 May 2022 22:02:57 +0800

<linux/mm.h> already provides the PAGE_ALIGNED macro.  Let's use this
macro instead of IS_ALIGNED and passing PAGE_SIZE directly.

Link: https://lkml.kernel.org/r/20220526140257.1568744-1-bh1scw@gmail.com
Signed-off-by: Fanjun Kong <bh1scw@gmail.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-use-page_aligned-instead-of-is_aligned
+++ a/mm/sparse-vmemmap.c
@@ -200,8 +200,8 @@ static int vmemmap_remap_range(unsigned
 	unsigned long next;
 	pgd_t *pgd;
 
-	VM_BUG_ON(!IS_ALIGNED(start, PAGE_SIZE));
-	VM_BUG_ON(!IS_ALIGNED(end, PAGE_SIZE));
+	VM_BUG_ON(!PAGE_ALIGNED(start));
+	VM_BUG_ON(!PAGE_ALIGNED(end));
 
 	pgd = pgd_offset_k(addr);
 	do {
_

Patches currently in -mm which might be from bh1scw@gmail.com are

mm-use-page_aligned-instead-of-is_aligned.patch

