Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F56C433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D8E9206D4
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168342;
	bh=4RhG3MwaL+HWMwJeZ7kmI6DxzRWdHnNUn/jLU3RuFT8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uvYftHURgV6alrUPosdlo2avfq4zMyKQLw5+jgL00UiaIic2v6TgvGGCghikkbNzZ
	 pEuQKtKvZnRyYqgZPzdrCWPCuHLw9LkHKSWT16QSEMjBbfwcXhf8PjIjlNXtIq4e5z
	 UcuQ3ZoCtnqbv9stFL1FfH8lNE+cr2fgtYP2XRsg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgICVZm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgICVZl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:41 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1778206CA;
        Thu,  3 Sep 2020 21:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168340;
        bh=4RhG3MwaL+HWMwJeZ7kmI6DxzRWdHnNUn/jLU3RuFT8=;
        h=Date:From:To:Subject:From;
        b=OnjOcY205DgmatZ8S2wr5+0wSbFg6bDNaypzYzR0iapEBdasR2sRam9pXy+yPqkEq
         Fxlt6CyEgGWUx9OOJxc6Y/a4247jm5emzLJIxz/c1UN4o85Fx7RwtNrdV6N5KCq91C
         cj+vYMHP/CwhSvvxPjiPllXIe5LZlYSrFwnywoLk=
Date:   Thu, 03 Sep 2020 14:25:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtables-hugevmap-use-the-arch-helper-to-?=
 =?us-ascii?Q?identify-huge-vmap-support.patch?= added to -mm tree
Message-ID: <20200903212540.X8UKq%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtables/hugevmap: use the arch helper to identify huge vmap support.
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtables/hugevmap: use the arch helper to identify huge vmap support.

ppc64 supports huge vmap only with radix translation.  Hence use arch
helper to determine the huge vmap support.

Link: https://lkml.kernel.org/r/20200902114222.181353-5-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support
+++ a/mm/debug_vm_pgtable.c
@@ -28,6 +28,7 @@
 #include <linux/swapops.h>
 #include <linux/start_kernel.h>
 #include <linux/sched/mm.h>
+#include <linux/io.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
@@ -206,11 +207,12 @@ static void __init pmd_leaf_tests(unsign
 	WARN_ON(!pmd_leaf(pmd));
 }
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+	if (!arch_ioremap_pmd_supported())
 		return;
 
 	pr_debug("Validating PMD huge\n");
@@ -224,6 +226,9 @@ static void __init pmd_huge_tests(pmd_t
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(!pmd_none(pmd));
 }
+#else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
+static void __init pmd_huge_tests(pmd_t *pmdp, unsigned long pfn, pgprot_t prot) { }
+#endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 static void __init pmd_savedwrite_tests(unsigned long pfn, pgprot_t prot)
 {
@@ -320,11 +325,12 @@ static void __init pud_leaf_tests(unsign
 	WARN_ON(!pud_leaf(pud));
 }
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot)
 {
 	pud_t pud;
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+	if (!arch_ioremap_pud_supported())
 		return;
 
 	pr_debug("Validating PUD huge\n");
@@ -338,6 +344,10 @@ static void __init pud_huge_tests(pud_t
 	pud = READ_ONCE(*pudp);
 	WARN_ON(!pud_none(pud));
 }
+#else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+static void __init pud_huge_tests(pud_t *pudp, unsigned long pfn, pgprot_t prot) { }
+#endif /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+
 #else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot) { }
 static void __init pud_advanced_tests(struct mm_struct *mm,
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

powerpc-mm-add-debug_vm-warn-for-pmd_clear.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch
mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch
mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support.patch
mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing.patch
mm-debug_vm_pgtable-thp-mark-the-pte-entry-huge-before-using-set_pmd-pud_at.patch
mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry.patch
mm-debug_vm_pgtable-locks-move-non-page-table-modifying-test-together.patch
mm-debug_vm_pgtable-locks-take-correct-page-table-lock.patch
mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch
mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch
mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch
mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test.patch

