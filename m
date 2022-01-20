Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14832C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377802AbiATVXC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56072 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiATVXB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BB74B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14D5C340E0;
        Thu, 20 Jan 2022 21:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713778;
        bh=UPz6EZ26ouGANcAS2wHgI3a31FvvmQ8ATWiDRbFIkyQ=;
        h=Date:From:To:Subject:From;
        b=s2vhbvU/FvDQ9lzmRqX1GC+iJd9ef2b2nswypY2x09UKKOeVeUlGcDWWAzoe4XHng
         Pr7mjt9oGevDr+GAJYpkFI0bq/KFVY13BlzVHxUJffe69jCT5BGbwmg1syplo8HtRv
         XYk0E/gvmCobnML9jJ6L4Kh1khWFPUTZ8Y46gCg4=
Date:   Thu, 20 Jan 2022 13:22:58 -0800
From:   akpm@linux-foundation.org
To:     davidcomponentone@gmail.com, mm-commits@vger.kernel.org,
        yang.guang5@zte.com.cn, zealci@zte.com.cn
Subject:  [merged] ia64-use-swap-to-make-code-cleaner.patch removed
 from -mm tree
Message-ID: <20220120212258.zuALjOuT_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/kernel/setup.c: use swap() to make code cleaner
has been removed from the -mm tree.  Its filename was
     ia64-use-swap-to-make-code-cleaner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Guang <yang.guang5@zte.com.cn>
Subject: arch/ia64/kernel/setup.c: use swap() to make code cleaner

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Link: https://lkml.kernel.org/r/20211104001908.695110-1-yang.guang5@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Cc: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/ia64/kernel/setup.c~ia64-use-swap-to-make-code-cleaner
+++ a/arch/ia64/kernel/setup.c
@@ -208,10 +208,7 @@ sort_regions (struct rsvd_region *rsvd_r
 	while (max--) {
 		for (j = 0; j < max; ++j) {
 			if (rsvd_region[j].start > rsvd_region[j+1].start) {
-				struct rsvd_region tmp;
-				tmp = rsvd_region[j];
-				rsvd_region[j] = rsvd_region[j + 1];
-				rsvd_region[j + 1] = tmp;
+				swap(rsvd_region[j], rsvd_region[j + 1]);
 			}
 		}
 	}
_

Patches currently in -mm which might be from yang.guang5@zte.com.cn are


