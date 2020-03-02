From: akpm@linux-foundation.org
Subject: +
 powerpc-add-support-for-folded-p4d-page-tables-fix.patch added to -mm tree
Date: Mon, 02 Mar 2020 14:39:56 -0800
Message-ID: <20200302223956.1BqE2Rpnz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgCBWj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:39:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, rppt@linux.ibm.com, sfr@canb.auug.org.au


The patch titled
     Subject: fix for "powerpc: add support for folded p4d page tables"
has been added to the -mm tree.  Its filename is
     powerpc-add-support-for-folded-p4d-page-tables-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-support-for-folded-p4d-page-tables-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-support-for-folded-p4d-page-tables-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix for "powerpc: add support for folded p4d page tables"

build fix

Link: http://lkml.kernel.org/r/20200302152306.49cd866d@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_64_mmu_radix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c~powerpc-add-support-for-folded-p4d-page-tables-fix
+++ a/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1223,7 +1223,7 @@ static ssize_t debugfs_radix_read(struct
 	unsigned long gpa;
 	pgd_t *pgt;
 	struct kvm_nested_guest *nested;
-	pgd_t pgd, *pgdp;
+	pgd_t *pgdp;
 	p4d_t p4d, *p4dp;
 	pud_t pud, *pudp;
 	pmd_t pmd, *pmdp;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

powerpc-add-support-for-folded-p4d-page-tables-fix.patch
