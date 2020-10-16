Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114F0C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F23208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814302;
	bh=kCUfl7MG54PPbP5ssRO/xXnw8KFYsOTnFh4UYeLYGcU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lc/vVFiL331d2HGzgH6cQCCkrsqp9lFq/mfISb1WGBGLwUBgEwuiX/vC7sInEoAcX
	 7wPTwWg/tYCjZASItGyA/Kr8y8SID99sNCMJ7UDCYmuHhuELubqiIwI+18GQAMCS5D
	 cGIDuzilPso7DNCKHe41DADtR0+JnvEdqD1UblEM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403858AbgJPCLm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403852AbgJPCLm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:11:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7A72073A;
        Fri, 16 Oct 2020 02:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814300;
        bh=kCUfl7MG54PPbP5ssRO/xXnw8KFYsOTnFh4UYeLYGcU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LctRj5Dy7ih8cA8DU8nP56Vls8En17numos6kaoRDzYwFU7NyoDh2TXPBitHlMno0
         t9NWxc6ZycQzbjQAZXgVUX2g28iSzSwC7V25EFvNd+XgZWyCI+Jz5qqArSh36/m4yk
         MhRwQQmTd/yjZPj+IFEtUIvr1kkMMjIQA9UBDEJM=
Date:   Thu, 15 Oct 2020 19:11:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au
Subject:  [folded-merged]
 powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch removed
 from -mm tree
Message-ID: <20201016021139.dh3ZJh0PD%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix
has been removed from the -mm tree.  Its filename was
     powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch

This patch was dropped because it was folded into powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix

whitespace fix, per Christophe

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -820,7 +820,7 @@ static inline void __set_pte_at(struct m
 	 * Keep the _PAGE_PTE added till we are sure we handle _PAGE_PTE
 	 * in all the callers.
 	 */
-	 pte = __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_PTE));
+	pte = __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_PTE));
 
 	if (radix_enabled())
 		return radix__set_pte_at(mm, addr, ptep, pte, percpu);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

