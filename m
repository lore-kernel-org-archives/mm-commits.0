Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EEDC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8361F61179
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhIIVIN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348443AbhIIVHd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 928D7611AF;
        Thu,  9 Sep 2021 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221583;
        bh=roOhH3L7oKADJPJWsja1r6V2eq0ftCZwmm+jqhg5RiA=;
        h=Date:From:To:Subject:From;
        b=dSS5ZOs0jh385lueLDNTkk8pN8NETc/9I1MKdrHNmEs3sfoo9ol87xEGh4g6jVNMM
         OwIKGbBbYhT5+rEzIUaPc5nNCgUtqWGGW9TLZtFIqiajOGHnv0WtMRFcJiHekM808c
         hRmpCAv2/ELHSywVaDs5UgR6BhSiQIHLfGmaLjUA=
Date:   Thu, 09 Sep 2021 14:06:23 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com, linux@roeck-us.net,
        lkp@intel.com, mm-commits@vger.kernel.org, nickhu@andestech.com,
        rppt@linux.ibm.com
Subject:  [merged]
 nds32-setup-remove-unused-memblock_region-variable-in-setup_memory.patch
 removed from -mm tree
Message-ID: <20210909210623.Enjdryqfe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nds32/setup: remove unused memblock_region variable in setup_memory()
has been removed from the -mm tree.  Its filename was
     nds32-setup-remove-unused-memblock_region-variable-in-setup_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rppt@linux.ibm.com are


