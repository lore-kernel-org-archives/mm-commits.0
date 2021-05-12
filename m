Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E577DC433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF1BE61155
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbhELVN1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 17:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1386740AbhELUWB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 16:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE5E560E09;
        Wed, 12 May 2021 20:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620850852;
        bh=dOBC8uf83V2ctcesmvUEd4aPU6qKRPCMVMc9PwCygcc=;
        h=Date:From:To:Subject:From;
        b=lTQTxQD28tczsH5cGA410kWKkG1m0dsXR6dfe6Fe7ndgYx0L78NUnt7HkKoj/i7sI
         VccX+DzwnLcFLHWX0+yDQura0h0jpymVWk3XzwKwyxl34te6727BdEf+LoDZHn7pcX
         8FW2GxbTlCjADkGMcWE8cQxzuIRjGB4dh/ZuAf0o=
Date:   Wed, 12 May 2021 13:20:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@kernel.org
Subject:  +
 arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix.patch added to -mm
 tree
Message-ID: <20210512202052.fTTqiEO61%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix
has been added to the -mm tree.  Its filename is
     arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix

fix merge fix

Link: https://lkml.kernel.org/r/YJtoQhidtIJOhYsV@kernel.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/Kconfig~arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix
+++ a/arch/arm64/Kconfig
@@ -201,7 +201,6 @@ config ARM64
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_GENERIC_VDSO
-	select HOLES_IN_ZONE
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
_

Patches currently in -mm which might be from rppt@kernel.org are

arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix.patch

