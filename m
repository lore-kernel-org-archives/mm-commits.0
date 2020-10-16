Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5462CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D36620897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817502;
	bh=GuAsHGmOHdRYyIjylQteYu/TzN8WF1gcxtpHnzuEmm4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VzuB6UCBcC1crdD/hj1olwdssqfWIZ01OZiCa+KPM1xxChB7yVPW1HVeWXL0D9Y96
	 BlmW9kF52kLehu11KpDfcRvR4i/hZBNd1wugf4uFLXV+UPbIroUjvCAvw6LX0zARa+
	 R1ZRYkUzO941x4ZOE4jB04Ng53A8B44uWJQk5XWw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392151AbgJPDFB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C08420878;
        Fri, 16 Oct 2020 03:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817500;
        bh=GuAsHGmOHdRYyIjylQteYu/TzN8WF1gcxtpHnzuEmm4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lxhcf7j+PxXLrsOM7unYNS2gAjX/cWfO/VivFTN2Td2OLtCY8SyfSgg/pzjBrhy98
         vC/1cY6Vjneg7h73B7kyTVo3X/eGZnMVvkAhKNDqmgs4pM8aT1yO0yMPHAJWGuTM+H
         D2GKMrZm44JojQyJmJaXMjT6PmqDjBvLax46UBwE=
Date:   Thu, 15 Oct 2020 20:04:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 012/156] mm/debug_vm_pgtable/pmd_clear: don't use
 pmd/pud_clear on pte entries
Message-ID: <20201016030459.3Zsrl30xf%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/pmd_clear: don't use pmd/pud_clear on pte entries

pmd_clear() should not be used to clear pmd level pte entries.

Link: https://lkml.kernel.org/r/20200902114222.181353-12-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries
+++ a/mm/debug_vm_pgtable.c
@@ -196,6 +196,8 @@ static void __init pmd_advanced_tests(st
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_young(pmd));
 
+	/*  Clear the pte entries  */
+	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
 	pgtable = pgtable_trans_huge_withdraw(mm, pmdp);
 }
 
@@ -319,6 +321,8 @@ static void __init pud_advanced_tests(st
 	pudp_test_and_clear_young(vma, vaddr, pudp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(pud_young(pud));
+
+	pudp_huge_get_and_clear(mm, vaddr, pudp);
 }
 
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot)
@@ -442,8 +446,6 @@ static void __init pud_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pud_bad().
 	 */
-	pmd_clear(pmdp);
-	pud_clear(pudp);
 	pud_populate(mm, pudp, pmdp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(pud_bad(pud));
@@ -575,7 +577,6 @@ static void __init pmd_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pmd_bad().
 	 */
-	pmd_clear(pmdp);
 	pmd_populate(mm, pmdp, pgtable);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_bad(pmd));
_
