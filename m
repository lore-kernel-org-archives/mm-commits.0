Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D39C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91C1761481
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhC1VEA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 17:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231478AbhC1VDu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 17:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB02A61925;
        Sun, 28 Mar 2021 21:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616965429;
        bh=MAZ3JyUYZUuC1MdBJyBwp4N7/tExOl4f77GY2GBhYEk=;
        h=Date:From:To:Subject:From;
        b=P+e6rZt3Cqejyjnl9Okl669QFng08apthN1eueLf36UK7lXgS125oO5t2wF/asbkh
         KWVVe5OpXT4x8NXkaOiGUys9vmILEVWbH/5mhC28DjvrKCadVrZQnIxfNeJPFRyoTq
         Hg9gDusxMN8rW581nesZ0X0gj//5mVc3v429hGts=
Date:   Sun, 28 Mar 2021 14:03:49 -0700
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, mm-commits@vger.kernel.org, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  +
 =?US-ASCII?Q?mm-vmalloc-fix-huge=5Fvmap-regression-by-enabling-huge-pa?=
 =?US-ASCII?Q?ges-in-vmalloc=5Fto=5Fpage-fix.patch?= added to -mm tree
Message-ID: <20210328210349.kAx0bOG4c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc32: add stub pud_page define for walking huge vmalloc page tables
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: sparc32: add stub pud_page define for walking huge vmalloc page tables

Similarly to the stub p4d_page in sparc64, add a stub pud_page, this
is needed for hugepages in the vmap page tables to be walked without
ifdefs, which should be no functional change for sparc32.

Link: https://lkml.kernel.org/r/20210324232825.1157363-1-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/sparc/include/asm/pgtable_32.h~mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page-fix
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -321,6 +321,9 @@ static inline pte_t pte_modify(pte_t pte
 		pgprot_val(newprot));
 }
 
+/* only used by the huge vmap code, should never be called */
+#define pud_page(pud)			NULL
+
 struct seq_file;
 void mmu_info(struct seq_file *m);
 
_

Patches currently in -mm which might be from npiggin@gmail.com are

arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page-fix.patch
mm-apply_to_pte_range-warn-and-fail-if-a-large-pte-is-encountered.patch
mm-vmalloc-rename-vmap__range-vmap_pages__range.patch
mm-ioremap-rename-ioremap__range-to-vmap__range.patch
mm-huge_vmap-arch-support-cleanup.patch
powerpc-inline-huge-vmap-supported-functions.patch
arm64-inline-huge-vmap-supported-functions.patch
x86-inline-huge-vmap-supported-functions.patch
mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions.patch
mm-move-vmap_range-from-mm-ioremapc-to-mm-vmallocc.patch
mm-vmalloc-add-vmap_range_noflush-variant.patch
mm-vmalloc-hugepage-vmalloc-mappings.patch
powerpc-64s-radix-enable-huge-vmalloc-mappings.patch

