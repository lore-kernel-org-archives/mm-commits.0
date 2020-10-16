Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F352C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 143B6208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817482;
	bh=AptcQx8u9w8rrn9oiKesYVDyuySO4AAFV1zFXR8NwZg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SCV0ZVXiS+DMTE0Q/TxVlEaR61Aq5S+tVjDONQGJBycRx5XjzvQ1IY5E/UY6F/xZa
	 UGXLsUqysi/Ak2qssFv6oDbtQK6XsGhekoPTC5IKZa6ii2e9hODB35hle66wdnacnZ
	 OK0nnnwGE1LWL8jEh7PV9xWfQxXq/IKttDS91MYE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbgJPDEl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDEl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:04:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8230020878;
        Fri, 16 Oct 2020 03:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817480;
        bh=AptcQx8u9w8rrn9oiKesYVDyuySO4AAFV1zFXR8NwZg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oYLkhgjZMsDtUojKIACjMKXBGxAvpD2ghoLfOs+LmNqoo4hLu+VJVqax8phcGwuBR
         7WyTP97dGAvbMpXP/r7p3Qu8uB+A2R+XWRKM2OO0RyYByGKUNeynQD66XLgLhtaKHR
         jQEF8wtR5njNDIQ3/X4+zcxu9IOS/FT/HxDLdcxc=
Date:   Thu, 15 Oct 2020 20:04:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 006/156] mm/debug_vm_pgtable/savedwrite: enable
 savedwrite test with CONFIG_NUMA_BALANCING
Message-ID: <20201016030440.eGpRlE1nn%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
