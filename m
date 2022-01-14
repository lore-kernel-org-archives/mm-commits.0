Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30814C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiANWDT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57340 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWDT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EBCEB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87EFC36AE5;
        Fri, 14 Jan 2022 22:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197797;
        bh=WFzDB0RhxBdKuLWNL/xqpojlHFldianfv0A/q3T/7yI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GbeSRuQc2pcSu6DMSuSSNIQn59XU8fJME3xIjnETt9o+UYg1eZBzN+THOkTE2JEWu
         lzPeGQy4lkRbCJ9g8hJwwTY5XbmnmL2GZoW0Q5y5dJ64C63ueY5WDUsBIA3faQyv0/
         EZWdRga225N/FbA8aYHACXJwKm3KlEEm62Khl0z0=
Date:   Fri, 14 Jan 2022 14:03:16 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davidcomponentone@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yang.guang5@zte.com.cn,
        zealci@zte.com.cn
Subject:  [patch 008/146] arch/ia64/kernel/setup.c: use swap() to
 make code cleaner
Message-ID: <20220114220316.7j_Se__l2%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
