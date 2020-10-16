Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1000EC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B367C216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881250;
	bh=WVhP9UUJ23wgq+rIcnJakjHFeVGaQpi8+Np/mCdm/aI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yybO3vh+CObEsTUxtV0FyJEAcVRYJGX+Uz8BJFLiMCVR3ljAxJ//yKhEw5hTCJUKC
	 H+vTiW2AG21cfj8gTI9+MmQlIINn0m3UhZMsGbG8xO5m3GyZCM9tpcrF3bCVFRuQLR
	 P00QUIhbvl4O43nt257+SKUvkSHsaFbMyxPsWDdM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390822AbgJPUra (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391117AbgJPUr3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:47:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF24C2145D;
        Fri, 16 Oct 2020 20:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881249;
        bh=WVhP9UUJ23wgq+rIcnJakjHFeVGaQpi8+Np/mCdm/aI=;
        h=Date:From:To:Subject:From;
        b=Z9bcMgxI26LX5rIVTWsZk0YxW+p6DCWieeRiRaLC/0MtLC7F9/d0W+SXCwIL9ifBl
         gm7jCLsO0unc4tnEoHT+IJe+e5CvF12MYzg1cQWhsFWPlU2FfmmeDPXpliB3GVwfaQ
         HhIZQErF1dU7MQndXLTnMWEutn1BslJrSkVscrzY=
Date:   Fri, 16 Oct 2020 13:47:28 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au
Subject:  [merged]
 mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch
 removed from -mm tree
Message-ID: <20201016204728.WAd8Uz4-o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/ppc64: avoid setting top bits in radom value
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/ppc64: avoid setting top bits in radom value

ppc64 use bit 62 to indicate a pte entry (_PAGE_PTE).  Avoid setting that
bit in random value.

Link: https://lkml.kernel.org/r/20200902114222.181353-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value
+++ a/mm/debug_vm_pgtable.c
@@ -44,10 +44,17 @@
  * entry type. But these bits might affect the ability to clear entries with
  * pxx_clear() because of how dynamic page table folding works on s390. So
  * while loading up the entries do not change the lower 4 bits. It does not
- * have affect any other platform.
+ * have affect any other platform. Also avoid the 62nd bit on ppc64 that is
+ * used to mark a pte entry.
  */
-#define S390_MASK_BITS	4
-#define RANDOM_ORVALUE	GENMASK(BITS_PER_LONG - 1, S390_MASK_BITS)
+#define S390_SKIP_MASK		GENMASK(3, 0)
+#if __BITS_PER_LONG == 64
+#define PPC64_SKIP_MASK		GENMASK(62, 62)
+#else
+#define PPC64_SKIP_MASK		0x0
+#endif
+#define ARCH_SKIP_MASK (S390_SKIP_MASK | PPC64_SKIP_MASK)
+#define RANDOM_ORVALUE (GENMASK(BITS_PER_LONG - 1, 0) & ~ARCH_SKIP_MASK)
 #define RANDOM_NZVALUE	GENMASK(7, 0)
 
 static void __init pte_basic_tests(unsigned long pfn, pgprot_t prot)
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


