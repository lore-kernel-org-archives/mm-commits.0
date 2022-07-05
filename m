Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5DBC43334
	for <mm-commits@archiver.kernel.org>; Tue,  5 Jul 2022 20:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiGEUre (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Jul 2022 16:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiGEUrd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2022 16:47:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793A5AE6E
        for <mm-commits@vger.kernel.org>; Tue,  5 Jul 2022 13:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0128061C43
        for <mm-commits@vger.kernel.org>; Tue,  5 Jul 2022 20:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5550EC341C7;
        Tue,  5 Jul 2022 20:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657054051;
        bh=45lfTPvpmMbz7CpbZruqOVvb9agg60RErNjDs+UMDLY=;
        h=Date:To:From:Subject:From;
        b=kRpKkQrgkFB2gvB0mW2hs0+MCDLoLog6UsYhQl4Z2OjKMbHHpnSFudvnZoP6hq2ld
         ZvbAn7hWB0a5NJ+JWAHBk5Wn5dyj6lNPp58K8jqVgOrUUAq2tKxda25vy0RDgI09H9
         Pol9ohXiIsOyimFxEkAF+T1Ir7UjnRjTJ/9sSPko=
Date:   Tue, 05 Jul 2022 13:47:30 -0700
To:     mm-commits@vger.kernel.org, chenhuacai@kernel.org,
        rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-drop-definition-of-pgd_order-v2.patch added to mm-unstable branch
Message-Id: <20220705204731.5550EC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: loongarch: drop definition of PGD_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     loongarch-drop-definition-of-pgd_order-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-drop-definition-of-pgd_order-v2.patch

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
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: loongarch: drop definition of PGD_ORDER
Date: Tue, 5 Jul 2022 18:47:05 +0300

drop extra BLANK() line in arch/loongarch/kernel/asm-offsets.c

Link: https://lkml.kernel.org/r/20220705154708.181258-13-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/kernel/asm-offsets.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/loongarch/kernel/asm-offsets.c~loongarch-drop-definition-of-pgd_order-v2
+++ a/arch/loongarch/kernel/asm-offsets.c
@@ -190,7 +190,6 @@ void output_mm_defines(void)
 #endif
 	DEFINE(_PTE_T_LOG2, PTE_T_LOG2);
 	BLANK();
-	BLANK();
 	DEFINE(_PMD_SHIFT, PMD_SHIFT);
 	DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
 	BLANK();
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

csky-drop-definition-of-pte_order.patch
csky-drop-definition-of-pgd_order.patch
mips-rename-pud_order-to-pud_table_order.patch
mips-drop-definitions-of-pte_order.patch
mips-rename-pgd_order-to-pgd_table_order.patch
nios2-drop-definition-of-pte_order.patch
nios2-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pte_order.patch
loongarch-drop-definition-of-pmd_order.patch
loongarch-drop-definition-of-pud_order.patch
loongarch-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pgd_order-v2.patch
parisc-rename-pgd_order-to-pgd_table_order.patch
xtensa-drop-definition-of-pgd_order.patch

