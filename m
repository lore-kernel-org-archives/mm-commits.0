Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95A0C38142
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 23:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjAaXKC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 18:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjAaXKB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 18:10:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452AF9773
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 15:10:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA215B81F75
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 23:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EE5C433D2;
        Tue, 31 Jan 2023 23:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675206597;
        bh=ijs68bsuRHeQpX1effSVtB4O86HCMcIxMO6lnqIChHE=;
        h=Date:To:From:Subject:From;
        b=bdrbjmWhWa/PsQJHMkX5LoXraJGkCssM4R02+YenwqD5sbfGcxCUE/kDQzvh6Rlek
         2BJsR9JmRwtHyY0RUj8YTO5Vyruib2aH4oCkCEGnKpT8vn/DC3Lw0eW84JQWh2ezpF
         +YStenmSjmQKu05LhQu1fDCfwwQWEfPDmEQp3wJg=
Date:   Tue, 31 Jan 2023 15:09:56 -0800
To:     mm-commits@vger.kernel.org, conor.dooley@microchip.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix.patch added to mm-unstable branch
Message-Id: <20230131230957.78EE5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix
Date: Tue, 31 Jan 2023 20:41:49 +0200

The generic pfn_valid() does not take into account pfn_offset when it
compares it with max_mapnr.

Link: https://lkml.kernel.org/r/Y9lg7R1Yd931C+y5@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/memory_model.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix
+++ a/include/asm-generic/memory_model.h
@@ -26,7 +26,7 @@ static inline int pfn_valid(unsigned lon
 	extern unsigned long max_mapnr;
 	unsigned long pfn_offset = ARCH_PFN_OFFSET;
 
-	return pfn >= pfn_offset && pfn < max_mapnr;
+	return pfn >= pfn_offset && (pfn - pfn_offset) < max_mapnr;
 }
 #define pfn_valid pfn_valid
 #endif
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-sparse-fix-unused-function-pgdat_to_phys-warning.patch
arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch
m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch
mips-drop-definition-of-pfn_valid-for-discontigmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix.patch

