Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EAFC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4110823A9F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794324;
	bh=5rqZYot2s33GDrI8HbCrCxcJ1FyfT+b+YNbIjLHh6X0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hxhzbba3lXvXMkO41eNxs5S120IHlHm9rjrwQZxo2Ij0ebTJ34byi6uq9rXJGdU5z
	 3i9SZNG5M0ImXkavz7bSsC1czBy00AR08y71/YO0POIn491GrsrcTo0tF/Vcv4rwme
	 i+LvNCNhzdPQJNwh4163//hCQ1G+GpJkOjr28iAQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgIVRFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgIVRFX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:05:23 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D24F523A9C;
        Tue, 22 Sep 2020 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794323;
        bh=5rqZYot2s33GDrI8HbCrCxcJ1FyfT+b+YNbIjLHh6X0=;
        h=Date:From:To:Subject:From;
        b=yXBGIKOZBG6eZzf3xAHWOJArtK29rybVCLRT3YfatTN6hBQzYStp5BD28TuvEIUyy
         qd2PyMXoKs4NKAeNtwg/8xTXqA31HeYPt/eSbOVWuzom+u8QHEb6cJ2UflOokEAEda
         7luR7rGMmfGM6/WhF18HyGcCFrDvNlNOxccSAXPE=
Date:   Tue, 22 Sep 2020 10:05:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yuleixzhang@tencent.com,
        yulei.kernel@gmail.com
Subject:  + mm-cleanup-mincore_huge_pmd.patch added to -mm tree
Message-ID: <20200922170522._xY6k%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/huge_mm.h: remove mincore_huge_pmd declaration
has been added to the -mm tree.  Its filename is
     mm-cleanup-mincore_huge_pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-mincore_huge_pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-mincore_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yuleixzhang <yulei.kernel@gmail.com>
Subject: include/linux/huge_mm.h: remove mincore_huge_pmd declaration

As mincore_huge_pmd() was dropped, remove the declaration from the header
file.

Link: https://lkml.kernel.org/r/20200922083423.15074-1-yuleixzhang@tencent.com
Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/huge_mm.h~mm-cleanup-mincore_huge_pmd
+++ a/include/linux/huge_mm.h
@@ -38,9 +38,6 @@ extern int zap_huge_pmd(struct mmu_gathe
 extern int zap_huge_pud(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pud_t *pud, unsigned long addr);
-extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, unsigned long end,
-			unsigned char *vec);
 extern bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			 unsigned long new_addr,
 			 pmd_t *old_pmd, pmd_t *new_pmd);
_

Patches currently in -mm which might be from yulei.kernel@gmail.com are

mm-cleanup-mincore_huge_pmd.patch

