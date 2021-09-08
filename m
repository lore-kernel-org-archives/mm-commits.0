Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C9EC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B7726113A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241996AbhIHWjD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 18:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237353AbhIHWjC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 18:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CF3560F5B;
        Wed,  8 Sep 2021 22:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631140674;
        bh=VauPkax5oxTfthE6Qbbpqtybyb/+ksGqHuTtjZjQcTs=;
        h=Date:From:To:Subject:From;
        b=ZCNTEGcT1L45+IlhcDunWD67dcpksr7brg+BLeufF2olSVylt56zXHjxtz9hZs4+T
         eX9r1bUFmguC3t9svCnqLb5a1VnsJTSfdwItT8oWiEUA3vZsAEYCnRWG2gGiHrAwc/
         HHdKjojWuw3mAWsTse3vONjKlwlXHlg9i9J4DDBI=
Date:   Wed, 08 Sep 2021 15:37:53 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com, linux@roeck-us.net,
        lkp@intel.com, mm-commits@vger.kernel.org, nickhu@andestech.com,
        rppt@linux.ibm.com
Subject:  +
 nds32-setup-remove-unused-memblock_region-variable-in-setup_memory.patch
 added to -mm tree
Message-ID: <20210908223753.Rb1kqvzMd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nds32/setup: remove unused memblock_region variable in setup_memory()
has been added to the -mm tree.  Its filename is
     nds32-setup-remove-unused-memblock_region-variable-in-setup_memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nds32-setup-remove-unused-memblock_region-variable-in-setup_memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nds32-setup-remove-unused-memblock_region-variable-in-setup_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch
memblock-make-memblock_find_in_range-method-private.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch
nds32-setup-remove-unused-memblock_region-variable-in-setup_memory.patch

