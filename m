From: akpm@linux-foundation.org
Subject: + mm-cma-allocation-trigger-fix.patch added to -mm tree
Date: Wed, 18 Feb 2015 14:18:34 -0800
Message-ID: <54e50fba.PWWkZmuF69DfRTgE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbbBRWSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 17:18:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, konrad.wilk@oracle.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocation-trigger-fix
has been added to the -mm tree.  Its filename is
     mm-cma-allocation-trigger-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-allocation-trigger-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-allocation-trigger-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-allocation-trigger-fix

s/CONFIG_CMA_ALIGNMENT/0/, per Joonsoo

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/cma_debug.c~mm-cma-allocation-trigger-fix mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-allocation-trigger-fix
+++ a/mm/cma_debug.c
@@ -102,7 +102,7 @@ static int cma_alloc_mem(struct cma *cma
 	if (!mem)
 		return -ENOMEM;
 
-	p = cma_alloc(cma, count, CONFIG_CMA_ALIGNMENT);
+	p = cma_alloc(cma, count, 0);
 	if (!p) {
 		kfree(mem);
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-allocation-trigger-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

