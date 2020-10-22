Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5E9C5517A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBB9724673
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408236;
	bh=m/6D+/c6XOQDHBqzKDzDI7Tzljjhg6y2TQYdRdWcqz0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=K81S6OC3vccqtQMbW1AYuFgYffDv1HwG2tukbRc4+OJClIolQ/HglWMm/qmvGuegQ
	 EzNMCx7AxfJFhcQJAGju2/jKccPtDbnFgknX4z3Jj+WXbfEIV221GANJf4FxaHSRIL
	 i3ORkJImXWQpDDKwenDYfqNK7dbdjzgC7edaXCwA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373269AbgJVXKg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373268AbgJVXKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:36 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9240724655;
        Thu, 22 Oct 2020 23:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408235;
        bh=m/6D+/c6XOQDHBqzKDzDI7Tzljjhg6y2TQYdRdWcqz0=;
        h=Date:From:To:Subject:From;
        b=khv1oc0ytlc7QuV/h962tkp3c5QbFD/+NFN2m95LzZe6W8A4KRDPVQpMB+ljInHau
         FqAMncLItOtmGj7Mst85ytoR94oe5XM9b0WiqCqY17sSNTg6O5iWWioA6lfOp+Dpqj
         D4PAl86xACI0WIf1k0iJOp74gEldd8pMTa1gOjp4=
Date:   Thu, 22 Oct 2020 16:10:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        tiantao6@hisilicon.com
Subject:  [merged]
 mm-remove-duplicate-include-statement-in-mmuc.patch removed from -mm tree
Message-ID: <20201022231035.Cpm5ISK-U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove duplicate include statement in mmu.c
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicate-include-statement-in-mmuc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


