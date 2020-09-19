Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B9FC43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E360521D43
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475593;
	bh=meTG4P3nb92b3dKo0tdIovAb4pIxsJK3nUyksDN31k4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KFbEfeboPCuHqt9NfKm9q1S8jeBBcuOljR/oVLh1qIN9sg1W+FadmkFQ402IcX1S0
	 wTaFB4ZFB0P8XgurJ+copWf+5V7g6lWOlAoq0AH9AZmCefNcytsTHBTggLgzXr9x9E
	 kLnWgnO6Ken8QzqNRgz5OGhVFHPn7w+B6cBeofOQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgISAdN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAdN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:33:13 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38E321D20;
        Sat, 19 Sep 2020 00:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475592;
        bh=meTG4P3nb92b3dKo0tdIovAb4pIxsJK3nUyksDN31k4=;
        h=Date:From:To:Subject:From;
        b=LEaCUn0w1MSXfzxGMWR7rJTZzQl4wb1TYmm18ln9yYt7N7+TV2SHqnrc4zKb3NOhj
         MuS+N0K6hmyRnNuvuEOnf7uQJqoWJqJuJGMB0mF+J8NOhQkI1hPDoBwIL2+AJsiS3s
         07Ydeap8YI16rLW4aewhURn3Bet0698NF/RktGXo=
Date:   Fri, 18 Sep 2020 17:33:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        tiantao6@hisilicon.com
Subject:  +
 documentation-remove-cmas-dependency-on-architecture.patch added to -mm tree
Message-ID: <20200919003311.ZYpu2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: remove CMA's dependency on architecture
has been added to the -mm tree.  Its filename is
     documentation-remove-cmas-dependency-on-architecture.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-remove-cmas-dependency-on-architecture.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-remove-cmas-dependency-on-architecture.patch

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
Subject: Documentation: remove CMA's dependency on architecture

CMA only depends on MMU.  It doesn't depend on arch too much.  such as
ARM, ARM64, X86, MIPS etc.  so We remove the dependency of cma about the
architecture in kernel-parameters.txt.

Link: https://lkml.kernel.org/r/1600412758-60545-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~documentation-remove-cmas-dependency-on-architecture
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -591,7 +591,7 @@
 			some critical bits.
 
 	cma=nn[MG]@[start[MG][-end[MG]]]
-			[ARM,X86,KNL]
+			[KNL,CMA]
 			Sets the size of kernel global memory area for
 			contiguous memory allocations and optionally the
 			placement constraint by the physical address range of
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are

mm-remove-duplicate-include-statement-in-mmuc.patch
documentation-remove-cmas-dependency-on-architecture.patch

