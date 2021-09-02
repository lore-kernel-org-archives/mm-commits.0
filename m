Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D718C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2DD0610C8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243323AbhIBVvE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347540AbhIBVvB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E8A6610A0;
        Thu,  2 Sep 2021 21:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619402;
        bh=5AjqKVEFTPxftISxRsVwzVkw7/cenVskMEX0FwhlsE4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eoZw6yZS+BDmSKzy0sICf2/2pNsx1H1xI2NmxZWu1aZIjtp9O8tSE5y1cTFZ533ra
         Jk0iwU7pVfpNtvWC2mcoGEw1WgXiIeEojBY5yzQ6yIymNXWvI19IAyYIw+17o8uaaX
         KY4npmwIJhd7jSlGbbXtBxwwWrStvo5PURBHH6NI=
Date:   Thu, 02 Sep 2021 14:50:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, frowand.list@gmail.com,
        geert+renesas@glider.be, horms@verge.net.au, jlan@sgi.com,
        linux-mm@kvack.org, magnus.damm@gmail.com,
        mm-commits@vger.kernel.org, robh+dt@kernel.org,
        rppt@linux.vnet.ibm.com, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 002/212] ia64: fix #endif comment for
 reserve_elfcorehdr()
Message-ID: <20210902215001.4qUF6e279%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: ia64: fix #endif comment for reserve_elfcorehdr()

Patch series "ia64: Miscellaneous fixes and cleanups".

This patch series contains some miscellaneous fixes and cleanups for ia64.
The second patch fixes a naming conflict triggered by a patch for the FDT
code.


This patch (of 3):

The definition of reserve_elfcorehdr() depends on CONFIG_CRASH_DUMP, not
CONFIG_PROC_VMCORE.

Link: https://lkml.kernel.org/r/cover.1629884459.git.geert+renesas@glider.be
Link: https://lkml.kernel.org/r/77b4c0648f200cab7e1c2c5171c06763e09362aa.1629884459.git.geert+renesas@glider.be
Fixes: d9a9855d0b06ca6d ("always reserve elfcore header memory in crash kernel")
Fixes: 17c1f07ed70afa4f ("[IA64] Reserve elfcorehdr memory in CONFIG_CRASH_DUMP")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Jay Lan <jlan@sgi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/setup.c~ia64-fix-endif-comment-for-reserve_elfcorehdr
+++ a/arch/ia64/kernel/setup.c
@@ -546,7 +546,7 @@ int __init reserve_elfcorehdr(u64 *start
 	return 0;
 }
 
-#endif /* CONFIG_PROC_VMCORE */
+#endif /* CONFIG_CRASH_DUMP */
 
 void __init
 setup_arch (char **cmdline_p)
_
