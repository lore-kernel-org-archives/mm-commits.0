Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59663C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B33F20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816080;
	bh=AptcQx8u9w8rrn9oiKesYVDyuySO4AAFV1zFXR8NwZg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1NXdLCwlrEwwaVcdUpj40SAaGti1z2MBx8NNX25+YBHnpem487a3JUE/s42WUEPfd
	 Ttl6w+k4ntEzQmx4weUL8EyP5f4fc49RJ4o6YbmroRJgadNe+963sfkO2GFWkNVIkH
	 EfIiFLyckZ+mZPWWkCo4jflxTeGNh25eMqOFBSOA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404284AbgJPClT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404278AbgJPClT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:41:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF2F208C7;
        Fri, 16 Oct 2020 02:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816078;
        bh=AptcQx8u9w8rrn9oiKesYVDyuySO4AAFV1zFXR8NwZg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=07K5RGTGDon9qRnHk5FV8sHPnwHcpIsXoOC4unVglnhm0pszY++QMjajD/PGo8Ptg
         TC1Z1PZpuyECiupSPAdrX/nHPxOyqmfwYZAAEp6jVTcD4hwWMA8eHuiOTJpaTIJnpM
         meff6WUnh1LZ+4/amKo762+GcXffxK/YHoZUXf9Q=
Date:   Thu, 15 Oct 2020 19:41:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 006/156] mm/debug_vm_pgtable/savedwrite: enable
 savedwrite test with CONFIG_NUMA_BALANCING
Message-ID: <20201016024117.nC0uTGSvP%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
