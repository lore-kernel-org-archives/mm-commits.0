Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E65C433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6C5206EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168338;
	bh=VehJwryRhbxPH2UM6ei+X+lzT1ioNi/Pbox7x5SKLAE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rI2fnC4BBv1cIfqyPUPFRg7p8cWuANaDhNMXRQq2s9kBOIxD959zorqfUndoEem0u
	 61AeVy/m+pKMRK1i3sxMjTs3hvz280dcAIzSnuR09PHcU8HUZwaqbsYTZO9RwH3p+/
	 n7D+j3UyDFy6g4zW8PcrkmIIeqoCBVv/Yox7lRu8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgICVZh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgICVZh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:37 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A19AB206E7;
        Thu,  3 Sep 2020 21:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168336;
        bh=VehJwryRhbxPH2UM6ei+X+lzT1ioNi/Pbox7x5SKLAE=;
        h=Date:From:To:Subject:From;
        b=jXNRuLUwoZyjFL4Vu48o5ZNFNknoEfOkF4J7i0Q49Ob7RxkoEfJG+89jVdcJSwItd
         TS1VX5zWohqhUq+KeNAoG9QTvq0/rF8ttTYjQsIm+ka81M+rRsFVYG13PcUdDa7ZJi
         uCjmaXCNC9xmFaZkuElQB3E/hOD8299d4Z3u0aF0=
Date:   Thu, 03 Sep 2020 14:25:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
Subject:  +
 powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch added to -mm
 tree
Message-ID: <20200903212536.Ij2np%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix
has been added to the -mm tree.  Its filename is
     powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

