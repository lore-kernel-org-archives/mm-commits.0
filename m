From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 x86-mm-ptdump-calculate-effective-permissions-correctly-fix.patch added to
 -mm tree
Date: Wed, 27 May 2020 15:32:33 -0700
Message-ID: <20200527223233.mLmrc1Osc%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgE0Wce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 18:32:34 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, mm-commits@vger.kernel.org, steven.price@arm.com


The patch titled
     Subject: x86-mm-ptdump-calculate-effective-permissions-correctly-fix
has been added to the -mm tree.  Its filename is
     x86-mm-ptdump-calculate-effective-permissions-correctly-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-ptdump-calculate-effective-permissions-correctly-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-ptdump-calculate-effective-permissions-correctly-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
