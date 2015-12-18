From: akpm@linux-foundation.org
Subject: + mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t-fix.patch added to
 -mm tree
Date: Fri, 18 Dec 2015 13:42:25 -0800
Message-ID: <56747dc1.aSMWEo5cr/Wu/Uty%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965392AbbLRVm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 16:42:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: convert vmf_insert_pfn_pmd() to pfn_t fix
has been added to the -mm tree.  Its filename is
     mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm, dax: convert vmf_insert_pfn_pmd() to pfn_t fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t-fix arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t-fix
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -186,6 +186,7 @@ void pgtable_cache_init(void);
 struct page *realmode_pfn_to_page(unsigned long pfn);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define pfn_pmd pfn_pmd
 extern pmd_t pfn_pmd(unsigned long pfn, pgprot_t pgprot);
 extern pmd_t mk_pmd(struct page *page, pgprot_t pgprot);
 extern pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t-fix.patch

