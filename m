Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED59C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 01:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F66461166
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 01:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349094AbhIIBLc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 21:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349033AbhIIBLc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 21:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D12F161158;
        Thu,  9 Sep 2021 01:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149824;
        bh=NnqWfeDW33Zyv+mR5GNV//cYwvzlzImsqF2TL+vuJbs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZkCsIgOm8sSo9ZxeqOQG1KUcr5bpmSrWvUYLT1uu/mguFQ8Ww28tuYrk/Ps76VwUq
         Yn/lu8RxwNRlqWttdcdFKP3dLxVeCU6QK3fRAsZ2xW7bjaiq+2fQTvxZS7HtD9l9ed
         xfWv043Dr4H5LBLq+y0JAGUpczHkxzi5Ft7eYVlk=
Date:   Wed, 08 Sep 2021 18:10:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deanbo422@gmail.com, green.hu@gmail.com,
        linux-mm@kvack.org, linux@roeck-us.net, lkp@intel.com,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        rppt@linux.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 8/8] nds32/setup: remove unused memblock_region
 variable in setup_memory()
Message-ID: <20210909011023.FwapIlJdh%akpm@linux-foundation.org>
In-Reply-To: <20210908180859.d523d4bb4ad8eec11c61500d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: nds32/setup: remove unused memblock_region variable in setup_memory()

kernel test robot reports unused variable warning:

cppcheck possible warnings: (new ones prefixed by >>, may not real
problems)

>> arch/nds32/kernel/setup.c:247:26: warning: Unused variable: region
>> [unusedVariable]
    struct memblock_region *region;
                            ^

Remove the unused variable.

Link: https://lkml.kernel.org/r/20210712125218.28951-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/kernel/setup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/nds32/kernel/setup.c~nds32-setup-remove-unused-memblock_region-variable-in-setup_memory
+++ a/arch/nds32/kernel/setup.c
@@ -244,7 +244,6 @@ static void __init setup_memory(void)
 	unsigned long ram_start_pfn;
 	unsigned long free_ram_start_pfn;
 	phys_addr_t memory_start, memory_end;
-	struct memblock_region *region;
 
 	memory_end = memory_start = 0;
 
_
