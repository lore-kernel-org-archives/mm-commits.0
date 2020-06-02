From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-mm-ptdump-calculate-effective-permissions-correctly-fix.patch removed
 from -mm tree
Date: Mon, 01 Jun 2020 21:18:55 -0700
Message-ID: <20200602041855.XWq70C50s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgFBES4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, mm-commits@vger.kernel.org, steven.price@arm.com


The patch titled
     Subject: x86-mm-ptdump-calculate-effective-permissions-correctly-fix
has been removed from the -mm tree.  Its filename was
     x86-mm-ptdump-calculate-effective-permissions-correctly-fix.patch

This patch was dropped because it was folded into x86-mm-ptdump-calculate-effective-permissions-correctly.patch

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: x86-mm-ptdump-calculate-effective-permissions-correctly-fix

make the assignment conditional on val != 0.

Link: http://lkml.kernel.org/r/430c8ab4-e7cd-6933-dde6-087fac6db872@arm.com
Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/dump_pagetables.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/dump_pagetables.c~x86-mm-ptdump-calculate-effective-permissions-correctly-fix
+++ a/arch/x86/mm/dump_pagetables.c
@@ -282,10 +282,10 @@ static void note_page(struct ptdump_stat
 	struct seq_file *m = st->seq;
 
 	new_prot = val & PTE_FLAGS_MASK;
-	new_eff = st->prot_levels[level];
