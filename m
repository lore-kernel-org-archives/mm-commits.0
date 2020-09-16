Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDFAC433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 02:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0B4721655
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 02:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600223038;
	bh=EXPJRSVGoGzvVuKmxSJ1ZwINk9xeXb3lbMfXFD5mC74=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ajhODoNarqgEyftUiazyj2eW4EcLkCcybBM84CnBeyi3CchAGI18a9BpZdmrxDSqg
	 Phu2v2uEA7x1L8tYe6TSEUjTC/H2aO2BhDE10GF1uqRMtqalyP7c8bomk4WGbqK1uS
	 IaYAKjt6H/wUOrGU8LPtyehWWN4Oa8JhHBqAJ1jo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgIPCX5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 22:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgIPCX4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 22:23:56 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198C5206C9;
        Wed, 16 Sep 2020 02:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600223036;
        bh=EXPJRSVGoGzvVuKmxSJ1ZwINk9xeXb3lbMfXFD5mC74=;
        h=Date:From:To:Subject:From;
        b=b+2gSigpjvLZc4biezA5Xxajb2XbCwgxNobWNjrcb9LSjzy+Pt4HUQMngiWFV4CQ5
         rTE1U/NDC9gfNQZoMMzzNiSMSrdyVeuL5/35w2GWSxOOCYFSmBp0VHTGpPFMN2LqtE
         aTUW3mb99fG/Des+Nks58tgp/g21QN3KxUCK4bDA=
Date:   Tue, 15 Sep 2020 19:23:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        tiantao6@hisilicon.com
Subject:  + mm-remove-duplicate-include-statement-in-mmuc.patch added
 to -mm tree
Message-ID: <20200916022355.H7RzR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove duplicate include statement in mmu.c
has been added to the -mm tree.  Its filename is
     mm-remove-duplicate-include-statement-in-mmuc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-duplicate-include-statement-in-mmuc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-duplicate-include-statement-in-mmuc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tian Tao <tiantao6@hisilicon.com>
Subject: mm: remove duplicate include statement in mmu.c

asm/sections.h is included more than once, Remove the one that isn't
necessary.

Link: https://lkml.kernel.org/r/1600088607-17327-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/mm/mmu.c~mm-remove-duplicate-include-statement-in-mmuc
+++ a/arch/arm/mm/mmu.c
@@ -17,7 +17,6 @@
 
 #include <asm/cp15.h>
 #include <asm/cputype.h>
-#include <asm/sections.h>
 #include <asm/cachetype.h>
 #include <asm/fixmap.h>
 #include <asm/sections.h>
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are

mm-remove-duplicate-include-statement-in-mmuc.patch

