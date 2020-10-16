Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B95C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5502421775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881256;
	bh=3XovPPREm4ZBUtyUxTaXx9DwPMvEyE2oeUMGkSW1ITU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Rn0n4e0RW/FDOTmGBebrbx1rV8qMxsXOvi+vfQlttvHNqIuYtjKyNhzWyQJJRKM7X
	 2kZb8WI58VgCfmyvtYczG3DAyFk0YtIlQqzCxTYI/jjIYUnf06bp4WCixKDwmjhmo5
	 07mcR3ahyNZ3d9KJS8LQmpCyMX355NSCOw7YaA7A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391418AbgJPUrf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391117AbgJPUrf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:47:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C278E214DB;
        Fri, 16 Oct 2020 20:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881255;
        bh=3XovPPREm4ZBUtyUxTaXx9DwPMvEyE2oeUMGkSW1ITU=;
        h=Date:From:To:Subject:From;
        b=EAes2u/ChFh2VbuRCmPTd/jlJftGBInzRGVlg1KHZ0MevCBRRx8AGynEY3B2pIsAI
         dKCFqFK/Vcp7kaekTJJgiZ3spQaEzcGiXE/nkLxIHHsMjakhwS+7Z1ngtEOUIfdYH8
         STFIigp4Psu1hvxbSRMXhhOhDa0sq9evO37su1R8=
Date:   Fri, 16 Oct 2020 13:47:34 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au
Subject:  [merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-savedwrite-enable-savedwrite-test-?=
 =?US-ASCII?Q?with-config=5Fnuma=5Fbalancing.patch?= removed from -mm tree
Message-ID: <20201016204734.PUpGydghp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/savedwrite: enable savedwrite test with CONFIG_NUMA_BALANCING
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/savedwrite: enable savedwrite test with CONFIG_NUMA_BALANCING

Saved write support was added to track the write bit of a pte after
marking the pte protnone.  This was done so that AUTONUMA can convert a
write pte to protnone and still track the old write bit.  When converting
it back we set the pte write bit correctly thereby avoiding a write fault
again.  Hence enable the test only when CONFIG_NUMA_BALANCING is enabled
and use protnone protflags.

Link: https://lkml.kernel.org/r/20200902114222.181353-6-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing
+++ a/mm/debug_vm_pgtable.c
@@ -119,10 +119,14 @@ static void __init pte_savedwrite_tests(
 {
 	pte_t pte = pfn_pte(pfn, prot);
 
+	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+		return;
+
 	pr_debug("Validating PTE saved write\n");
 	WARN_ON(!pte_savedwrite(pte_mk_savedwrite(pte_clear_savedwrite(pte))));
 	WARN_ON(pte_savedwrite(pte_clear_savedwrite(pte_mk_savedwrite(pte))));
 }
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void __init pmd_basic_tests(unsigned long pfn, pgprot_t prot)
 {
@@ -234,6 +238,9 @@ static void __init pmd_savedwrite_tests(
 {
 	pmd_t pmd = pfn_pmd(pfn, prot);
 
+	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+		return;
+
 	pr_debug("Validating PMD saved write\n");
 	WARN_ON(!pmd_savedwrite(pmd_mk_savedwrite(pmd_clear_savedwrite(pmd))));
 	WARN_ON(pmd_savedwrite(pmd_clear_savedwrite(pmd_mk_savedwrite(pmd))));
@@ -1019,8 +1026,8 @@ static int __init debug_vm_pgtable(void)
 	pmd_huge_tests(pmdp, pmd_aligned, prot);
 	pud_huge_tests(pudp, pud_aligned, prot);
 
-	pte_savedwrite_tests(pte_aligned, prot);
-	pmd_savedwrite_tests(pmd_aligned, prot);
+	pte_savedwrite_tests(pte_aligned, protnone);
+	pmd_savedwrite_tests(pmd_aligned, protnone);
 
 	pte_unmap_unlock(ptep, ptl);
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


