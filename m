Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73059C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbjBJVyp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbjBJVyR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:54:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC0E360A2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:54:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE1F861EAA
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D817C4339B;
        Fri, 10 Feb 2023 21:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676066054;
        bh=FJiph8TKfNorMfYroHD4dXrcI9FOUOrT92selbriuy0=;
        h=Date:To:From:Subject:From;
        b=aIPibnaRnXNGpSM5EVmlm2VPS1yo+UXkepuGY3v8KSt2a1+SVcgLR0SbsPRqr57sB
         K4DUrPgCeiAXdmIs1jhKRFs+dF6QRmjrueeo+73UI0arCFJKau5g28rv67MeoKS3fX
         CZG5pZm48Zc3GjvfSqKnLVyTAfZaEcTFHMrxE66c=
Date:   Fri, 10 Feb 2023 13:54:13 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        jwilk@jwilk.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typo-in-__vm_enough_memory-warning.patch added to mm-unstable branch
Message-Id: <20230210215414.4D817C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typo in __vm_enough_memory warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-typo-in-__vm_enough_memory-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typo-in-__vm_enough_memory-warning.patch

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
From: Jakub Wilk <jwilk@jwilk.net>
Subject: mm: fix typo in __vm_enough_memory warning
Date: Fri, 10 Feb 2023 21:33:16 +0100

Link: https://lkml.kernel.org/r/20230210203316.5613-1-jwilk@jwilk.net
Signed-off-by: Jakub Wilk <jwilk@jwilk.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/util.c~mm-fix-typo-in-__vm_enough_memory-warning
+++ a/mm/util.c
@@ -967,7 +967,7 @@ int __vm_enough_memory(struct mm_struct
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
 error:
-	pr_warn_ratelimited("%s: pid: %d, comm: %s, no enough memory for the allocation\n",
+	pr_warn_ratelimited("%s: pid: %d, comm: %s, not enough memory for the allocation\n",
 			    __func__, current->pid, current->comm);
 	vm_unacct_memory(pages);
 
_

Patches currently in -mm which might be from jwilk@jwilk.net are

mm-fix-typo-in-__vm_enough_memory-warning.patch

