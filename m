Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86F5C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 837DC206EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168345;
	bh=0gNMpziw3coxd0nvlP6N74ALBGRFJ90PThBN5JgYPW0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qd/BRH9iurm/KkUMKQ7nsWV+FOwkWC1KTDEF+vBuSRxiH4AJ6NK7x+e2U7TB4HgsA
	 KNZPB6FvlENFFAAsm9e8GV1zuCDfQa5IoqzuDnXyrRv2Nrmr3Kj8/lc5yxml4RZcDJ
	 QUk8siUi70QaRWV4D5Wdu2gUmFF6tf0ulh1uNq5w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgICVZo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgICVZn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:43 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6464206D4;
        Thu,  3 Sep 2020 21:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168342;
        bh=0gNMpziw3coxd0nvlP6N74ALBGRFJ90PThBN5JgYPW0=;
        h=Date:From:To:Subject:From;
        b=X4xTO1BDDRTAoobQYMV/ELuRnIKrDxTlAqwEzw0neQsW4LTCP2PXzedpJngfB0jXd
         40nq8IlbyE1xuPOFM3CAXnJBqkK5pZNWs6kkFx9AgCR21pGVA5m/qgXJPVXR7E5+My
         /tqek42zBUFHnMBZX+r2bhPvXSZMSkhSskzASk0U=
Date:   Thu, 03 Sep 2020 14:25:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 =?us-ascii?Q?mm-debug=5Fvm=5Fpgtable-savedwrite-enable-savedwrite-test-?=
 =?us-ascii?Q?with-config=5Fnuma=5Fbalancing.patch?= added to -mm tree
Message-ID: <20200903212542.B75Xn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/savedwrite: enable savedwrite test with CONFIG_NUMA_BALANCING
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing.patch

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
Subject: mm/debug_vm_pgtable/savedwrite: enable savedwrite test with CONFIG_NUMA_BALANCING

Saved write support was added to track the write bit of a pte after
marking the pte protnone.  This was done so that AUTONUMA can convert a
write pte to protnone and still track the old write bit.  When converting
it back we set the pte write bit correctly thereby avoiding a write fault
again.  Hence enable the test only when CONFIG_NUMA_BALANCING is enabled
and use protnone protflags.

Link: https://lkml.kernel.org/r/20200902114222.181353-6-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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

