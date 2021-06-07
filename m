Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB498C47082
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB3C061185
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFGWjL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230356AbhFGWjL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 18:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9851561090;
        Mon,  7 Jun 2021 22:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623105427;
        bh=v1E5OlnOrzwxnhRyXowP+wwCQZnHaaD4lbPyEXgKMkA=;
        h=Date:From:To:Subject:From;
        b=LXdXwm7oVL/tduJPi9rKjIOhIpEFCfzYSg+dqcJQ0P9ELOzDaewWDRia4tZjPpG4v
         FmN8Z+EceGckXc7RjuGrtuRAyxLDS0LKlqpPQJlfkPENeqSUzBEZ3ukFkmUOUVLulI
         Zqz4HIAgcKn88ReMkiYUsUlPSmEEFgRa+tfCQ1hM=
Date:   Mon, 07 Jun 2021 15:37:07 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  [to-be-updated] powerpc-mm-enable-move-pmd-pud.patch
 removed from -mm tree
Message-ID: <20210607223707.sRQvBj2CZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: enable move pmd/pud
has been removed from the -mm tree.  Its filename was
     powerpc-mm-enable-move-pmd-pud.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm: enable move pmd/pud

mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:
1GB mremap - Source PTE-aligned, Destination PTE-aligned
  mremap time:      1127034ns
1GB mremap - Source PMD-aligned, Destination PMD-aligned
  mremap time:       508817ns
1GB mremap - Source PUD-aligned, Destination PUD-aligned
  mremap time:        23046ns

Link: https://lkml.kernel.org/r/20210422054323.150993-10-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/Kconfig.cputype |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/Kconfig.cputype~powerpc-mm-enable-move-pmd-pud
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -96,6 +96,8 @@ config PPC_BOOK3S_64
 	select PPC_FPU
 	select PPC_HAVE_PMU_SUPPORT
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_MOVE_PMD
+	select HAVE_MOVE_PUD
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_PMD_SPLIT_PTLOCK
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


