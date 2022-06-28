Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6487C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 19:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiF1TQK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiF1TQA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 15:16:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E6D1F2C1
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 12:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D54B361BAC
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 19:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3749EC3411D;
        Tue, 28 Jun 2022 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656443743;
        bh=wnmDITKBTaoAJWduGKZ+N7hS6UrcJxROM59bvHtzPeE=;
        h=Date:To:From:Subject:From;
        b=tIm5VCIB1LUaJXPMtX1XVpcsL1iq6uoVxA/Wfjy+R6QaICuzSdb0sYqwFvcIwfVkB
         xvU3kpAQ3lJJ9gcjOMz/XylxE/FMHMivm4oQijU0/sBl6gdX4biqkKN1R4phfWZz2L
         3jXolo3dLOqsr3oEPWj14vdyjNDxF7e52PBgXlqY=
Date:   Tue, 28 Jun 2022 12:15:42 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@Oracle.com,
        mchehab@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-linked-list-fix-2.patch added to mm-unstable branch
Message-Id: <20220628191543.3749EC3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document maple tree pointer at unmap_vmas() at memory.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-vma-linked-list-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-vma-linked-list-fix-2.patch

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
From: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: mm: document maple tree pointer at unmap_vmas() at memory.c
Date: Tue, 28 Jun 2022 10:46:19 +0100

A maple tree pointer parameter was added at unmap_vmas() without
description:

	mm/memory.c:1729: warning: Function parameter or member 'mt' not described in 'unmap_vmas'

Document it it.

Link: https://lkml.kernel.org/r/d2690118414c5458c448348cc94f831d8e8444ce.1656409369.git.mchehab@kernel.org
Fixes: 5966e5c968b2 ("mm: remove the vma linked list")
Fixes: f8acc5e9581e ("Maple Tree: add new data structure")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory.c~mm-remove-the-vma-linked-list-fix-2
+++ a/mm/memory.c
@@ -1699,6 +1699,8 @@ static void unmap_single_vma(struct mmu_
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
+ * @mt: maple tree pointer. A maple tree is a RCU-safe range based B-tree
+ *	designed to use modern processor cache efficiently
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
_

Patches currently in -mm which might be from mchehab@kernel.org are

mm-remove-the-vma-linked-list-fix-2.patch

