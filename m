Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C723C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiANWH2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiANWH1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF71C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48CE0B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4921C36AED;
        Fri, 14 Jan 2022 22:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198045;
        bh=9PlbeLhugCgVuTC0nx8YtiRpKMewE3NTT+OCUMOAQ4Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1Tbh3snbT7NNc53tO4wsborI/2qklFZA9aexmRw1vvQ9+XXJKK6mHiwEcjP9eufL9
         6+LxEDXRdCIv9/WpmvjFod7PCJ78YXOPIZAgWGwIv0k4XcJSC1pinD34bvGC6dOZnk
         PjKye3MQQugt9/ubN/1l5aQd+grk2FG4sog/cDHw=
Date:   Fri, 14 Jan 2022 14:07:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arthur.marsh@internode.on.net,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sxwjean@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 081/146] mm: page_alloc: fix building error on
 -Werror=array-compare
Message-ID: <20220114220724.BNY5-7-ga%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiongwei Song <sxwjean@gmail.com>
Subject: mm: page_alloc: fix building error on -Werror=array-compare

Arthur Marsh reported we would hit the error below when building kernel
with gcc-12:

CC      mm/page_alloc.o
mm/page_alloc.c: In function `mem_init_print_info':
mm/page_alloc.c:8173:27: error: comparison between two arrays [-Werror=array-compare]
 8173 |                 if (start <= pos && pos < end && size > adj) \
      |

In C++20, the comparision between arrays should be warned.

Link: https://lkml.kernel.org/r/20211125130928.32465-1-sxwjean@me.com
Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-building-error-on-werror=array-compare
+++ a/mm/page_alloc.c
@@ -8228,7 +8228,7 @@ void __init mem_init_print_info(void)
 	 */
 #define adj_init_size(start, end, size, pos, adj) \
 	do { \
-		if (start <= pos && pos < end && size > adj) \
+		if (&start[0] <= &pos[0] && &pos[0] < &end[0] && size > adj) \
 			size -= adj; \
 	} while (0)
 
_
