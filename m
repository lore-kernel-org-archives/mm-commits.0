Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F97AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 00:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E732084C
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 00:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602806475;
	bh=OsmaG+mLIn5Nxp0NAmSmog1XesouQa7hElFE1XW7g1g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ELP6WzZVRlN37NLylWichMQXhYLIcdN6lvNSnXJOScYAVu0mrVSEI+Ld1LpnUma4e
	 MSqlGY4KAE2MMWHkgDv1j0ZAxCJ7RSGRF4SWamIdtGw5MerGIgS9VJybdr+qqfxsTP
	 ToExnv46egjcjMilhO6jC8PS9rnAqxEQp2gVb4/0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbgJPABO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 20:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733025AbgJPABO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 20:01:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0220A206CA;
        Fri, 16 Oct 2020 00:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602806473;
        bh=OsmaG+mLIn5Nxp0NAmSmog1XesouQa7hElFE1XW7g1g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MvLJPN9Vc+WoLFi38JwhG0xqnr3mdDg1POjFolnmWbCTYDKB28Vy4yeiT4yNN/U+N
         rqoTmDm3pe2oZQLM5eQQRPBNlORnPBV7JS/FFfya/6EZvDHnNW2A4IjN4hDkz4EFse
         /Hh1+FYhqpIu3Myfk3R2yOJaDA5sfih7GvsyCdBE=
Date:   Thu, 15 Oct 2020 17:01:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, aou@eecs.berkeley.edu,
        linux@roeck-us.net, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, palmer@dabbelt.com,
        paul.walmsley@sifive.com
Subject:  +
 mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test-fix.patch added to -mm
 tree
Message-ID: <20201016000112.C_uYeaP8o%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: avoid kernel crash with riscv
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test-fix.patch

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
Subject: mm/debug_vm_pgtable: avoid kernel crash with riscv

It was observed that the usage of RANDOM_ORVALUE with a valid pte cause
kernel crash on riscv.  Comment out the usage of random value on riscv

Link: https://lkml.kernel.org/r/20201015033206.140550-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test-fix
+++ a/mm/debug_vm_pgtable.c
@@ -548,7 +548,9 @@ static void __init pte_clear_tests(struc
 	pte_t pte = pfn_pte(pfn, prot);
 
 	pr_debug("Validating PTE clear\n");
+#ifndef CONFIG_RISCV
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
+#endif
 	set_pte_at(mm, vaddr, ptep, pte);
 	barrier();
 	pte_clear(mm, vaddr, ptep);
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
mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test-fix.patch
mm-debug_vm_pgtable-avoid-doing-memory-allocation-with-pgtable_t-mapped.patch

