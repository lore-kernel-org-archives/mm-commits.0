Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1C6C43457
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E89B21D7F
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976551;
	bh=WW+QIOioUOhg8gLSnK8E45pkFkJmr2Apo31iYGEGcSc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DTJxS+pXUEsdOjkzebNMzYS6Uc/dpWhW5Qk2KTQQB+/8rgbuJaXFRQcC3OjOcDNqv
	 lXL4NV50CrehA5KnBOvqIwIpGvS7hRVjuR3WXKKOhtd6pJogiE344GT3eqxO85ZYmu
	 e9/iblE777m5To7IncLD/jUlBHUKenO51xODp3rs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439923AbgJQXPu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12CD5214DB;
        Sat, 17 Oct 2020 23:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976550;
        bh=WW+QIOioUOhg8gLSnK8E45pkFkJmr2Apo31iYGEGcSc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0vJowV5QdYpPx/7YZP4Vegl3E2BHqrFif+NkHXVJRB3aEQmiz9XiLVtWCArv53LX9
         gKJuNH/yMyKvOCIT3BXABemhno8ez4qfwqohl23ak7pots2B7dHky+XQfUOtF6m+sT
         ZLozsLpBWKroENTDvNW5mH5Ap1/eGU8dg3RdoYas=
Date:   Sat, 17 Oct 2020 16:15:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        tiantao6@hisilicon.com, torvalds@linux-foundation.org
Subject:  [patch 40/40] mm: remove duplicate include statement in
 mmu.c
Message-ID: <20201017231549.ebZiVJavh%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
