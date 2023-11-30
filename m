Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6C8C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjK3Wf2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjK3Wf2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:35:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F8C10F0
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:35:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5CAC433C7;
        Thu, 30 Nov 2023 22:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383734;
        bh=vHyg6I+H4m93MQ1BhVlFztb8EFoEXy4CjLWn8vGCMFA=;
        h=Date:To:From:Subject:From;
        b=dsv3+Rhd3MBLtW0UNbruOP6A4qT90jv6aEWU3DlRcDFVG19vWCFVjUDwMmBiHybVj
         0beh7Z016CrmBL7j7INaekC4QOAugUz6Qvh6Y6IynH1RBe7W4c8zIpecdGy3t7jnz+
         1ZiM4rWKpjneFomFNStrVT1vijNnKRvish9hq2M0=
Date:   Thu, 30 Nov 2023 14:35:33 -0800
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au, arnd@arndb.de,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-pmd_move_must_withdraw-is-only-needed-for-config_transparent_hugepage.patch added to mm-nonmm-unstable branch
Message-Id: <20231130223534.4E5CAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Mon, 27 Nov 2023 13:08:57 +1100
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powerpc-pmd_move_must_withdraw-is-only-needed-for-config_transparent_hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-pmd_move_must_withdraw-is-only-needed-for-config_transparent_hugepage.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 Nov 2023 13:08:57 +1100
Subject: powerpc: pmd_move_must_withdraw() is only needed for CONFIG_TRANSPARENT_HUGEPAGE

This is required for the later patch "Makefile.extrawarn: turn on
missing-prototypes globally".

Link: https://lkml.kernel.org/r/20231127132809.45c2b398@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/pgtable.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/mm/book3s64/pgtable.c~powerpc-pmd_move_must_withdraw-is-only-needed-for-config_transparent_hugepage
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -542,6 +542,7 @@ void ptep_modify_prot_commit(struct vm_a
 	set_pte_at(vma->vm_mm, addr, ptep, pte);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * For hash translation mode, we use the deposited table to store hash slot
  * information and they are stored at PTRS_PER_PMD offset from related pmd
@@ -563,6 +564,7 @@ int pmd_move_must_withdraw(struct spinlo
 
 	return true;
 }
+#endif
 
 /*
  * Does the CPU support tlbie?
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

powerpc-pmd_move_must_withdraw-is-only-needed-for-config_transparent_hugepage.patch

